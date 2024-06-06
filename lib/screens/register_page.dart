import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:uts/components/my_textfield.dart';
import 'package:uts/screens/login.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class RegisterPage extends StatelessWidget {
  RegisterPage({super.key});

  // text controllers
  final usernameController = TextEditingController();
  final emailController = TextEditingController();
  final nikController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmpasswordController = TextEditingController();

  // sign user up method
  Future<void> signUserUp(BuildContext context) async {
    try {
      if (emailController.text.isEmpty ||
          passwordController.text.isEmpty ||
          confirmpasswordController.text.isEmpty ||
          usernameController.text.isEmpty ||
          nikController.text.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Please fill in all fields')),
        );
        return;
      }

      if (passwordController.text == confirmpasswordController.text) {
        UserCredential userCredential =
            await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: emailController.text,
          password: passwordController.text,
        );

        // Save user data to Firestore
        await FirebaseFirestore.instance
            .collection('users')
            .doc(userCredential.user?.uid)
            .set({
          'username': usernameController.text,
          'nik': nikController.text,
          'email': emailController.text,
        });

        // Navigate to homepage if sign-up is successful
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => LoginPage()),
        );
      } else {
        // Show error message if passwords don't match
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Passwords do not match')),
        );
      }
    } on FirebaseAuthException catch (e) {
      // Show an error message if sign-up fails
      String message;
      if (e.code == 'email-already-in-use') {
        message = 'The email address is already in use by another account.';
      } else if (e.code == 'weak-password') {
        message = 'The password provided is too weak.';
      } else {
        message = 'An error occurred. Please try again.';
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(message)),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          child: Align(
            alignment: Alignment.topCenter,
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  const SizedBox(height: 20),

                  // Register text
                  const Text(
                    'Register',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Inter',
                      fontSize: 25,
                    ),
                  ),

                  const SizedBox(height: 20),

                  // Username field
                  MyTextField(
                    controller: usernameController,
                    hintText: 'Username',
                    prefixIcon: Icons.people,
                    obscureText: false,
                  ),

                  const SizedBox(height: 10),

                  // NIK field
                  MyTextField(
                    controller: nikController,
                    hintText: 'NIK',
                    prefixIcon: Icons.card_membership,
                    obscureText: false,
                  ),

                  const SizedBox(height: 10),

                  // Email field
                  MyTextField(
                    controller: emailController,
                    hintText: 'Email',
                    prefixIcon: Icons.email,
                    obscureText: false,
                  ),

                  const SizedBox(height: 10),

                  // Password field
                  MyTextField(
                    controller: passwordController,
                    hintText: 'Password',
                    prefixIcon: Icons.key,
                    obscureText: true,
                  ),

                  const SizedBox(height: 10),

                  // Confirm Password field
                  MyTextField(
                    controller: confirmpasswordController,
                    hintText: 'Confirm Password',
                    prefixIcon: Icons.key,
                    obscureText: true,
                  ),

                  const SizedBox(height: 25),

                  // Sign Up button
                  SizedBox(
                    width: 358,
                    child: ElevatedButton(
                      onPressed: () => signUserUp(context),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF205295),
                        padding: const EdgeInsets.symmetric(
                          vertical: 17,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(18),
                        ),
                      ),
                      child: const Text(
                        "Sign Up",
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

                  const SizedBox(height: 50),

                  // OR divider
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
                          child: Text(
                            'OR',
                            style: TextStyle(color: Colors.black),
                          ),
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

                  const SizedBox(height: 30),

                  // Social login buttons
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
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
                          child: Image.asset(
                            'assets/images/Ggoogle.webp',
                            height: 35,
                            width: 35,
                          ),
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
                          child: Image.asset(
                            'assets/images/apple.png',
                            height: 35,
                            width: 35,
                          ),
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
                          child: Image.asset(
                            'assets/images/facebook.png',
                            height: 35,
                            width: 35,
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 20),

                  // Already have an account? Sign In
                  Text.rich(
                    TextSpan(
                      children: [
                        const TextSpan(
                          text: 'Sudah punya akun? ',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 14,
                            fontFamily: 'Poppins',
                            fontWeight: FontWeight.w500,
                            height: 0,
                          ),
                        ),
                        TextSpan(
                          text: 'Sign In',
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
                                  builder: (context) => LoginPage(),
                                ),
                              );
                            },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
