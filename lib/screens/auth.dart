import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:vrit/homeNavigation.dart';
import 'package:vrit/screens/homeScreen.dart';

class SignInPage extends StatefulWidget {
  const SignInPage({super.key});

  @override
  _SignInPageState createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  bool _isSigningIn = false;

  Future<User?> _signInWithGoogle() async {
    setState(() {
      _isSigningIn = true;
    });

    try {
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      if (googleUser == null) {
        setState(() {
          _isSigningIn = false;
        });
        return null;
      }
      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;
      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );
      final UserCredential userCredential =
          await FirebaseAuth.instance.signInWithCredential(credential);
      setState(() {
        _isSigningIn = false;
      });
      return userCredential.user;
    } catch (e) {
      print(e); // Print the error to the console
      setState(() {
        _isSigningIn = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Sign in failed: $e')),
      );
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Center(
          child: Padding(
            padding: EdgeInsets.only(top: 250.h),
            child: Column(
              children: [
                Text(
                  "Set up your profile",
                  style: TextStyle(
                      fontSize: 18.sp,
                      fontWeight: FontWeight.w500,
                      color: Colors.black),
                ),
                SizedBox(
                  height: 50.h,
                ),
                FilledButton.tonalIcon(
                    style: ButtonStyle(
                        iconColor: const MaterialStatePropertyAll(Colors.black),
                        backgroundColor:
                            const MaterialStatePropertyAll(Colors.white),
                        side: MaterialStatePropertyAll(
                            BorderSide(width: 1.w, color: Colors.black))),
                    onPressed: () async {
                      try {
                        User? user = await _signInWithGoogle();
                        if (user != null) {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => HomeNavigation()),
                          );
                        }
                      } catch (e) {
                        print(
                            e); // Handle the error, e.g., show a snackbar or dialog
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Sign in failed: $e')),
                        );
                      }
                    },
                    icon: SizedBox(
                        height: 18.h,
                        width: 18.w,
                        child: Image.asset("assets/google.png")),
                    label: Text(
                      "Continue with Google",
                      style: TextStyle(
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w500,
                        color: Colors.black,
                      ),
                    )),
                SizedBox(
                  height: 10.h,
                ),
                _isSigningIn == true ? CircularProgressIndicator() : SizedBox()
              ],
            ),
          ),
        ),
      ),
    );
  }
}
