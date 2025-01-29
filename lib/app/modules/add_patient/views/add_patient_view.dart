import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/add_patient_controller.dart';

class AddPatientView extends GetView<AddPatientController> {
  const AddPatientView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('AddPatientView'),
        centerTitle: true,
      ),
      body: const Center(
        child: Text(
          'AddPatientView is working',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
