import 'package:hindustan_job/candidate/model/serviceProviderModal/alldata_get_modal.dart';
import 'package:hindustan_job/candidate/model/serviceProviderModal/day_provider.dart';
import 'package:hindustan_job/candidate/model/service_categories_model.dart';
import 'package:hindustan_job/services/api_service_serviceProvider/service_provider.dart';
import 'package:hindustan_job/services/services_constant/response_model.dart';
import 'package:hindustan_job/utility/function_utility.dart';

List<ServiceCategories> catego = [];
Future categoryData(context) async {
  ApiResponse response = await category();

  var res = response.body!.data;

  if (response.status == 200) {
    return ServiceCategoriesModel.fromJson(res).serviceCategories;
  } else {
    return <ServiceCategories>[];
  }
}

Future fetchData(context) async {
  ApiResponse response = await getDays();
  var res = response.body!.data;

  if (response.status == 200) {
    return Days.fromJson(res).rows;
  } else {
    await showSnack(
        context: context, msg: response.body!.message, type: 'error');
  }
}
