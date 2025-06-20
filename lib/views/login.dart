import 'package:eight_news/services/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
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

//fungsi untuk login
class _LoginState extends State<Login> {
  final TextEditingController _emailController = TextEditingController(
    text: 'news@itg.ac.id',
  ); // Default for testing
  final TextEditingController _passwordController = TextEditingController(
    text: 'ITG#news',
  ); // Default for testing

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _isObscure = true;
  bool _rememberMe = false;
  bool _isLoading = false;

  Future<void> _handleLogin() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
    });

    try {
      await Provider.of<AuthService>(
        context,
        listen: false,
      ).login(_emailController.text.trim(), _passwordController.text.trim());

      if (mounted) {
        context.goNamed(RouteNames.main);
      }
    } catch (error) {
      showDialog(
        context: context,
        builder:
            (ctx) => AlertDialog(
              title: const Text('Login Gagal'),
              content: Text(error.toString()),
              actions: [
                TextButton(
                  child: const Text('OK'),
                  onPressed: () => Navigator.of(ctx).pop(),
                ),
              ],
            ),
      );
    }

    if (mounted) {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: cBg,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Form(
            key: _formKey,
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
                  controller: _emailController,
                  hintText: 'Username',
                  keyboardType: TextInputType.emailAddress,
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
                  controller: _passwordController,
                  hintText: 'Password',
                  keyboardType: TextInputType.text,
                  textInputAction: TextInputAction.done,
                  obscureText: _isObscure,
                  suffixIcon: IconButton(
                    onPressed: () {
                      setState(() {
                        _isObscure = !_isObscure;
                      });
                    },
                    icon: Icon(
                      _isObscure
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
                      value: _rememberMe,
                      activeColor: cPrimary,
                      onChanged: (value) {
                        setState(() {
                          _rememberMe = value!;
                        });
                      },
                    ),
                    Text(
                      'Remember me',
                      style: subtitle2.copyWith(color: Colors.white),
                    ),
                    const Spacer(),
                  ],
                ),
                vsMedium,
                _isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : PrimaryButton(onPressed: _handleLogin, title: 'Login'),
                vsSmall,
                Center(
                  child: RichTextWidget(
                    textOne: "Don't have an account? ",
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

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
}
