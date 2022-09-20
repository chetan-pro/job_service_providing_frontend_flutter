import 'package:flutter/foundation.dart';
import 'package:hindustan_job/candidate/model/provider_model.dart';
import 'package:hindustan_job/candidate/model/services_model.dart';
import 'package:hindustan_job/services/api_services/service_seeker_services.dart';
import 'package:hindustan_job/services/services_constant/constant.dart';
import 'package:hindustan_job/utility/function_utility.dart';

class ServiceSeekerChangeNotifier extends ChangeNotifier {
  ServiceSeekerChangeNotifier();

  List<Services> services = [];
  List<Services> lastestServices = [];
  List<ServiceProvider> serviceProvider = [];
  List<Services> filterServices = [];
  List<ServiceProvider> filterServiceProvider = [];
  List<Services> pendingServices = [];
  List<Services> upcomingServices = [];
  List<Services> completedServices = [];
  List<Services> cancelledServices = [];
  List<Services> rejectedServices = [];

  getAllServices(context, {status, page}) async {
    services = await fetchAllServices(context, status: status, page: page);
    notifyListeners();
    return services;
  }

  getLatestServices(context, {status, page}) async {
    lastestServices = await fetchAllServices(context, page: page);
    notifyListeners();
  }

  getAllServiceProviders(context, {status, page}) async {
    serviceProvider = await getServiceProvider(context);
    notifyListeners();
    return serviceProvider;
  }

  filterServicesAndProviders(context, {isProvider, filterData, page}) async {
    String url = '';
    if (page != null) {
      url = url + "page=$page&";
    }
    var data = filterData;
    if (data != null && data.isNotEmpty) {
      for (String key in data.keys) {
        if (data[key] != '' && data[key] != null && data[key] != 'null') {
          url = url + "$key=${data[key].toString()}&";
        }
      }
    }
    if (isProvider) {
      filterServices = [];
      filterServiceProvider =
          await getServiceProvider(context, additionalUrl: url);
    } else {
      filterServiceProvider = [];
      filterServices = await fetchAllServices(context, additionalUrl: url);
    }
    notifyListeners();
  }

  getRequestedServices(context, {status, page, year, month, sortBy}) async {
    return await getServiceSeekerRequest(context,
        status: status, page: page, year: year, month: month, sortBy: sortBy);
  }

  getServiceByStatus({status, context, year, month, sortBy}) async {
    switch (status) {
      case ServiceStatus.accepted:
        upcomingServices = await getRequestedServices(context,
            status: status, year: year, month: month, sortBy: sortBy);
        notifyListeners();
        break;
      case ServiceStatus.pending:
        pendingServices = await getRequestedServices(context,
            status: status, year: year, month: month, sortBy: sortBy);
        notifyListeners();
        break;
      case ServiceStatus.completed:
        completedServices = await getRequestedServices(context,
            status: status, year: year, month: month, sortBy: sortBy);
        notifyListeners();
        break;
      case ServiceStatus.reject:
        cancelledServices = await getServiceSeekerReject(context);
        notifyListeners();
        break;
      case ServiceStatus.rejected:
        rejectedServices = await getRequestedServices(context,
            status: status, year: year, month: month, sortBy: sortBy);
        notifyListeners();
        break;
      default:
    }
  }
}
