import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:parkz_keeper_app/common/button/button_widget.dart';
import 'package:parkz_keeper_app/common/constanst.dart';
import 'package:parkz_keeper_app/common/text/medium.dart';
import 'package:parkz_keeper_app/common/text/semi_bold.dart';
import 'package:parkz_keeper_app/network/api.dart';

import '../../../models/booking_detail_response.dart';
import '../../../models/check_booking_response.dart';

class BookingInfoPopup extends StatelessWidget {
  final int bookingId;
  final User? user;
  const BookingInfoPopup({super.key, required this.bookingId, this.user});

  String moneyFormat(double number) {
    String formattedNumber = number.toStringAsFixed(0); // Convert double to string and remove decimal places
    return formattedNumber.replaceAllMapped(
      RegExp(r'(\d)(?=(\d{3})+(?!\d))'),
          (Match m) => '${m[1]} ',
    );
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<CheckBooking>(
        future: getBookingAndCheck(bookingId),
        builder: (myContext, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const SizedBox(
                height: 50,
                width: 50,
                child: Center(
                  child: CircularProgressIndicator(
              color: AppColor.navy,
            ),
                ));
          }
          if (snapshot.hasData && snapshot.connectionState == ConnectionState.done) {
            CheckBooking checkBooking = snapshot.data!;
            return Dialog(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    const SemiBoldText(text: 'Thông tin đơn', fontSize: 14, color: AppColor.navy),
                    const Divider(thickness: 1, color: AppColor.fadeText,),
                    MediumText(
                        text:
                            'Tên phương tiện: ${checkBooking.data!.booking!.vehicleInfor!.vehicleName}',
                        fontSize: 13,
                        color: AppColor.forText),
                    const SizedBox(height: 8,),
                    MediumText(
                        text:
                            'Tên biển số xe: ${checkBooking.data!.booking!.vehicleInfor!.licensePlate}',
                        fontSize: 13,
                        color: AppColor.forText),
                    const SizedBox(height: 8,),
                    MediumText(
                        text:
                            'Màu xe: ${checkBooking.data!.booking!.vehicleInfor!.color}',
                        fontSize: 13,
                        color: AppColor.forText),
                    const SizedBox(height: 8,),
                    MediumText(
                        text:
                        'Giờ vào: ${DateFormat('HH:mm').format(checkBooking.data!.booking!.checkinTime!)}',
                        fontSize: 13,
                        color: AppColor.forText),
                    const SizedBox(height: 8,),
                    MediumText(
                        text:
                        'Giờ ra: ${DateFormat('HH:mm').format(checkBooking.data!.booking!.checkoutTime!)}',
                        fontSize: 13,
                        color: AppColor.forText),
                    const SizedBox(height: 8),
                    Column(
                      children: [
                        const SemiBoldText(
                            text:
                                'Cần thanh toán:',
                            fontSize: 14,
                            color: AppColor.forText),
                        SemiBoldText(
                            text:
                            '${moneyFormat(checkBooking.data!.booking!.unPaidMoney!)} đ',
                            fontSize: 20,
                            color: AppColor.orange),
                      ],
                    ),
                    const SizedBox(height: 8),
                    SizedBox(
                      width: double.infinity,
                      child: MyButton(
                          text: 'Thanh toán tiền mặt',
                          function: ()  {
                            AwesomeDialog(
                              context: context,
                              dialogType: DialogType.info,
                              animType: AnimType.bottomSlide,
                              title: 'Xác nhận',
                              desc: 'Khách hàng đã thanh toán tiền ?',
                              btnCancelOnPress: () {},
                              btnOkOnPress: () async {
                                String isSuccess = await checkoutBooking(
                                  bookingId,
                                  checkBooking.data!.parkingId!,
                                  'thanh_toan_tien_mat',
                                  null
                                );
                                if (isSuccess == 'true') {
                                  AwesomeDialog(
                                    context: context,
                                    dialogType: DialogType.success,
                                    animType: AnimType.bottomSlide,
                                    title: 'Thành công',
                                    desc: 'Khách hàng đã thanh toán thành công',
                                    btnOkOnPress: ()  {
                                      Navigator.pop(context, true);
                                    },
                                  ).show();
                                }else{
                                  AwesomeDialog(
                                    context: context,
                                    dialogType: DialogType.success,
                                    animType: AnimType.bottomSlide,
                                    title: 'Thất bại',
                                    desc: 'Cập nhật trạng thái đơn thất bại',
                                    btnOkOnPress: ()  {
                                      Navigator.pop(context, true);
                                    },
                                  ).show();
                                }
                              },
                            ).show();

                          },
                          textColor: Colors.white,
                          backgroundColor: AppColor.navy),
                    ),
                    user != null ?
                    SizedBox(
                      width: double.infinity,
                      child: MyButton(
                          text: 'Thanh toán qua ví',
                          function: () async {
                            String isSuccess = await checkoutBooking(
                              bookingId,
                              checkBooking.data!.parkingId!,
                              'thanh_toan_online',
                              null
                            );
                            if (isSuccess == 'true') {
                              AwesomeDialog(
                                context: context,
                                dialogType: DialogType.success,
                                animType: AnimType.bottomSlide,
                                title: 'Thành công',
                                desc: 'Khách hàng đã thanh toán thành công',
                                btnOkOnPress: ()  {
                                  Navigator.pop(context, true);
                                },
                              ).show();
                            }else {
                              AwesomeDialog(
                                context: context,
                                dialogType: DialogType.error,
                                animType: AnimType.bottomSlide,
                                title: 'Thất bại',
                                desc: isSuccess,
                                btnOkOnPress: ()  {
                                },
                              ).show();
                            }
                          },
                          textColor: Colors.white,
                          backgroundColor: AppColor.forText),
                    )
                        : const SizedBox.shrink()

                  ],
                ),
              ),
            );
          }
          if (snapshot.hasError) {
            return const SizedBox(
              width: double.infinity,
              height: 310,
              child: Center(
                child: SemiBoldText(
                    text: '[E]Không lấy được thông tin đơn',
                    fontSize: 19,
                    color: AppColor.forText),
              ),
            );
          }
          return const SizedBox(
            width: double.infinity,
            height: 310,
            child: Center(
              child: SemiBoldText(
                  text: '[U]Không lấy được thông tin đơn',
                  fontSize: 19,
                  color: AppColor.forText),
            ),
          );
        });
  }
}
