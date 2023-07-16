import 'package:flutter/material.dart';

import '../../common/button/button_widget.dart';
import '../../common/constanst.dart';
import '../../common/text/semi_bold.dart';
import 'component/slot.dart';

class ParkingMapPage extends StatefulWidget {
  const ParkingMapPage({Key? key}) : super(key: key);

  @override
  State<ParkingMapPage> createState() => _ParkingMapPageState();
}

class _ParkingMapPageState extends State<ParkingMapPage> {
  final ScrollController _horizontalScrollController = ScrollController();
  final ScrollController _verticalScrollController = ScrollController();

  @override
  void dispose() {
    _horizontalScrollController.dispose();
    _verticalScrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    String? dropdownValue = 'Tầng 1';
    int _selectedSlotIndex = -1;
    return Scaffold(
      appBar: AppBar(
        // bottomOpacity: 0.0,
        elevation: 0.0,
        leading: const BackButton(color: AppColor.forText),

        backgroundColor: Colors.white,
        title: const SemiBoldText(
            text: 'Đặt chỗ', fontSize: 20, color: AppColor.forText),
        bottom: PreferredSize(
            preferredSize: const Size.fromHeight(50),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    flex: 3,
                    child: Container(
                      margin: const EdgeInsets.only(
                        left: 8,
                        right: 8,
                      ),
                      height: 49,
                      padding:
                      const EdgeInsets.only(left: 18, bottom: 8, top: 8),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: AppColor.navyPale),
                      child: DropdownButton<String>(
                        isExpanded: true,
                        value: dropdownValue,
                        onChanged: (newValue) {
                          setState(() {
                            dropdownValue = newValue!;
                            // print('Newwa: ' + newValue);
                            // print('dropdownValue ' + dropdownValue!);
                          });
                        },
                        items: <String>['Tầng 1', 'Tầng 2', 'Tầng 3', 'Tầng 4']
                            .map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(
                              value,
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: Container(
                      height: 49,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: AppColor.navyPale),
                      child: const Center(
                          child: Icon(Icons.filter_list)),
                    ),
                  )
                ],
              ),
            )),
      ),
      bottomNavigationBar: Padding(
        padding:
        const EdgeInsets.only(left: 30.0, right: 30, bottom: 20, top: 16),

        child: MyButton(
            text: 'Tiếp tục',
            function: () {

            },
            textColor: Colors.white,
            backgroundColor: AppColor.navy),

      ),
      body: StatefulBuilder(
          builder: (context, setState) {
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
                    dataRowHeight: 120,
                    columnSpacing: 0,
                    dividerThickness: 0,
                    showCheckboxColumn: false,
                    border: TableBorder.all(color: AppColor.fadeText, width: 0.5, ),
                    columns: List.generate(
                      10,
                          (index) => const DataColumn(
                        label: SizedBox.shrink(),
                      ),
                    ),
                    rows: List.generate(
                      10,
                          (index) => DataRow(
                        cells: List.generate(
                          10,
                              (cellIndex) => DataCell(
                              onTap: () {
                                setState(() {
                                  _selectedSlotIndex = index * 10 + cellIndex;
                                  print('Sao: ${_selectedSlotIndex}' );
                                }
                                );
                              },
                              Slot(index: index,cellIndex: cellIndex,isSelected: _selectedSlotIndex == index * 10 + cellIndex,)
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            );
          }
      ),
    );
  }
}