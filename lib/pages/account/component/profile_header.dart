import 'package:flutter/material.dart';
import 'package:parkz_keeper_app/pages/account/component/profile_pic.dart';

import '../../../common/text/regular.dart';
import '../../../common/text/semi_bold.dart';
import '../../../models/profile_response.dart';
import '../../../network/api.dart';

class ProfileHeader extends StatelessWidget {
  const ProfileHeader({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: MediaQuery.of(context).size.height / 2.4,
      decoration: const BoxDecoration(
        gradient: LinearGradient(colors: [
          Color(0xFF064789),
          Color(0xFF023B72),
          Color(0xFF022F5B),
          Color(0xFF032445)
        ], begin: Alignment.topLeft, end: Alignment.bottomRight),
      ),
      child: Padding(
        padding: EdgeInsets.only(top: 30.0, bottom: 45),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SizedBox(
              height: 20,
            ),
            ProfilePic(
              isEdited: false,
            ),
            FutureBuilder<ProfileResponse?>(
                future: getProfile(context),
                builder: (myContext, snapshot) {
                  if (snapshot.hasData && snapshot.connectionState == ConnectionState.done) {
                    if (snapshot.data!.data != null) {
                      ProfileData profile = snapshot.data!.data!;
                      String role = profile.roleName == 'Keeper' ? 'Nhân viên' : 'Chủ bãi xe';
                      return Column(
                        children: [
                          SemiBoldText(
                              text: profile.name!,
                              fontSize: 20,
                              color: Colors.white),
                          const SizedBox(height: 15,),
                          RegularText(
                              text: profile.email!,
                              fontSize: 12,
                              color: Colors.white),
                          const SizedBox(height: 15,),
                          RegularText(
                              text: role,
                              fontSize: 12,
                              color: Colors.white)
                        ],
                      );
                    }
                  }
                  return const Column(
                    children: [
                      SemiBoldText(
                          text: '-------',
                          fontSize: 20,
                          color: Colors.white),
                      SizedBox(
                        height: 15,
                      ),
                      RegularText(
                          text: '-------', fontSize: 16, color: Colors.white)
                    ],
                  );
                }),
          ],
        ),
      ),
    );
  }
}
