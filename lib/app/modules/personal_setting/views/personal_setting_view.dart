import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/personal_setting_controller.dart';

class PersonalSettingView extends GetView<PersonalSettingController> {
  const PersonalSettingView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('PersonalSettingView'),
        centerTitle: true,
      ),
      body: const Center(
        child: Text(
          'PersonalSettingView is working',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
