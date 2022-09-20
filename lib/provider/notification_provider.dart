import 'package:flutter/cupertino.dart';
import 'package:hindustan_job/candidate/model/notification_model.dart';
import 'package:hindustan_job/services/api_services/panel_services.dart';
import 'package:hindustan_job/services/services_constant/response_model.dart';

class NotificationChangeNotifier extends ChangeNotifier {
  NotificationChangeNotifier();

  List<Notifications> notification = [];

  getAllNotification({page}) async {
    if (page > 1) {
      notification = [...notification, ...await getNotification(page: page)];
    } else {
      notification = await getNotification(page: page);
    }
    notifyListeners();
  }

  deleteAllNotification({id}) async {
    ApiResponse response = await deleteNotificaton(id: id);

    if (response.status == 200) {
      if (id != null) {
        notification.removeWhere((element) => element.id == id);
      } else {
        notification = [];
      }
      notifyListeners();
    }
  }
}
