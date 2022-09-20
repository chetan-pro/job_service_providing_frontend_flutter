import 'package:flutter/material.dart';
import 'package:hindustan_job/candidate/model/job_model_two.dart';
import 'package:hindustan_job/candidate/theme_modeule/new_text_style.dart';
import 'package:hindustan_job/constants/colors.dart';
import 'package:hindustan_job/widget/text_form_field_widget.dart';

import 'function_utility.dart';

bottomSheeetSortByRelevance(context) {
  return showModalBottomSheet<void>(
      context: context,
      builder: (BuildContext context) {
        return SafeArea(
            child: Container(
          height: 120,
          padding: EdgeInsets.only(left: 8),
          decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(.5),
                offset: const Offset(
                  -5.0,
                  -5.0,
                ),
                blurRadius: 10.0,
              ),
            ],
            color: MyAppColor.backgroundColor,
          ),
          child: Wrap(children: <Widget>[
            new ListTile(
                title: new Text('Ascending', style: blackBold18),
                onTap: () {
                  Navigator.pop(context, 'Ascending');
                }),
            new ListTile(
                title: new Text('Descending', style: blackBold18),
                onTap: () {
                  Navigator.pop(context, 'Descending');
                })
          ]),
        ));
      });
}

questionAndAnswerDialog(context, List<Questions>? questions, {title}) async {
  List<TextEditingController> _controller = [];
  var _formCurrentJobKey = GlobalKey<FormState>();

  return showDialog<String>(
    context: context,
    builder: (BuildContext context) => Container(
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(.3),
            offset: const Offset(
              5.0,
              5.0,
            ),
            blurRadius: 8.0,
          ),
        ],
      ),
      child: AlertDialog(
        backgroundColor: MyAppColor.backgroundColor,
        elevation: 10,
        title: Text(
          title,
          style: TextStyle(color: MyAppColor.blackdark, fontSize: 18),
        ),
        content: SingleChildScrollView(
          child: Form(
            key: _formCurrentJobKey,
            child: Column(
                children: List.generate(questions!.length, (index) {
              TextEditingController controller = TextEditingController();
              _controller.add(controller);
              return Padding(
                padding: const EdgeInsets.only(bottom: 5.0),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                          "${index + 1}. ${getCapitalizeString(questions[index].questions)}",
                          style: TextStyle(color: MyAppColor.blackdark)),
                      SizedBox(height: 2),
                      TextFormFieldWidget(
                        type: TextInputType.multiline,
                        text: 'Answer',
                        control: _controller[index],
                        isRequired: true,
                      )
                    ]),
              );
            })),
          ),
        ),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.pop(context, 'Cancel'),
            child: Text(
              'No',
              style: TextStyle(color: MyAppColor.blackdark),
            ),
          ),
          TextButton(
            onPressed: () {
              if (!isFormValid(_formCurrentJobKey)) {
                return;
              }
              List answers = _controller.map((e) {
                if (e.toString().isEmpty) {}
                return e.text;
              }).toList();

              String ans = answers.join(',');
              if (ans.isEmpty) {
                toast('Please fill answers');
              }
              Navigator.pop(context, answers.join(','));
            },
            child: Text('Done', style: TextStyle(color: MyAppColor.blackdark)),
          ),
        ],
      ),
    ),
  );
}
