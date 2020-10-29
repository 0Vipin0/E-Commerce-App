import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/authentication_controller.dart';
import '../screens/login_screen.dart';
import '../utils/i18n.dart';
import 'home_screen.dart';

class SignUp extends StatelessWidget {
  static String route = "signup";
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(Messages.signup_heading.tr),
      ),
      body: Center(
        child: Container(
          padding: const EdgeInsets.all(20.0),
          width: context.isPhone ? Get.width / 2 : Get.width / 3,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              TextFormField(
                decoration: InputDecoration(
                  hintText: Messages.input_name.tr,
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20.0),
                    borderSide: const BorderSide(
                      width: 1.5,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20.0),
                    borderSide: const BorderSide(
                      color: Colors.blue,
                      width: 1.5,
                    ),
                  ),
                ),
                controller: nameController,
              ),
              const SizedBox(height: 40),
              TextFormField(
                decoration: InputDecoration(
                  hintText: Messages.input_email.tr,
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20.0),
                    borderSide: const BorderSide(
                      width: 1.5,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20.0),
                    borderSide: const BorderSide(
                      color: Colors.blue,
                      width: 1.5,
                    ),
                  ),
                ),
                controller: emailController,
              ),
              const SizedBox(height: 40),
              TextFormField(
                decoration: InputDecoration(
                  hintText: Messages.input_password.tr,
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20.0),
                    borderSide: const BorderSide(
                      width: 1.5,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20.0),
                    borderSide: const BorderSide(
                      color: Colors.blue,
                      width: 1.5,
                    ),
                  ),
                ),
                obscureText: true,
                controller: passwordController,
              ),
              const SizedBox(height: 10),
              GetBuilder<AuthenticationController>(
                builder: (AuthenticationController controller) => controller
                        .isBusy
                    ? const CircularProgressIndicator()
                    : RaisedButton(
                        onPressed: () {
                          controller
                              .signup(
                                  emailController.text, passwordController.text)
                              .then((dynamic value) => Get.offNamed(Home.route))
                              .catchError((dynamic error) {
                            Get.snackbar(
                              Messages.unable_signup.tr,
                              error.toString(),
                              snackPosition: SnackPosition.BOTTOM,
                            );
                          });
                        },
                        child: Text(Messages.signup_button.tr),
                      ),
              ),
              const SizedBox(height: 10),
              FlatButton(
                onPressed: () {
                  Get.offNamed(Login.route);
                },
                child: Text(Messages.login_button.tr),
              )
            ],
          ),
        ),
      ),
    );
  }
}
