import 'package:flutter/material.dart';

import 'friendtext_field.dart';

class MyForm extends StatefulWidget {
  const MyForm({Key? key}) : super(key: key);


  @override
  MyFormState createState() => MyFormState();
}

class MyFormState extends State<MyForm> {

  static List<String> friendsList = [];
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(title: Text('Dynamic TextFormFields'),),
    body: Form(
      key: _formKey,
    child: Padding(
      padding: const EdgeInsets.all(16.0),
       child: Column(
         crossAxisAlignment: CrossAxisAlignment.start,
         children: [
           Padding(
             padding: const EdgeInsets.only(right: 32.0),
             child: TextFormField(
               controller: _nameController,
               decoration: InputDecoration(
                   hintText: 'Enter your name'
               ),
               validator: (v){
                 if(v!.trim().isEmpty){
                   return 'Please enter something';
                 }
                 return null;
               },
             ),
           ),
           SizedBox(height: 20,),
           Text('Add Friends', style: TextStyle(
               fontWeight: FontWeight.w700,
               fontSize: 16,
             ),),
           ..._getFriends(),
           SizedBox(height: 40,),
           TextButton(
             onPressed: (){
               if(_formKey.currentState!.validate()){
                 _formKey.currentState!.save();
               }
             },
             child: Text('Submit'),
           ),
         ],
    )
    )
    ),
    );
  }

  List<Widget> _getFriends(){
    List<Widget> friendsTextFieldsList = [];
    for(int i=0; i<friendsList.length; i++){
      friendsTextFieldsList.add(
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16.0),
            child: Row(
              children: [
                Expanded(child: FriendTextFields(i)),
                SizedBox(width: 16,),
                _addRemoveButton(i == friendsList.length-1, i),
              ],
            ),
          )
      );
    }
    return friendsTextFieldsList;
  }

  Widget _addRemoveButton(bool add, int index){
    return InkWell(
      onTap: (){
        if(add){
          friendsList.insert(0,"");
        }
        else friendsList.removeAt(index);
        setState((){});
      },
      child: Container(
        width: 30,
        height: 30,
        decoration: BoxDecoration(
          color: (add) ? Colors.green : Colors.red,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Icon(
          (add) ? Icons.add : Icons.remove, color: Colors.white,
        ),
      ),
    );
  }

}
