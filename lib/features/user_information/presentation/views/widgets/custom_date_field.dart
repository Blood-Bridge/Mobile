import 'package:blood_bridge/core/models/snackbar_type.dart';
import 'package:blood_bridge/core/services/text_style_helper.dart';
import 'package:blood_bridge/core/utiles/app_colors.dart';
import 'package:blood_bridge/core/widgets/custom_snackbar.dart';
import 'package:flutter/material.dart';

class CustomDateField extends StatefulWidget {
  final String label;
  final Function(DateTime) onDateSelected;
  final String? date;
  const CustomDateField({
    required this.label,
    required this.onDateSelected,
    required this.date,
  });

  @override
  _CustomDateFieldState createState() => _CustomDateFieldState();
}

class _CustomDateFieldState extends State<CustomDateField> {
  TextEditingController _controller = TextEditingController();

  Future<void> _selectDate() async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime(2008),
      firstDate: DateTime(1980),
      lastDate: DateTime.now(),
    );

    if (pickedDate != null) {
      int age = DateTime.now().year - pickedDate.year;

      if (age < 18) {
        showSnackBar("Not Allowed", "Age less than 18", SnackbarType.error);
        return;
      }

      _controller.text =
          "${pickedDate.day}/${pickedDate.month}/${pickedDate.year}";

      widget.onDateSelected(pickedDate);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(widget.label, style: TextStyleHelper.small(context)),
        SizedBox(height: 8),
        TextField(
          controller: _controller,
          readOnly: true,
          onTap: _selectDate,
          style: TextStyle(color: AppColors.textMuted),
          decoration: InputDecoration(
            hintText: widget.date ?? "mm/dd/yyyy",
            prefixIcon: Icon(Icons.calendar_today),
            filled: true,
            fillColor: AppColors.card,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(color: AppColors.border),
            ),
          ),
        ),
      ],
    );
  }
}
