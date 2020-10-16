import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/authentication_controller.dart';
import '../utils/i18n.dart';
import 'home_screen.dart';
import 'signup_screen.dart';

class Login extends StatelessWidget {
  static String route = "/login/";
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(Messages.login_heading.tr),
      ),
      body: Center(
        child: Container(
          padding: const EdgeInsets.all(20.0),
          width: context.isPhone ? Get.width / 2 : Get.width / 3,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              TextFormField(
                decoration: InputDecoration(hintText: Messages.input_email.tr),
                controller: emailController,
              ),
              const SizedBox(height: 40),
              TextFormField(
                decoration:
                    InputDecoration(hintText: Messages.input_password.tr),
                controller: passwordController,
                obscureText: true,
              ),
              const SizedBox(height: 40),
              GetBuilder<AuthenticationController>(
                builder: (AuthenticationController controller) => controller
                        .isBusy
                    ? const CircularProgressIndicator()
                    : RaisedButton(
                        onPressed: () {
                          controller
                              .login(
                                  emailController.text, passwordController.text)
                              .then((dynamic value) => Get.offNamed(Home.route))
                              .catchError((dynamic error) {
                            Get.snackbar(
                              Messages.unable_login.tr,
                              error.toString(),
                              snackPosition: SnackPosition.BOTTOM,
                            );
                          });
                        },
                        child: Text(Messages.login_button.tr),
                      ),
              ),
              FlatButton(
                onPressed: () {
                  Get.to(SignUp());
                },
                child: Text(Messages.signup_button.tr),
              )
            ],
          ),
        ),
      ),
    );
  }
}
