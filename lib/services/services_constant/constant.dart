const String url = 'https://admin.hindustaanjobs.com/api/';
// const String url = 'http://192.168.29.244:3002/api/';

const String imageUrl = 'https://admin.hindustaanjobs.com/assets/images/user/';
const String certificateUrl =
    'https://admin.hindustaanjobs.com/assets/certificate/';
const String offerletter =
    'https://admin.hindustaanjobs.com/assets/OfferLetter/';
const String resumeUrl = 'https://admin.hindustaanjobs.com/assets/resume/';
const String locationFetchApi = "http://www.postalpincode.in/api/pincode/";

String? api;
const double kDesignWidth = 360;
const double kDesignHeight = 760;

class CandidateStatus {
  static const String applyJob = "APPLY_JOB";
  static const String rejectOffer = "REJECT_OFFER";
  static const String acceptOffer = "ACCEPT_OFFER";
  static const String accepted = "ACCEPTED";
}

class ServiceStatus {
  static const String accepted = "ACCEPTED";
  static const String rejected = "REJECTED";
  static const String reject = "REJECT";
  static const String request = "REQUEST";
  static const String completed = "COMPLETED";
  static const String pending = "PENDING";
}

class WalletStatus {
  static const String transaction = "TRANSACTION";
  static const String wallet = "WALLET";
  static const String settlement = "SETTELMENT";
}

class CompanyStatus {
  static const String shortListed = "SHORTLISTED";
  static const String sendOffer = "SEND_OFFER";
  static const String pending = "PENDING";
  static const String rejected = "REJECTED";
}

class JobStatus {
  static String open = "OPEN";
  static String close = "CLOSE";
}

class PermissionConstant {
  static String hireCandidate = "HireCandidate";
  static String viewCandidate = "ViewApplicant";
  static String postJob = "PostJob";
}

const String downloadImage =
    "https://admin.hindustaanjobs.com/assets/certificate/1645095730.jpg";

const String defaultImage = "https://i.stack.imgur.com/l60Hf.png";

class SubscriptionType {
  static String resumeDataAccessPlan = "Resume_Data_Access_Plan";
  static String validityPlan = "Validity_Plan";
  static String jobBrandingPlan = "Company_Branding_Plan";
  static String limitExtensionPlan = "Limit_Extension_Plan";
}

class SUBSCRIPTION_PLAN_TYPE_AREA {
  static String metro = 'Metro';
  static String nonMetro = 'Non_Metro';
}

class SUBSCRIPTION_PLAN_SUB_TYPE {
  static String classified = "Classified";
  static String hotVacancy = "Hot_Vacancy";
}

class SUBSCRIPTION_OFFER_TYPE {
  static String twoMonthPlanExtension = 'Two_Month_Plan_Extension';
}
