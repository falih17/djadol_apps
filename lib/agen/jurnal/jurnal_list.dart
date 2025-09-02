import 'package:djadol_mobile/core/utils/ext_currency.dart';
import 'package:djadol_mobile/core/utils/ext_date.dart';
import 'package:djadol_mobile/core/widgets/zui.dart';
import 'package:easy_date_timeline/easy_date_timeline.dart';
import 'package:flutter/material.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

import '../../core/utils/api_service.dart';
import '../../core/utils/store.dart';
import '../../core/widgets/flist_page.dart';
import '../../widgets/floating_center.dart';
import 'journal_detail.dart';
import 'jurnal.dart';
import 'jurnal_add.dart';

class JurnalListPage extends StatefulWidget {
  const JurnalListPage({super.key});

  @override
  State<JurnalListPage> createState() => _JurnalListPageState();
}

class _JurnalListPageState extends State<JurnalListPage> {
  DateTime _selectedDate = DateTime.now();
  String totalSales = '0';

  static const _pageSize = 20;
  late final _pagingController = PagingController<int, dynamic>(
    getNextPageKey: (state) {
      final keys = state.keys;
      final pages = state.pages;
      if (keys == null) return 0;
      if (pages != null && pages.last.length < _pageSize) return null;
      return keys.last + 1;
    },
    fetchPage: (pageKey) => fetchPage(pageKey),
  );

  @override
  void initState() {
    super.initState();
    getTotal();
  }

  Future<List<Jurnal>> fetchPage(int page) async {
    try {
      var filter = {
        'created_at_min': _selectedDate.toStringDate(),
        'created_at_max': _selectedDate.toStringDate(),
        'created_by': Store().userId,
      };
      List result =
          await ApiService().getList('/all/44', page, _pageSize, data: filter);
      return result.map((i) => Jurnal.fromMap(i)).toList();
    } catch (error) {
      debugPrint('Error fetching data: $error');
      throw Exception('Failed to fetch data');
    }
  }

  Future<void> getTotal() async {
    // api/api_cust
    Map<String, dynamic> data = {
      'created_at': _selectedDate.toStringDate(),
    };
    var result = await ApiService().post('/act/totalsales', data);
    setState(() {
      totalSales = result.data['total'] ?? '0';
    });
  }

  Future<void> delete(String id) async {
    await ApiService().delete('Jurnal', id, context: context);
  }

  Widget widgetItemList(Jurnal i, int index) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => JurnalDetailPage(
              item: i,
            ),
          ),
        ).then((v) {
          if (v != null) _pagingController.refresh();
        });
      },
      // onLongPress: () async {
      //   if (await confirmDanger(context, title: 'Delete')) {
      //     delete(i.id);
      //   }
      // },
      child: Card(
        child: Container(
          padding: const EdgeInsets.all(10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Flexible(
                child: Row(
                  children: [
                    CircleAvatar(
                      backgroundColor: Colors.grey[300],
                      child: Icon(Icons.store, color: Constants.mColorBlue),
                    ),
                    Flexible(
                      child: Text(
                        ' ${i.retailIdName}',
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(fontSize: 16),
                      ),
                    ),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    'Rp. ${i.totalPrice.toCurrency()}',
                    style: TextStyle(
                        fontSize: 18,
                        color: Constants.mColorBlue,
                        fontWeight: FontWeight.bold),
                  ),
                  Text(i.createdAt.toDateMMMwHourMinutes()),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: const Text('Sales'),
        ),
        body: Column(
          children: [
            Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
              child: EasyDateTimeLinePicker(
                focusedDate: _selectedDate,
                firstDate: DateTime(2024, 3, 18),
                lastDate: DateTime.now(),
                onDateChange: (date) {
                  setState(() {
                    _selectedDate = date;
                  });
                  getTotal();
                  _pagingController.refresh();
                },
              ),
            ),
            Flexible(
              child: FListPage(
                pagingController: _pagingController,
                itemBuilder: (context, item, index) =>
                    widgetItemList(item, index),
              ),
            ),
            InfoButtomBar(
              leftText: 'Total Sales : ',
              rightText: totalSales.toCurrency(),
            ),
          ],
        ),
        floatingActionButton: _selectedDate.day == DateTime.now().day &&
                _selectedDate.month == DateTime.now().month &&
                _selectedDate.year == DateTime.now().year
            ? FloatingButtonCenter(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const JurnalAddPage(),
                    ),
                  ).then((v) {
                    if (v != null) {
                      _pagingController.refresh();
                      getTotal();
                    }
                  });
                },
              )
            : null,
      );
}
