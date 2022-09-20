import 'package:flutter/cupertino.dart';
import 'package:hindustan_job/candidate/model/commision_model.dart';
import 'package:hindustan_job/constants/types_constant.dart';

import '../candidate/model/addbank/wallet_transactions.dart';
import '../candidate/model/business_correspondance_count_model.dart';
import '../candidate/model/registree_model.dart';
import '../services/api_services/business_correspondance_services.dart';
import '../services/api_services/user_services.dart';
import '../services/services_constant/response_model.dart';

class BusinessCorrespondance extends ChangeNotifier {
  BusinessCorrespondance();

  String totalComission = '0',
      totalNumberRegistrees = '0',
      totalBussinessCorrespondence = '0',
      newCommission = '0';
  List<BusinessCorrespondanceCount> listBusinessCorrespondanceCount = [];
  List<Commision> commisionList = [];
  List<Registree> registreeList = [];
  List<Registree> registreeJSList = [];
  List<Registree> registreeCOMPANYList = [];
  List<Registree> registreeHSSList = [];
  List<Registree> registreeHSPList = [];
  List<Registree> registreeLHList = [];
  List<Registree> registreeSubBcList = [];
  List<Transactions> walletTransactions = [];

  getWalletTransactions(context, {filterData}) async {
    String url = '';
    if (filterData.isNotEmpty) {
      for (String key in filterData.keys) {
        url = url + "$key=${filterData[key].toString()}&";
      }
    }
    ApiResponse response = await getWalletTransaction(additionalUrl: url);

    if (response.status == 200) {
      walletTransactions =
          WalletTransactions.fromJson(response.body!.data).transactions!;
    } else {
      walletTransactions = [];
    }

    notifyListeners();
  }

  getDashBoardCountData() async {
    BusinessCorrespondanceCountModel businessCorrespondanceCount =
        await getBusinessCorrespondanceDashboardData();

    totalComission =
        (businessCorrespondanceCount.totalCommission ?? 0).toString();
    totalNumberRegistrees =
        (businessCorrespondanceCount.totalNumberRegistrees ?? 0).toString();
    totalBussinessCorrespondence =
        (businessCorrespondanceCount.totalBussinessCorrespondence ?? 0)
            .toString();
    if (businessCorrespondanceCount.newCommission != null &&
        businessCorrespondanceCount.newCommission.length > 0) {
      double sum = 0;
      for (int i = 0;
          i < businessCorrespondanceCount.newCommission.length;
          i++) {
        sum += double.parse(
            businessCorrespondanceCount.newCommission[i]['my_new_commission']);
      }
      newCommission = "$sum";
    } else {
      newCommission = '0';
    }
    listBusinessCorrespondanceCount =
        businessCorrespondanceCount.businessCorrespondanceCount ?? [];
    notifyListeners();
  }

  getCommisionData() async {
    CommisionModel commisionModel =
        await getBusinessCorrespondanceCommisionData();
    if (commisionModel.commision != null) {
      commisionList = commisionModel.commision!;
      notifyListeners();
    }
  }

  getRegistreeData({roleType, sortBy, status}) async {
    RegistreeModel registreeModel = await getMiscellaneousUserRegistreeDetails(
        userRoleType: roleType, sortBy: sortBy, status: status);
    if (registreeModel.registree != null) {
      if (roleType != null) {
        return registreeModel.registree;
      } else {
        registreeList = registreeModel.registree!;
      }
      notifyListeners();
    }
  }

  getAllRoleData({status}) async {
    await getRegistreeByRoleType(RoleTypeConstant.jobSeeker, status: status);
    await getRegistreeByRoleType(RoleTypeConstant.company, status: status);
    await getRegistreeByRoleType(RoleTypeConstant.homeServiceProvider,
        status: status);
    await getRegistreeByRoleType(RoleTypeConstant.homeServiceSeeker,
        status: status);
    await getRegistreeByRoleType(RoleTypeConstant.localHunar, status: status);
  }

  getRegistreeByRoleType(value, {sortBy, status}) async {
    switch (value) {
      case RoleTypeConstant.jobSeeker:
        registreeJSList = await getRegistreeData(
            roleType: RoleTypeConstant.jobSeeker,
            sortBy: sortBy,
            status: status);
        break;
      case RoleTypeConstant.company:
        registreeCOMPANYList = await getRegistreeData(
            roleType: RoleTypeConstant.company, sortBy: sortBy, status: status);
        break;
      case RoleTypeConstant.homeServiceProvider:
        registreeHSPList = await getRegistreeData(
            roleType: RoleTypeConstant.homeServiceProvider,
            sortBy: sortBy,
            status: status);
        break;
      case RoleTypeConstant.homeServiceSeeker:
        registreeHSSList = await getRegistreeData(
            roleType: RoleTypeConstant.homeServiceSeeker,
            sortBy: sortBy,
            status: status);
        break;
      case RoleTypeConstant.localHunar:
        registreeLHList = await getRegistreeData(
            roleType: RoleTypeConstant.localHunar,
            sortBy: sortBy,
            status: status);
        break;
      case RoleTypeConstant.businessCorrespondence:
        registreeSubBcList = await getRegistreeData(
            roleType: RoleTypeConstant.businessCorrespondence,
            sortBy: sortBy,
            status: status);
        break;
      default:
        [];
    }
    notifyListeners();
  }
}
