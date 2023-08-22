import 'package:flutter/material.dart';

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
        padding: const EdgeInsets.only(top: 30.0, bottom: 45),
        child: FutureBuilder<ProfileResponse?>(
            future: getProfile(),
            builder: (myContext, snapshot) {
              if (snapshot.hasData && snapshot.connectionState == ConnectionState.done) {
                if (snapshot.data!.data != null) {
                  ProfileData profile = snapshot.data!.data!;
                  String role = profile.roleName == 'Keeper' ? 'Nhân viên' : 'Chủ bãi xe';
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const SizedBox(
                        height: 20,
                      ),
                      SizedBox(
                        width: 120,
                        height: 120,
                        child: CircleAvatar(
                          backgroundImage: NetworkImage(profile.avatar == null ? 'https://cdn.pixabay.com/photo/2016/03/28/12/35/cat-1285634_1280.png' : profile.avatar!),
                        ),
                      ),
                      Column(
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
                      ),
                    ],
                  );
                }
              }
              return const SizedBox();
            }),
      ),
    );
  }
}
