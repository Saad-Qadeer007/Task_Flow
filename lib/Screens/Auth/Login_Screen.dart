import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

import '../../Utilties/App_Colors.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _forgetformkey = GlobalKey<FormState>();
  bool showPassword = false;
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController forgetPasswordController = TextEditingController();
  bool isLoading = false;

  void clearController() {
    emailController.clear();
    passwordController.clear();
    forgetPasswordController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: SafeArea(
          child: Container(
            padding: EdgeInsetsGeometry.all(25.0),
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(color: AppColors.lightColor),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(height: 20),
                Text(
                  "Welcome Back!",
                  style: TextStyle(fontSize: 35, fontWeight: FontWeight(500)),
                ),
                SizedBox(height: 5),
                Text(
                  "Login To Continue",
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
                                } else {
                                  return null;
                                }
                              },
                            ),
                            SizedBox(height: 10),
                            // Forget Password
                            Container(
                              width: MediaQuery.of(context).size.width,
                              child: InkWell(
                                onTap: () {
                                  showDialog(
                                    context: context,
                                    builder: (context) => AlertDialog(
                                      backgroundColor: Colors.grey.shade900,
                                      title: Text("Forget Password"),
                                      content: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Text(
                                            "Enter Your Email To Reset Your Password",
                                            style: TextStyle(fontSize: 16),
                                          ),
                                          SizedBox(height: 20),
                                          Form(
                                            key: _forgetformkey,
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  "Email",
                                                  style: TextStyle(
                                                    fontSize: 18,
                                                  ),
                                                ),
                                                SizedBox(height: 10),
                                                TextFormField(
                                                  controller:
                                                      forgetPasswordController,
                                                  keyboardType: TextInputType
                                                      .emailAddress,
                                                  textInputAction:
                                                      TextInputAction.done,
                                                  decoration: InputDecoration(
                                                    filled: true,
                                                    fillColor:
                                                        Colors.grey.shade900,
                                                    hintText:
                                                        "Enter Your Email",
                                                    hintStyle: TextStyle(
                                                      color: Colors.white,
                                                    ),
                                                    border:
                                                        OutlineInputBorder(),
                                                  ),
                                                  validator: (value) {
                                                    if (value!.isEmpty) {
                                                      return "Please Enter Your Email";
                                                    } else {
                                                      return null;
                                                    }
                                                  },
                                                ),
                                              ],
                                            ),
                                          ),
                                          SizedBox(height: 1),
                                        ],
                                      ),
                                      // actions: [
                                      //   ElevatedButton(
                                      //     style: ElevatedButton.styleFrom(
                                      //       backgroundColor:
                                      //       AppColors.error,
                                      //       foregroundColor: Colors.white,
                                      //       shape: RoundedRectangleBorder(
                                      //         borderRadius:
                                      //         BorderRadiusGeometry.circular(
                                      //           8.0,
                                      //         ),
                                      //       ),
                                      //     ),
                                      //     onPressed: () {
                                      //       Navigator.pop(context);
                                      //       clearController();
                                      //     },
                                      //     child: Text("Cancel"),
                                      //   ),
                                      //   ElevatedButton(
                                      //     style: ElevatedButton.styleFrom(
                                      //       backgroundColor:
                                      //       AppColors.success,
                                      //       foregroundColor: Colors.white,
                                      //       shape: RoundedRectangleBorder(
                                      //         borderRadius:
                                      //         BorderRadiusGeometry.circular(
                                      //           8.0,
                                      //         ),
                                      //       ),
                                      //     ),
                                      //     onPressed: () async {
                                      //       if (_forgetformkey.currentState!
                                      //           .validate()) {
                                      //         try {
                                      //           await FirebaseAuth.instance
                                      //               .sendPasswordResetEmail(
                                      //             email:
                                      //             forgetPasswordController
                                      //                 .text,
                                      //           );
                                      //           SuccessSnackBar.showSuccessSnackBar(
                                      //             context,
                                      //             "Password reset email sent",
                                      //           );
                                      //           Navigator.pop(context);
                                      //         } on FirebaseAuthException catch (
                                      //         e
                                      //         ) {
                                      //           if (e.code ==
                                      //               'invalid-email') {
                                      //             ErrorSnackbar.showErrorSnackBar(
                                      //               context,
                                      //               "Invalid Email",
                                      //             );
                                      //           } else if (e.code ==
                                      //               'user-not-found') {
                                      //             ErrorSnackbar.showErrorSnackBar(
                                      //               context,
                                      //               "No user found",
                                      //             );
                                      //           } else if (e.code ==
                                      //               'invalid-credential') {
                                      //             ErrorSnackbar.showErrorSnackBar(
                                      //               context,
                                      //               "Invalid email or password",
                                      //             );
                                      //           } else if (e.code ==
                                      //               'network-request-failed') {
                                      //             ErrorSnackbar.showErrorSnackBar(
                                      //               context,
                                      //               "Please check your internet connection",
                                      //             );
                                      //           } else {
                                      //             ErrorSnackbar.showErrorSnackBar(
                                      //               context,
                                      //               "Something went wrong",
                                      //             );
                                      //           }
                                      //         }
                                      //       }
                                      //     },
                                      //     child: Text("Reset Password"),
                                      //   ),
                                      // ],
                                    ),
                                  );
                                },
                                child: Text(
                                  "Forget Password ?",
                                  style: TextStyle(
                                    fontSize: 18,
                                    color: AppColors.primaryColor,
                                    fontWeight: FontWeight(600),
                                  ),
                                  textAlign: TextAlign.end,
                                ),
                              ),
                            ),
                            SizedBox(height: 40),
                            // Login Button
                            Container(
                              width: MediaQuery.of(context).size.width,
                              child: ElevatedButton(
                                // onPressed: () async {
                                //   if (_formKey.currentState!.validate()) {
                                //     setState(() {
                                //       isLoading = true;
                                //     });
                                //     try {
                                //       await FirebaseAuth.instance
                                //           .signInWithEmailAndPassword(
                                //         email: emailController.text
                                //             .trim(),
                                //         password: passwordController
                                //             .text
                                //             .trim(),
                                //       );
                                //
                                //       Navigator.pushReplacement(
                                //         context,
                                //         MaterialPageRoute(
                                //           builder: (context) =>
                                //               HomeScreen(),
                                //         ),
                                //       );
                                //       SuccessSnackBar.showSuccessSnackBar(
                                //         context,
                                //         "Login successful",
                                //       );
                                //       clearController();
                                //     } on FirebaseAuthException catch (e) {
                                //       if (e.code == 'invalid-email') {
                                //         ErrorSnackbar.showErrorSnackBar(
                                //           context,
                                //           "Invalid email",
                                //         );
                                //       } else if (e.code ==
                                //           'user-not-found') {
                                //         ErrorSnackbar.showErrorSnackBar(
                                //           context,
                                //           "No user found",
                                //         );
                                //       } else if (e.code ==
                                //           'invalid-credential') {
                                //         ErrorSnackbar.showErrorSnackBar(
                                //           context,
                                //           "Invalid email or password",
                                //         );
                                //       } else if (e.code ==
                                //           'network-request-failed') {
                                //         ErrorSnackbar.showErrorSnackBar(
                                //           context,
                                //           "Please check your internet connection",
                                //         );
                                //       } else {
                                //         ErrorSnackbar.showErrorSnackBar(
                                //           context,
                                //           "Something went wrong",
                                //         );
                                //       }
                                //     } finally {
                                //       setState(() {
                                //         isLoading = false;
                                //       });
                                //     }
                                //   } else {
                                //     ScaffoldMessenger.of(
                                //       context,
                                //     ).showSnackBar(
                                //       SnackBar(
                                //         duration: Duration(seconds: 1),
                                //         backgroundColor: AppColors.error,
                                //         content: Text(
                                //           "Please fill all the fields",
                                //           style: TextStyle(fontSize: 16),
                                //         ),
                                //       ),
                                //     );
                                //   }
                                // },
                                onPressed: () {},
                                style: ElevatedButton.styleFrom(
                                  padding: EdgeInsetsGeometry.all(15.0),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  elevation: 0,
                                  foregroundColor: AppColors.lightColor,
                                  backgroundColor: AppColors.primaryColor,
                                ),
                                child: isLoading
                                    ? CircularProgressIndicator()
                                    : Text(
                                        "Login",
                                        style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                              ),
                            ),
                            SizedBox(height: 20),
                            // Donot Have Account
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  "Don't have an account ?",
                                  style: TextStyle(
                                    color: AppColors.moderateGrey,
                                    fontSize: 18,
                                  ),
                                ),
                                SizedBox(width: 5),
                                GestureDetector(
                                  // onTap: () {
                                  //   Navigator.push(
                                  //     context,
                                  //     MaterialPageRoute(
                                  //       builder: (context) =>
                                  //           RegisterScreen(),
                                  //     ),
                                  //   );
                                  //   clearController();
                                  // },
                                  child: Text(
                                    "Sign Up",
                                    style: TextStyle(
                                      color: AppColors.primaryColor,
                                      fontSize: 18,
                                      fontWeight: FontWeight(600),
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
