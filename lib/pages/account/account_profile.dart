import 'package:flutter/material.dart';

import '../../common/text/semi_bold.dart';

import 'component/profile_body.dart';

class AccountProfile extends StatelessWidget {
  const AccountProfile({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      extendBody: true,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        automaticallyImplyLeading: false,
        title: const SemiBoldText(
            text: 'Tài khoản', fontSize: 20, color: Colors.white),
      ),
      body: const ProfileBody(),
    );
  }
}
