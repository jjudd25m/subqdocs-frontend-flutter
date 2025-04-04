import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/sign_up_profile_complete_controller.dart';

class SignUpProfileCompleteView
    extends GetView<SignUpProfileCompleteController> {
  const SignUpProfileCompleteView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('SignUpProfileCompleteView'),
        centerTitle: true,
      ),
      body: const Center(
        child: Text(
          'SignUpProfileCompleteView is working',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
