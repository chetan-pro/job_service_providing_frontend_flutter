import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hindustan_job/candidate/model/notification_model.dart';
import 'package:hindustan_job/candidate/pages/job_seeker_page/home/homeappbar.dart';
import 'package:hindustan_job/constants/colors.dart';
import 'package:hindustan_job/utility/function_utility.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class NotificationScreen extends ConsumerStatefulWidget {
  const NotificationScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends ConsumerState<NotificationScreen> {
  int page = 1;

  // ignore: prefer_final_fields
  RefreshController _refreshController =
      RefreshController(initialRefresh: false);
  void _onRefresh() async {
    // monitor network fetch
    await Future.delayed(Duration(milliseconds: 1000));
    // if failed,use refreshFailed()
    page = 1;
    await ref.read(notificationProvider).getAllNotification(page: page);
    _refreshController.refreshCompleted();
  }

  void _onLoading() async {
    // monitor network fetch
    // return;
    await Future.delayed(Duration(milliseconds: 1000));
    // if failed,use loadFailed(),if no data return,use LoadNodata()

    page += 1;
    ref.read(notificationProvider).getAllNotification(page: page);
    _refreshController.loadComplete();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    ref.read(notificationProvider).getAllNotification(page: page);
  }

  @override
  Widget build(BuildContext context) {
    return Consumer(builder: (context, ref, child) {
      List<Notifications> notifications =
          ref.watch(notificationProvider).notification;
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
                  "Notifications",
                  style: TextStyle(color: Colors.black, fontSize: 16),
                )
              ],
            ),
            actions: [
              InkWell(
                onTap: () async{
                await  ref.read(notificationProvider).deleteAllNotification();
                await  ref.read(notificationProvider).getAllNotification(page: page);
                
                },
                child: Padding(
                  padding: const EdgeInsets.only(right: 10),
                  child: Row(
                    children: [
                      Icon(
                        Icons.clear,
                        color: Colors.black,
                        size: 20,
                      ),
                      Text(
                        "Clear All",
                        style: TextStyle(color: Colors.black, fontSize: 14),
                      )
                    ],
                  ),
                ),
              )
            ],
          ),
          body: SmartRefresher(
            enablePullDown: true,
            enablePullUp: true,
            header: WaterDropHeader(),
            footer: CustomFooter(
              builder: (BuildContext? context, LoadStatus? mode) {
                Widget body;
                if (mode == LoadStatus.idle) {
                  body = Text("pull up load");
                } else if (mode == LoadStatus.loading) {
                  body = CupertinoActivityIndicator();
                } else if (mode == LoadStatus.failed) {
                  body = Text("Load Failed!Click retry!");
                } else if (mode == LoadStatus.canLoading) {
                  body = Text("release to load more");
                } else {
                  body = Text("No more Data");
                }
                return SizedBox(
                  height: 55.0,
                  child: Center(child: body),
                );
              },
            ),
            controller: _refreshController,
            onRefresh: _onRefresh,
            onLoading: _onLoading,
            child: ListView(
                children: List.generate(
              notifications.length,
              (index) => Padding(
                padding: const EdgeInsets.only(left: 15, right: 15, bottom: 15),
                child: Container(
                  padding: EdgeInsets.all(10),
                  color: MyAppColor.greynormal,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "${notifications[index].title}",
                            style: TextStyle(
                                fontSize: 15,
                                color: Colors.black,
                                fontWeight: FontWeight.w500),
                          ),
                          SizedBox(
                            height: 4,
                          ),
                          Text(
                            "${formatDate(notifications[index].updatedAt)} | ${formatTime(notifications[index].updatedAt)}",
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey,
                            ),
                          )
                        ],
                      ),
                      InkWell(
                        onTap: () {
                          ref.read(notificationProvider).deleteAllNotification(
                              id: notifications[index].id);
                        },
                        child: Icon(
                          Icons.clear,
                          size: 16,
                        ),
                      )
                    ],
                  ),
                ),
              ),
            )),
          ));
    });
  }
}
