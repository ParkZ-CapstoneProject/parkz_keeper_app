import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../common/button/button_widget.dart';
import '../../common/constanst.dart';
import '../../common/text/regular.dart';
import '../../common/text/semi_bold.dart';
import '../../common/utils/util_widget.dart';
import '../../models/floors_response.dart';
import '../../models/slots_response.dart';
import '../../network/api.dart';
import '../bookingdetail/booking_detail_page.dart';
import 'component/booking_slot_loading.dart';
import 'component/slot.dart';
import 'package:table_calendar/table_calendar.dart';


class ParkingMapPage extends StatefulWidget {
  final int? bookingID;
  final bool? isEarly;

  const ParkingMapPage({
    Key? key, this.bookingID, this.isEarly,
  }) : super(key: key);

  @override
  State<ParkingMapPage> createState() => _ParkingMapPageState();
  static String floorNameGlobal = '';
  static String slotNameGlobal = '';
}


class _ParkingMapPageState extends State<ParkingMapPage> {
  final ScrollController _horizontalScrollController = ScrollController();
  final ScrollController _verticalScrollController = ScrollController();

  TextEditingController startTimeController = TextEditingController();
  TextEditingController endTimeBookController = TextEditingController();
  TextEditingController durationController = TextEditingController();

  TextEditingController guessNameController = TextEditingController();
  TextEditingController guessPhoneController = TextEditingController();
  TextEditingController licensePlateController = TextEditingController();
  TextEditingController vehicleNameController = TextEditingController();
  TextEditingController colorController = TextEditingController();

  FocusNode durationNode = FocusNode();

  final DateTime currentDate = DateTime.now();

  late List<Floor> floors = [];
  late Floor selectedFloor= Floor();
  late ParkingSlot slotSelected = ParkingSlot();


  late List<ParkingSlot> slots = [];

  late DateTime startTime =  DateTime(currentDate.year, currentDate.month, currentDate.day, currentDate.hour, 0, 0);
  late DateTime endTime = startTime.add(const Duration(hours: 2));
  late DateTime endTimeBook = endTime;

  void _showGuessBookingDialog(startTimeValue,BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        startTimeController.text = DateFormat('HH:mm dd/MM/yyyy').format(startTime);

        return Dialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.0),
            ),
            // insetPadding: const EdgeInsets.all(16),
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10.0),
              ),
              child: ListView(
                shrinkWrap: true,
                children: [
                  TextField(
                    enabled: false,
                    controller: startTimeController,
                    readOnly: true,
                    decoration: const InputDecoration(
                      labelText: 'Giờ vào *',
                      border: OutlineInputBorder(
                        borderSide: BorderSide(color: AppColor.navy, width: 2),
                      ),
                    ),
                    style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        color: AppColor.navy,
                        fontSize: 16
                    ),
                  ),
                  const SizedBox(height: 8),
                  TextField(
                    enabled: false,
                    controller: endTimeBookController,
                    decoration: const InputDecoration(
                      labelText: 'Giờ ra *',
                      labelStyle: TextStyle(
                          fontSize: 15,
                          color: AppColor.navy
                      ),
                      border: OutlineInputBorder(
                        borderSide: BorderSide(color: AppColor.navy, width: 2),
                      ),
                    ),
                    style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        color: AppColor.navy,
                        fontSize: 16
                    ),
                  ),
                  const SizedBox(height: 8),
                  TextField(
                    keyboardType: TextInputType.number,
                    controller: durationController,
                    focusNode: durationNode,
                    decoration: const InputDecoration(
                      labelText: 'Thời hạn trong bãi *',
                      border: OutlineInputBorder(
                        borderSide: BorderSide(color: AppColor.navy, width: 2),
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  TextField(
                    controller: guessNameController,
                    decoration: const InputDecoration(
                      labelText: 'Tên khách',
                      border: OutlineInputBorder(
                        borderSide: BorderSide(color: AppColor.navy, width: 2),
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  TextField(
                    controller: guessPhoneController,
                    keyboardType: TextInputType.phone,
                    decoration: const InputDecoration(
                      labelText: 'Số điện thoại',
                      border: OutlineInputBorder(
                        borderSide: BorderSide(color: AppColor.navy, width: 2),
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  TextField(
                    controller: licensePlateController,
                    decoration: const InputDecoration(
                      labelText: 'Biển số xe *',
                      border: OutlineInputBorder(
                        borderSide: BorderSide(color: AppColor.navy, width: 2),
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  TextField(
                    controller: vehicleNameController,
                    decoration: const InputDecoration(
                      labelText: 'Tên phương tiện *',
                      border: OutlineInputBorder(
                        borderSide: BorderSide(color: AppColor.navy, width: 2),
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  TextField(
                    controller: colorController,
                    decoration: const InputDecoration(
                      labelText: 'Màu xe *',
                      border: OutlineInputBorder(
                        borderSide: BorderSide(color: AppColor.navy, width: 2),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  MyButton(text: 'Đặt chỗ',
                      function:  () async {
                        print('${slotSelected.parkingSlotDto!.parkingSlotId!}');

                        int slotId = slotSelected.parkingSlotDto!.parkingSlotId!;

                        String guessNameBook = guessNameController.text;
                        String guessPhoneBook = guessPhoneController.text;

                        String licensePlate = licensePlateController.text;
                        String vehicleName = vehicleNameController.text;
                        String color = colorController.text;

                        if(licensePlate.isEmpty){
                          Utils(context).showErrorSnackBar('Biển số xe không được trống');
                        }else if (vehicleName.isEmpty){
                          Utils(context).showErrorSnackBar('Tên xe không được trống');
                        } else if (color.isEmpty){
                          Utils(context).showErrorSnackBar('Màu không được trống');
                        }else{
                          if(guessNameBook.isEmpty){
                            guessNameBook = 'Không';
                          }
                          if(guessPhoneBook.isEmpty){
                            guessPhoneBook = 'Không';
                          }

                          int? bookingId = await createBooking(slotId,
                              endTimeBook,
                              startTime,
                              guessNameBook,
                              guessPhoneBook,
                              licensePlate,
                              vehicleName,
                              color,
                              context);
                          if(bookingId != null){
                            debugPrint('BookingIDne: $bookingId');
                            await Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>  BookingPage(bookingId: bookingId,)),
                            );
                          }
                          Navigator.of(context).pop();
                        }
                      }, textColor: Colors.white, backgroundColor: AppColor.navy
                  )
                ],
              ),
            )
        );


      },
    );
  }


  Future<void> _getSlots(id, startTime, endTime) async {
    SlotsResponse resonse = await getSlotsParkingByFloor(id, startTime, endTime);
    if (resonse.data != null) {
      List<ParkingSlot> storeSlot = resonse.data!;
      setState(() {
        slots = storeSlot;
      });
    }
  }

  Future<void> _getFloors() async {
    List<Floor> response = await getFloorsByParking();
      setState(() {
        floors = response;
        selectedFloor = response.first;
      });
  }


  void updateDate(newStartTime, newEndTime){
    setState(() {
      startTime = newStartTime;
      endTime = newEndTime;
    });
  }

  @override
  void initState() {
    _getFloors();
    durationNode.addListener(() {
      if (!durationNode.hasFocus) {
        if(durationController.text != ''){
          int duration = int.parse(durationController.text);
          setState(() {
            endTimeBook = startTime.add(Duration(hours: duration));
            endTimeBookController.text =  DateFormat('HH:mm dd/MM/yyyy').format(endTimeBook);
          });
        }
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    _horizontalScrollController.dispose();
    _verticalScrollController.dispose();
    durationController.dispose();
    endTimeBookController.dispose();
    startTimeController.dispose();

     guessNameController.dispose();
     guessPhoneController.dispose();
     licensePlateController.dispose();
     vehicleNameController.dispose();
     colorController.dispose();

    super.dispose();
  }


  Future<void> _refreshData() async {
    setState(() {
      startTime =  DateTime(currentDate.year, currentDate.month, currentDate.day, currentDate.hour, 0, 0);
      endTime = startTime.add(const Duration(hours: 2));
    });
  }
  void showMenuActivate(){
    showModalBottomSheet<void>(
      context: context,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(30))),

      builder: (context) {
        return SizedBox(
          height: 150,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child:  Column(
              children: [
                const SizedBox(height: 8,),
                Center(
                  child: Container(
                      width: 50,
                      height: 7,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          color: AppColor.fadeText)
                  ),
                ),
                const SizedBox(height: 8,),
                const Divider(color: AppColor.fadeText, thickness: 0.5, indent: 8, endIndent: 8),
                const SizedBox(height: 8,),
                InkWell(
                    onTap: () async {
                      bool isSuccess = await enableSlot(slotSelected.parkingSlotDto!.parkingSlotId!);
                      Navigator.pop(context);
                      if(isSuccess == true){
                        _refreshData();
                        Utils(context).showSuccessSnackBar('Kích hoạt thành công');
                      }else{
                        Utils(context).showErrorSnackBar('Kích hoạt thất bại');
                      }
                    },
                    child: const SizedBox(
                        height: 60,
                        width: double.infinity,
                        child: Row(
                          children: [
                            Padding(
                              padding: EdgeInsets.only(left: 26.0, right: 35),
                              child: Icon(Icons.check_circle_sharp, size: 30, color: Colors.green,),
                            ),
                            RegularText(text: 'Kích hoạt chỗ', fontSize: 18, color: Colors.green),
                          ],
                        )
                    )
                ),
                const SizedBox(height: 18,),
              ],
            ),
          ),
        );
      },
    );
  }

  void showMenuBooking(int? isBooked){

    showModalBottomSheet<void>(
      context: context,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(30))),

      builder: (context) {
        return SizedBox(
          height: 210,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child:  Column(
              children: [
                const SizedBox(height: 8,),
                Center(
                  child: Container(
                      width: 50,
                      height: 7,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          color: AppColor.fadeText)
                  ),
                ),
                const SizedBox(height: 8,),
                const Divider(color: AppColor.fadeText, thickness: 0.5, indent: 8, endIndent: 8),
                const SizedBox(height: 8,),
                isBooked == 0 ?
                InkWell(
                    onTap: () {
                      _showGuessBookingDialog(startTime,context);
                    },
                    child: const SizedBox(
                        height: 60,
                        width: double.infinity,
                        child: Row(
                          children: [
                            Padding(
                              padding: EdgeInsets.only(left: 26.0, right: 35),
                              child: Icon(Icons.note_alt_outlined,  color: AppColor.navy, size: 30,),
                            ),
                            RegularText(text: 'Đặt chỗ cho khách', fontSize: 18, color: AppColor.navy),
                          ],
                        )
                    )
                ) : const SizedBox(),
                InkWell(
                  onTap: () async {
                    bool isSuccess = await disableSlot(slotSelected.parkingSlotDto!.parkingSlotId!);
                    Navigator.pop(context);
                    if(isSuccess == true){
                      _refreshData();
                      Utils(context).showSuccessSnackBar('Vô hiệu thành công');
                    }else{
                      Utils(context).showErrorSnackBar('Vô hiệu thất bại');
                    }
                  },
                    child: const SizedBox(
                      height: 60,
                        width: double.infinity,
                        child: Row(
                          children: [
                            Padding(
                              padding: EdgeInsets.only(left: 26.0, right: 35),
                              child: Icon(Icons.handyman, size: 30, color: AppColor.forText,),
                            ),
                            RegularText(text: 'Vô hiệu hóa slot', fontSize: 18, color: AppColor.forText),
                          ],
                        )
                    )
                ),
                const SizedBox(height: 18,),
              ],
            ),
          ),
        );
      },
    );
  }

  void showDateFilter() {
    DateTime focusedDay = DateTime.now();
    late int durationSelected = 0;
    late int startTime = 0;
    late int endTime = 0;
    late DateTime? selectedDayCalendar = DateTime.now();



    showModalBottomSheet<void>(
      isScrollControlled: true,
      context: context,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(30))),

      builder: (context) {
        return StatefulBuilder(builder: (context, setState) {
          return Container(
            padding: const EdgeInsets.only(left: 28, right: 28),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 16,),
                Center(
                  child: Container(
                      width: 50,
                      height: 7,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          color: AppColor.fadeText)
                  ),
                ),
                const SizedBox(height: 24,),
                SizedBox(
                  height: 50,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const RegularText(text: 'Ngày', fontSize: 14, color: AppColor.forText),

                          const SizedBox(height: 2,),

                          SemiBoldText(
                              text: DateFormat('dd/MM').format(selectedDayCalendar!),
                              fontSize: 16,
                              color: AppColor.navy)
                        ],
                      ),
                      const VerticalDivider(
                        thickness: 1.5,
                        color: AppColor.navyPale,
                        endIndent: 3,
                        indent: 3,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children:  [
                          const RegularText(
                              text: 'Từ',
                              fontSize: 14,
                              color: AppColor.forText),
                          const SizedBox(
                            height: 2,
                          ),
                          SemiBoldText(
                              text: '$startTime:00', fontSize: 16, color: AppColor.navy)
                        ],
                      ),

                      const VerticalDivider(thickness: 1.5, color: AppColor.navyPale, endIndent: 3, indent: 3,),

                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children:  [
                          const RegularText(
                              text: 'Thời hạn',
                              fontSize: 14,
                              color: AppColor.forText),
                          const SizedBox(
                            height: 2,
                          ),
                          SemiBoldText(
                              text: '$durationSelected giờ', fontSize: 16, color: AppColor.navy)
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 16,
                ),
                Container(
                  padding: const EdgeInsets.only(left: 8, right: 8, bottom: 8),
                  decoration: BoxDecoration(borderRadius: BorderRadius.circular(5), color: AppColor.navyPale),
                  child: TableCalendar(
                    calendarBuilders: CalendarBuilders(
                      dowBuilder: (context, day) {
                        if (day.weekday == DateTime.sunday) {
                          const text = 'CN';
                          return const Center(
                            child: SemiBoldText(
                              text: text,
                              fontSize: 14,
                              color: AppColor.forText,
                            ),
                          );
                        }
                        if (day.weekday == DateTime.monday) {
                          const text = 'T2';
                          return const Center(
                            child: SemiBoldText(
                              text: text,
                              fontSize: 14,
                              color: AppColor.forText,
                            ),
                          );
                        }
                        if (day.weekday == DateTime.tuesday) {
                          const text = 'T3';
                          return const Center(
                            child: SemiBoldText(
                              text: text,
                              fontSize: 14,
                              color: AppColor.forText,
                            ),
                          );
                        }
                        if (day.weekday == DateTime.wednesday) {
                          const text = 'T4';
                          return const Center(
                            child: SemiBoldText(
                              text: text,
                              fontSize: 14,
                              color: AppColor.forText,
                            ),
                          );
                        }
                        if (day.weekday == DateTime.thursday) {
                          const text = 'T5';
                          return const Center(
                            child: SemiBoldText(
                              text: text,
                              fontSize: 14,
                              color: AppColor.forText,
                            ),
                          );
                        }
                        if (day.weekday == DateTime.friday) {
                          const text = 'T6';
                          return const Center(
                            child: SemiBoldText(
                              text: text,
                              fontSize: 14,
                              color: AppColor.forText,
                            ),
                          );
                        }
                        if (day.weekday == DateTime.saturday) {
                          const text = 'T7';
                          return const Center(
                            child: SemiBoldText(
                              text: text,
                              fontSize: 14,
                              color: AppColor.forText,
                            ),
                          );
                        }
                        return null;
                      },
                      defaultBuilder: (context, day, focusedDay) {
                        return Center(
                            child: SemiBoldText(
                                text: day.day.toString(),
                                fontSize: 14,
                                color: AppColor.forText));
                      },
                      disabledBuilder: (context, day, focusedDay) {
                        return Center(
                            child: SemiBoldText(
                                text: day.day.toString(),
                                fontSize: 14,
                                color: Colors.grey));
                      },
                      outsideBuilder: (context, day, focusedDay) {
                        return Center(
                            child: SemiBoldText(
                                text: day.day.toString(),
                                fontSize: 14,
                                color: AppColor.fadeText));
                      },
                      headerTitleBuilder: (context, day) {
                        return Center(
                            child: SemiBoldText(
                                text: 'Tháng ${day.month}, ${day.year}',
                                fontSize: 15,
                                color: AppColor.forText));
                      },
                      selectedBuilder: (context, day, focusedDay) {
                        return Center(
                            child: Container(
                                height: 30,
                                width: 30,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: AppColor.paleOrange,
                                  border: Border.all(
                                    color: AppColor.orange,
                                    width: 1.0,
                                  ),
                                ),
                                child: Center(
                                    child: SemiBoldText(
                                      text: day.day.toString(),
                                      fontSize: 14,
                                      color: AppColor.forText,
                                      align: TextAlign.center,
                                    ))));
                      },
                      todayBuilder: (context, day, focusedDay) {
                        return Center(
                            child: SemiBoldText(
                              text: day.day.toString(),
                              fontSize: 14,
                              color: AppColor.orange,
                              align: TextAlign.center,
                            ));
                      },
                    ),
                    locale: 'vi_VN',
                    headerStyle: const HeaderStyle(
                        formatButtonVisible: false, titleCentered: true),
                    rowHeight: 40,
                    lastDay: DateTime.utc(2030),
                    focusedDay: focusedDay,
                    firstDay: currentDate,
                    selectedDayPredicate: (day) => isSameDay(day, selectedDayCalendar),
                    availableGestures: AvailableGestures.all,
                    onDaySelected: (selectedDay, focusedDay) {
                      setState(() {
                        selectedDayCalendar = selectedDay;
                        focusedDay = focusedDay;
                      });
                    },
                  ),
                ),
                const SizedBox(
                  height: 24,
                ),
                const SemiBoldText(
                    text: 'Bắt đầu từ',
                    fontSize: 15,
                    color: AppColor.forText),
                const SizedBox(height: 8,),

                SizedBox(
                  height:
                  35, // Set the desired height for the horizontal scroll
                  child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: 24, // Set the total number of items
                      itemBuilder: (BuildContext context, int index) {
                        int hour = index;
                        if (hour <= currentDate.hour && selectedDayCalendar?.day == currentDate.day) {
                          return const SizedBox(); // Skip rendering for hours in the past
                        }
                        return InkWell(
                          onTap: (){
                            setState(() {
                              startTime = index;
                            });
                          },

                          child: Container(
                            margin: const EdgeInsets.only(right: 8.0),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(color:  startTime == index ? AppColor.orange : AppColor.navyPale),
                              color: startTime == index ? AppColor.paleOrange : AppColor.navyPale,
                            ),
                            padding: const EdgeInsets.only(left: 16.0, right: 16, top: 8, bottom: 8),
                            child:  SemiBoldText(
                              text: '$index:00',
                              fontSize: 15,
                              color: AppColor.forText,
                            ),
                          ),
                        );

                      }),
                ),

                const SizedBox(height: 16,),

                const SemiBoldText(
                    text: 'Chọn thời hạn',
                    fontSize: 15,
                    color: AppColor.forText),

                const SizedBox(height: 8,),
                SizedBox(
                  height:
                  35, // Set the desired height for the horizontal scroll
                  child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: 12, // Set the total number of items
                      itemBuilder: (BuildContext context, int index) {
                        return InkWell(
                          onTap: (){
                            setState(() {
                              durationSelected = index +1 ;
                            });
                          },
                          child: Container(
                            margin: const EdgeInsets.only(right: 8.0),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(color:  durationSelected - 1 == index ? AppColor.orange : AppColor.navyPale),
                              color: durationSelected - 1 == index ? AppColor.paleOrange : AppColor.navyPale,
                            ),
                            padding: const EdgeInsets.only(left: 16.0, right: 16, top: 8, bottom: 8),
                            child:  SemiBoldText(
                              text: '${index + 1} giờ',
                              fontSize: 15,
                              color: AppColor.forText,
                            ),
                          ),
                        );
                      }),
                ),

                const SizedBox(height: 24,),

                MyButton(
                  text: 'Áp dụng',
                  function: () {
                    endTime = (startTime + durationSelected) % 24;
                    DateTime startDay = selectedDayCalendar!;
                    DateTime endDay ;

                    if(startTime > endTime){
                      endDay = selectedDayCalendar!.add(const Duration(days: 1));
                    }else {
                      endDay = selectedDayCalendar!;
                    }

                    DateTime startDateTime = DateTime(
                      startDay.year,
                      startDay.month,
                      startDay.day,
                      startTime,
                    );

                    DateTime endDateTime = DateTime(
                      endDay.year,
                      endDay.month,
                      endDay.day,
                      endTime,
                    );
                    //update here
                    updateDate(startDateTime, endDateTime);

                    Navigator.pop(context);
                  },
                  textColor: Colors.white,
                  backgroundColor: AppColor.navy,
                  minWidth: double.infinity,
                )
              ],
            ),
          );

        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    int selectedSlotIndex = -1;
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        automaticallyImplyLeading: false,
        backgroundColor: Colors.white,
        title: const SemiBoldText(
            text: 'Đặt chỗ', fontSize: 20, color: AppColor.forText),
        bottom: PreferredSize(
            preferredSize: const Size.fromHeight(120),
            child: StatefulBuilder(
              builder: (context, setState) {
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Flexible(
                            flex: 6,
                            child: Container(
                              padding: const EdgeInsets.only(left: 18, bottom: 8, top: 8),
                              margin: const EdgeInsets.only(
                                left: 8,
                                right: 8,
                              ),
                              height: 49,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  color: AppColor.navyPale),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Flexible(
                                    child: DropdownButton<Floor>(
                                      isExpanded: true,
                                      value: selectedFloor,
                                      onChanged: (newValue) {
                                        setState(() {
                                          selectedFloor = newValue!;
                                          _getSlots(selectedFloor.floorId, startTime, endTime);
                                        });
                                      },
                                      items: floors.map((floor) {
                                        return DropdownMenuItem<Floor>(
                                          value: floor,
                                          child: Text(floor.floorName!),
                                        );
                                      }).toList(),
                                    ),
                                  ),
                                  IconButton(
                                    padding: const EdgeInsets.only(bottom: 3),
                                    icon: const Icon(
                                      Icons.refresh,
                                    ),
                                    onPressed: () {
                                      _refreshData();
                                    },
                                  ),
                                ],
                              ),
                            ),
                          ),

                          Flexible(
                            flex: 1,
                            child: Container(
                              width: 49,
                              height: 49,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  color: AppColor.navy),
                              child: IconButton(onPressed: () {
                                showDateFilter();
                              }, icon: const Icon(Icons.calendar_month, color: AppColor.navyPale,)),
                            ),
                          )
                        ],
                      ),
                      const SizedBox(height: 8,),
                      SizedBox(
                        height: 50,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          crossAxisAlignment: CrossAxisAlignment.center,

                          children: [
                            Row(
                              children: [
                                const RegularText(text: 'Ngày ', fontSize: 14, color: AppColor.forText),

                                const SizedBox(width: 2,),

                                SemiBoldText(
                                    text: DateFormat('dd/MM').format(startTime),
                                    fontSize: 16,
                                    color: AppColor.navy)
                              ],
                            ),
                            const VerticalDivider(
                              thickness: 1.5,
                              color: AppColor.navyPale,
                              endIndent: 3,
                              indent: 3,
                            ),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.end,
                              children:  [
                                const RegularText(
                                    text: 'Từ ',
                                    fontSize: 14,
                                    color: AppColor.forText),
                                const SizedBox(
                                  width: 2,
                                ),
                                SemiBoldText(
                                    text: DateFormat('HH:mm').format(startTime), fontSize: 16, color: AppColor.navy)
                              ],
                            ),

                            const VerticalDivider(thickness: 1.5, color: AppColor.navyPale, endIndent: 3, indent: 3,),

                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children:  [
                                const RegularText(
                                    text: 'Đến ',
                                    fontSize: 14,
                                    color: AppColor.forText),
                                const SizedBox(
                                  width: 2,
                                ),
                                SemiBoldText(
                                    text: DateFormat('HH:mm').format(endTime), fontSize: 16, color: AppColor.navy)
                              ],
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                );
              },
            )),
      ),

      bottomNavigationBar: widget.bookingID != null ?BottomAppBar(
        color: Colors.white,
        child: SizedBox(
          height: 80,
          child: Center(
            child: Container(
              height: 40,
              width: double.infinity,
              margin: const EdgeInsets.only(left: 24, right: 24),
              child: MyButton(text: 'Chuyển chỗ',
                  function: () async {
                    print('slotSelected: ${slotSelected.parkingSlotDto!.parkingSlotId}');
                    if(widget.isEarly == true && slotSelected.parkingSlotDto != null ){
                    bool isSuccess = await earlyChangeSlot(slotSelected.parkingSlotDto!.parkingSlotId!, widget.bookingID!);
                    if (isSuccess == true){
                       Navigator.pop(context, true);
                    } else {
                      Utils(context).showErrorSnackBar('Chuyển slot thất bại');
                    }
                    }else if(widget.isEarly == false &&  slotSelected.parkingSlotDto != null ){
                      bool isSuccess = await changeSlot(slotSelected.parkingSlotDto!.parkingSlotId!, widget.bookingID!);
                      if (isSuccess == true){
                         Navigator.pop(context, true);
                      } else {
                        Utils(context).showErrorSnackBar('Chuyển slot thất bại');
                      }
                }
              }
                  , textColor: Colors.white, backgroundColor: AppColor.navy),
            ),
          )
        ),
      ) : const SizedBox.shrink(),


      body: FutureBuilder<SlotsResponse>(
          future: getSlotsParkingByFloor(
              selectedFloor.floorId, startTime.toIso8601String(), endTime.toIso8601String()),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const BookingSlotLoading();
            }

            if (snapshot.hasError) {
              return const SizedBox(
                width: double.infinity,
                height: 310,
                child: Center(
                  child: SemiBoldText(
                      text: 'Không có slot trong ngày giờ này',
                      fontSize: 19,
                      color: AppColor.forText),
                ),
              );
            }

            if (snapshot.connectionState == ConnectionState.done && snapshot.hasData) {
              if (snapshot.data!.data!.isNotEmpty) {
                slots = snapshot.data!.data!;
                slots.sort(
                  (a, b) => a.parkingSlotDto!.columnIndex!.compareTo(b.parkingSlotDto!.columnIndex!),
                );
                int maxColumnIndex = 0;
                int maxRowIndex = 0;
                //Find max column and row
                for (var slot in slots) {
                  if (slot.parkingSlotDto!.columnIndex! > maxColumnIndex) {
                    maxColumnIndex = slot.parkingSlotDto!.columnIndex!;
                  }
                  if (slot.parkingSlotDto!.rowIndex! > maxRowIndex) {
                    maxRowIndex = slot.parkingSlotDto!.rowIndex!;
                  }
                }

                return StatefulBuilder(builder: (context, setState) {
                  //Map ở đây nè
                  List<DataRow> myRows = [];

                  for (int rowIndex = 0; rowIndex <= maxRowIndex; rowIndex++) {
                    List<DataCell> myCells = [];

                    for (int cellIndex = 0; cellIndex <= maxColumnIndex; cellIndex++) {

                      ParkingSlot? slot = slots.firstWhere(
                        (element) =>
                            element.parkingSlotDto?.columnIndex == cellIndex &&
                            element.parkingSlotDto?.rowIndex == rowIndex,
                        orElse: () => ParkingSlot(),
                      );

                      if (slot.parkingSlotDto != null) {

                        myCells.add(
                          DataCell(

                            onLongPress:  widget.bookingID == null ? () {
                              setState(() {
                                selectedSlotIndex = rowIndex * 10 + cellIndex;
                                  slotSelected = slot;
                              });
                              if(slotSelected.isBooked == 2){
                                showMenuActivate();
                              }else{
                                showMenuBooking(slotSelected.isBooked);
                              }
                              } : null,

                            onTap: () {
                              setState(() {
                                if (slot.isBooked == 0) {
                                  selectedSlotIndex = rowIndex * 10 + cellIndex;
                                  slotSelected = slot;
                                } else {
                                  Utils(context).showWarningSnackBar('Vui lòng chọn chỗ khác');
                                }
                              });
                            },

                            Slot(
                                isSelected: selectedSlotIndex == rowIndex * 10 + cellIndex,
                                slotId: slot.parkingSlotDto!.parkingSlotId!,
                                isBooked: slot.isBooked!,
                                srow: slot.parkingSlotDto!.rowIndex!,
                                scell: slot.parkingSlotDto!.columnIndex!,
                                name: slot.parkingSlotDto!.name!,
                                isBackup: slot.parkingSlotDto!.isBackup!,),
                          ),
                        );
                      } else {
                        // Add an empty cell if no slot exists at the current column and row indices
                        myCells.add(
                          DataCell(Container(
                            color: Colors.grey,
                            height: 120,
                            width: 140,
                          )),
                        );
                      }
                    }

                    myRows.add(
                      DataRow(
                        cells: myCells,
                      ),
                    );
                  }
                  return SingleChildScrollView(
                    scrollDirection: Axis.vertical,
                    controller: _verticalScrollController,
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      controller: _horizontalScrollController,
                      child: Padding(
                        padding: const EdgeInsets.only(top: 18.0, bottom: 18.0),
                        child: DataTable(
                          horizontalMargin: 0,
                          headingRowHeight: 0,
                          dataRowMaxHeight: 120,
                          dataRowMinHeight: 120,
                          columnSpacing: 0,
                          dividerThickness: 0,
                          showCheckboxColumn: false,
                          border: TableBorder.all(
                            color: AppColor.fadeText,
                            width: 0.5,
                          ),
                          columns: List.generate(
                            maxColumnIndex + 1,
                            (index) => const DataColumn(
                              label: SizedBox.shrink(),
                            ),
                          ),
                          rows: myRows,
                        ),
                      ),
                    ),
                  );
                });
              } else {
                return const SizedBox(
                  width: double.infinity,
                  height: 310,
                  child: Center(
                    child: SemiBoldText(
                        text: 'Không có slot trong bãi',
                        fontSize: 19,
                        color: AppColor.forText),
                  ),
                );
              }
            }
            return const SizedBox(
              width: double.infinity,
              height: 310,
              child: Center(
                child: SemiBoldText(
                    text: '[E]Không có slot trong bãi xe',
                    fontSize: 19,
                    color: AppColor.forText),
              ),
            );
          }),
    );
  }
}
