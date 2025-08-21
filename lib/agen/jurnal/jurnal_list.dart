import 'package:djadol_mobile/core/utils/ext_currency.dart';
import 'package:djadol_mobile/core/utils/ext_date.dart';
import 'package:easy_date_timeline/easy_date_timeline.dart';
import 'package:flutter/material.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

import '../../core/utils/api_service.dart';
import '../../core/utils/store.dart';
import '../../core/widgets/flist_page.dart';
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
    return;
    // api/api_cust
    Map<String, dynamic> data = {
      'created_at_min': _selectedDate.toStringDate(),
      'created_at_max': _selectedDate.toStringDate()
    };
    var result = await ApiService().post('/api_cust', data);
    print(result);
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
        child: ListTile(
          title: Text('${++index}. ${i.retailIdName}',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          subtitle: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(i.totalPrice.toCurrency()),
              Text(i.createdAt.toString()),
              // i.isNew == '1'
              //     ? const Icon(Icons.new_releases, color: Colors.green)
              //     : const SizedBox.shrink(),
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
                lastDate: DateTime(2030, 3, 18),
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
            Padding(
              padding: const EdgeInsets.all(20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Total Sales : ',
                    style: TextStyle(fontSize: 20),
                  ),
                  Text(
                    '200.000',
                    style: TextStyle(fontSize: 20),
                  )
                ],
              ),
            ),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const JurnalAddPage(),
              ),
            ).then((v) {
              if (v != null) _pagingController.refresh();
            });
          },
          child: const Icon(Icons.add),
        ),
      );
}
