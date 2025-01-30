import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/patient_profile_controller.dart';

class PatientProfileView extends GetView<PatientProfileController> {
  const PatientProfileView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('PatientProfileView'),
        centerTitle: true,
      ),
      body: const Center(
        child: Text(
          'PatientProfileView is working',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
