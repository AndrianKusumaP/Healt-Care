import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:uts/components/my_textfield.dart';
import 'package:flutter/gestures.dart';
import 'package:uts/screens/homepage.dart';
import 'package:uts/screens/register_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class LoginPage extends StatelessWidget {
  LoginPage({super.key});

  // text editing controller
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  // Sign user in method
  Future<void> signUserIn(BuildContext context) async {
    try {
      if (emailController.text.isEmpty || passwordController.text.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Please fill in both fields')),
        );
        return;
      }

      String input = emailController.text.trim();
      String password = passwordController.text.trim();

      // Check if input is an email or NIK
      String? email;
      if (input.contains('@')) {
        // Input is an email
        email = input;
      } else {
        // Input is assumed to be a NIK, get email from Firestore
        email = await _getEmailFromNik(input);
        if (email == null) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('No user found for that NIK.')),
          );
          return;
        }
      }

      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Navigate to homepage if sign-in is successful
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => homepage()),
      );
    } on FirebaseAuthException catch (e) {
      // Show an error message if sign-in fails
      String message;
      if (e.code == 'user-not-found') {
        message = 'No user found for that email.';
      } else if (e.code == 'wrong-password') {
        message = 'Wrong password provided.';
      } else {
        message = 'An error occurred. Please try again.';
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(message)),
      );
    }
  }

  // Method to get email from NIK
  Future<String?> _getEmailFromNik(String nik) async {
    try {
      QuerySnapshot snapshot = await FirebaseFirestore.instance
          .collection('users')
          .where('nik', isEqualTo: nik)
          .limit(1)
          .get();
      if (snapshot.docs.isNotEmpty) {
        return snapshot.docs.first.get('email');
      }
      return null;
    } catch (e) {
      print(e);
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Center(
          child: Column(
            children: [
              const SizedBox(height: 50),

              // login
              const Text(
                'Login',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 20,
                  fontFamily: 'Inter',
                  fontWeight: FontWeight.w600,
                  height: 0,
                ),
              ),

              const SizedBox(height: 30),

              // email/NIK
              MyTextField(
                controller: emailController,
                hintText: 'Enter Your Email / NIK',
                prefixIcon: Icons.email,
                obscureText: false,
              ),

              const SizedBox(height: 15),

              // password
              MyTextField(
                controller: passwordController,
                prefixIcon: Icons.key,
                hintText: 'Enter Your Password',
                obscureText: true,
              ),

              const SizedBox(height: 10),

              // forget password
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text.rich(
                      TextSpan(
                        text: 'Forget your password?',
                        style: const TextStyle(
                          color: Color(0xFF205295),
                          fontSize: 13,
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.w600,
                          height: 0,
                        ),
                        recognizer: TapGestureRecognizer()..onTap = () {},
                      ),
                    )
                  ],
                ),
              ),

              const SizedBox(height: 25),

              // login button
              SizedBox(
                width: 358,
                child: ElevatedButton(
                  onPressed: () => signUserIn(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF205295),
                    padding: const EdgeInsets.symmetric(vertical: 17),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18),
                    ),
                  ),
                  child: const Text(
                    "Login",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontFamily: 'Inter',
                      fontWeight: FontWeight.w400,
                      height: 0,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 15),

              // tidak punya akun dan signup
              Text.rich(
                TextSpan(
                  children: [
                    const TextSpan(
                      text: 'Tidak punya akun? ',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 14,
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w500,
                        height: 0,
                      ),
                    ),
                    TextSpan(
                      text: 'Sign Up',
                      style: const TextStyle(
                        color: Color(0xFF205295),
                        fontSize: 14,
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w500,
                        height: 0,
                      ),
                      recognizer: TapGestureRecognizer()
                        ..onTap = () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => RegisterPage()),
                          );
                        },
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 50),

              // or continue with
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 25.0),
                child: Row(
                  children: [
                    Expanded(
                      child: Divider(
                        thickness: 2,
                        color: Colors.black,
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 10.0),
                      child: Text('OR'),
                    ),
                    Expanded(
                      child: Divider(
                        thickness: 2,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 25),

              // google + apple + facebook
              Row(
                children: [
                  const SizedBox(width: 55),
                  SizedBox(
                    width: 100,
                    child: ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(
                          vertical: 17,
                        ),
                        shape: RoundedRectangleBorder(
                          side: const BorderSide(
                            width: 2,
                            color: Color(0xCC205295),
                          ),
                          borderRadius: BorderRadius.circular(18),
                        ),
                      ),
                      child: Image.asset('assets/images/Ggoogle.webp',
                          height: 35, width: 35),
                    ),
                  ),
                  const SizedBox(width: 20),
                  SizedBox(
                    width: 100,
                    child: ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(
                          vertical: 17,
                        ),
                        shape: RoundedRectangleBorder(
                          side: const BorderSide(
                            width: 2,
                            color: Color(0xCC205295),
                          ),
                          borderRadius: BorderRadius.circular(18),
                        ),
                      ),
                      child: Image.asset('assets/images/apple.png',
                          height: 35, width: 35),
                    ),
                  ),
                  const SizedBox(width: 20),
                  SizedBox(
                    width: 100,
                    child: ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(
                          vertical: 17,
                        ),
                        shape: RoundedRectangleBorder(
                          side: const BorderSide(
                            width: 2,
                            color: Color(0xCC205295),
                          ),
                          borderRadius: BorderRadius.circular(18),
                        ),
                      ),
                      child: Image.asset('assets/images/facebook.png',
                          height: 35, width: 35),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
