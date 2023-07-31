import 'package:flutter/material.dart';

import '../../common/constanst.dart';
import '../../models/bookings_response.dart';
import '../../network/api.dart';
import 'component/activity_card.dart';
import 'component/activity_loading.dart';
import 'component/empty_booking.dart';

class BookingListPage extends StatefulWidget {
  const BookingListPage({Key? key}) : super(key: key);

  @override
  State<BookingListPage> createState() => _BookingListPageState();
}

class _BookingListPageState extends State<BookingListPage> {

  Future<void> _refreshData() async {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.navyPale,
      body: RefreshIndicator(
        onRefresh: _refreshData,
        child: CustomScrollView(
          slivers: [
            SliverAppBar(
              automaticallyImplyLeading: false,
              backgroundColor: AppColor.navy,
              floating: true,
              pinned: true,
              snap: false,
              centerTitle: false,
              title: const Text('Danh sách đơn'),
              actions: [
                IconButton(
                  icon: const Icon(Icons.filter_list),
                  onPressed: () {},
                ),
              ],
              bottom: AppBar(
                automaticallyImplyLeading: false,
                backgroundColor: AppColor.navy,
                title: Container(
                  width: double.infinity,
                  height: 40,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Center(
                    child: TextField(
                      decoration: InputDecoration(
                          hintText: 'Mã đơn I Tên khác I Biển số',
                          prefixIcon: Icon(Icons.search),
                          suffixIcon: Icon(Icons.close_sharp)),
                    ),
                  ),
                ),
              ),
            ),
            // Other Sliver Widgets

            FutureBuilder<BookingsResponse?>(
                future: getBookingList(context),
                builder: (context, snapshot) {
                  if(snapshot.connectionState == ConnectionState.waiting){
                    return const ActivityLoading();
                  }
                  if(snapshot.hasData && snapshot.connectionState == ConnectionState.done){
                    if(snapshot.data!.data != null){
                      return SliverList(
                        delegate: SliverChildBuilderDelegate(
                              (BuildContext context, int index)  {
                            return  Padding(
                              padding: const EdgeInsets.only(top: 16.0, right: 8, left: 8),
                              child: ActivityCard(
                                  bookingId:  snapshot.data!.data![index].bookingSearchResult!.bookingId!,
                                  dateBook: snapshot.data!.data![index].bookingSearchResult!.dateBook!,
                                  startTime: snapshot.data!.data![index].bookingSearchResult!.startTime!,
                                  endTime: snapshot.data!.data![index].bookingSearchResult!.endTime!,
                                  licensePlate: snapshot.data!.data![index].vehicleInforSearchResult!.licensePlate!,
                                  address: snapshot.data!.data![index].parkingSearchResult!.address!,
                                  parkingName: snapshot.data!.data![index].parkingSearchResult!.name!,
                                  floorName: snapshot.data!.data![index].parkingSlotSearchResult!.floorName!,
                                  slotName: snapshot.data!.data![index].parkingSlotSearchResult!.name!,
                                  status: snapshot.data!.data![index].bookingSearchResult!.status!
                              ),
                            );
                          },
                          childCount: snapshot.data!.data!.length,
                        ),
                      );
                    }
                  }
                  return const SliverToBoxAdapter(child: EmptyBooking());
                }
            ),
          ],
        ),
      ),
    );
  }
}



