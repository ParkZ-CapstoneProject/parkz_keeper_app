import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:parkz_keeper_app/common/constanst.dart';
import 'package:parkz_keeper_app/common/text/medium.dart';
import 'package:parkz_keeper_app/common/text/regular.dart';
import 'package:parkz_keeper_app/common/text/semi_bold.dart';
import 'package:parkz_keeper_app/pages/dashboard/component/daterangebutton.dart';
import 'package:parkz_keeper_app/pages/dashboard/component/linechart.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({Key? key}) : super(key: key);

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 16,),
                const Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        RegularText(text: 'Nhân viên - Bãi xe tình thương ', fontSize: 15, color: AppColor.forText),
                        SemiBoldText(text: 'Trần Ngọc Théng', fontSize: 25, color: Colors.black),
                      ],
                    ),
                     SizedBox(
                       width: 50,
                       height: 50,
                       child: CircleAvatar(
                        backgroundImage: NetworkImage('https://cdn.pixabay.com/photo/2016/03/28/12/35/cat-1285634_1280.png'),
                    ),
                     )

                  ],
                ),
                const SizedBox(height: 32,),
                Row(
                  children: [
                    Flexible(
                      child: Container(
                        height: 170,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: AppColor.navy,
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.5),
                              spreadRadius: 5,
                              blurRadius: 7,
                              offset: const Offset(0, 3), // changes position of shadow
                            ),
                          ],
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                width: 50,
                                height: 50,
                                decoration: const BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Colors.white,
                                ),
                                child:  Center(
                                  child: SvgPicture.asset('assets/icon/timer.svg'),
                                ),
                              ),
                              const SemiBoldText(text: '50', fontSize: 40, color: Colors.white),
                              const SemiBoldText(text: 'Đơn hôm nay', fontSize: 14, color: Colors.white)
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 16,),
                    Flexible(
                      child: Container(
                        height: 170,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: AppColor.forText,
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.5),
                              spreadRadius: 5,
                              blurRadius: 7,
                              offset: const Offset(0, 3), // changes position of shadow
                            ),
                          ],
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,

                            children: [
                              Container(
                                width: 50,
                                height: 50,
                                decoration: const BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Colors.white,
                                ),
                                child:  Center(
                                  child: SvgPicture.asset('assets/icon/schedule.svg'),
                                ),
                              ),
                              const SemiBoldText(text: '220', fontSize: 40, color: Colors.white),
                              const SemiBoldText(text: 'Tổng số đơn', fontSize: 14, color: Colors.white)
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 32,),
                const SemiBoldText(text: 'Tổng doanh thu ', fontSize: 20, color: AppColor.forText),
                const SizedBox(height: 16,),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: AppColor.navyPale,
                      width: 1,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.5),
                        spreadRadius: 5,
                        blurRadius: 7,
                        offset: const Offset(0, 3), // changes position of shadow
                      ),
                    ],
                  ),
                  height: 325,
                  child:  Column(

                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 16.0, top: 26.0, right: 16),
                        child: SizedBox(
                          height: 50,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Row(
                                children: [
                                  VerticalDivider(width: 18, color: AppColor.orange, thickness: 3 , endIndent: 7),
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      MediumText(text: 'Tổng tiền', fontSize: 12, color: AppColor.forText),
                                      SemiBoldText(text: '8 750 000 đ', fontSize: 20, color: AppColor.forText)
                                    ],
                                  ),
                                ],
                              ),
                              IconButton(onPressed: () {

                              }, icon: const Icon(Icons.calendar_month))


                            ],
                          ),
                        ),
                      ),
                      const LineChartSample2(),
                    ],
                  ),
                  // Other container properties or child widgets can be added here
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
