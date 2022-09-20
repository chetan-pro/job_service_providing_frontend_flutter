import 'package:flutter/material.dart';
import 'package:hindustan_job/candidate/model/company_image_model.dart';
import 'package:hindustan_job/candidate/theme_modeule/theme.dart';
import 'package:hindustan_job/config/responsive.dart';
import 'package:hindustan_job/config/size_config.dart';
import 'package:hindustan_job/constants/colors.dart';
import 'package:hindustan_job/constants/mystring_text.dart';
import 'package:hindustan_job/utility/function_utility.dart';
import 'package:hindustan_job/widget/landing_page_widget/footer.dart';

class WorkCulture extends StatefulWidget {
  List<CompanyImage>? companyImageList;
  WorkCulture({Key? key, this.companyImageList}) : super(key: key);

  @override
  _WorkCultureState createState() => _WorkCultureState();
}

class _WorkCultureState extends State<WorkCulture> {
  @override
  Widget build(BuildContext context) {
    final styles = Mytheme.lightTheme(context).textTheme.headline1!;
    return ListView(
      children: [
        SizedBox(
          height: Sizeconfig.screenHeight! / 20,
        ),
        !Responsive.isDesktop(context)
            ? Column(
                children: List.generate(
                    widget.companyImageList!.length,
                    (index) => mainOffice(styles,
                        object: widget.companyImageList![index])))
            : Padding(
                padding: const EdgeInsets.only(left: 12.0),
                child: Center(
                  child: Wrap(
                    runSpacing: 10,
                    children: List.generate(
                    widget.companyImageList!.length,
                    (index) => mainOffice(styles,
                        object: widget.companyImageList![index])),
                  ),
                ),
              ),
        SizedBox(
          height: Sizeconfig.screenHeight! / 20,
        ),
        Footer(),
        Container(
          alignment: Alignment.center,
          color: MyAppColor.normalblack,
          height: 30,
          width: double.infinity,
          child: Text(Mystring.hackerkernel,
              style: Mytheme.lightTheme(context)
                  .textTheme
                  .headline1!
                  .copyWith(color: MyAppColor.white)),
        ),
      ],
    );
  }

  Padding mainOffice(TextStyle styles, {CompanyImage? object}) {
    return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
        child: Container(
          alignment: Alignment.bottomLeft,
          height: Sizeconfig.screenHeight! / 2.5,
          width: !Responsive.isDesktop(context)
              ? Sizeconfig.screenWidth
              : Sizeconfig.screenWidth! / 5,
          decoration: BoxDecoration(
            image: DecorationImage(
                image: NetworkImage('${currentUrl(object!.image)}'),
                fit: BoxFit.cover),
          ),
          child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Text('${object.title}',
                      style:
                          styles.copyWith(color: MyAppColor.backgroundColor)),
                ),
              ]),
        ));
  }
}
