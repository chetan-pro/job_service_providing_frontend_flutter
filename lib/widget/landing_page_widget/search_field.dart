import 'package:flutter/material.dart';
import 'package:hindustan_job/candidate/pages/landing_page/search_job_here.dart';
import 'package:hindustan_job/config/responsive.dart';
import 'package:hindustan_job/config/size_config.dart';
import 'package:hindustan_job/constants/colors.dart';
import 'package:hindustan_job/utility/function_utility.dart';

class Search extends StatefulWidget {
  String? text;
  var route;
  Search({Key? key, this.text, this.route}) : super(key: key);

  @override
  State<Search> createState() => _SearchState();
}

class _SearchState extends State<Search> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () async {
          if(widget.route==null){

          await widgetFullScreenPopDialog(SerchJobHere(), context,
              width: Sizeconfig.screenWidth);
          }else{

          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => widget.route ));
          }
        },
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10),
          color: MyAppColor.white,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Icon(
                Icons.search,
                size: !Responsive.isDesktop(context) ? 23 : 15,
                color: MyAppColor.orangelight,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 3),
                child: Text(
                  widget.text ?? 'Search job here',
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.grey[400],
                      fontSize: Responsive.isMobile(context) ? 12 : 10),
                ),
              )
            ],
          ),
        ));
  }
}
