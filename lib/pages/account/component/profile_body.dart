import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:parkz_keeper_app/pages/account/component/password_form.dart';
import 'package:parkz_keeper_app/pages/account/component/profile_header.dart';

import 'package:parkz_keeper_app/pages/account/component/profile_menu.dart';
import 'package:parkz_keeper_app/pages/authentication/authentication_page.dart';

import '../../../network/api.dart';
import '../../personalinformation/personal_information_page.dart';


class ProfileBody extends StatelessWidget {
  const ProfileBody({Key? key}) : super(key: key);

  void logout(BuildContext context)  {
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

  void changeUserPassword(BuildContext context){
    AwesomeDialog(
      context: context,
      dialogType: DialogType.info,
      animType: AnimType.bottomSlide,
      title: 'Nhập mật khẩu',
      desc: 'Mật khẩu ít nhất 8 ký tự, gồm ký tự hoa, thường và đặc biệt',
      body:  PasswordForm(),
    ).show();
  }

  @override
  Widget build(BuildContext context) {
    return  SingleChildScrollView(
      child: Column(
        children: [
          const SizedBox(
            height: 18,
          ),
          const ProfileHeader(),
          const ProfileMenu(iconData: Icons.person, textData: 'Thông tin cá nhân', page: PersonalInformationPage()),
          const Divider(
            height: 8,
          ),
          GestureDetector(child: const ProfileMenu(iconData: Icons.lock, textData: 'Đổi mật khẩu'), onTap: () {changeUserPassword(context);},),
          const Divider(
            height: 8,
          ),
          const ProfileMenu(iconData: Icons.support_agent, textData: 'Hỗ trợ'),
          const Divider(
            height: 8,
          ),
          GestureDetector(child: const ProfileMenu(iconData: Icons.login_outlined, textData: 'Đăng xuất',), onTap: (){logout(context);}),
        ],
      ),
    );
  }
}
