import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hindustan_job/candidate/model/user_model.dart';
import 'package:hindustan_job/candidate/theme_modeule/new_text_style.dart';
import 'package:hindustan_job/candidate/theme_modeule/text_style.dart';
import 'package:hindustan_job/company/home/homepage.dart';
import 'package:hindustan_job/config/responsive.dart';
import 'package:hindustan_job/config/size_config.dart';
import 'package:hindustan_job/constants/colors.dart';
import 'package:hindustan_job/constants/mystring_text.dart';
import 'package:hindustan_job/services/auth/auth.dart';
import 'package:hindustan_job/services/auth/auth_services.dart';
import 'package:hindustan_job/services/auth/company_services.dart';
import 'package:hindustan_job/services/services_constant/response_model.dart';
import 'package:hindustan_job/widget/buttons/submit_elevated_button.dart';
import 'package:hindustan_job/widget/landing_page_widget/footer.dart';

class ProfileOverViewCompany extends ConsumerStatefulWidget {
  const ProfileOverViewCompany({Key? key}) : super(key: key);

  @override
  _ProfileOverViewCompanyState createState() => _ProfileOverViewCompanyState();
}

class _ProfileOverViewCompanyState
    extends ConsumerState<ProfileOverViewCompany> {
  bool isEditing = false;

  TextEditingController descriptionController =
      TextEditingController(text: userData!.companyDescription ?? '');
  updateOverview(text) async {
    var data = {"company_description": text};

    ApiResponse response = await updateCompanyOverview(data);

    if (response.status == 200) {
      ApiResponse profileResponse = await getProfile(userData!.resetToken);

      UserData user = UserData.fromJson(profileResponse.body!.data);

      await setUserData(user);

      ref.read(companyProfile).updateUserData(user);

      setState(() {
        isEditing = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Column(
            children: [
              if (Responsive.isDesktop(context))
                SizedBox(
                  height: 40,
                ),
              Container(
                width: Responsive.isDesktop(context)
                    ? Sizeconfig.screenWidth! / 1.5
                    : double.infinity,
                color: MyAppColor.greynormal,
                child: Padding(
                  padding: const EdgeInsets.only(
                      left: 15, right: 15, top: 10, bottom: 10),
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          !Responsive.isDesktop(context)
                              ? "OverView"
                              : "Company Overview",
                          style: Responsive.isDesktop(context)
                              ? appleColorR10
                              : GoogleFonts.darkerGrotesque(fontSize: 16),
                        ),
                        SizedBox(
                          height: 14,
                        ),
                        isEditing
                            ? _companyDescription(
                                context, descriptionController)
                            : _contant(descriptionController.text),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        SizedBox(
          height: 20,
        ),
        Responsive.isDesktop(context)
            ? Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  isEditing
                      ? ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              primary: MyAppColor.orangelight),
                          onPressed: () async {
                            isEditing = false;
                            await updateOverview(descriptionController.text);
                          },
                          child: Text('update company overview'))
                      : InkWell(
                          onTap: () async {
                            isEditing = true;
                            setState(() {});
                          },
                          child: Text(
                            "  edit company overview ",
                            style: orangeLightM12(),
                          ),
                        )
                ],
              )
            : Container(
                margin: const EdgeInsets.symmetric(horizontal: 50),
                child: isEditing
                    ? SubmitElevatedButton(
                        label: "update company overview",
                        onSubmit: () async {
                          isEditing = false;
                          await updateOverview(descriptionController.text);
                        },
                      )
                    : editButton(),
              ),
        if (Responsive.isDesktop(context))
          SizedBox(
            height: 80,
          ),
        Footer(),
        Container(
          alignment: Alignment.center,
          color: MyAppColor.normalblack,
          height: 30,
          width: double.infinity,
          child: Text(
            Mystring.hackerkernel,
            style: TextStyle(
              color: MyAppColor.white,
              fontSize: 15,
            ),
          ),
        ),
      ],
    );
  }

  editButton() {
    return SizedBox(
      width: 50,
      child: SubmitElevatedButton(
        label: "edit company overview",
        onSubmit: () {
          isEditing = true;
          setState(() {});
        },
      ),
    );
  }

  Widget _companyDescription(BuildContext context, controller) {
    return TextField(
      controller: controller,
      textAlign: TextAlign.justify,
      decoration: InputDecoration(
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(2),
          borderSide: BorderSide(color: Colors.white70),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(2),
          borderSide: BorderSide(color: Colors.white),
        ),
        fillColor: Colors.white,
        filled: true,
        hintText: 'Company Overview',
        contentPadding: EdgeInsets.only(left: 16, top: 20),
        hintStyle: !Responsive.isDesktop(context)
            ? blackDarkOpacityM14()
            : blackDarkOpacityM12(),
      ),
      keyboardType: TextInputType.multiline,
      minLines: null,
      maxLines: !Responsive.isDesktop(context) ? 8 : 3,
    );
  }

  _contant(content) {
    return SingleChildScrollView(
      child: Text("$content",
          textAlign: TextAlign.justify,
          style: Responsive.isDesktop(context)
              ? blackDarkM14()
              : GoogleFonts.darkerGrotesque(fontSize: 16)),
    );
  }
}
