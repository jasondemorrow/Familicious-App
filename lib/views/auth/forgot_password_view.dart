import 'package:provider/provider.dart';
import 'package:famlicious_app/managers/auth_manager.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class ForgotPasswordView extends StatefulWidget {
  const ForgotPasswordView({Key? key}) : super(key: key);

  @override
  State<ForgotPasswordView> createState() => _ForgotPasswordViewState();
}

class _ForgotPasswordViewState extends State<ForgotPasswordView> {
  final RegExp emailRegexp = RegExp(r"^[a-zA-Z0-9.]+@[a-zA-Z0-9]+\.[a-zA-Z]+");

  final TextEditingController _emailController = TextEditingController();

  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SafeArea(
          child: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Image.asset(
            'assets/logo_header.png',
            width: 130,
            height: 130,
          ),
          const SizedBox(
            height: 35,
          ),
          Text(
            'Kindly check your email for the password reset link after submitting your email address',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodyText2,
          ),
          const SizedBox(
            height: 20,
          ),
          TextFormField(
            controller: _emailController,
            keyboardType: TextInputType.emailAddress,
            decoration: const InputDecoration(
                label: Text('Email'),
                hintText: 'Please provide your email address'),
            validator: (value) {
              if (value!.isEmpty) {
                return 'Email is required!';
              }

              if (!emailRegexp.hasMatch(value)) {
                return 'Email is invalid';
              }
            },
          ),
          const SizedBox(
            height: 25,
          ),
          isLoading
              ? const Center(child: CircularProgressIndicator.adaptive())
              : TextButton(
                  onPressed: () async {
                    if (_emailController.text.isNotEmpty &&
                        emailRegexp.hasMatch(_emailController.text)) {
                      setState(() {
                        isLoading = true;
                      });
                      bool isSent = await Provider.of<AuthManager>(
                        context,
                        listen: false,
                      ).sendResetLink(_emailController.text);
                      setState(() {
                        isLoading = false;
                      });
                      if (isSent) {
                        //successs
                        Fluttertoast.showToast(
                            msg:
                                "Please check your email for password reset link.",
                            toastLength: Toast.LENGTH_LONG,
                            gravity: ToastGravity.BOTTOM,
                            timeInSecForIosWeb: 1,
                            backgroundColor: Colors.green,
                            textColor: Colors.white,
                            fontSize: 16.0);
                        Navigator.pop(context);
                      } else {
                        final errorMessage = Provider.of<AuthManager>(context, listen: false).message;
                        Fluttertoast.showToast(
                            msg: errorMessage,
                            toastLength: Toast.LENGTH_LONG,
                            gravity: ToastGravity.BOTTOM,
                            timeInSecForIosWeb: 1,
                            backgroundColor: Colors.red,
                            textColor: Colors.white,
                            fontSize: 16.0);
                      }
                    } else {
                      Fluttertoast.showToast(
                          msg: 'Email address is required!',
                          toastLength: Toast.LENGTH_LONG,
                          gravity: ToastGravity.BOTTOM,
                          timeInSecForIosWeb: 1,
                          backgroundColor: Colors.red,
                          textColor: Colors.white,
                          fontSize: 16.0);
                    }
                  },
                  style: TextButton.styleFrom(
                      backgroundColor: Theme.of(context)
                          .buttonTheme
                          .colorScheme!
                          .background),
                  child: Text('Reset Password',
                      style: Theme.of(context).textTheme.bodyText1!.copyWith(
                          color: Theme.of(context)
                              .buttonTheme
                              .colorScheme!
                              .primary)))
        ],
      )),
    );
  }
}
