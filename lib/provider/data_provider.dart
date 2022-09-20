import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:hindustan_job/candidate/dropdown/dropdown_list.dart';
import 'package:hindustan_job/candidate/model/city_model.dart';
import 'package:hindustan_job/candidate/model/company_list_model.dart';
import 'package:hindustan_job/candidate/model/contract_type_model.dart';
import 'package:hindustan_job/candidate/model/education_model.dart';
import 'package:hindustan_job/candidate/model/employment_type_model.dart';
import 'package:hindustan_job/candidate/model/experience_filter_model.dart';
import 'package:hindustan_job/candidate/model/industry_model.dart';
import 'package:hindustan_job/candidate/model/job_model_two.dart';
import 'package:hindustan_job/candidate/model/job_schedule_model.dart';
import 'package:hindustan_job/candidate/model/job_type_model.dart';
import 'package:hindustan_job/candidate/model/key_value_model.dart';
import 'package:hindustan_job/candidate/model/language_model.dart';
import 'package:hindustan_job/candidate/model/sector_model.dart';
import 'package:hindustan_job/candidate/model/skill_category.dart';
import 'package:hindustan_job/candidate/model/skill_sub_category_model.dart';
import 'package:hindustan_job/candidate/model/state_model.dart';
import 'package:hindustan_job/candidate/model/user_model.dart';
import 'package:hindustan_job/candidate/model/work_from_home_model.dart';
import 'package:hindustan_job/services/api_services/panel_services.dart';

class ListDataChangeNotifier extends ChangeNotifier {
  List<Language> languages = [];
  List<Sector> sector = [];
  List<Industry> industry = [];
  List<Industry> jobRoleTypes = [];
  List<Education> educations = [];
  List<Sector> multiSector = [];
  List<States> state = [];
  List<City> city = [];
  List<UserData> companyList = [];
  List<ExperienceFilter> experienceFilter = [];
  List<EmploymentType> employmentType = [];
  List<KeyValue> applicationStatus = [];
  List<ContractType> contractType = [];
  List<JobScheduleType> jobSchedule = [];
  String isRadioValue = '';
  bool isData = false;
  List<WFHType> wfhList = [];

  List<JobType> jobTypes = [];
  List<SubSkill> subSkills = [];
  List<Skill> skillCategory = [];

  clearData() {
    languages = [];
    industry = [];
    educations = [];
    sector = [];
    multiSector = [];
    state = [];
    city = [];
    jobTypes = [];
    subSkills = [];
    skillCategory = [];
    notifyListeners();
  }

  checkData() {
    isData = industry.isNotEmpty && state.isNotEmpty && companyList.isNotEmpty;
    notifyListeners();
  }

  fetchData(context) async {
    await fetchState(context);
    await fetchCity(context, page: 1);
    await fetchIndustries(context);
    await fetchJobRoleTypes(context);
    await fetchSkills(context);
    await fetchEducation(context);
    await fetchCompanyList(context);
    await fetchJobType(context);
    wfhList = WFHModel.fromJson(ListDropdown.wfh).wfhType!;
    contractType =
        ContractTypeModel.fromJson(ListDropdown.contractType).contractType!;
    jobSchedule =
        JobScheduleModel.fromJson(ListDropdown.jobSchedule).jobScheduleType!;
    experienceFilter =
        ExperienceFilterModel.fromJson(ListDropdown.experienceFilter)
            .experienceFilter!;
    employmentType =
        EmploymentModel.fromJson(ListDropdown.employmentType).employmentType!;
    applicationStatus =
        KeyValueModel.fromJson(ListDropdown.applicationStatus).keyValue!;
  }

  radioChanged(value) {
    isRadioValue = value;
    notifyListeners();
  }

  getLanguages(context) async {
    languages = await fetchLanguages(context);
    notifyListeners();
  }

  onSelectIndustry(context, {index, value}) async {
    industry[index].isSelected = value;
    if (!value) {
      multiSector
          .removeWhere((element) => element.industryId == industry[index].id);
    } else {
      await addMultiSector(context, industry[index].id);
    }
    notifyListeners();
  }

  addMultiSector(context, industryId) async {
    List<Sector> sec = await fetchSector(context, industryId: industryId);
    if (sec.isNotEmpty && !multiSector.contains(sec.first)) {
      multiSector = [...multiSector, ...sec];
    }
    notifyListeners();
  }

  onSelectSector(context, {index, value}) async {
    multiSector[index].isSelected = value;
    notifyListeners();
  }

  onSelectLocation(context, {index, value}) async {
    state[index].isSelected = value;
    notifyListeners();
  }

  onSelectSkills(context, {index, value}) async {
    skillCategory[index].isSelected = value;
    notifyListeners();
  }

  onSelectEducation(context, {index, value}) async {
    educations[index].isSelected = value;
    notifyListeners();
  }

  onSelectApplicationStatus(context, {index, value}) async {
    applicationStatus[index].isSelected = value;
    notifyListeners();
  }

  onSelectWFHType(context, {index, value}) async {
    for (var element in wfhList) {
      element.isSelected = false;
    }
    wfhList[index].isSelected = true;
    notifyListeners();
  }

  fetchIndustries(context) async {
    industry = await fetchIndustry(context);
    notifyListeners();
  }

  fetchJobRoleTypes(context) async {
    jobRoleTypes = await fetchJobRoleType(context);
    notifyListeners();
  }

  fetchCompanyList(context) async {
    companyList = await fetchCompany(context);
    notifyListeners();
  }

  fetchEducation(context) async {
    educations = await fetchEducations(context);
    notifyListeners();
  }

  fetchSectors(
    context,
    industryId,
  ) async {
    sector = [];
    sector = await fetchSector(context, industryId: industryId);
    notifyListeners();
  }

  fetchState(context) async {
    state = await fetchStates(context);
    notifyListeners();
  }

  fetchJobType(context) async {
    jobTypes = await fetchJobTypes(context);
    notifyListeners();
  }

  fetchCity(context, {id, page, name}) async {
    city = [];
    city = await fetchCities(context,
        stateId: id.toString(), page: page, filterByName: name);
    notifyListeners();
  }

  fetchSkills(context) async {
    skillCategory = await fetchSkillCategory(context);
    notifyListeners();
  }

  fetchSubSkills(context, id) async {
    subSkills = await fetchSubSkillsCategory(context, categoryId: id);
    notifyListeners();
    return subSkills;
  }
}
