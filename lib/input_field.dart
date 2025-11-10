import 'package:flutter/material.dart';

class InputField extends StatefulWidget {
  const InputField({super.key});

  @override
  State<InputField> createState() => _InputField();
}

class _InputField extends State<InputField> {

  void handleSubmit(value) {

  }


  @override
  Widget build(BuildContext context) {
    return TextField(
        decoration: const InputDecoration(
          labelText: 'Add item',
          border: OutlineInputBorder(),
        ),
        onSubmitted: (value) {
          handleSubmit(value);
        },
    );
  }
}
