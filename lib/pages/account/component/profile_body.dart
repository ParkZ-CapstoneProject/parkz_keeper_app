import 'package:flutter/material.dart';
import 'package:parkz_keeper_app/pages/account/component/profile_header.dart';
import 'package:parkz_keeper_app/pages/account/component/profile_menu.dart';


class ProfileBody extends StatelessWidget {
  const ProfileBody({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return  const SingleChildScrollView(
      child: Column(
        children: [
          SizedBox(height: 18,),
          ProfileHeader(),
          ProfileMenu(iconData: Icons.person, textData: 'Thông tin cá nhân'),
          Divider(height: 8,),
          ProfileMenu(iconData: Icons.support_agent, textData: 'Hỗ trợ'),
          Divider(height: 8,),
          ProfileMenu(iconData: Icons.login_outlined, textData: 'Đăng xuất'),
        ],
      ),
    );
  }
}