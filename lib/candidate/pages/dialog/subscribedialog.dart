import 'package:flutter/material.dart';
import 'package:hindustan_job/candidate/model/subscription_order.dart';
import 'package:hindustan_job/constants/colors.dart';
import 'package:hindustan_job/utility/function_utility.dart';

class SubsCribe extends StatelessWidget {
  var data;
  String? description;
  SubsCribe({Key? key, this.data, this.description}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: Container(
        height: 250,
        child: Center(
          child: Column(
            children: [
              SizedBox(
                height: 15,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Subscribed "),
                  Text(
                    "Successfully",
                    style: TextStyle(color: MyAppColor.orangelight),
                  )
                ],
              ),
              SizedBox(
                height: 15,
              ),
              Image.asset(
                "assets/subscribesucessicon.png",
                height: 70,
                width: 70,
              ),
              SizedBox(
                height: 15,
              ),
              Text(
                "Congratulations! You have successfully Subscribed ",
                textAlign: TextAlign.center,
              ),
              SizedBox(
                height: 15,
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                  Navigator.pop(context);
                },
                child: Text("Done"),
                style: ElevatedButton.styleFrom(
                  primary: MyAppColor.orangelight,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
