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
  BookingsResponse? listBooking;
  final TextEditingController _searchController = TextEditingController();

  Future<void> _refreshData() async {
    setState(() {
      _searchController.clear();
      _loadData();
    });
  }

// Common function to get booking data
  Future<BookingsResponse?> fetchBookings({String? searchString}) async {
    try {
      if (searchString != null) {
        return getBookingBySearch(searchString);
      } else {
        return getBookingList();
      }
    } catch (e) {
      // Handle the error if needed
      print('Error fetching bookings: $e');
      return null;
    }
  }


// Inside your Widget class
  Future<void> _loadData({String? searchString}) async {
    BookingsResponse? bookings = await fetchBookings(searchString: searchString);
    setState(() {
      listBooking = bookings;
    });
  }

  @override
  void initState() {
    _loadData();
    super.initState();
  }
  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
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
                  child:  Center(
                    child: TextField(
                      controller: _searchController,
                      onSubmitted: (value) {
                        if(value.isNotEmpty){
                          _loadData(searchString: value);
                        }else{
                          _loadData();
                        }
                      },

                      decoration: InputDecoration(
                          hintText: 'Mã đơn I Tên khách I Biển số',
                          prefixIcon: const Icon(Icons.search),
                          suffixIcon: InkWell( onTap: () {
                            _searchController.clear();
                            _loadData();
                          },child: const Icon(Icons.close_sharp))),
                    ),
                  ),
                ),
              ),
            ),
            // Other Sliver Widgets

            FutureBuilder(
                future: fetchBookings(),
                builder: (context, snapshot) {
                  if(snapshot.connectionState == ConnectionState.waiting){
                    return const ActivityLoading();
                  }
                  if(snapshot.hasData && snapshot.connectionState == ConnectionState.done){
                    if(listBooking != null  && listBooking!.data != null){
                      return SliverList(
                        delegate: SliverChildBuilderDelegate(
                              (BuildContext context, int index)  {
                            return  Padding(
                              padding: const EdgeInsets.only(top: 16.0, right: 8, left: 8),
                              child: ActivityCard(
                                  bookingId:  listBooking!.data![index].bookingSearchResult!.bookingId!,
                                  dateBook: listBooking!.data![index].bookingSearchResult!.dateBook!,
                                  startTime: listBooking!.data![index].bookingSearchResult!.startTime!,
                                  endTime: listBooking!.data![index].bookingSearchResult!.endTime!,
                                  licensePlate: listBooking!.data![index].vehicleInforSearchResult!.licensePlate!,
                                  address: listBooking!.data![index].parkingSearchResult!.address!,
                                  parkingName: listBooking!.data![index].parkingSearchResult!.name!,
                                  floorName: listBooking!.data![index].parkingSlotSearchResult!.floorName!,
                                  slotName: listBooking!.data![index].parkingSlotSearchResult!.name!,
                                  status: listBooking!.data![index].bookingSearchResult!.status!
                              ),
                            );
                          },
                          childCount: listBooking!.data!.length,
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



