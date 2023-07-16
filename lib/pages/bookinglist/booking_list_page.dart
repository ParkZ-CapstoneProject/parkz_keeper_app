import 'package:flutter/material.dart';

import '../../common/constanst.dart';
import '../../common/text/semi_bold.dart';
import 'component/activity_card.dart';

class BookingListPage extends StatefulWidget {
  const BookingListPage({Key? key}) : super(key: key);

  @override
  State<BookingListPage> createState() => _BookingListPageState();
}

class _BookingListPageState extends State<BookingListPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.navyPale,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
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

          SliverList(
            delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    return const Padding(
                      padding: EdgeInsets.only(top: 16.0, right: 16, left: 16,),
                      child: ActivityCard(),
                    );
              },
              childCount:  5,
            ),
          ),
        ],
      ),
    );
  }
}



