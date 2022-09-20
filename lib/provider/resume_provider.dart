import 'package:flutter/cupertino.dart';
import 'package:hindustan_job/services/api_services/resume_services.dart';

class ResumeChangeNotifier extends ChangeNotifier {
  ResumeChangeNotifier();

  createResume(context, body) async {
    await resumeCreate(context, body);
  }
}
