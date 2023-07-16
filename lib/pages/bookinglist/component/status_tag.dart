import 'package:flutter/material.dart';

import '../../../common/constanst.dart';
import '../../../common/text/regular.dart';


class StatusTag extends StatelessWidget {
  const StatusTag({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(6),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5),
        color: AppColor.navyPale,
      ),
      child: const RegularText(text: 'Thành công', fontSize: 13, color: Colors.green),
    );
  }
}
