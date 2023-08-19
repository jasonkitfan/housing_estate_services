import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({Key? key}) : super(key: key);

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final FocusNode pass1Node = FocusNode();
  final FocusNode pass2Node = FocusNode();
  final emailController = TextEditingController();
  final pass1Controller = TextEditingController();
  final pass2Controller = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  final auth = FirebaseAuth.instance;

  @override
  void dispose() {
    pass1Node.dispose();
    pass2Node.dispose();
    pass1Controller.dispose();
    pass2Controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
            image: DecorationImage(
                opacity: 0.6,
                image: AssetImage("assets/images/bg_img.png"),
                fit: BoxFit.cover)),
        height: size.height,
        child: Form(
            key: _formKey,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  SizedBox(
                    height: size.height * 0.2,
                  ),
                  Container(
                    decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.95),
                        borderRadius: BorderRadius.circular(20)),
                    margin: const EdgeInsets.symmetric(horizontal: 20),
                    padding: const EdgeInsets.symmetric(vertical: 50),
                    child: Column(
                      children: [
                        const Text(
                          "Sign Up",
                          style: TextStyle(
                              fontSize: 36, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 20),
                        RegisterInputField(
                          validator: validateInput,
                          controller: emailController,
                          labelText: "Email",
                          nextFocus: pass1Node,
                        ),
                        RegisterInputField(
                          validator: validateInput,
                          controller: pass1Controller,
                          labelText: "Password",
                          nextFocus: pass2Node,
                          currentFocus: pass1Node,
                          secure: true,
                        ),
                        RegisterInputField(
                          validator: validateInput,
                          controller: pass2Controller,
                          labelText: "Confirm Password",
                          currentFocus: pass2Node,
                          secure: true,
                        ),
                        ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.deepPurpleAccent,
                                shape: const StadiumBorder()),
                            onPressed: () async {
                              bool valid = _formKey.currentState!.validate();
                              if (valid) {
                                createAccount();
                              }
                            },
                            child: const Text("Register")),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text("Already have an account?"),
                            TextButton(
                                onPressed: () => Navigator.pop(context),
                                child: const Text("Login"))
                          ],
                        )
                      ],
                    ),
                  )
                ],
              ),
            )),
      ),
    );
  }

  String? validateInput(String input, String type) {
    if (input.isEmpty) {
      return "Please input some text";
    } else if (input.length < 6) {
      return "Please enter text more than 5 characters";
    } else if (type.contains("Email")) {
      if (!input.contains("@")) {
        return "Please enter a valid email";
      }
    } else if (type.contains("Password")) {
      if (pass1Controller.text != pass2Controller.text) {
        return "Password not match";
      }
    }
    return null;
  }

  Future<void> createAccount() async {
    String message = "Registration Completed";
    try {
      UserCredential result = await auth.createUserWithEmailAndPassword(
          email: emailController.text, password: pass1Controller.text);
      if (result.user != null) {
        createUserProfile(result.user!);
      }
    } on FirebaseAuthException catch (e) {
      // print("error code: ${e.code}");
      // print("error message: ${e.message}");
      message = e.message!;
    } finally {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(
        message,
        textAlign: TextAlign.center,
      )));
      emailController.text = "";
      pass1Controller.text = "";
      pass2Controller.text = "";
    }
  }
}

Future<void> createUserProfile(User user) async {
  FirebaseFirestore.instance
      .collection('users_profile')
      .doc()
      .set({"uid": user.uid, "email": user.email, "role": "normal_user"});
}

class RegisterInputField extends StatelessWidget {
  const RegisterInputField({
    Key? key,
    required this.labelText,
    required this.controller,
    this.validator,
    this.secure = false,
    this.currentFocus,
    this.nextFocus,
  }) : super(key: key);

  final String labelText;
  final FocusNode? currentFocus;
  final FocusNode? nextFocus;
  final bool secure;
  final TextEditingController controller;
  final Function? validator;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: TextFormField(
        validator: (value) {
          return validator!(value, labelText);
        },
        controller: controller,
        obscureText: secure,
        onFieldSubmitted: (_) => FocusScope.of(context).requestFocus(nextFocus),
        focusNode: currentFocus,
        decoration: InputDecoration(
            labelText: labelText,
            floatingLabelStyle: const TextStyle(color: Colors.deepPurpleAccent),
            border: const OutlineInputBorder(),
            focusedBorder: const OutlineInputBorder(
                borderSide:
                    BorderSide(color: Colors.deepPurpleAccent, width: 3))),
      ),
    );
  }
}
