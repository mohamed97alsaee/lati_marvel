import 'package:flutter/material.dart';

class TextFieldWidget extends StatefulWidget {
  const TextFieldWidget(
      {super.key,
      required this.controller,
      required this.validator,
      required this.hint,
      required this.label,
      this.obSecure = false,
      this.perffix,
      this.suffix,
      this.isEnabled = true});
  final TextEditingController controller;

  final FormFieldValidator<String?> validator;
  final String hint;
  final String label;
  final bool obSecure;
  final Widget? perffix;
  final Widget? suffix;
  final bool isEnabled;

  @override
  State<TextFieldWidget> createState() => _TextFieldWidgetState();
}

class _TextFieldWidgetState extends State<TextFieldWidget> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextFormField(
        enabled: widget.isEnabled,
        obscureText: widget.obSecure,
        controller: widget.controller,
        validator: widget.validator,
        decoration: InputDecoration(
          suffix: widget.suffix,
          prefix: widget.perffix,
          label: Text(widget.label),
          hintText: widget.hint,
        ),
      ),
    );
  }
}
