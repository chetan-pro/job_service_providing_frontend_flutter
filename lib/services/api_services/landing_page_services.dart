import 'package:hindustan_job/services/api_provider/api_provider.dart';
import 'package:hindustan_job/services/auth/auth.dart';
import 'package:hindustan_job/services/services_constant/api_string_constant.dart';

Future getLandingPageJobs() async {
  String url = LandingPagesApi.getLandingPageJobs;
  return await ApiProvider.get(url);
}

Future getLandingPageHomeServices() async {
  String url = LandingPagesApi.getLandingPageHomeServices;
  return await ApiProvider.get(url);
}

Future getLandingPageLocalHunar() async {
  String url = LandingPagesApi.getLandingPageLocalHunar;
  return await ApiProvider.get(url);
}

Future getLandingPageUserCounts() async {
  String url = LandingPagesApi.getLandingPageUserCounts;
  return await ApiProvider.get(url);
}

Future getLandingPageTestimonials() async {
  String url = LandingPagesApi.getLandingPageTestimonials;
  return await ApiProvider.get(url);
}

Future getLandingPageStaticData(key) async {
  String url = LandingPagesApi.getLandingPageStaticData + '/$key';
  return await ApiProvider.get(url);
}
