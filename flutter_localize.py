#!/usr/bin/env python3
"""
Flutter Localization Extractor
-------------------------------
يستخرج كل النصوص الـ hardcoded من مشروع Flutter
ويحولها لـ ARB files جاهزة للـ localization

الاستخدام:
    python flutter_localize.py --project /path/to/flutter/project
    python flutter_localize.py --project . --langs ar,en,fr
    python flutter_localize.py --project . --dry-run   # معاينة بدون تعديل
"""

import os
import re
import json
import argparse
import shutil
from pathlib import Path
from collections import OrderedDict
from datetime import datetime

# ========== PATTERNS ==========

# نصوص داخل Widgets الشائعة
WIDGET_TEXT_PATTERNS = [
    # Text('...')  أو  Text("...")
    r"""Text\(\s*['"]([^'"\\${}]+)['"]\s*[,)]""",
    # label: '...'  أو  label: "..."
    r"""label\s*:\s*['"]([^'"\\${}]{2,})['"]\s*""",
    # title: '...'
    r"""title\s*:\s*['"]([^'"\\${}]{2,})['"]\s*""",
    # hint: '...'  (هintText)
    r"""hint(?:Text)?\s*:\s*['"]([^'"\\${}]{2,})['"]\s*""",
    # hintText: '...'
    r"""hintText\s*:\s*['"]([^'"\\${}]{2,})['"]\s*""",
    # helperText: '...'
    r"""helperText\s*:\s*['"]([^'"\\${}]{2,})['"]\s*""",
    # errorText: '...'
    r"""errorText\s*:\s*['"]([^'"\\${}]{2,})['"]\s*""",
    # tooltip: '...'
    r"""tooltip\s*:\s*['"]([^'"\\${}]{2,})['"]\s*""",
    # semanticsLabel: '...'
    r"""semanticsLabel\s*:\s*['"]([^'"\\${}]{2,})['"]\s*""",
    # confirmDismiss, message, etc
    r"""message\s*:\s*['"]([^'"\\${}]{2,})['"]\s*""",
    # AppBar title as string
    r"""AppBar\s*\([^)]*title\s*:\s*Text\(\s*['"]([^'"\\${}]+)['"]\s*\)""",
    # SnackBar content
    r"""SnackBar\s*\([^)]*content\s*:\s*Text\(\s*['"]([^'"\\${}]+)['"]\s*\)""",
    # showDialog title/content strings
    r"""AlertDialog\s*\([^)]*title\s*:\s*Text\(\s*['"]([^'"\\${}]+)['"]\s*\)""",
    # ElevatedButton / TextButton / OutlinedButton child Text
    r"""(?:Elevated|Text|Outlined)Button\s*\([^)]*child\s*:\s*Text\(\s*['"]([^'"\\${}]+)['"]\s*\)""",
    # FloatingActionButton tooltip
    r"""FloatingActionButton\s*\([^)]*tooltip\s*:\s*['"]([^'"\\${}]+)['"]\s*""",
]

# نصوص يجب تجاهلها
IGNORE_PATTERNS = [
    r'^https?://',          # URLs
    r'^[/\\]',              # paths
    r'^\d+$',               # أرقام فقط
    r'^[a-z_]+\.[a-z_]+',  # asset paths like 'assets/img.png'
    r'^\s*$',               # فراغات
    r'^[A-Z_]+$',           # constants
    r'^\w+\.\w+\(',        # function calls
    r'^#[0-9a-fA-F]+$',    # hex colors
    r'\.dart$',             # dart file names
    r'\.png$|\.jpg$|\.svg$|\.json$',  # asset files
]

# كلمات تقنية نتجاهلها
TECHNICAL_KEYWORDS = {
    'GET', 'POST', 'PUT', 'DELETE', 'PATCH',
    'null', 'true', 'false', 'void', 'async', 'await',
    'flutter', 'dart', 'widget', 'context', 'BuildContext',
    'StatefulWidget', 'StatelessWidget', 'State',
}


def to_camel_case(text: str) -> str:
    """تحويل النص لـ camelCase مناسب للـ key"""
    # إزالة الأحرف الخاصة
    text = re.sub(r'[^a-zA-Z0-9\s\u0600-\u06FF]', ' ', text)
    words = text.strip().split()
    if not words:
        return 'text'

    # إذا كان النص عربي، نستخدم transliteration بسيطة
    first = words[0]
    if re.search(r'[\u0600-\u06FF]', first):
        # نص عربي - نستخدم index-based key
        return None  # سيتم التعامل معه بشكل مختلف

    result = first[0].lower() + first[1:] if first else ''
    for word in words[1:]:
        result += word.capitalize()
    return result[:50] if result else 'text'


def generate_key(text: str, existing_keys: set, index: int) -> str:
    """توليد key فريد للنص"""
    # محاولة camelCase أولاً
    key = to_camel_case(text)

    if key is None or re.search(r'[\u0600-\u06FF]', text):
        # نص عربي - نستخدم key وصفي
        key = f'text{index:03d}'
    else:
        key = key or f'text{index:03d}'

    # التأكد من الـ uniqueness
    original_key = key
    counter = 1
    while key in existing_keys:
        key = f'{original_key}{counter}'
        counter += 1

    existing_keys.add(key)
    return key


def should_ignore(text: str) -> bool:
    """هل يجب تجاهل هذا النص؟"""
    text = text.strip()

    # قصير جداً (حرف أو حرفين)
    if len(text) < 2:
        return True

    # كلمة تقنية
    if text in TECHNICAL_KEYWORDS:
        return True

    # يطابق أحد أنماط التجاهل
    for pattern in IGNORE_PATTERNS:
        if re.search(pattern, text, re.IGNORECASE):
            return True

    return False


def extract_strings_from_file(file_path: Path) -> list[tuple[int, str, str]]:
    """استخراج النصوص من ملف Dart واحد
    Returns: list of (line_number, original_code, extracted_text)
    """
    results = []
    content = file_path.read_text(encoding='utf-8', errors='ignore')

    # تجاهل الكومنتات
    content_no_comments = re.sub(r'//[^\n]*', '', content)
    content_no_comments = re.sub(r'/\*.*?\*/', '', content_no_comments, flags=re.DOTALL)

    found_texts = set()

    for pattern in WIDGET_TEXT_PATTERNS:
        for match in re.finditer(pattern, content_no_comments, re.DOTALL):
            text = match.group(1).strip()

            if not text or should_ignore(text) or text in found_texts:
                continue

            found_texts.add(text)

            # إيجاد رقم السطر في المحتوى الأصلي
            try:
                pos = content.find(text)
                line_num = content[:pos].count('\n') + 1 if pos >= 0 else 0
            except Exception:
                line_num = 0

            results.append((line_num, match.group(0), text))

    return results


def scan_project(project_path: Path) -> dict:
    """مسح كامل المشروع وإرجاع كل النصوص المستخرجة"""
    dart_files = list(project_path.rglob('*.dart'))

    # استثناء الملفات الـ generated وملفات الـ test
    dart_files = [
        f for f in dart_files
        if not any(part.startswith('.') for part in f.parts)
        and 'generated' not in str(f)
        and '.freezed.' not in f.name
        and '.g.dart' not in f.name
    ]

    print(f"\n📂 تم العثور على {len(dart_files)} ملف Dart")
    print("─" * 50)

    all_strings = {}  # text -> {files: [], key: str}
    existing_keys = set()
    index = 1

    for dart_file in dart_files:
        relative = dart_file.relative_to(project_path)
        extractions = extract_strings_from_file(dart_file)

        if extractions:
            print(f"  ✅ {relative} → {len(extractions)} نص")

        for line_num, original, text in extractions:
            if text not in all_strings:
                key = generate_key(text, existing_keys, index)
                all_strings[text] = {
                    'key': key,
                    'files': [],
                    'line': line_num,
                }
                index += 1

            all_strings[text]['files'].append({
                'file': str(relative),
                'line': line_num,
                'original': original,
            })

    return all_strings


def generate_arb(strings: dict, lang: str, is_template: bool = False) -> dict:
    """توليد محتوى ملف ARB"""
    arb = OrderedDict()
    arb['@@locale'] = lang
    arb['@@last_modified'] = datetime.now().isoformat()

    for text, info in strings.items():
        key = info['key']
        arb[key] = text  # النص الأصلي كـ default value

        if is_template:
            # metadata لـ template فقط
            arb[f'@{key}'] = {
                'description': f'Found in: {info["files"][0]["file"]} (line {info["files"][0]["line"]})',
                'type': 'text',
            }

    return arb


def generate_dart_l10n(strings: dict, class_name: str = 'AppLocalizations') -> str:
    """توليد ملف Dart للـ localization helper"""
    lines = [
        '// GENERATED BY flutter_localize.py',
        '// قم بمراجعة هذا الملف وتعديل الـ keys حسب الحاجة',
        '',
        "import 'package:flutter/material.dart';",
        "import 'package:flutter_gen/gen_l10n/app_localizations.dart';",
        '',
        '// Extension للوصول السريع للـ localizations',
        'extension BuildContextL10n on BuildContext {',
        f'  {class_name} get l10n => {class_name}.of(this)!;',
        '}',
        '',
        '// === قائمة الـ Keys المستخرجة ===',
        '// استخدم AppLocalizations.of(context)!.keyName في كودك',
        '//',
    ]

    for text, info in strings.items():
        key = info['key']
        short_text = text[:60] + '...' if len(text) > 60 else text
        lines.append(f'// {key}: "{short_text}"')

    return '\n'.join(lines)


def replace_in_files(project_path: Path, strings: dict, dry_run: bool = False) -> int:
    """استبدال النصوص في ملفات Dart بـ AppLocalizations.of(context)!.key"""
    replacements_count = 0

    # جمع التعديلات حسب الملف
    file_replacements = {}
    for text, info in strings.items():
        key = info['key']
        for file_info in info['files']:
            file_path = project_path / file_info['file']
            if file_path not in file_replacements:
                file_replacements[file_path] = []
            file_replacements[file_path].append({
                'original': file_info['original'],
                'text': text,
                'key': key,
            })

    for file_path, replacements in file_replacements.items():
        try:
            content = file_path.read_text(encoding='utf-8')
            new_content = content

            for rep in replacements:
                original = rep['original']
                key = rep['key']
                text = rep['text']

                # إنشاء النسخة البديلة
                # Text('...') → Text(AppLocalizations.of(context)!.key)
                new_code = original.replace(f"'{text}'", f'AppLocalizations.of(context)!.{key}')
                new_code = new_code.replace(f'"{text}"', f'AppLocalizations.of(context)!.{key}')

                if new_code != original:
                    new_content = new_content.replace(original, new_code)
                    replacements_count += 1

            if new_content != content:
                if dry_run:
                    print(f"  [DRY-RUN] سيتم تعديل: {file_path.relative_to(project_path)}")
                else:
                    # نسخة احتياطية
                    backup = file_path.with_suffix('.dart.bak')
                    shutil.copy2(file_path, backup)
                    file_path.write_text(new_content, encoding='utf-8')

        except Exception as e:
            print(f"  ⚠️ خطأ في {file_path}: {e}")

    return replacements_count


def setup_l10n_structure(project_path: Path, langs: list[str]) -> None:
    """إنشاء هيكل مجلدات الـ localization"""
    l10n_dir = project_path / 'lib' / 'l10n'
    l10n_dir.mkdir(parents=True, exist_ok=True)

    # l10n.yaml
    yaml_path = project_path / 'l10n.yaml'
    if not yaml_path.exists():
        yaml_content = f"""arb-dir: lib/l10n
template-arb-file: app_{langs[0]}.arb
output-localization-file: app_localizations.dart
output-class: AppLocalizations
nullable-getter: false
"""
        yaml_path.write_text(yaml_content)
        print(f"  ✅ تم إنشاء l10n.yaml")

    # pubspec.yaml - إضافة flutter_localizations
    pubspec_path = project_path / 'pubspec.yaml'
    if pubspec_path.exists():
        pubspec = pubspec_path.read_text()
        if 'flutter_localizations' not in pubspec:
            print(f"\n  ⚠️  أضف هذا لـ pubspec.yaml يدوياً:")
            print("""
  dependencies:
    flutter_localizations:
      sdk: flutter
    intl: any

  flutter:
    generate: true
""")


def main():
    parser = argparse.ArgumentParser(
        description='Flutter Localization Extractor - يستخرج النصوص ويعمل ARB files'
    )
    parser.add_argument('--project', '-p', default='.', help='مسار مشروع Flutter')
    parser.add_argument('--langs', '-l', default='en,ar', help='اللغات (مثال: en,ar,fr)')
    parser.add_argument('--output', '-o', default='lib/l10n', help='مجلد الـ output')
    parser.add_argument('--dry-run', '-d', action='store_true', help='معاينة بدون تعديل')
    parser.add_argument('--no-replace', action='store_true', help='إنشاء ARB فقط بدون تعديل الكود')
    parser.add_argument('--class-name', default='AppLocalizations', help='اسم الـ class')

    args = parser.parse_args()

    project_path = Path(args.project).resolve()
    langs = [l.strip() for l in args.langs.split(',')]
    output_dir = project_path / args.output

    print('=' * 60)
    print('🌍 Flutter Localization Extractor')
    print('=' * 60)
    print(f'📁 المشروع: {project_path}')
    print(f'🌐 اللغات: {", ".join(langs)}')
    print(f'📤 المخرجات: {output_dir}')
    if args.dry_run:
        print('👁  وضع المعاينة (DRY-RUN) - لن يتم حفظ أي تغييرات')
    print()

    # التحقق من وجود المشروع
    if not (project_path / 'pubspec.yaml').exists():
        print('❌ خطأ: المسار المحدد لا يحتوي على مشروع Flutter (pubspec.yaml غير موجود)')
        return 1

    # ===== المرحلة 1: استخراج النصوص =====
    print('📖 المرحلة 1: استخراج النصوص من ملفات Dart...')
    all_strings = scan_project(project_path)

    if not all_strings:
        print('\n✅ لم يتم العثور على نصوص hardcoded قابلة للاستخراج.')
        return 0

    print(f'\n📊 إجمالي النصوص المستخرجة: {len(all_strings)}')

    # ===== المرحلة 2: إنشاء ARB Files =====
    print('\n📝 المرحلة 2: إنشاء ملفات ARB...')
    output_dir.mkdir(parents=True, exist_ok=True)

    for i, lang in enumerate(langs):
        is_template = (i == 0)  # أول لغة هي الـ template
        arb_content = generate_arb(all_strings, lang, is_template=is_template)
        arb_path = output_dir / f'app_{lang}.arb'

        if not args.dry_run:
            with open(arb_path, 'w', encoding='utf-8') as f:
                json.dump(arb_content, f, ensure_ascii=False, indent=2)
            print(f'  ✅ {arb_path.relative_to(project_path)}')
        else:
            print(f'  [DRY-RUN] سيتم إنشاء: app_{lang}.arb ({len(arb_content)} keys)')

    # ===== المرحلة 3: ملف Dart Helper =====
    print('\n🛠  المرحلة 3: إنشاء Dart helper...')
    helper_content = generate_dart_l10n(all_strings, args.class_name)
    helper_path = project_path / 'lib' / 'core' / 'l10n_helper.dart'

    if not args.dry_run:
        helper_path.parent.mkdir(parents=True, exist_ok=True)
        helper_path.write_text(helper_content, encoding='utf-8')
        print(f'  ✅ {helper_path.relative_to(project_path)}')

    # ===== المرحلة 4: إعداد الهيكل =====
    print('\n⚙️  المرحلة 4: إعداد هيكل الـ localization...')
    if not args.dry_run:
        setup_l10n_structure(project_path, langs)

    # ===== المرحلة 5: استبدال في الكود (اختياري) =====
    if not args.no_replace:
        print('\n🔄 المرحلة 5: استبدال النصوص في الكود...')
        if args.dry_run:
            print('  (وضع المعاينة - لن يتم التعديل)')
            count = replace_in_files(project_path, all_strings, dry_run=True)
        else:
            print('  ⚠️  سيتم إنشاء نسخ احتياطية (.dart.bak) لكل ملف يتم تعديله')
            count = replace_in_files(project_path, all_strings, dry_run=False)
            print(f'  ✅ تم تعديل {count} موضع في الكود')

    # ===== ملخص المخرجات =====
    print('\n' + '=' * 60)
    print('✨ تم الانتهاء! ملخص المخرجات:')
    print('=' * 60)
    print(f'  📊 نصوص مستخرجة: {len(all_strings)}')
    print(f'  📁 ملفات ARB: {len(langs)} ملف في {args.output}/')
    print()
    print('📋 الخطوات القادمة:')
    print('  1️⃣  راجع ملفات ARB وتأكد من صحة الـ keys')
    print('  2️⃣  ترجم النصوص في ملفات اللغات الأخرى')
    print('  3️⃣  أضف flutter_localizations لـ pubspec.yaml')
    print('  4️⃣  شغّل: flutter gen-l10n')
    print('  5️⃣  أضف للـ MaterialApp:')
    print('        localizationsDelegates: AppLocalizations.localizationsDelegates,')
    print('        supportedLocales: AppLocalizations.supportedLocales,')
    print()

    if not args.no_replace and not args.dry_run:
        print('  ⚠️  تحقق من الكود بعد الاستبدال - بعض الأماكن قد تحتاج تعديل يدوي')
        print('  💾 النسخ الاحتياطية محفوظة كـ .dart.bak')

    return 0


if __name__ == '__main__':
    exit(main())
