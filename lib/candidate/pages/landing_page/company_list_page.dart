import 'package:flutter/material.dart';
import 'package:hindustan_job/candidate/model/user_model.dart';
import 'package:hindustan_job/candidate/pages/job_seeker_widget/jobseekartab.dart';
import 'package:hindustan_job/constants/colors.dart';
import 'package:hindustan_job/services/api_services/home_page_services.dart';
import 'package:hindustan_job/utility/function_utility.dart';
import 'package:hindustan_job/widget/landing_page_widget/company_thats_trust_us.dart';

class CompanyListPage extends StatefulWidget {
  List<UserData> companyList;
  CompanyListPage({Key? key, required this.companyList}) : super(key: key);

  @override
  State<CompanyListPage> createState() => _CompanyListPageState();
}

class _CompanyListPageState extends State<CompanyListPage> {
  List<UserData> companies = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fetchAllCompany(false);
  }

  fetchAllCompany(flag) async {
    companies = await getHomepageVisibleCompany(flag: flag);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MyAppColor.backgroundColor,
      appBar: AppBar(
        toolbarHeight: 80,
        elevation: 0,
        backgroundColor: MyAppColor.backgroundColor,
        automaticallyImplyLeading: false,
        title: Row(
          children: [
            InkWell(
                onTap: () {
                  Navigator.pop(context);
                },
                child: Icon(
                  Icons.arrow_back,
                  color: Colors.black,
                  size: 20,
                )),
            SizedBox(
              width: 10,
            ),
            Text(
              "Companiess",
              style: TextStyle(color: Colors.black, fontSize: 16),
            )
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: companies.isNotEmpty
            ? SingleChildScrollView(
              child: Wrap(
                  runSpacing: 17,
                  spacing: 17,
                  children: List.generate(companies.length,
                      (index) => Cradwidget(company: companies[index])),
                ),
            )
            : loaderIndicator(context),
      ),
    );
  }
}
