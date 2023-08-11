import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:parkz_keeper_app/common/button/button_widget.dart';
import 'package:parkz_keeper_app/network/api.dart';

import '../../../common/constanst.dart';
import '../../../common/text/medium.dart';
import '../../authentication/authentication_page.dart';

class PasswordForm extends StatefulWidget {
  @override
  _PasswordFormState createState() => _PasswordFormState();
}

class _PasswordFormState extends State<PasswordForm> {
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
  TextEditingController();

  bool isPasswordValid(String password) {
    // Password must contain at least 8 characters, both upper and lower case letters, and at least 1 special character
    final RegExp passwordPattern = RegExp(
      r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$',
    );
    return passwordPattern.hasMatch(password);
  }


  void showSucess(BuildContext context)  {
    AwesomeDialog(
      context: context,
      dialogType: DialogType.warning,
      animType: AnimType.bottomSlide,
      title: 'Đăng xuất',
      desc: 'Bạn có chắc chắn muốn đăng xuất?',
      btnCancelOnPress: () {},
      btnOkOnPress: () {
        storage.delete(key: 'token');
        storage.delete(key: 'userID');
        storage.delete(key: 'parkingId');
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const AuthenticationPage()),);
      },
    ).show();
  }

  bool passwordsMatch() {
    return passwordController.text == confirmPasswordController.text;
  }

  bool formIsValid = false;

  @override
  void dispose() {
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const MediumText(text: 'Mật khẩu ít nhất 8 ký tự, \n gồm ký tự hoa, thường và đặc biệt', fontSize: 12, color: AppColor.forText, maxLine: 5, align: TextAlign.center),
        const SizedBox(height: 8,),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: TextFormField(
            controller: passwordController,
            obscureText: true,
            decoration: InputDecoration(
              border: const OutlineInputBorder(),
              labelText: 'Nhập mật khẩu',
              errorText: formIsValid &&
                  !isPasswordValid(passwordController.text)
                  ? 'Mật khẩu không hợp lệ'
                  : null,
              focusedErrorBorder: const OutlineInputBorder(
                borderSide: BorderSide(color: Colors.red),
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: TextFormField(
            controller: confirmPasswordController,
            obscureText: true,
            decoration: InputDecoration(
              border: const OutlineInputBorder(),
              labelText: 'Xác nhận mật khẩu',
              errorText:
              formIsValid && !passwordsMatch() ? 'Mật khẩu không khớp' : null,
              focusedErrorBorder: const OutlineInputBorder(
                borderSide: BorderSide(color: Colors.red),
              ),
            ),
          ),
        ),
        const SizedBox(height: 8,),

        MyButton(text: 'Đổi mật khẩu',
            function: () async {
              setState(() {
                formIsValid = true; // Enable form validation on button click
              });
              if (isPasswordValid(passwordController.text) && passwordsMatch()) {
                // Perform form submission or any other action here
                String isSuccess = await changePassword(AuthenticationPage.email, passwordController.text);
                if(isSuccess == 'true'){
                  AwesomeDialog(
                    context: context,
                    dialogType: DialogType.success,
                    animType: AnimType.bottomSlide,
                    title: 'Đổi mật khẩu thành công',
                    desc: 'Đã cập nhật mật khẩu mới',
                    btnOkOnPress: () {},
                  ).show();
                }else{
                  AwesomeDialog(
                    context: context,
                    dialogType: DialogType.error,
                    animType: AnimType.bottomSlide,
                    title: 'Đổi mật khẩu thất bại',
                    desc: isSuccess,
                    btnOkOnPress: () {},
                  ).show();

                }
              }

            }, textColor: Colors.white, backgroundColor: AppColor.navy)
      ],
    );
  }
}
