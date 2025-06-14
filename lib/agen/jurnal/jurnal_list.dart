import 'package:djadol_mobile/core/utils/ext_currency.dart';
import 'package:flutter/material.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

import '../../core/utils/api_service.dart';
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
      List result = await ApiService().getList('/all/43', page, _pageSize);
      return result.map((i) => Jurnal.fromMap(i)).toList();
    } catch (error) {
      debugPrint('Error fetching data: $error');
      throw Exception('Failed to fetch data');
    }
  }

  Future<void> delete(String id) async {
    await ApiService().delete('Jurnal', id, context: context);
  }

  Widget widgetItemList(Jurnal i) {
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
          title: Text(i.retailIdName),
          subtitle: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(i.totalPrice.toCurrency()),
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
        body: FListPage(
          pagingController: _pagingController,
          itemBuilder: (context, item, index) => widgetItemList(
            item,
          ),
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
