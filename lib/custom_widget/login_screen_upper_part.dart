import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:ui' as ui;

class LoginScreenUpper extends StatefulWidget {
  const LoginScreenUpper({Key? key}) : super(key: key);

  @override
  State<LoginScreenUpper> createState() => _LoginScreenUpperState();
}

class _LoginScreenUpperState extends State<LoginScreenUpper> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final FocusNode passwordFocusNode = FocusNode();
  final auth = FirebaseAuth.instance;
  bool loginLoading = false;

  @override
  void dispose() {
    passwordFocusNode.dispose();
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return SizedBox(
      height: size.height * 0.7,
      width: double.infinity,
      child: CustomPaint(
        painter: RPSCustomPainter(),
        child: Padding(
          padding: EdgeInsets.only(
              bottom: size.height * 0.05, top: size.height * 0.1),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              SizedBox(
                width: 250,
                height: size.height * 0.20,
                child: AspectRatio(
                    aspectRatio: 16 / 9,
                    child: Image.asset(
                      "assets/images/smart_city.png",
                    )),
              ),
              Form(
                  child: Column(
                children: [
                  CustomInputField(
                    textFieldController: emailController,
                    icon: Icons.email_outlined,
                    hintText: "Email",
                    size: size,
                    nextFocusNode: passwordFocusNode,
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  CustomInputField(
                    textFieldController: passwordController,
                    icon: Icons.lock_outline_rounded,
                    hintText: "Password",
                    obscureText: true,
                    size: size,
                    currentFocusNode: passwordFocusNode,
                  ),
                ],
              )),
              Container(
                  height: size.height * 0.05,
                  decoration:
                      BoxDecoration(borderRadius: BorderRadius.circular(10)),
                  margin: EdgeInsets.symmetric(horizontal: size.width * 0.1),
                  width: double.infinity,
                  child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          shape: const StadiumBorder(),
                          backgroundColor: Colors.indigoAccent),
                      onPressed: () => signIn(),
                      child: !loginLoading
                          ? const Text(
                              "Login",
                              style: TextStyle(fontSize: 20),
                            )
                          : const SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 1,
                                color: Colors.white,
                              )))),
              TextButton(
                  onPressed: () {
                    ScaffoldMessenger.of(context).hideCurrentSnackBar();
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                          content: const Text(
                            "pay \$HKD 1,000 to get back your account",
                            textAlign: TextAlign.center,
                          ),
                          action: SnackBarAction(
                            label: "OK",
                            onPressed: () {},
                          )),
                    );
                  },
                  child: const Text("Forget your password?"))
            ],
          ),
        ),
      ),
    );
  }

  Future<void> signIn() async {
    try {
      setState(() {
        loginLoading = true;
      });
      await auth.signInWithEmailAndPassword(
          email: emailController.text, password: passwordController.text);
      Navigator.of(context).pushReplacementNamed("home");
    } on FirebaseAuthException catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(
        e.message!,
        textAlign: TextAlign.center,
      )));
      setState(() {
        loginLoading = false;
      });
    }
  }
}

class CustomInputField extends StatefulWidget {
  const CustomInputField(
      {Key? key,
      required this.textFieldController,
      required this.icon,
      required this.hintText,
      required this.size,
      this.obscureText = false,
      this.currentFocusNode,
      this.nextFocusNode})
      : super(key: key);

  final TextEditingController textFieldController;
  final IconData icon;
  final String hintText;
  final bool obscureText;
  final Size size;
  final FocusNode? nextFocusNode;
  final FocusNode? currentFocusNode;

  @override
  State<CustomInputField> createState() => _CustomInputFieldState();
}

class _CustomInputFieldState extends State<CustomInputField> {
  bool hasInput = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: widget.size.height * 0.07,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(90.0),
          border: Border.all(color: Colors.white, width: 3)),
      margin: EdgeInsets.symmetric(horizontal: widget.size.width * 0.1),
      padding: const EdgeInsets.all(5.0),
      child: TextFormField(
        key: ValueKey(widget.hintText),
        onFieldSubmitted: (_) =>
            FocusScope.of(context).requestFocus(widget.nextFocusNode),
        focusNode: widget.currentFocusNode,
        onChanged: (value) {
          if (value.isNotEmpty) {
            setState(() {
              hasInput = true;
            });
          } else {
            setState(() {
              hasInput = false;
            });
          }
        },
        style: const TextStyle(color: Colors.white),
        obscureText: widget.obscureText,
        decoration: InputDecoration(
            prefixIcon: Icon(
              widget.icon,
              color: Colors.white,
            ),
            suffixIcon: hasInput == true
                ? IconButton(
                    onPressed: () {
                      widget.textFieldController.clear();
                      setState(() {
                        hasInput = false;
                      });
                    },
                    icon: const Icon(
                      Icons.clear,
                      color: Colors.white,
                    ),
                  )
                : null,
            border: InputBorder.none,
            hintText: widget.hintText,
            hintStyle: const TextStyle(
              color: Colors.white,
            )),
        controller: widget.textFieldController,
      ),
    );
  }
}

class RPSCustomPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    Paint paint0 = Paint()
      ..color = const Color.fromARGB(255, 33, 150, 243)
      ..style = PaintingStyle.fill
      ..strokeWidth = 1;
    paint0.shader = ui.Gradient.linear(
        Offset(size.width * 0.50, 0),
        Offset(size.width * 0.50, size.height * 1.12),
        [const Color(0xff42a5f5), const Color(0xffb3e5fc)],
        [0.00, 1.00]);

    Path path0 = Path();
    path0.moveTo(0, 0);
    path0.quadraticBezierTo(
        0, size.height * 0.7467666, 0, size.height * 0.9956888);
    path0.cubicTo(
        size.width * 0.4994333,
        size.height * 0.7799490,
        size.width * 0.5713333,
        size.height * 1.1220918,
        size.width,
        size.height * 0.9398214);
    path0.quadraticBezierTo(size.width, size.height * 0.7048661, size.width, 0);
    path0.lineTo(0, 0);
    path0.close();

    canvas.drawPath(path0, paint0);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
