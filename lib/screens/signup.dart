import 'package:data_flow_manager/provider/theme_Provider.dart';
import 'package:data_flow_manager/screens/signin.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';


class SignUp extends StatelessWidget {
  SignUp({super.key});

  final TextEditingController fullNameController = TextEditingController();
  final TextEditingController phoneNumberController = TextEditingController();
  final TextEditingController mailIDController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Builder(
        builder: (BuildContext context) {
          return SingleChildScrollView(
            child: Column(
              children: [
                Stack(
                  children: [
                    CustomPaint(
                      size: Size(MediaQuery.of(context).size.width, 200),
                      painter: HeaderCurvedContainer(),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 170.0),
                      child: Center(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Container(
                            height: 450,
                            width: 370,
                            padding:
                                const EdgeInsets.symmetric(horizontal: 16.0),
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.black),
                              borderRadius: BorderRadius.circular(10),
                              color: Colors.black38.withOpacity(0.12),
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(
                                      top: 5.0, bottom: 5),
                                  child: Text(
                                    "CREATE ACCOUNT",
                                    style: TextStyle(
                                      color: context
                                              .watch<ThemeProvider>()
                                              .isDarkMode
                                          ? Colors.grey
                                          : Colors.black,
                                      fontWeight: FontWeight.bold,
                                      fontFamily: GoogleFonts.lora().fontFamily,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                                buildTextField(
                                    context, fullNameController, "Full Name"),
                                buildTextField(context, phoneNumberController,
                                    "Phone Number"),
                                buildTextField(
                                    context, mailIDController, "Mail ID"),
                                buildTextField(
                                    context, passwordController, "Password",
                                    obscureText: true),
                                InkWell(
                                  onTap: () async {
                                    SharedPreferences prefs =
                                        await SharedPreferences.getInstance();
                                    await prefs.setString(
                                        'email', mailIDController.text);
                                    await prefs.setString(
                                        'password', passwordController.text);


                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                          content: Text('Sign Up Successful!')),
                                    );

                                    Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => SignIn(),), (route) => false);


                                  },
                                  child: Card(
                                    elevation: 8,
                                    child: Container(
                                      alignment: Alignment.center,
                                      height: 38,
                                      width: 106,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(5),
                                        boxShadow: const [
                                          BoxShadow(
                                              offset: Offset(2, 2),
                                              blurRadius: 3,
                                              color: Colors.grey)
                                        ],
                                        color: Colors.black38,
                                      ),
                                      child: const Text(
                                        "SIGN UP",
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 12),
                                InkWell(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => SignIn()),
                                    );
                                  },
                                  child: const Text(
                                    "I already have an account",
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 13),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget buildTextField(
      BuildContext context, TextEditingController controller, String hintText,
      {bool obscureText = false}) {
    return Card(
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          hintText: hintText,
          filled: true,
          isDense: true,
          fillColor: Colors.white,
          enabledBorder: const OutlineInputBorder(borderSide: BorderSide.none),
          focusedBorder: const OutlineInputBorder(borderSide: BorderSide.none),
        ),
        obscureText: obscureText,
      ),
    );
  }
}

class HeaderCurvedContainer extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()..color = Colors.black38;
    Path path = Path()
      ..relativeLineTo(0, 120)
      ..quadraticBezierTo(size.width / 2, 200.0, size.width, 120)
      ..relativeLineTo(0, -120)
      ..close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
