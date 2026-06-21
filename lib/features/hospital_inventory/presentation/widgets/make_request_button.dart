import 'package:blood_bridge/core/utiles/app_colors.dart';
import 'package:flutter/material.dart';

const _bloodTypes = ['A+', 'A-', 'B+', 'B-', 'O+', 'O-', 'AB+', 'AB-'];

/// Bottom button that opens a small form sheet for submitting a
/// new blood request (blood type + units needed).
class MakeRequestButton extends StatelessWidget {
  const MakeRequestButton({
    super.key,
    required this.isSubmitting,
    required this.onSubmit,
  });

  final bool isSubmitting;
  final void Function(String bloodType, int unitsNeeded) onSubmit;

  Future<void> _openSheet(BuildContext context) async {
    final result = await showModalBottomSheet<Map<String, dynamic>>(
      context: context,
      backgroundColor: AppColors.popover,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) => const _RequestForm(),
    );

    if (result != null) {
      onSubmit(result['bloodType'] as String, result['units'] as int);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: SizedBox(
        width: double.infinity,
        height: 48,
        child: ElevatedButton.icon(
          onPressed: isSubmitting ? null : () => _openSheet(context),
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primary,
            disabledBackgroundColor: AppColors.likeprimary,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          ),
          icon: isSubmitting
              ? const SizedBox(
                  width: 16,
                  height: 16,
                  child: CircularProgressIndicator(strokeWidth: 2, color: AppColors.primaryForeground),
                )
              : const Icon(Icons.add, color: AppColors.primaryForeground),
          label: Text(
            isSubmitting ? 'Submitting...' : 'Make New Request',
            style: const TextStyle(color: AppColors.primaryForeground, fontSize: 14, fontWeight: FontWeight.w600),
          ),
        ),
      ),
    );
  }
}

class _RequestForm extends StatefulWidget {
  const _RequestForm();

  @override
  State<_RequestForm> createState() => _RequestFormState();
}

class _RequestFormState extends State<_RequestForm> {
  String _bloodType = _bloodTypes.first;
  final _unitsController = TextEditingController(text: '1');

  @override
  void dispose() {
    _unitsController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(16, 16, 16, 16 + MediaQuery.of(context).viewInsets.bottom),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'New Blood Request',
            style: TextStyle(color: AppColors.text, fontSize: 16, fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 16),
          const Text('Blood Type', style: TextStyle(color: AppColors.textMuted, fontSize: 12)),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: _bloodTypes.map((type) {
              final selected = type == _bloodType;
              return ChoiceChip(
                label: Text(type),
                selected: selected,
                onSelected: (_) => setState(() => _bloodType = type),
                backgroundColor: AppColors.muted,
                selectedColor: AppColors.primary,
                labelStyle: TextStyle(
                  color: selected ? AppColors.primaryForeground : AppColors.text,
                  fontSize: 13,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                  side: BorderSide(color: selected ? AppColors.primary : AppColors.border),
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: 16),
          const Text('Units Needed', style: TextStyle(color: AppColors.textMuted, fontSize: 12)),
          const SizedBox(height: 8),
          TextField(
            controller: _unitsController,
            keyboardType: TextInputType.number,
            style: const TextStyle(color: AppColors.text),
            decoration: InputDecoration(
              filled: true,
              fillColor: AppColors.input,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(color: AppColors.border),
              ),
              contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            ),
          ),
          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            height: 48,
            child: ElevatedButton(
              onPressed: () {
                final units = int.tryParse(_unitsController.text) ?? 1;
                Navigator.pop(context, {'bloodType': _bloodType, 'units': units});
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              child: const Text('Submit Request', style: TextStyle(color: AppColors.primaryForeground, fontWeight: FontWeight.w600)),
            ),
          ),
        ],
      ),
    );
  }
}
