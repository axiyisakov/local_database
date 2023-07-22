import 'dart:convert';
import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_g2/main.dart';
import 'package:flutter_g2/model/profile_model.dart';
import 'package:flutter_g2/page/auth/widget/custom_field.dart';
import 'package:flutter_g2/service/prefs.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  bool? isEabled = false;
  bool? isObscure = true;
  final emailController = TextEditingController();
  final passWordController = TextEditingController();
  final confirmPasswordContoller = TextEditingController();
  void showObscure() {
    isEabled = !isEabled!;
    isObscure = !isObscure!;
    setState(() {});
  }

  void signUp() async {
    try {
      final email = emailController.text;
      final password = passWordController.text;
      final confirm = confirmPasswordContoller.text;
      if (email.isEmpty || password.isEmpty || confirm.isEmpty) return;

      if (password != confirm) return;

      final ProfileModel profileModel =
          ProfileModel(email: email, password: password);
      final profileSaved = await Prefs.saveDataToLocal(
          key: 'data', data: jsonEncode(profileModel.toJson()));
      if (profileSaved!) {
        log('Lokal xotiraga saqlandi');
        scaffoldMessangerKey.currentState!.showMaterialBanner(MaterialBanner(
            content: const Text('Siz muvofaqiyatli royxatdan otdingiz'),
            actions: [
              TextButton(
                  onPressed: () => scaffoldMessangerKey.currentState!
                      .hideCurrentMaterialBanner(),
                  child: const Text('dismiss'))
            ]));
        // ignore: use_build_context_synchronously
        Navigator.of(context)
            .pushNamedAndRemoveUntil('/home', (route) => false);
      }
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SizedBox(
        width: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: SizedBox(
                height: 45,
                child: CustomTextField(
                    placeholder: 'email',
                    controller: emailController,
                    iconData: Icons.email,
                    onPressed: () {},
                    enableObscure: false),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: SizedBox(
                height: 45,
                child: CustomTextField(
                    placeholder: 'Password',
                    controller: passWordController,
                    iconData: Icons.lock,
                    onPressed: showObscure,
                    isPasswordField: true,
                    obscureText: isObscure,
                    enableObscure: isEabled),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: SizedBox(
                height: 45,
                child: CustomTextField(
                  placeholder: 'Confirm password',
                  controller: confirmPasswordContoller,
                  iconData: Icons.lock,
                  onPressed: () {},
                  isPasswordField: false,
                  obscureText: true,
                  enableObscure: false,
                ),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            const SizedBox(
              height: 10,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: SizedBox(
                  height: 45,
                  width: double.infinity,
                  child: CupertinoButton.filled(
                      borderRadius: BorderRadius.circular(22.5),
                      onPressed: signUp,
                      child: const Text('Sign UP'))),
            ),
          ],
        ),
      ),
    );
  }
}
