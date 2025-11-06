import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter_application_1/components/CustomTextField.dart';
import 'package:flutter_application_1/components/logo.dart';
import 'package:flutter_application_1/components/mainButton.dart';
import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'dart:async';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => LoginPageState();
}

class LoginPageState extends State<LoginPage> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  final GoogleSignIn googleSignIn = GoogleSignIn(
    clientId:
        '475068962100-rj1fb14cq1nfi75etlfinv25slhh2706.apps.googleusercontent.com', // remplace par ton Web Client ID complet
    scopes: ['email', 'profile'],
    signInOption: SignInOption.standard, // important pour Web
  );

  Future<UserCredential> signInWithGoogle() async {
    try {
      // Déclenche le flux de connexion
      final GoogleSignInAccount? googleUser = await googleSignIn.signIn();

      // Si l'utilisateur annule la connexion
      if (googleUser == null) {
        return Future.error("Login canceled by user");
      }

      // Récupérer les informations d'authentification
      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      // Créer les credentials Firebase
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      // Sign in avec Firebase
      return await FirebaseAuth.instance.signInWithCredential(credential);
    } catch (e) {
      if (e.toString().contains('popup_closed')) {
        return Future.error('Popup fermée avant authentification');
      }
      return Future.error('Erreur Google Sign-In: $e');
    }
  }

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
                SizedBox(height: 70),
                Logo(),
                Text(
                  "Login",
                  style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                ),
                Text(
                  "Login to Continue Using The App",
                  style: TextStyle(fontSize: 15, color: Colors.grey[400]),
                ),
                SizedBox(height: 20),
                Text(
                  "Email",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                ),
                SizedBox(height: 10),
                CustomTextField(
                  controller: emailController,
                  hinttext: "Enter your email",
                  validator: (value) {
                    if (value!.isEmpty) {
                      return "Email is required";
                    } else if (!value.contains("@") && !value.contains(".")) {
                      return "Invalid email format";
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
                  hinttext: "Enter your password",
                  controller: passwordController,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return "Password is required";
                    }
                    return null;
                  },
                ),
                SizedBox(height: 8),
              ],
            ),
            InkWell(
              onTap: () async {
                final email = emailController.text.trim();
                if (email.isEmpty) {
                  // show snackbar
                  final snackBar = SnackBar(
                    elevation: 0,
                    behavior: SnackBarBehavior.floating,
                    backgroundColor: Colors.transparent,
                    content: AwesomeSnackbarContent(
                      title: 'Info',
                      message:
                          'Email is required, please enter your email before resetting your password',
                      contentType: ContentType.help,
                    ),
                  );
                  ScaffoldMessenger.of(context).showSnackBar(snackBar);
                  return;
                }

                // send password reset email
                await FirebaseAuth.instance.sendPasswordResetEmail(
                  email: email,
                );
                // show snackbar
                final snackBar = SnackBar(
                  elevation: 0,
                  behavior: SnackBarBehavior.floating,
                  backgroundColor: Colors.transparent,
                  content: AwesomeSnackbarContent(
                    title: 'Info',
                    message:
                        'If the email exists, you will receive an email to reset your password',
                    contentType: ContentType.help,
                  ),
                );
                ScaffoldMessenger.of(context).showSnackBar(snackBar);
              },
              child: Text(
                "Forgot Password?",
                style: TextStyle(fontSize: 12),
                textAlign: TextAlign.right,
              ),
            ),
            SizedBox(height: 20),
            mainButton(
              text: "Login",
              onPressed: () async {
                try {
                  final credential = await FirebaseAuth.instance
                      .signInWithEmailAndPassword(
                        email: emailController.text,
                        password: passwordController.text,
                      );

                  // check if email is verified and user exist
                  if (credential.user != null &&
                      credential.user!.emailVerified) {
                    Navigator.pushNamedAndRemoveUntil(
                      context,
                      '/home',
                      (_) => false,
                    );
                  } else if (!credential.user!.emailVerified) {
                    // snackbar
                    final snackBar = SnackBar(
                      elevation: 0,
                      behavior: SnackBarBehavior.floating,
                      backgroundColor: Colors.transparent,
                      content: AwesomeSnackbarContent(
                        title: 'Error',
                        message: 'Pls Verify you Email',
                        contentType: ContentType.help,
                      ),
                    );
                    ScaffoldMessenger.of(context).showSnackBar(snackBar);
                  }
                } on FirebaseAuthException catch (e) {
                  if (e.code == 'invalid-credential') {
                    // snack bar
                    final snackBar = SnackBar(
                      elevation: 0,
                      behavior: SnackBarBehavior.floating,
                      backgroundColor: Colors.transparent,
                      content: AwesomeSnackbarContent(
                        title: 'Error',
                        message: 'Email or Password is incorrect',
                        contentType: ContentType.failure,
                      ),
                    );
                    ScaffoldMessenger.of(context).showSnackBar(snackBar);
                  }
                  print(e.code);
                }
              },
            ),
            SizedBox(height: 30),
            Text(
              "--------------------- OR ---------------------",
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,

              children: [
                InkWell(
                  onTap: () {
                    print("google");
                    signInWithGoogle();
                  },
                  child: Image.asset(
                    "assets/images/google_logo.png",
                    width: 40,
                    height: 40,
                  ),
                ),
                InkWell(
                  onTap: () {
                    print("google");
                    signInWithGoogle();
                  },
                  child: Image.asset(
                    "assets/images/facebook_logo.png",
                    width: 50,
                    height: 50,
                  ),
                ),
                InkWell(
                  onTap: () {
                    print("apple");
                  },
                  child: Image.asset(
                    "assets/images/apple_logo.png",
                    width: 40,
                    height: 40,
                  ),
                ),
              ],
            ),
            SizedBox(height: 40),
            InkWell(
              onTap: () {
                Navigator.pushNamed(context, "/register");
              },
              child: RichText(
                textAlign: TextAlign.center,
                text: TextSpan(
                  text: "Don't have an account?",
                  children: [
                    TextSpan(
                      text: " Register",
                      style: TextStyle(
                        color: Colors.amber,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
