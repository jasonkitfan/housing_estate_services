import 'package:flutter/material.dart';

import '../custom_widget/login_screen_upper_part.dart';
import '../custom_widget/login_screen_lower_part.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [LoginScreenUpper(), LoginScreenLower()],
        ),
      ),
    );
  }
}
