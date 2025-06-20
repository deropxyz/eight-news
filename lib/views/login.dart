import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:eight_news/routes/route_name.dart';
import 'utils/helper.dart';
import 'utils/form_validator.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'widgets/primary_button.dart';
import 'widgets/custom_form.dart';
import 'widgets/rich_text.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  bool isObscure = true;
  bool rememberMe = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: cBg, // Dark background
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Form(
            key: formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                RichTextWidget(
                  textOne: 'Hello',
                  textStyleOne: headline1.copyWith(
                    fontWeight: FontWeight.w700,
                    color: cWhite,
                  ),
                  textTwo: '\nAgain!',
                  textStyleTwo: headline1.copyWith(
                    fontWeight: FontWeight.w700,
                    color: cPrimary,
                  ),
                ),
                vsSmall,
                Text(
                  'Welcome back you’ve \nbeen missed',
                  style: subtitle1.copyWith(color: cTextGrey),
                ),
                vsXLarge,
                RichTextWidget(
                  textOne: 'Username',
                  textTwo: '*',
                  textStyleOne: subtitle2.copyWith(color: cTextGrey),
                  textStyleTwo: subtitle2.copyWith(color: cPrimary),
                ),

                vsSuperTiny,
                CustomFormField(
                  controller: usernameController,
                  hintText: 'Username',
                  keyboardType: TextInputType.name,
                  textInputAction: TextInputAction.next,
                  validator:
                      (value) =>
                          value == null || value.isEmpty ? 'Required' : null,
                ),
                vsSmall,
                RichTextWidget(
                  textOne: 'Password',
                  textTwo: '*',
                  textStyleOne: subtitle2.copyWith(color: cTextGrey),
                  textStyleTwo: subtitle2.copyWith(color: cPrimary),
                ),

                vsSuperTiny,
                CustomFormField(
                  controller: passwordController,
                  hintText: 'Password',
                  keyboardType: TextInputType.text,
                  textInputAction: TextInputAction.done,
                  obscureText: isObscure,
                  suffixIcon: IconButton(
                    onPressed: togglePasswordVisibility,
                    icon: Icon(
                      isObscure
                          ? Icons.visibility_outlined
                          : Icons.visibility_off_outlined,
                      color: Colors.grey,
                    ),
                  ),
                  validator: validatePassword,
                ),
                vsMedium,
                Row(
                  children: [
                    Checkbox(
                      value: rememberMe,
                      activeColor: cPrimary,
                      onChanged: (value) {
                        setState(() {
                          rememberMe = value!;
                        });
                      },
                    ),
                    Text(
                      'Remember me',
                      style: subtitle2.copyWith(color: Colors.white),
                    ),
                    Spacer(),
                    GestureDetector(
                      onTap: () => log('Forgot Password tapped'),
                      child: Text(
                        'Forgot the password ?',
                        style: subtitle2.copyWith(color: cPrimary),
                      ),
                    ),
                  ],
                ),
                vsMedium,
                PrimaryButton(
                  onPressed: () {
                    if (formKey.currentState!.validate()) {
                      context.goNamed(RouteNames.main);
                    }
                  },
                  title: 'Login',
                ),
                vsSmall,
                vsSmall,
                Center(
                  child: RichTextWidget(
                    textOne: "don't have an account ? ",
                    textStyleOne: subtitle2.copyWith(color: Colors.white),
                    textTwo: 'Sign Up',
                    textStyleTwo: subtitle2.copyWith(color: cPrimary),
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
    usernameController.dispose();
    passwordController.dispose();
    super.dispose();
  }
}
