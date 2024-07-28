import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';

class Intro extends StatefulWidget {
  const Intro({super.key});

  @override
  State<Intro> createState() => _IntroState();
}

class _IntroState extends State<Intro> {

  @override
  void initState() {
    Future.delayed(
      const Duration(seconds: 5),
      () => context.goNamed("web"),
    );
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    
    return Scaffold(
      body: SizedBox(
        width: double.maxFinite,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Spacer(),
            const Text(
              "Find NEB notes and Questions on",
              style: TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: 8,
              ),
            ),
            SizedBox(height: 2),
            Image.asset("assets/app_logo.png"),
            const SizedBox(
              height: 10,
            ),
            const Text(
              "Empowering Education with AI",
              style: TextStyle(
                fontWeight: FontWeight.w500,
              ),
            ),
            const Spacer(),
            const SizedBox.square(
                dimension: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 3,
                )),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  "assets/tech_hanger_logo.png",
                  height: 50,
                ),
                const SizedBox(
                  width: 0,
                ),
                RichText(
                  text: const TextSpan(
                    style: TextStyle(
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                    ),
                    children: [
                      TextSpan(
                          text: " Tech ",
                          style: TextStyle(color: Colors.black)),
                      TextSpan(
                          text: "Hanger",
                          style: TextStyle(
                            color: Colors.purple,
                          )),
                    ],
                  ),
                ),
              ],
            ),
            const Text(
              "Developed By Tech Hanger Team",
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            const Text(
              "www.techhanger.shikshahive.com",
              style: TextStyle(fontWeight: FontWeight.w500, fontSize: 12),
            ),
           const SizedBox(
              height: 20,
            )
          ],
        ),
      ),
    );
  }
}
