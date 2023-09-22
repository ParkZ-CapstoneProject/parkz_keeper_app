import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:parkz_keeper_app/common/utils/util_widget.dart';
import 'package:parkz_keeper_app/pages/bookingdetail/component/booking_info_popup.dart';
import 'package:parkz_keeper_app/pages/bookinglist/booking_list_page.dart';
import 'package:parkz_keeper_app/pages/home/home_page.dart';
import 'package:parkz_keeper_app/pages/parkingmap/map_page.dart';

import '../../common/button/button_widget.dart';
import '../../common/constanst.dart';
import '../../common/text/medium.dart';
import '../../common/text/regular.dart';
import '../../common/text/semi_bold.dart';
import '../../common/utils/loading_page.dart';
import '../../models/booking_detail_response.dart';
import '../../models/check_booking_response.dart';
import '../../network/api.dart';
import '../bookinglist/component/status_tag.dart';

class BookingPage extends StatefulWidget {
  final int bookingId;
  const BookingPage({Key? key, required this.bookingId}) : super(key: key);

  @override
  State<BookingPage> createState() => _BookingPageState();
}

class _BookingPageState extends State<BookingPage> {
  String moneyFormat(double number) {
    String formattedNumber = number.toStringAsFixed(0); // Convert double to string and remove decimal places
    return formattedNumber.replaceAllMapped(
      RegExp(r'(\d)(?=(\d{3})+(?!\d))'),
      (Match m) => '${m[1]} ',
    );
  }
  Future<void> _refreshData() async {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: _refreshData,
      child: FutureBuilder<BookingDetailResponse>(
          future: getBookingDetail(widget.bookingId),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const LoadingPage();
            }
            if (snapshot.hasError) {
              return Container(
                width: double.infinity,
                height: double.infinity,
                color: Colors.white,
                child: const Center(
                  child: SemiBoldText(
                      text: '[E]Không lấy được thông tin đơn',
                      fontSize: 19,
                      color: AppColor.forText),
                ),
              );
            }
            if (snapshot.hasData && snapshot.connectionState == ConnectionState.done) {
              DetailBooking booking = snapshot.data!.data!;
              return Scaffold(
                extendBodyBehindAppBar: true,
                extendBody: true,
                appBar: AppBar(
                  automaticallyImplyLeading: true,
                  elevation: 0,
                  backgroundColor: Colors.transparent,
                  actions: [
                    IconButton(
                        onPressed: () {
                          Navigator.pushAndRemoveUntil(
                            context, MaterialPageRoute(builder: (context) => const HomePage()),
                            (route) => false,
                          );
                        },
                        icon: const Icon(
                          Icons.home,
                          color: Colors.white,
                        ))
                  ],
                  title: const SemiBoldText(
                      text: 'Chi tiết đơn đặt',
                      fontSize: 20,
                      color: Colors.white),
                ),
                bottomNavigationBar: booking.bookingDetails!.status == 'Initial' ||  booking.bookingDetails!.status == 'Success' ||  booking.bookingDetails!.status == 'Check_In' || booking.bookingDetails!.status == 'Check_Out' || booking.bookingDetails!.status == 'OverTime' ?
              BottomAppBar(
                  child: Container(
                    color: AppColor.navy,
                    padding: const EdgeInsets.only(
                        left: 10.0, right: 10.0, top: 20.0, bottom: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        booking.bookingDetails!.status == 'Initial' || booking.bookingDetails!.status == 'Success'
                            ? Expanded(
                                child: Padding(
                                padding: const EdgeInsets.only(
                                    left: 16.0, right: 16.0),
                                child: OutlinedButton(
                                    style: OutlinedButton.styleFrom(
                                      side: const BorderSide(
                                          color: AppColor.orange, width: 2),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(50.0),
                                      ),
                                    ),
                                    onPressed: () {
                                      // Vết hàm ở đây
                                      cancelBooking(widget.bookingId, context);

                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                const BookingListPage()),
                                      );
                                    },
                                    child: const SemiBoldText(
                                        text: 'Từ chối',
                                        fontSize: 13,
                                        color: Colors.white)),
                              ))
                            : const SizedBox(),
                        Expanded(
                            child: Padding(
                          padding: const EdgeInsets.only(left: 16.0, right: 16.0),
                          child: MyButton(
                              text: booking.bookingDetails!.status == 'Initial' ? 'Xác nhận đơn'
                                  : booking.bookingDetails!.status == 'Success' ? 'Check-in'
                                      : 'Check-out',
                              function: () async {
                                if (booking.bookingDetails!.status == 'Initial')  {
                                  bool isSuccess = await approveBooking(widget.bookingId, context);
                                  if(isSuccess == true){
                                    setState(() {
                                    });
                                  }
                                }
                                else if (booking.bookingDetails!.status == 'Success') {
                                  //Gọi checkin funtion
                                  debugPrint('checkin');
                                  String successMessage = await checkInBooking(widget.bookingId, context);
                                  if(successMessage == 'true'){
                                    setState(() {
                                    });
                                  }else{
                                    if(successMessage == 'Không thể check-in vào sớm. Tại vì slot vẫn đang có người đặt.'){
                                      AwesomeDialog(
                                        context: context,
                                        dialogType: DialogType.warning,
                                        animType: AnimType.bottomSlide,
                                        title: 'Khách vẫn đang ở trong bãi.',
                                        desc: 'Bạn có muốn đổi slot cho khách hàng đang checkin này?',
                                        btnOkOnPress: () async {
                                          // Navigator.of(context).pop();
                                          bool? isSuccess = await Navigator.push(context, MaterialPageRoute(builder: (context) =>  ParkingMapPage(bookingID: widget.bookingId, isEarly: true,)),);
                                          if( isSuccess == true){
                                            _refreshData();
                                            Utils(context).showSuccessSnackBar('Chuyển slot thành công');
                                          }
                                          // else{
                                          //   Utils(context).showErrorSnackBar('Chuyển slot thất bại');
                                          // }
                                        },
                                        btnCancelOnPress: () {},
                                        btnCancelText: "Hủy",
                                        btnOkText: "Đồng ý",
                                      ).show();
                                    }
                                    if(successMessage == 'Đơn đặt xảy ra lỗi. Do slot đặt có đơn khác lấn giờ.'){
                                      AwesomeDialog(
                                        context: context,
                                        dialogType: DialogType.warning,
                                        animType: AnimType.bottomSlide,
                                        title: 'Khách còn trong bãi',
                                        desc: 'Bạn có muốn đổi slot cho khách hàng đang checkin này?',
                                        btnOkOnPress: () async {
                                          // Navigator.of(context).pop();
                                          bool? isSuccess = await Navigator.push(context, MaterialPageRoute(builder: (context) =>  ParkingMapPage(bookingID: widget.bookingId, isEarly: false,)),);
                                          if( isSuccess == true){
                                            _refreshData();
                                            Utils(context).showSuccessSnackBar('Chuyển slot thành công');
                                          }
                                          // else{
                                          //   Utils(context).showErrorSnackBar('Chuyển slot thất bại');
                                          // }
                                        },
                                        btnCancelOnPress: () {},
                                        btnCancelText: "Hủy",
                                        btnOkText: "Đồng ý",
                                      ).show();
                                    }
                                    if(successMessage == 'Đơn đặt xảy ra lỗi. Do slot đang bảo trì.'){
                                      AwesomeDialog(
                                        context: context,
                                        dialogType: DialogType.warning,
                                        animType: AnimType.bottomSlide,
                                        title: 'Slot đã bảo trì',
                                        desc: 'Bạn có muốn đổi slot cho khách hàng đang checkin này?',
                                        btnOkOnPress: () async {
                                          // Navigator.of(context).pop();
                                          bool? isSuccess = await Navigator.push(context, MaterialPageRoute(builder: (context) =>  ParkingMapPage(bookingID: widget.bookingId, isEarly: false,)),);
                                          if( isSuccess == true){
                                            _refreshData();
                                            Utils(context).showSuccessSnackBar('Chuyển slot thành công');
                                          }
                                          // else{
                                          //   Utils(context).showErrorSnackBar('Chuyển slot thất bại');
                                          // }
                                        },
                                        btnCancelOnPress: () {},
                                        btnCancelText: "Hủy",
                                        btnOkText: "Đồng ý",
                                      ).show();
                                    }

                                  }
                                }

                                // CHECK OUT Ở ĐÂY
                                else if (booking.bookingDetails!.status == 'Check_In' || booking.bookingDetails!.status == 'OverTime' || booking.bookingDetails!.status == 'Check_Out'){
                                  // Checkout
                                  if(booking.transactionWithBookingDetailDtos![0].paymentMethod == 'tra_sau'){
                                    debugPrint('Check out tiền mặt');
                                    bool? isSuccess = await showDialog(
                                      context: context,
                                      builder: (BuildContext context) => BookingInfoPopup(bookingId: widget.bookingId, user: booking.user),
                                    );

                                    if(isSuccess == true){
                                      Utils(context).showSuccessSnackBar('Check out thành công');
                                      setState(() {
                                      });
                                    }
                                    //thanh toán online sau ở dây
                                  }else{
                                    CheckBooking? checkingBookingSuccess = await checkoutOnline(widget.bookingId, booking.parkingWithBookingDetailDto!.parkingId!);
                                    if(checkingBookingSuccess == null){
                                      AwesomeDialog(
                                        context: context,
                                        dialogType: DialogType.success,
                                        animType: AnimType.bottomSlide,
                                        title: 'Thành công',
                                        desc: 'Đơn đã thanh toán và ra bãi thành công',
                                        btnOkOnPress: () {
                                          _refreshData();
                                        },
                                      ).show();
                                    }else {
                                      AwesomeDialog(
                                        context: context,
                                        dialogType: DialogType.info,
                                        animType: AnimType.bottomSlide,
                                        title: 'Thông tin thêm',
                                        body: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Column(
                                            mainAxisAlignment: MainAxisAlignment.start,
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              MediumText(
                                                  text:
                                                  'Tên phương tiện: ${checkingBookingSuccess.data!.booking!.vehicleInfor!.vehicleName}',
                                                  fontSize: 13,
                                                  color: AppColor.forText),
                                              const SizedBox(height: 8,),
                                              MediumText(
                                                  text:
                                                  'Tên biển số xe: ${checkingBookingSuccess.data!.booking!.vehicleInfor!.licensePlate}',
                                                  fontSize: 13,
                                                  color: AppColor.forText),
                                              const SizedBox(height: 8,),
                                              MediumText(
                                                  text:
                                                  'Màu xe: ${checkingBookingSuccess.data!.booking!.vehicleInfor!.color}',
                                                  fontSize: 13,
                                                  color: AppColor.forText),
                                              const SizedBox(height: 8,),
                                              MediumText(
                                                  text:
                                                  'Giờ vào: ${DateFormat('HH:mm').format(checkingBookingSuccess.data!.booking!.checkinTime!)}',
                                                  fontSize: 13,
                                                  color: AppColor.forText),
                                              const SizedBox(height: 8,),
                                              MediumText(
                                                  text:
                                                  'Giờ ra: ${DateFormat('HH:mm').format(checkingBookingSuccess.data!.booking!.checkoutTime!)}',
                                                  fontSize: 13,
                                                  color: AppColor.forText),
                                              const SizedBox(height: 8),
                                              Divider(color: AppColor.navy,),
                                              SemiBoldText(text: 'Chi tiết đơn', fontSize: 15, color: AppColor.forText),
                                              const SizedBox(height: 8),
                                              Column(
                                                mainAxisAlignment: MainAxisAlignment.start,
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  for (var transaction in checkingBookingSuccess.data!.booking!.transactions!)
                                                    Row(
                                                      children: [
                                                        RegularText( text:
                                                        transaction == checkingBookingSuccess.data!.booking!.transactions!.first
                                                            ? 'Tiền đặt: '
                                                            : 'Phụ phí: ',
                                                          color: AppColor.forText,
                                                          fontSize: 12,
                                                        ),
                                                        MediumText(text: moneyFormat(transaction.price!), fontSize: 13, color: AppColor.navy),
                                                        const SizedBox(width: 6,),
                                                        Icon(transaction.status == 'Chua_thanh_toan' ? Icons.cancel : Icons.check_circle,
                                                          color: transaction.status == 'Chua_thanh_toan' ? Colors.red : Colors.green,
                                                          size: 12,)
                                                      ],
                                                    ),
                                                  const SizedBox(height: 8),
                                                ],
                                              ),
                                              Column(
                                                children: [
                                                  const SemiBoldText(
                                                      text:
                                                      'Cần thanh toán:',
                                                      fontSize: 14,
                                                      color: AppColor.forText),
                                                  SemiBoldText(
                                                      text:
                                                      '${moneyFormat(checkingBookingSuccess.data!.booking!.unPaidMoney!).trim()} đ',
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
                                                              checkingBookingSuccess.data!.booking!.bookingId!,
                                                              checkingBookingSuccess.data!.parkingId!,
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
                                                                _refreshData();
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
                                                                _refreshData();
                                                              },
                                                            ).show();
                                                          }
                                                        },
                                                      ).show();
                                                    },
                                                    textColor: Colors.white,
                                                    backgroundColor: AppColor.navy),
                                              ),
                                              SizedBox(
                                                width: double.infinity,
                                                child: MyButton(
                                                    text: 'Thanh toán qua ví',
                                                    function: () async {
                                                      String isSuccess = await checkoutBooking(
                                                          checkingBookingSuccess.data!.booking!.bookingId!,
                                                          checkingBookingSuccess.data!.parkingId!,
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
                                                            _refreshData();
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
                                                            _refreshData();
                                                          },
                                                        ).show();
                                                      }
                                                    },
                                                    textColor: Colors.white,
                                                    backgroundColor: AppColor.forText),
                                              )
                                            ],
                                          ),
                                        ),
                                      ).show();
                                    }

                                  }
                                }

                              },
                              textColor: Colors.white,
                              backgroundColor: AppColor.orange),
                        ))
                      ],
                    ),
                  ),
                ) : const SizedBox(),
                body: Container(
                  height: double.infinity,
                  padding:  EdgeInsets.only(left: 24, right: 24, top: 20, bottom: booking.bookingDetails!.status == 'Done' || booking.bookingDetails!.status == 'Cancel' ? 0 : 50),
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(colors: [
                      Color(0xFF064789),
                      Color(0xFF023B72),
                      Color(0xFF022F5B),
                      Color(0xFF032445)
                    ], begin: Alignment.topLeft, end: Alignment.bottomRight),
                  ),
                  child: ListView(
                    children: [
                      SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Container(
                              padding: const EdgeInsets.only(left: 30, right: 30, top: 20, bottom: 20),
                              height: 200,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20),
                                  color: Colors.white),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  booking.user != null ?
                                  Column(
                                    children: [
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          const MediumText(
                                              text: 'Tên',
                                              fontSize: 14,
                                              color: AppColor.forText),
                                          SemiBoldText(
                                              text: booking.user!.name!,
                                              fontSize: 14,
                                              color: AppColor.forText)
                                        ],
                                      ),
                                      SizedBox(height: booking.bookingDetails!.guestPhone != null ? 10 : 30,),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          const MediumText(
                                              text: 'Số điện thoại',
                                              fontSize: 14,
                                              color: AppColor.forText),
                                          SemiBoldText(
                                              text: booking.user!.phone!,
                                              fontSize: 14,
                                              color: AppColor.forText)
                                        ],
                                      ),
                                    ],
                                  )
                                  : const SemiBoldText(text: 'Khách vãng lai', fontSize: 20, color: AppColor.navy),

                                  booking.bookingDetails!.guestPhone != null
                                      ? Column(
                                          children: [
                                            const Divider(
                                              thickness: 1,
                                              color: AppColor.fadeText,
                                            ),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.spaceBetween,
                                              children: [
                                                const MediumText(
                                                    text: 'Số người đặt hộ',
                                                    fontSize: 14,
                                                    color: AppColor.forText),
                                                SemiBoldText(
                                                    text: booking
                                                        .bookingDetails!.guestPhone!.trim(),
                                                    fontSize: 14,
                                                    color: AppColor.forText)
                                              ],
                                            ),
                                            const SizedBox(
                                              height: 8,
                                            ),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.spaceBetween,
                                              children: [
                                                const MediumText(
                                                    text: 'Tên người đặt hộ',
                                                    fontSize: 14,
                                                    color: AppColor.forText),
                                                SemiBoldText(
                                                    text: booking
                                                        .bookingDetails!.guestName!,
                                                    fontSize: 14,
                                                    color: AppColor.forText)
                                              ],
                                            ),
                                          ],
                                        )
                                      : const SizedBox.shrink(),

                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      const MediumText(
                                          text: 'Biển số xe',
                                          fontSize: 14,
                                          color: AppColor.forText),
                                      SemiBoldText(
                                          text: booking.vehicleInfor!.licensePlate!,
                                          fontSize: 14,
                                          color: AppColor.forText)
                                    ],
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      const MediumText(
                                          text: 'Hãng xe',
                                          fontSize: 14,
                                          color: AppColor.forText),
                                      SemiBoldText(
                                          text: booking.vehicleInfor!.vehicleName!,
                                          fontSize: 14,
                                          color: AppColor.forText)
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 14,),
                            Container(
                              padding: const EdgeInsets.only(
                                  left: 30, right: 30, top: 20, bottom: 20),
                              height: 250,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20),
                                  color: Colors.white),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  InkWell(
                                    onTap: () {
                                      showDialog(
                                        context: context,
                                        builder: (BuildContext context) {
                                          return AlertDialog(
                                            title: const Text('Địa chỉ'),
                                            content: Text(booking
                                                .parkingWithBookingDetailDto!
                                                .address!),
                                            actions: [
                                              TextButton(
                                                onPressed: () {
                                                  Navigator.of(context).pop();
                                                },
                                                child: const Text('Đóng'),
                                              ),
                                            ],
                                          );
                                        },
                                      );
                                    },
                                    child: Row(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        const MediumText(
                                            text: 'Địa chỉ',
                                            fontSize: 14,
                                            color: AppColor.forText),
                                        Flexible(
                                          child: Padding(
                                            padding:
                                                const EdgeInsets.only(left: 50.0),
                                            child: SemiBoldText(
                                                text: booking
                                                    .parkingWithBookingDetailDto!
                                                    .address!
                                                    .trim(),
                                                maxLine: 1,
                                                align: TextAlign.right,
                                                fontSize: 14,
                                                color: AppColor.forText),
                                          ),
                                        ),
                                        const Icon(
                                          Icons.remove_red_eye_rounded,
                                          color: AppColor.orange,
                                          size: 20,
                                        )
                                      ],
                                    ),
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      const MediumText(
                                          text: 'Vị trí',
                                          fontSize: 14,
                                          color: AppColor.forText),
                                      SemiBoldText(
                                          text:
                                              '${booking.floorWithBookingDetailDto!.floorName!} - ${booking.parkingSlotWithBookingDetailDto!.name!.trim()}',
                                          fontSize: 14,
                                          color: AppColor.forText)
                                    ],
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      const MediumText(
                                          text: 'Bãi xe',
                                          fontSize: 14,
                                          color: AppColor.forText),
                                      SemiBoldText(
                                          text: booking
                                              .parkingWithBookingDetailDto!.name!,
                                          fontSize: 14,
                                          color: AppColor.forText)
                                    ],
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      const MediumText(
                                          text: 'Ngày đặt',
                                          fontSize: 14,
                                          color: AppColor.forText),
                                      SemiBoldText(
                                          text:
                                          DateFormat('dd/MM/yyyy').format(booking.bookingDetails!.startTime!),
                                          fontSize: 14,
                                          color: AppColor.forText)
                                    ],
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      const MediumText(
                                          text: 'Giờ đặt',
                                          fontSize: 14,
                                          color: AppColor.forText),
                                      SemiBoldText(
                                          text:
                                          '${DateFormat('HH:mm').format(booking.bookingDetails!.startTime!)} - ${DateFormat('HH:mm').format(booking.bookingDetails!.endTime!)}',
                                          fontSize: 14,
                                          color: AppColor.forText)
                                    ],
                                  ),
                                   Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      const MediumText(
                                          text: 'Thời gian vào bãi',
                                          fontSize: 14,
                                          color: AppColor.forText),
                                      SemiBoldText(
                                          text: booking.bookingDetails!.checkinTime == null ? '-----' : DateFormat('HH:mm').format(booking.bookingDetails!.checkinTime!),
                                          fontSize: 14,
                                          color: AppColor.forText)
                                    ],
                                  ),
                                   Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      const MediumText(
                                          text: 'Thời gian ra bãi',
                                          fontSize: 14,
                                          color: AppColor.forText),
                                      SemiBoldText(
                                          text: booking.bookingDetails!.checkoutTime == null ? '-----' : DateFormat('HH:mm').format(booking.bookingDetails!.checkoutTime!),
                                          fontSize: 14,
                                          color: AppColor.forText)
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(
                              height: 14,
                            ),
                            Container(
                              padding: const EdgeInsets.only(
                                  left: 30, right: 30, top: 20, bottom: 20),
                              height: 160,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20),
                                  color: Colors.white),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      const MediumText(
                                          text: 'Trạng thái',
                                          fontSize: 14,
                                          color: AppColor.forText),
                                      StatusTag(
                                        status: booking.bookingDetails!.status!,
                                      ),
                                    ],
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      const MediumText(
                                          text: 'Mã đơn',
                                          fontSize: 14,
                                          color: AppColor.forText),
                                      Row(
                                        children: [
                                          SemiBoldText(
                                              text: booking.bookingDetails!.bookingId
                                                  .toString(),
                                              fontSize: 14,
                                              color: AppColor.forText),
                                          const SizedBox(
                                            width: 2,
                                          ),
                                          InkWell(
                                            onTap: () {
                                              Clipboard.setData(ClipboardData(
                                                  text: booking
                                                      .bookingDetails!.bookingId
                                                      .toString()));
                                            },
                                            child: const Icon(Icons.content_copy,
                                                color: AppColor.orange, size: 20),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      const MediumText(
                                          text: 'Phương thức',
                                          fontSize: 14,
                                          color: AppColor.forText),
                                      SemiBoldText(
                                          text: booking
                                              .transactionWithBookingDetailDtos![0]
                                              .paymentMethod
                                              .toString(),
                                          fontSize: 14,
                                          color: AppColor.forText)
                                    ],
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      const MediumText(
                                          text: 'Tổng cộng',
                                          fontSize: 14,
                                          color: AppColor.forText),
                                      SemiBoldText(
                                          text:
                                              '${moneyFormat(booking.bookingDetails!.totalPrice!)} Đ',
                                          fontSize: 25,
                                          color: AppColor.forText)
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(
                              height: 14,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }

            return Container(
              width: double.infinity,
              height: double.infinity,
              color: Colors.white,
              child: const Center(
                child: SemiBoldText(
                    text: '[U]Không lấy được thông tin đơn',
                    fontSize: 19,
                    color: AppColor.forText),
              ),
            );
          }),
    );
  }
}
