import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:eight_news/routes/route_name.dart';
import 'utils/helper.dart';
import 'utils/form_validator.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'widgets/primary_button.dart';
import 'widgets/secondary_button.dart';
import 'widgets/custom_form.dart';
import 'widgets/rich_text.dart';

class Register extends StatefulWidget {
  const Register({super.key});

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController phoneNumberController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  bool isObscure = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: cWhite,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Form(
            key: formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Hello', style: headline1.copyWith(fontWeight: semibold)),
                vsSmall,
                Text('Signup to get started', style: subtitle1),
                SizedBox(height: 96.h),
                RichTextWidget(
                  textOne: '* ',
                  textStyleOne: subtitle2.copyWith(color: cError),
                  textTwo: 'Name',
                  textStyleTwo: subtitle2.copyWith(color: cBlack),
                ),
                vsSuperTiny,
                CustomFormField(
                  controller: nameController,
                  hintText: 'Name',
                  keyboardType: TextInputType.name,
                  textInputAction: TextInputAction.next,
                  validator: validateName,
                ),
                vsSmall,
                RichTextWidget(
                  textOne: '* ',
                  textStyleOne: subtitle2.copyWith(color: cError),
                  textTwo: 'PhoneNumber',
                  textStyleTwo: subtitle2.copyWith(color: cBlack),
                ),
                vsSuperTiny,
                CustomFormField(
                  controller: phoneNumberController,
                  hintText: 'Phone Number',
                  keyboardType: TextInputType.number,
                  textInputAction: TextInputAction.done,
                  validator: validatePhoneNumber,
                ),
                vsSmall,
                RichTextWidget(
                  textOne: '* ',
                  textStyleOne: subtitle2.copyWith(color: cError),
                  textTwo: 'Email',
                  textStyleTwo: subtitle2.copyWith(color: cBlack),
                ),
                vsSuperTiny,
                CustomFormField(
                  controller: emailController,
                  hintText: 'Email',
                  keyboardType: TextInputType.emailAddress,
                  textInputAction: TextInputAction.next,
                  validator: validateEmail,
                ),
                vsSmall,
                RichTextWidget(
                  textOne: '* ',
                  textStyleOne: subtitle2.copyWith(color: cError),
                  textTwo: 'Password',
                  textStyleTwo: subtitle2.copyWith(color: cBlack),
                ),
                vsSuperTiny,
                CustomFormField(
                  controller: passwordController,
                  hintText: 'Password',
                  keyboardType: TextInputType.url,
                  textInputAction: TextInputAction.done,
                  suffixIcon: IconButton(
                    onPressed: togglePasswordVisibility,
                    icon:
                        isObscure
                            ? const Icon(Icons.visibility_outlined)
                            : const Icon(Icons.visibility_off_outlined),
                  ),
                  validator: validatePassword,
                  obscureText: isObscure,
                ),
                Spacer(),
                PrimaryButton(
                  onPressed: () {
                    log('Register onTap');
                    context.goNamed(RouteNames.login);
                  },
                  title: 'Register',
                ),
                vsSmall,
                GestureDetector(
                  onTap: () {
                    context.pop();
                  },
                  child: Align(
                    alignment: Alignment.center,
                    child: RichTextWidget(
                      textOne: 'Already have an account? ',
                      textStyleOne: subtitle2.copyWith(color: cBlack),
                      textTwo: 'Login',
                      textStyleTwo: subtitle2.copyWith(color: cPrimary),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void togglePasswordVisibility() {
    setState(() {
      isObscure = !isObscure;
    });
  }

  @override
  void dispose() {
    nameController.dispose();
    phoneNumberController.dispose();
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }
}
