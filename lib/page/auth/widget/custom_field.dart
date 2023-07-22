import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  final String? placeholder;
  final TextEditingController? controller;
  final bool? obscureText;
  final IconData? iconData;
  final bool? enableObscure;
  final VoidCallback? onPressed;
  final bool? isPasswordField;
  const CustomTextField(
      {super.key,
      required this.placeholder,
      required this.controller,
      required this.iconData,
      required this.onPressed,
      required this.enableObscure,
      this.isPasswordField = false,
      this.obscureText = false});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 45,
      child: CupertinoTextField(
        controller: controller,
        obscureText: obscureText!,
        prefix: Padding(
          padding: const EdgeInsets.only(left: 10),
          child: Icon(iconData!),
        ),
        style: const TextStyle(fontSize: 20),
        placeholder: placeholder,
        suffix: IconButton(
          icon: isPasswordField!
              ? Icon(enableObscure!
                  ? Icons.remove_red_eye_outlined
                  : Icons.remove_red_eye)
              : const SizedBox(),
          onPressed: onPressed,
        ),
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(22.5),
            color: Colors.grey.withOpacity(.5)),
      ),
    );
  }
}
