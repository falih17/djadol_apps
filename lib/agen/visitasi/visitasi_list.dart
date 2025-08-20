import 'package:djadol_mobile/core/utils/ext_date.dart';
import 'package:easy_date_timeline/easy_date_timeline.dart';
import 'package:flutter/material.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

import '../../core/utils/api_service.dart';
import '../../core/widgets/flist_page.dart';
import 'visitasi.dart';
import 'visitasi_add.dart';

class VisitasiListPage extends StatefulWidget {
  const VisitasiListPage({super.key});

  @override
  State<VisitasiListPage> createState() => _VisitasiListPageState();
}

class _VisitasiListPageState extends State<VisitasiListPage> {
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
  }

  Future<List<Jurnal>> fetchPage(int page) async {
    try {
      var filter = {
        'created_at_min': _selectedDate.toStringDate(),
        'created_at_max': _selectedDate.toStringDate()
      };

      List result =
          await ApiService().getList('/all/43', page, _pageSize, data: filter);
      return result.map((i) => Jurnal.fromMap(i)).toList();
    } catch (error) {
      debugPrint('Error fetching data: $error');
      throw Exception('Failed to fetch data');
    }
  }

  Future<void> delete(String id) async {
    await ApiService().delete('Jurnal', id, context: context);
  }

  Widget widgetItemList(Jurnal i, int index) {
    return Column(
      children: [
        InkWell(
          child: Card(
            child: ListTile(
              title: Text('${++index}. ${i.retailIdName}'),
              subtitle: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Tanggal: ${i.createdAt.split(' ')[0]}'),
                      Text(
                          'Waktu: ${i.createdAt.split(' ').length > 1 ? i.createdAt.split(' ')[1] : ''}'),
                    ],
                  ),
                  i.isNew == '1'
                      ? const Icon(Icons.new_releases, color: Colors.green)
                      : const SizedBox.shrink(),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: const Text('Kunjungan'),
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
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const VisitasiAddPage(),
              ),
            ).then((v) {
              if (v != null) _pagingController.refresh();
            });
          },
          child: const Icon(Icons.add),
        ),
      );
}
