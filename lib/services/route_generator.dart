import 'package:btp_project/constants/routes.dart';
import 'package:btp_project/screens/h_admin.dart';
import 'package:btp_project/screens/insurance_admin.dart';
import 'package:btp_project/screens/lab_admin.dart';
import 'package:btp_project/screens/login.dart';
import 'package:btp_project/screens/patient_records_screen.dart';
import 'package:btp_project/screens/signup.dart';
import 'package:btp_project/services/route_generator_helper.dart';
import 'package:flutter/material.dart';

import '../screens/landing_screen.dart';

class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case RoutesName.hAdmin:
        return GeneratePageRoute(
            page: const HospitalAdmin(), routeName: settings.name);
      case RoutesName.patient:
        return GeneratePageRoute(
            page: const Patient(), routeName: settings.name);
      case RoutesName.labAdmin:
        return GeneratePageRoute(
            page: const LabAdmin(), routeName: settings.name);
      case RoutesName.insuranceAdmin:
        return GeneratePageRoute(
            page: const InsuranceAdmin(), routeName: settings.name);
      case RoutesName.landingPage:
        return GeneratePageRoute(
          page: const LandingPage(),
          routeName: settings.name,
        );
      default:
        return GeneratePageRoute(
          page: const LandingPage(),
          routeName: settings.name,
        );
    }
  }
}
