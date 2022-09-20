import 'package:flutter/material.dart';
import 'package:hindustan_job/candidate/theme_modeule/theme.dart';
import 'package:hindustan_job/config/responsive.dart';
import 'package:hindustan_job/config/size_config.dart';

import 'package:hindustan_job/constants/colors.dart';

class ResumeResultBox extends StatelessWidget {
  ResumeResultBox({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final styles = Mytheme.lightTheme(context).textTheme.headline1!;
    Sizeconfig().init(context);
    return Container(
        margin: EdgeInsets.only(
          left: Responsive.isDesktop(context) ? 12 : 00,
        ),
        width: Responsive.isDesktop(context)
            ? MediaQuery.of(context).size.width / 4.7
            : 500,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5),
          color: Colors.grey[300],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Container(
                  height: 20,
                  color: MyAppColor.backgray,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 6,right: 6),
                    child: Row(
                      children: [
                        Icon(Icons.arrow_forward,color: Colors.green,size: 14,),
                        Text("Available for job",style: TextStyle(
                          fontSize: 10,
                          color: Colors.green
                        ),)
                      ],
                    ),
                  ),
                  
                ),
              ],
            ),
            SizedBox(
              height: Responsive.isMobile(context) ? 10 : 6,
            ),
            Padding(
              padding: EdgeInsets.only(
                left: Responsive.isMobile(context) ? 20 : 10,
                right: 20,
              ),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [

                    Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(right: 5),
                          child: CircleAvatar(
                            child: ClipOval(
                              child: Image.asset(
                                'assets/male.png',
                                height: 40,
                                width: 40,
                                fit: BoxFit.cover,
                              ),
                            ),
                            backgroundColor: Colors.transparent,
                          ),
                        ),
                        Column(
                          children: [
                            Text('John Kumar Cena',
                                style: styles.copyWith(
                                    fontSize: 18, fontWeight: FontWeight.w700)),

                            Text('Experience 3+ years',
                                style: styles.copyWith(
                                    fontSize: 14, fontWeight: FontWeight.w700)),
                          ],
                        )
                      ],
                    ),
                    SizedBox(
                      height: Responsive.isMobile(context) ? 12 : 7,
                    ),
                    Row(
                      children: [
                        
                        Chip(
                          visualDensity: VisualDensity(horizontal: 0.0, vertical: -4),
                          backgroundColor: MyAppColor.chipcolor,
                          avatar: CircleAvatar(
                            radius: 9.0,
                            backgroundColor: MyAppColor.white,
                            child: Icon(Icons.edit,size: 12,),
                          ),
                          label: Text('Adobe photoshop',style: TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                          ),),
                        ),
                        SizedBox(
                          width: 3,
                        ),
                        Chip(
                          visualDensity: VisualDensity(horizontal: 0.0, vertical: -4),
                          backgroundColor: MyAppColor.chipcolor,
                          avatar: CircleAvatar(
                            radius: 9.0,
                            backgroundColor: MyAppColor.white,
                            child: Icon(Icons.edit,size: 12,),
                          ),
                          label: Text('Blender',style: TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                          ),),
                        ),
                        SizedBox(
                          width: 3,
                        ),
                        Chip(
                          visualDensity: VisualDensity(horizontal: 0.0, vertical: -4),
                          backgroundColor: MyAppColor.chipcolor,
                          avatar: CircleAvatar(
                            radius: 9.0,
                            backgroundColor: MyAppColor.white,
                            child: Icon(Icons.edit,size: 12,),
                          ),
                          label: Text('...',style: TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                          ),),
                        ),

                      ],
                    ),
                    SizedBox(
                      height: Responsive.isMobile(context) ? 14 : 13,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Icon(
                              Icons.location_on,
                              size: 12,
                            ),
                            SizedBox(
                              width: 3,
                            ),
                            Text(
                              'Bhopal Madhaya Pradesh',
                              style: styles.copyWith(
                                fontSize: 14,
                              ),
                            ),
                            // SizedBox(
                            //   width: Responsive.isMobile(context) ? 75 : 110,
                            // ),
                          ],
                        ),
                        Row(
                          // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'View profile',
                              style: styles.copyWith(
                                  fontSize: 14, color: MyAppColor.orangedark),
                            ),
                            Icon(
                              Icons.arrow_forward,
                              color: MyAppColor.orangedark,
                              size: Responsive.isMobile(context) ? 14 : 15,
                            ),
                          ],
                        )
                      ],
                    ),

                  ],
                ),
              ),
            ),
            SizedBox(height: 15,),
            Container(
              height: 30,
              color: MyAppColor.simplegrey,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Currently Salary per Annum",style: TextStyle(
                      fontSize: 11
                    ),),
                    Text("8.50,523",style: TextStyle(
                        fontSize: 11
                    ),)
                  ],
                ),
              ),
            ),
          ],
        ));
  }
}
