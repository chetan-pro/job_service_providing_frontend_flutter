import 'package:flutter/material.dart';
import 'package:hindustan_job/widget/text_form_field_widget.dart';

class NonEditableTextField extends StatelessWidget {
  String value;
  String label;
  NonEditableTextField({Key? key, required this.value, required this.label})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormFieldWidget(
      text: label,
      control: TextEditingController(text: value),
      isRequired: false,
      type: TextInputType.none,
      enableCursor: false,
      enableInterative: false,
    );
  }
}
