import 'package:flutter/material.dart';

class LoginScreenLower extends StatelessWidget {
  const LoginScreenLower({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
        height: size.height * 0.3,
        margin: EdgeInsets.symmetric(horizontal: size.width * 0.05),
        child:
            Column(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
          Row(
            children: [
              const Expanded(
                  child: Divider(
                color: Color(0xff0091ea),
                thickness: 5,
              )),
              Container(
                  margin: EdgeInsets.symmetric(horizontal: size.width * 0.05),
                  child: const Text("OR")),
              const Expanded(
                child: Divider(
                  thickness: 5,
                  color: Color(0xff0091ea),
                ),
              )
            ],
          ),
          const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              LoginWithOtherPlatform(
                imagePath: "assets/images/login_platform_logo/google_logo.png",
                platform: "Google",
              ),
              LoginWithOtherPlatform(
                imagePath: "assets/images/login_platform_logo/apple_logo.png",
                platform: "Apple",
              ),
              LoginWithOtherPlatform(
                imagePath:
                    "assets/images/login_platform_logo/facebook_logo.png",
                platform: "Facebook",
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text("Do not have an account?"),
              TextButton(
                  onPressed: () {
                    Navigator.of(context).pushNamed("register");
                  },
                  child: const Text("Register"))
            ],
          )
        ]));
  }
}

class LoginWithOtherPlatform extends StatelessWidget {
  const LoginWithOtherPlatform({
    required this.imagePath,
    required this.platform,
    Key? key,
  }) : super(key: key);

  final String imagePath;
  final String platform;

  @override
  Widget build(BuildContext context) {
    return TextButton(
        onPressed: () {},
        child: Column(
          children: [
            SizedBox(
                height: 40,
                child: AspectRatio(
                    aspectRatio: 16 / 9, child: Image.asset(imagePath))),
            const SizedBox(height: 10),
            Text(platform),
          ],
        ));
  }
}
