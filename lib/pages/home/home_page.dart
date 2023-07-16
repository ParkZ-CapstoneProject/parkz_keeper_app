import 'package:flutter/material.dart';
import 'package:parkz_keeper_app/common/constanst.dart';
import 'package:parkz_keeper_app/pages/account/account_profile.dart';
import 'package:parkz_keeper_app/pages/bookinglist/booking_list_page.dart';
import 'package:parkz_keeper_app/pages/parkingmap/map_page.dart';

import '../dashboard/dashboard_page.dart';
import '../qrpage/qr_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int currentTab = 0; // to keep track of active tab index
  final List<Widget> screens = [
    const Dashboard(),
    const ParkingMapPage(),
    const BookingListPage(),
    const AccountProfile(),
  ];
  final PageStorageBucket bucket = PageStorageBucket();
  Widget currentScreen = const Dashboard();



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.white,

      body: PageStorage(
        bucket: bucket,
        child: currentScreen,
      ),

      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppColor.navyPale,
        child: const Icon(Icons.qr_code_scanner, color: AppColor.navy),
        onPressed: () {
          Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => const QRViewExample(),
          ));
        },
      ),


      bottomNavigationBar: BottomAppBar(
        color: Colors.white,
        child: SizedBox(
          height: 60,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  MaterialButton(
                    minWidth: 40,
                    onPressed: () {
                      setState(() {
                        currentScreen = const Dashboard(); // if user taps on this dashboard tab will be active
                        currentTab = 0;
                      });
                    },

                    child: Icon(
                      Icons.dashboard,
                      color: currentTab == 0 ? AppColor.orange : AppColor.navy,
                    ),
                  ),
                  MaterialButton(
                    minWidth: 40,
                    onPressed: () {
                      setState(() {
                        currentScreen =
                        const ParkingMapPage(); // if user taps on this dashboard tab will be active
                        currentTab = 1;
                      });
                    },
                    child: Icon(
                      Icons.maps_home_work,
                      color: currentTab == 1 ? AppColor.orange : AppColor.navy,
                    ),
                  )
                ],
              ),

              // Right Tab bar icons

              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  MaterialButton(
                    minWidth: 40,
                    onPressed: () {
                      setState(() {
                        currentScreen =
                        const BookingListPage(); // if user taps on this dashboard tab will be active
                        currentTab = 2;
                      });
                    },
                    child: Icon(
                      Icons.list_alt,
                      color: currentTab == 2 ?AppColor.orange : AppColor.navy,
                    ),
                  ),
                  MaterialButton(
                    minWidth: 40,
                    onPressed: () {
                      setState(() {
                        currentScreen = const AccountProfile(); // if user taps on this dashboard tab will be active
                        currentTab = 3;
                      });
                    },
                    child: Icon(
                      Icons.person,
                      color: currentTab == 3 ?AppColor.orange : AppColor.navy,
                    ),
                  )
                ],
              )

            ],
          ),
        ),
      ),
    );
  }
}