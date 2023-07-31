import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

import '../../../common/constanst.dart';
import '../../../common/text/regular.dart';
import '../../../common/text/semi_bold.dart';


class EmptyBooking extends StatelessWidget {
  const EmptyBooking({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return  Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children:  [
        Lottie.asset('assets/json/empty/629-empty-box.json', ),
        const SizedBox(height: 30,),
        const SemiBoldText(text: 'Chưa có đơn đặt nào.', fontSize: 17, color: AppColor.forText),
        const SizedBox(height: 5,),
        const RegularText(text: 'Tìm bãi xe nhanh chóng và tiện lợi', fontSize: 13, color: AppColor.fadeText),
        const SizedBox(height: 50,),
      ],
    );
  }
}
