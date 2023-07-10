import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

import '../../common/button/button_widget.dart';
import '../../common/constanst.dart';
import '../../common/text/medium.dart';
import '../../common/text/semi_bold.dart';
import '../../common/utils/util_widget.dart';
import '../otp/otp_page.dart';

class AuthenticationPage extends StatefulWidget {
  const AuthenticationPage({Key? key}) : super(key: key);

  @override
  State<AuthenticationPage> createState() => _AuthenticationPageState();

  static String verify = "";
  static String phone = "";
}

class _AuthenticationPageState extends State<AuthenticationPage> {
  final mobileNumber = TextEditingController();

  @override
  void dispose() {
    mobileNumber.dispose();
    super.dispose();
  }

   submit() async {
    if (mobileNumber.text == "") return;
    RegExp regex = RegExp(r'(84|0[3|5|7|8|9])+([0-9]{8})\b');



    if (regex.hasMatch(mobileNumber.text)) {
      Navigator.push(context, MaterialPageRoute(builder: (context) =>  const OtpPage()));
      /*
      Utils(context).startLoading();
      //set phone value
      AuthenticationPage.phone = mobileNumber.text;

      await FirebaseAuth.instance.verifyPhoneNumber(
        phoneNumber: '+84 ${mobileNumber.text.substring(1)}',
        verificationCompleted: (PhoneAuthCredential credential) {
          Utils(context).showSuccessSnackBar('Thành công');
        },
        verificationFailed: (FirebaseAuthException e) {
          Utils(context).stopLoading();
          Utils(context).showErrorSnackBar('Xác thực thất bại: $e');
        },
        codeSent: (String verificationId, int? resendToken) {
          AuthenticationPage.verify = verificationId;

          Utils(context).stopLoading();
          Navigator.push(context, MaterialPageRoute(builder: (context) =>  const OtpPage()),
          );
        },

        codeAutoRetrievalTimeout: (String verificationId) {},
      );
      */
    } else {
      Utils(context).showErrorSnackBar('Số điện thoại không hợp lệ');
    }



  }

  @override
  Widget build(BuildContext context) {


    return Scaffold(
      body: ListView(
        children: [
          const SizedBox(
            height: 20,
          ),
          Lottie.asset('assets/json/register/data.json', reverse: true),
          const SizedBox(
            height: 20,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30),
            child: SizedBox(
              height: MediaQuery.of(context).size.height - 500,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                   const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children:  [
                      SemiBoldText(
                          text: 'Nhập số điện thoại để tiếp tục ',
                          color: Colors.black,
                          align: TextAlign.left,
                          fontSize: 20,
                          maxLine: 2),
                      SizedBox(height: 2,),
                      MediumText(
                          text: 'Nếu số điện thoại của bạn không có trong hệ thống,\n chúng tôi sẽ ghi nhận tài khoản mới cho bạn.',
                          color: Colors.blueGrey,
                          maxLine: 2,
                          fontSize: 12),
                    ],
                  ),
                   TextField(
                    controller: mobileNumber,
                     autofocus: true,
                    keyboardType: TextInputType.phone,
                    decoration: const InputDecoration(
                      hintText: 'Nhập số điện thoại',
                      hintStyle: TextStyle(color: AppColor.navy,fontWeight: FontWeight.w600, ),
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: AppColor.orange),
                      ),
                    ),
                   ),
                  const SizedBox(height: 40,),
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: SizedBox(
                        width: double.infinity,
                        child: MyButton(
                          text: 'Tiếp tục',
                          textColor: AppColor.navyPale,
                          backgroundColor: AppColor.navy,
                          function: submit,
                        )),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
