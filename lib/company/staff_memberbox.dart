import 'package:flutter/material.dart';
import 'package:hindustan_job/candidate/model/Company/staff_data.dart';
import 'package:hindustan_job/candidate/model/user_model.dart';
import 'package:hindustan_job/config/size_config.dart';
import 'package:hindustan_job/constants/colors.dart';

class StaffMemberBox extends StatefulWidget {
  List<UserData> staff;
  StaffMemberBox({Key? key, required this.staff}) : super(key: key);

  @override
  _StaffMemberBoxState createState() => _StaffMemberBoxState();
}

class _StaffMemberBoxState extends State<StaffMemberBox> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: MyAppColor.greynormal,
      child: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("#01"),
                Text(
                  "Enabled",
                  style: TextStyle(
                      color: Colors.green, fontWeight: FontWeight.bold),
                )
              ],
            ),
            SizedBox(
              height: 15,
            ),
            Text(
              "Brock Singh Lesnar",
              style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 16),
            ),
            SizedBox(
              height: 6,
            ),
            Text(
              "Mob No : 9876543210",
              style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.w400,
                  fontSize: 14),
            ),
            SizedBox(
              height: 15,
            ),
            Column(
              children: [
                Container(
                  color: MyAppColor.grayplane,
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Email",
                          style: TextStyle(
                            fontSize: 12,
                          ),
                        ),
                        Text(
                          "Example@gmail.com",
                          style: TextStyle(
                              fontSize: 12, fontWeight: FontWeight.bold),
                        )
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  height: 6,
                ),
                Container(
                  color: MyAppColor.grayplane,
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Password",
                          style: TextStyle(
                            fontSize: 12,
                          ),
                        ),
                        Text(
                          "erre53535",
                          style: TextStyle(
                              fontSize: 12, fontWeight: FontWeight.bold),
                        )
                      ],
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 20,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    OutlinedButton(
                      onPressed: () {},
                      child: Icon(
                        Icons.edit,
                        color: Colors.black,
                      ),
                      style: OutlinedButton.styleFrom(
                          side: BorderSide(color: Colors.black)),
                    ),
                    SizedBox(
                      width: 15,
                    ),
                    OutlinedButton(
                      onPressed: () {},
                      child: Icon(
                        Icons.delete,
                        color: Colors.black,
                      ),
                      style: OutlinedButton.styleFrom(
                          side: BorderSide(color: Colors.black)),
                    )
                  ],
                ),
                OutlinedButton(
                  onPressed: () {},
                  child: Icon(
                    Icons.arrow_forward,
                    color: Colors.black,
                  ),
                  style: OutlinedButton.styleFrom(
                      side: BorderSide(color: Colors.black)),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
