import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_application_1/components/CustomTextField.dart';
import 'package:flutter_application_1/components/logo.dart';
import 'package:flutter_application_1/components/mainButton.dart';
// awesome dialog
import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: const EdgeInsets.all(20),
        child: ListView(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Logo(),
                Text(
                  "Sign Up",
                  style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                ),
                Text(
                  "Sign Up to Continue Using The App",
                  style: TextStyle(fontSize: 15, color: Colors.grey[400]),
                ),
                SizedBox(height: 20),
                Text(
                  "Email",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                ),
                SizedBox(height: 10),
                CustomTextField(
                  hinttext: "Enter your email",
                  controller: emailController,
                  validator: (value) {
                    if (value!.isEmpty ||
                        !value.contains("@") ||
                        !value.contains(".")) {
                      return "Please enter a valid email";
                    }
                    return null;
                  },
                ),
                SizedBox(height: 20),
                Text(
                  "Password",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                ),
                SizedBox(height: 10),
                CustomTextField(
                  hinttext: "Enter a password",
                  controller: passwordController,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return "Please enter a password";
                    }
                    return null;
                  },
                ),
                SizedBox(height: 20),
                Text(
                  "Confirm Password",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                ),
                SizedBox(height: 10),
                CustomTextField(
                  hinttext: "Confirm Password",
                  controller: confirmPasswordController,
                  validator: (value) {
                    if (value != passwordController.text) {
                      return "Passwords don't match";
                    }
                    return null;
                  },
                ),
              ],
            ),
            SizedBox(height: 30),
            mainButton(
              text: "Register",
              onPressed: () async {
                if (passwordController.text != confirmPasswordController.text) {
                  print("Passwords don't match");
                  return;
                }
                try {
                  final credential = await FirebaseAuth.instance
                      .createUserWithEmailAndPassword(
                        email: emailController.text,
                        password: passwordController.text,
                      );

                  await credential.user!.sendEmailVerification();
                  await FirebaseAuth.instance.signOut();

                  // EMAIL  VERIFICATION
                  final snackBar = SnackBar(
                    elevation: 0,
                    behavior: SnackBarBehavior.floating,
                    backgroundColor: Colors.transparent,
                    content: AwesomeSnackbarContent(
                      title: 'Success',
                      message: 'Check your email to verify your account',
                      contentType: ContentType.success,
                    ),
                  );
                  ScaffoldMessenger.of(context).showSnackBar(snackBar);

                  Navigator.pushNamedAndRemoveUntil(
                    context,
                    '/login', // your home route
                    (route) => false, // remove all previous routes
                  );
                } on FirebaseAuthException catch (e) {
                  if (e.code == 'weak-password') {
                    // snackbar
                    final snackBar = SnackBar(
                      elevation: 0,
                      behavior: SnackBarBehavior.floating,
                      backgroundColor: Colors.transparent,
                      content: AwesomeSnackbarContent(
                        title: 'Error',
                        message: 'The password provided is too weak.',
                        contentType: ContentType.failure,
                      ),
                    );
                    ScaffoldMessenger.of(context).showSnackBar(snackBar);
                  } else if (e.code == 'email-already-in-use') {
                    // snackbar
                    final snackBar = SnackBar(
                      elevation: 0,
                      behavior: SnackBarBehavior.floating,
                      backgroundColor: Colors.transparent,
                      content: AwesomeSnackbarContent(
                        title: 'Error',
                        message: 'The account already exists for that email.',
                        contentType: ContentType.failure,
                      ),
                    );
                    ScaffoldMessenger.of(context).showSnackBar(snackBar);
                  }
                } catch (e) {
                  print(e);
                }
              },
            ),
            SizedBox(height: 30),
            InkWell(
              onTap: () {
                Navigator.pop(context);
              },
              child: Center(
                child: Text.rich(
                  const TextSpan(
                    text: "Already have an account? ",

                    children: [
                      TextSpan(
                        text: "Login",
                        style: TextStyle(
                          color: Colors.amber,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
