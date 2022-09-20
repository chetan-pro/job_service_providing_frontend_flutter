import 'package:flutter/material.dart';
import 'package:hindustan_job/company/home/dynamic_forrmstate.dart';

class FriendTextFields extends StatefulWidget {
  final int index;
  FriendTextFields(this.index);

  @override
  _FriendTextFieldsState createState() => _FriendTextFieldsState();
}

class _FriendTextFieldsState extends State<FriendTextFields> {
  late TextEditingController _nameController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _nameController.text = MyFormState.friendsList[widget.index];
    });
    return TextFormField(
      controller: _nameController,
      onChanged: (v) => MyFormState.friendsList[widget.index] = v,
      decoration: InputDecoration(hintText: 'Enter your friend\'s name'),
      validator: (v) {
        if (v!.trim().isEmpty) return 'Please enter something';
        return null;
      },
    );
  }
}
