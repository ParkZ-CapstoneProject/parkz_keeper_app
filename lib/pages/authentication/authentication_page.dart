import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:parkz_keeper_app/common/button/button_widget.dart';
import 'package:parkz_keeper_app/common/constanst.dart';
import 'package:parkz_keeper_app/models/login_response.dart';
import 'package:parkz_keeper_app/network/api.dart';

import '../../common/text/semi_bold.dart';
import '../home/home_page.dart';

class AuthenticationPage extends StatefulWidget {
  const AuthenticationPage({Key? key}) : super(key: key);

  @override
  State<AuthenticationPage> createState() => _AuthenticationPageState();
  static String email = "";
}

class _AuthenticationPageState extends State<AuthenticationPage> {
  bool _obscureText = true;
  final emailController = TextEditingController();
  final passwordController = TextEditingController();


  Future<void> submitLogin(context) async {
    String email = emailController.text;
    String password = passwordController.text;
    LoginResponse loginSuccess = await login(email, password, context);

    if (loginSuccess.data!.token != null) {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const HomePage()),
        (route) => false,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              SizedBox(
                height: 370,
                child: Stack(
                  children: <Widget>[
                    Positioned(
                        top: -20,
                        height: 400,
                        width: width,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: SvgPicture.asset(
                              'assets/image/login_illustrations.svg'),
                        )),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 40),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    const SemiBoldText(
                        text: 'Đăng nhập', fontSize: 30, color: Colors.black),
                    const SizedBox(
                      height: 30,
                    ),
                    Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Colors.white,
                          boxShadow: const [
                            BoxShadow(
                              color: Colors.grey,
                              blurRadius: 20,
                              offset: Offset(0, 10),
                            )
                          ]),
                      child: Column(
                        children: <Widget>[
                          Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                                border: Border(
                                    bottom: BorderSide(
                                        color: Colors.grey.shade200))),
                            child: TextField(
                              controller: emailController,
                              decoration: const InputDecoration(
                                  border: InputBorder.none,
                                  hintText: "Email",
                                  hintStyle: TextStyle(color: Colors.grey)),
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.all(10),
                            child: TextField(
                              controller: passwordController,
                              obscureText: _obscureText,
                              decoration:  InputDecoration(
                                  border: InputBorder.none,
                                  hintText: "Mật khẩu",
                                  hintStyle: const TextStyle(color: Colors.grey),
                                suffixIcon: IconButton(
                                  icon: Icon(_obscureText ? Icons.visibility : Icons.visibility_off),
                                  onPressed: () {
                                    setState(() {
                                      _obscureText = !_obscureText; // Toggle the obscureText state
                                    });
                                  },
                                ),
                              ),

                            ),
                          )
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    const Center(
                        child: Text(
                      "Quên mật khẩu ?",
                      style: TextStyle(color: AppColor.navy),
                    )),
                    const SizedBox(
                      height: 30,
                    ),
                    Container(
                      height: 50,
                      margin: const EdgeInsets.symmetric(horizontal: 60),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(50),
                        color: AppColor.navy,
                      ),
                      child: Center(
                        child: MyButton(
                            text: 'Đăng nhập',
                            function: () {
                              submitLogin(context);
                            },
                            textColor: Colors.white,
                            backgroundColor: AppColor.navy),
                      ),
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
