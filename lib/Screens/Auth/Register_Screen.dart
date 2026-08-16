import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

import '../../Utilties/App_Colors.dart';
import '../../Widgets/Error_SnackBar.dart';
import '../../Widgets/Success_SnackBar.dart';
import 'Login_Screen.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  bool showPassword = false;
  bool showConfirmPassword = false;
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();
  bool isLoading = false;

  void clearController() {
    nameController.clear();
    emailController.clear();
    passwordController.clear();
    confirmPasswordController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: SafeArea(
          child: Container(
            padding: EdgeInsetsGeometry.all(25.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(height: 20),
                Text(
                  "Create Account",
                  style: TextStyle(fontSize: 35, fontWeight: FontWeight(500)),
                ),
                SizedBox(height: 5),
                Text(
                  "Let's get you started",
                  style: TextStyle(
                    color: AppColors.moderateGrey,
                    fontSize: 18,
                    fontWeight: FontWeight(500),
                  ),
                ),
                SizedBox(height: 30),
                //   Login Button
                Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      Container(
                        width: MediaQuery.of(context).size.width,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            // Name Field
                            Text("Name", style: TextStyle(fontSize: 18)),
                            SizedBox(height: 10),
                            TextFormField(
                              controller: nameController,
                              keyboardType: TextInputType.emailAddress,
                              textInputAction: TextInputAction.done,
                              decoration: InputDecoration(
                                prefixIcon: Icon(
                                  Icons.mail,
                                  color: Colors.grey.shade700,
                                ),
                                hintText: "Enter Your Name",
                              ),
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return "Please Enter Your Name";
                                } else {
                                  return null;
                                }
                              },
                            ),
                            SizedBox(height: 10),
                            // Email Field
                            Text("Email", style: TextStyle(fontSize: 18)),
                            SizedBox(height: 10),
                            TextFormField(
                              controller: emailController,
                              keyboardType: TextInputType.emailAddress,
                              textInputAction: TextInputAction.done,
                              decoration: InputDecoration(
                                prefixIcon: Icon(
                                  Icons.mail,
                                  color: Colors.grey.shade700,
                                ),
                                hintText: "Enter Your Email",
                              ),
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return "Please Enter Your Email";
                                } else {
                                  return null;
                                }
                              },
                            ),
                            SizedBox(height: 10),
                            // Password Field
                            Text("Password", style: TextStyle(fontSize: 18)),
                            SizedBox(height: 10),
                            TextFormField(
                              controller: passwordController,
                              obscureText: showPassword ? false : true,
                              keyboardType: TextInputType.visiblePassword,
                              textInputAction: TextInputAction.done,
                              decoration: InputDecoration(
                                suffixIcon: InkWell(
                                  onTap: () {
                                    setState(() {
                                      showPassword = !showPassword;
                                    });
                                  },
                                  child: showPassword
                                      ? Icon(
                                          Icons.visibility,
                                          color: Colors.grey.shade700,
                                        )
                                      : Icon(
                                          Icons.visibility_off,
                                          color: Colors.grey.shade700,
                                        ),
                                ),
                                prefixIcon: Icon(
                                  Icons.lock,
                                  color: Colors.grey.shade700,
                                ),
                                hintText: "Enter Your Password",
                              ),
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return "Please Enter Your Password";
                                } else if (value.trim() !=
                                    confirmPasswordController.text.trim()) {
                                  return "Passwords do not match";
                                } else {
                                  return null;
                                }
                              },
                            ),
                            SizedBox(height: 10),
                            // Confirm Password Field
                            Text(
                              "Confirm Password",
                              style: TextStyle(fontSize: 18),
                            ),
                            SizedBox(height: 10),
                            TextFormField(
                              controller: confirmPasswordController,
                              obscureText: showConfirmPassword ? false : true,
                              keyboardType: TextInputType.visiblePassword,
                              textInputAction: TextInputAction.done,
                              decoration: InputDecoration(
                                suffixIcon: InkWell(
                                  onTap: () {
                                    setState(() {
                                      showConfirmPassword =
                                          !showConfirmPassword;
                                    });
                                  },
                                  child: showConfirmPassword
                                      ? Icon(
                                          Icons.visibility,
                                          color: Colors.grey.shade700,
                                        )
                                      : Icon(
                                          Icons.visibility_off,
                                          color: Colors.grey.shade700,
                                        ),
                                ),
                                prefixIcon: Icon(
                                  Icons.lock,
                                  color: Colors.grey.shade700,
                                ),
                                hintText: "Confirm Your Password",
                              ),
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return "Please Confirm Your Password";
                                } else if (value != passwordController.text) {
                                  return "Passwords do not match";
                                } else {
                                  return null;
                                }
                              },
                            ),
                            SizedBox(height: 40),
                            // Create Account Button
                            Container(
                              width: MediaQuery.of(context).size.width,
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  padding: EdgeInsetsGeometry.all(15.0),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  elevation: 0,
                                  foregroundColor: AppColors.lightColor,
                                  backgroundColor: AppColors.primaryColor,
                                ),
                                onPressed: () async {
                                  if (_formKey.currentState!.validate()) {
                                    setState(() {
                                      isLoading = true;
                                    });
                                    try {
                                      await FirebaseAuth.instance
                                          .createUserWithEmailAndPassword(
                                            email: emailController.text.trim(),
                                            password: passwordController.text
                                                .trim(),
                                          );
                                      SuccessSnackBar.showSuccessSnackBar(
                                        context,
                                        "Account Created Successfully",
                                      );
                                      Navigator.pop(context);
                                      clearController();
                                    } on FirebaseAuthException catch (e) {
                                      if (e.code == 'invalid-email') {
                                        ErrorSnackbar.showErrorSnackBar(
                                          context,
                                          "Invalid Email",
                                        );
                                      } else if (e.code == 'user-not-found') {
                                        ErrorSnackbar.showErrorSnackBar(
                                          context,
                                          "No user found",
                                        );
                                      } else if (e.code ==
                                          'email-already-in-use') {
                                        ErrorSnackbar.showErrorSnackBar(
                                          context,
                                          "Email already exists",
                                        );
                                      } else if (e.code ==
                                          'invalid-credential') {
                                        ErrorSnackbar.showErrorSnackBar(
                                          context,
                                          "Invalid email or password",
                                        );
                                      } else if (e.code ==
                                          'network-request-failed') {
                                        ErrorSnackbar.showErrorSnackBar(
                                          context,
                                          "Please check your internet connection",
                                        );
                                      } else {
                                        ErrorSnackbar.showErrorSnackBar(
                                          context,
                                          "Something went wrong",
                                        );
                                      }
                                    } finally {
                                      setState(() {
                                        isLoading = false;
                                      });
                                    }
                                  } else {
                                    ErrorSnackbar.showErrorSnackBar(
                                      context,
                                      "Please fill all the fields",
                                    );
                                  }
                                },
                                child: isLoading
                                    ? CircularProgressIndicator()
                                    : Text(
                                        "Create Account",
                                        style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                              ),
                            ),
                            SizedBox(height: 20),
                            // Already Have Account
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  "Already Have Account ?",
                                  style: TextStyle(
                                    color: AppColors.moderateGrey,
                                    fontSize: 18,
                                  ),
                                ),
                                SizedBox(width: 5),
                                GestureDetector(
                                  onTap: () {
                                    Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => LoginScreen(),
                                      ),
                                    );
                                  },
                                  child: Text(
                                    "Login",
                                    style: TextStyle(
                                      color: AppColors.primaryColor,
                                      fontSize: 18,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
