import 'package:hindustan_job/services/services_constant/constant.dart';

class ListDropdown {
  static final salutations = [
    "Select job role",
    "Mrs.",
    "Master",
    "Mistress",
  ];
  static final subscriptionTypeList = [
    SubscriptionType.jobBrandingPlan,
    SubscriptionType.limitExtensionPlan,
    SubscriptionType.resumeDataAccessPlan,
    SubscriptionType.validityPlan,
  ];

  static final cities = [
    "City",
    "bhopal",
    "indore",
    "kolkata",
  ];

  static final employmentType = {
    "rows": [
      {"key": "full_time", "value": "Full Time"},
      {"key": "part_time", "value": "Part Time"},
      {"key": "both", "value": "Both"},
    ]
  };

  static final applicationStatus = {
    "rows": [
      {"key": CandidateStatus.applyJob, "value": "Applied for Job"},
      {"key": CompanyStatus.shortListed, "value": "Short-Listed for Job"},
      {"key": CompanyStatus.sendOffer, "value": "Offer Letter Sent"},
      {"key": CandidateStatus.acceptOffer, "value": "Accepted Offer"},
      {"key": CandidateStatus.acceptOffer, "value": "Accepted Offer"},
    ]
  };

  static final experienceFilter = {
    "rows": [
      {"from": 0, "to": 1, "value": "Less than 12 Months"},
      {"from": 1, "to": 2, "value": "1-2 Years"},
      {"from": 2, "to": 5, "value": "2-5 Years"},
      {"from": 5, "to": 10, "value": "5-10 Years"},
      {"from": 10, "to": 100, "value": "More than 10 Years"},
    ]
  };

  static final hobbies = [
    {'name': "Fashion"},
    {'name': "Entertainment"},
    {'name': "Sports"},
    {'name': "Business"},
    {'name': "Social"},
    {'name': "Movies"},
    {'name': "Art"},
    {'name': "Travel"},
    {'name': "News"},
    {'name': "Music"},
    {'name': "Nature"},
    {'name': "Luxury"},
    {'name': "Technology"},
    {'name': "Stories"},
    {'name': "Food and Beverages"},
    {'name': "Shopping"},
  ];

  static final infrastructure = [
    {"name": "Table and chair"},
    {"name": "Telephone"},
    {"name": "Internet"},
    {"name": "Computer"},
    {"name": "Other"}
  ];

  static final roleOfHiring = ["HR", "Owner/CEO", "Other"];

  static final jobSchedule = {
    "rows": [
      {"key": "morning_shift", "value": "Morning Shift"},
      {"key": "night_shift", "value": "Night Shift"},
      {"key": "flexible", "value": "Flexible Shift"},
      {"key": "monday_to_friday", "value": "Monday to Friday"},
      {"key": "weekend", "value": "Weekends"},
      // {"key": "other", "value": "Other"},
    ]
  };

  static final yesNo = {
    "rows": [
      {"key": "Y", "value": "Yes"},
      {"key": "N", "value": "No"},
    ]
  };

  static final wfh = {
    "rows": [
      {"key": "Y", "value": "Yes"},
      {"key": "N", "value": "No"},
      {"key": "TEMP", "value": "Temporary due to covid19"},
    ]
  };

  static final salaryType = {
    "rows": [
      {"key": "PA", "value": "per annum"},
      {"key": "PH", "value": "per hour"},
    ]
  };

  static final currentSalaryType = {
    "rows": [
      {"key": "PM", "value": "per month"},
      {"key": "PA", "value": "per annum"},
    ]
  };

  static final noticePeriodType = {
    "rows": [
      {"key": "M", "value": "Months"},
      {"key": "D", "value": "Days"},
    ]
  };

  static final experienceType = {
    "rows": [
      {"key": "M", "value": "Months"},
      {"key": "year", "value": "Years"},
    ]
  };

  static final number = ["1", "2", "3", "4", "5", "6", "7", "8", "9", "10"];
  static final monthsNumber = [
    "0",
    "1",
    "2",
    "3",
    "4",
    "5",
    "6",
    "7",
    "8",
    "9",
    "10",
    "11",
    "12"
  ];
  static final months = {
    "rows": [
      {'key': 1, 'value': 'January'},
      {'key': 2, 'value': 'February'},
      {'key': 3, 'value': 'March'},
      {'key': 4, 'value': 'April'},
      {'key': 5, 'value': 'May'},
      {'key': 6, 'value': 'June'},
      {'key': 7, 'value': 'July'},
      {'key': 8, 'value': 'August'},
      {'key': 9, 'value': 'September'},
      {'key': 10, 'value': 'October'},
      {'key': 11, 'value': 'November'},
      {'key': 12, 'value': 'December'},
    ]
  };

  static final jobTimeTable = [
    "10am to 7pm",
    "12am to 9pm",
    "5pm to 2am",
    "7pm to 4am",
  ];

  static final states = [
    "State",
    "mp",
    "up",
    "kolkata",
  ];
  static final accountTypes = [
    "Saving account",
    "Current account",
  ];
  static final roles = [
    "Role",
    "mp",
    "up",
    "kolkata",
  ];
  static final selectIndustries = [
    "Select Industry",
    "mp",
    "up",
    "kolkata",
  ];

  static final contractType = {
    "rows": [
      {"key": "contracted", "value": "Contract"},
      {"key": "internship", "value": "Internship"},
      {"key": "fresher", "value": "Fresher"},
      {"key": "other", "value": "Other"},
    ]
  };
  static final companies = [
    "Company",
    "mp",
    "up",
    "kolkata",
  ];
  static final functions = [
    "Functional Area",
    "mp",
    "up",
    "kolkata",
  ];
  static final locations = [
    "Select Location",
    "mp",
    "up",
    "kolkata",
  ];
  static final contacts = [
    "Select a Reason for Contact",
    "mp",
    "up",
    "kolkata",
  ];
  static final sectors = [
    "Select Sector",
    "mp",
    "up",
    "kolkata",
  ];
  static final experiences = [
    "Select Expeience",
    "mp",
    "up",
    "kolkata",
  ];
  static final saleries = [
    "Salary/Hourly Rate",
    "mp",
    "up",
    "kolkata",
  ];
  static final skills = [
    "Select Skills",
    "mp",
    "up",
    "kolkata",
  ];
  static final genders = [
    "Male",
    "Female",
    "Other",
  ];
  static final languages = [
    "Select a Language 01",
    "mp",
    "up",
    "kolkata",
  ];
  static final documents = [
    {"name": "DRIVING_LISCENCE", "id": 15},
    {"name": "VOTER_Id", "id": 10},
    {"name": "PAN_CARD", "id": 10},
    {"name": "AADHAR_CARD", "id": 12}
  ];
  static final ratingsList = [
    {"name": "5 Stars", "id": 5},
    {"name": "4 Stars ", "id": 4},
    {"name": "3 Stars", "id": 3},
    {"name": "2 Stars", "id": 2},
    {"name": "1 Stars", "id": 1},
  ];

  static final serviceChargeList = {
    "rows": [
      {"from": 0, "to": 500, "value": "0-500"},
      {"from": 500, "to": 1000, "value": "500-1000"},
      {"from": 1000, "to": 5000, "value": "1000-5000"},
      {"from": 5000, "to": 10000, "value": "5000-10000"},
      {"from": 10000, "to": 1000000, "value": "10000 and above"},
    ]
  };
  static final residentalProof = [
    'Rental Agreement',
    'Passport',
    'Voter ID',
    'Ration Card.',
    'Utility Bills (water, electricity, phone or gas bill)',
  ];
  static final currentStatus = [
    'Independent business person',
    'Self-employed person',
    'Housewife',
    'Not employed',
    'Retired',
    'Working in family business',
    'Employed in a private public',
    'Any other firm',
    "Wish to become self-employed"
  ];
  static final currentBusinessOccupation = [
    "College",
    "Institute",
    "Kiosk",
    'Petrol Pump',
    'Agriculture',
    'Poultry',
    'Dairy (Animal Husbandry)',
    'Trading',
    'Other'
  ];
  static final typeOfBusiness = [
    "Proprietorship",
    "Partnership",
    "Family Business",
    'Society'
  ];

  static final selectYesNo = [
    "Yes",
    'No',
  ];
}

List<String> monthArray = [
  'Jan',
  'Feb',
  'March',
  'April',
  'May',
  'June',
  'July',
  'Aug',
  'Sept',
  'Oct',
  'Nov',
  'Dec'
];
List<String> yearArray = [
  '2022',
  '2021',
  '2020',
  '2019',
  '2018',
  '2017',
];
