import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hindustan_job/candidate/model/custom_job_alert_model.dart';
import 'package:hindustan_job/candidate/pages/job_seeker_page/home/edit_profile.dart';
import 'package:hindustan_job/candidate/pages/job_seeker_page/home/homeappbar.dart';
import 'package:hindustan_job/candidate/pages/side_drawerpages/customjob_alert.dart';
import 'package:hindustan_job/constants/colors.dart';
import 'package:hindustan_job/utility/function_utility.dart';

class CustomJobAlertList extends ConsumerStatefulWidget {
  const CustomJobAlertList({Key? key}) : super(key: key);

  @override
  ConsumerState<CustomJobAlertList> createState() => _CustomJobAlertListState();
}

class _CustomJobAlertListState extends ConsumerState<CustomJobAlertList> {
  @override
  void initState() {
    super.initState();
    ref.read(editProfileData).getCustomAlert(context);
  }

  @override
  Widget build(BuildContext context) {
    return Consumer(builder: (context, ref, child) {
      List<CustomAlert> customJobAlert =
          ref.watch(editProfileData).customJobAlert;
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
                    child: const Icon(
                      Icons.arrow_back,
                      color: Colors.black,
                      size: 20,
                    )),
                const SizedBox(
                  width: 10,
                ),
                const Text(
                  "Custom Job Alerts",
                  style: TextStyle(color: Colors.black, fontSize: 16),
                )
              ],
            ),
          ),
          body: ListView(
            children: List.generate(
                customJobAlert.length,
                (index) => Padding(
                      padding:
                          const EdgeInsets.only(left: 15, right: 15, top: 8),
                      child: Container(
                        padding: const EdgeInsets.all(10),
                        color: MyAppColor.greynormal,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "${customJobAlert[index].user!.name}",
                                  style: const TextStyle(
                                      fontSize: 15,
                                      color: Colors.black,
                                      fontWeight: FontWeight.w500),
                                ),
                                const SizedBox(
                                  height: 4,
                                ),
                                Text(
                                  "${locationShow(state: customJobAlert[index].sector, city: customJobAlert[index].industry)}",
                                  style: const TextStyle(
                                    fontSize: 13,
                                    color: Colors.black,
                                  ),
                                ),
                                const SizedBox(
                                  height: 4,
                                ),
                                Text(
                                  "${locationShow(state: customJobAlert[index].state, city: customJobAlert[index].city)}",
                                  style: const TextStyle(
                                    fontSize: 12,
                                    color: Colors.grey,
                                  ),
                                )
                              ],
                            ),
                            Row(
                              children: [
                                InkWell(
                                  onTap: () async {
                                    await Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                CustomJobAlerts(
                                                  customJobAlertData:
                                                      customJobAlert[index],
                                                      isFromConnectedRoutes: false,
                                                )));
                                    ref
                                        .read(editProfileData)
                                        .getCustomAlert(context);
                                  },
                                  child: Container(
                                    padding: const EdgeInsets.all(6),
                                    decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: MyAppColor.orangedark),
                                    child: const Icon(
                                      Icons.edit,
                                      size: 16,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                                const SizedBox(
                                  width: 15,
                                ),
                                InkWell(
                                  onTap: () {
                                    ref.read(editProfileData).deleteCustomAlert(
                                        context,
                                        customAlertId:
                                            customJobAlert[index].id);
                                  },
                                  child: Container(
                                    padding: const EdgeInsets.all(6),
                                    decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: MyAppColor.orangedark),
                                    child: const Icon(
                                      Icons.clear,
                                      size: 16,
                                      color: Colors.white,
                                    ),
                                  ),
                                )
                              ],
                            )
                          ],
                        ),
                      ),
                    )),
          ));
    });
  }
}
