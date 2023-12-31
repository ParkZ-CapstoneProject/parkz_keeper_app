import 'package:flutter/material.dart';
import 'package:parkz_keeper_app/common/text/medium.dart';

import '../../../common/constanst.dart';
class StatusTag extends StatelessWidget {
  final String status;
  const StatusTag({Key? key, required this.status}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(6),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5),
        color: status == "OverTime" ? AppColor.paleOrange : AppColor.navyPale,
      ),
      child:  MediumText(
          fontSize: 13,
          text: status == "Initial" ? 'Chờ xác nhận'
              : status == "Success" ? 'Xe sắp vào'
              : status == "Check_In" ? "Xe sắp ra"
              : status == "Check_Out" ? "Chờ thanh toán"
              : status == "OverTime" ? "Quá giờ"
              :  status == "Done" ? "Hoàn thành"
              : "Hủy đơn",
          color: status == "Initial" ? AppColor.orange
              : status == "Success" ? AppColor.orange
              : status == "Check_In" ? AppColor.forText
              : status == "OverTime" ? AppColor.forText
              : status == "Check_Out" ? AppColor.orange
              :  status == "Done" ? Colors.green
              : Colors.red
      ),
    );
  }
}
