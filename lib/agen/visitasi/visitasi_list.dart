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
      child: Card(
        child: ListTile(
          title: Text(i.retailIdName),
          subtitle: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(i.createdAt),
              i.isNew == '1'
                  ? const Icon(Icons.new_releases, color: Colors.green)
                  : const SizedBox.shrink(),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: const Text('Kunjungan'),
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
