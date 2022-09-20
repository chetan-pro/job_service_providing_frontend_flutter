import 'package:flutter/material.dart';

class ImageFile {
  static const AssetImage man = AssetImage('assets/male.png');
  static const AssetImage woman = AssetImage('assets/female.png');
  static const AssetImage facebook = AssetImage('assets/facebook.png');

  static List listPaths = [
    "assets/male-slider-desktop.png",
    "assets/female-slider.png",
    "assets/male-slider.png",
    "assets/female-slider-other.png",
    "assets/singer-male-slider.png"
  ];
  static List listCount = [
    "21.4 Lakh Job Providers",
    "36.54 Lakh Candidates",
    "1.25 Lakh Service Seekers across the Nation",
    "4.5 Lakh Service Provider across the Nation",
    "4.25 Lakh Talents & 4.5M Daily Views"
  ];
  static List listLabel = [
    "Job Seeker",
    "Company",
    "Service Provider",
    "Service Seeker",
    "Local Hunars"
  ];

  static List listString = [
    "Search Jobs\nCreate Curriculum Vitae\nGet Hired",
    "Post Jobs\nAssign Staff to Manage\nFind Best Candidates",
    "List your Services\nGet Online Exposure\nGet More Clients",
    "Find Service Provider\nJudge on Reviews & Ratings\nGet the Job Done",
    "Promote Local Talents\nUpload Videos\nFind Local Talents"
  ];
}

class CompanySubscription {}
