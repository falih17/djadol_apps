import 'package:djadol_mobile/core/utils/ext_currency.dart';
import 'package:djadol_mobile/core/utils/store.dart';
import 'package:djadol_mobile/core/widgets/zui.dart';
import 'package:flutter/material.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

import '../../core/utils/api_service.dart';
import '../../core/widgets/flist_page.dart';
import '../../widgets/floating_center.dart';
import 'retail.dart';
import 'retail_add.dart';

class RetailListPage extends StatefulWidget {
  const RetailListPage({super.key});

  @override
  State<RetailListPage> createState() => _RetailListPageState();
}

class _RetailListPageState extends State<RetailListPage> {
  String totalToko = '0';

  static const _pageSize = 40;
  late final _pagingController = PagingController<int, Retail>(
    getNextPageKey: (state) {
      final keys = state.keys;
      final pages = state.pages;
      if (keys == null) return 0;
      if (pages != null && pages.last.length < _pageSize) return null;
      return keys.last + 1;
    },
    fetchPage: (pageKey) => fetchPage(pageKey),
  );
  String _searchTerm = '';
  bool _searchState = false;

  @override
  void initState() {
    super.initState();
    getTotal();
  }

  void initData() {
    getTotal();
    _pagingController.refresh();
  }

  Future<void> getTotal() async {
    // api/api_cust
    var result = await ApiService().post('/act/totaltokobyagen', {});
    setState(() {
      totalToko = result.data['total'] ?? '0';
    });
  }

  Future<List<Retail>> fetchPage(int page) async {
    try {
      Map<String, dynamic> params = {
        'name': _searchTerm,
        'created_by': Store().userId,
      };
      List result =
          await ApiService().getList('/all/31', page, _pageSize, data: params);
      return result.map((i) => Retail.fromMap(i)).toList();
    } catch (error, s) {
      debugPrint(s.toString());
      throw Exception('Failed to fetch data');
    }
  }

  Future<void> delete(String id) async {
    await ApiService().delete('Retail', id, context: context);
    initData();
  }

  Widget widgetItemList(Retail i, int index) {
    return ProductCard(
      name: '${++index}. ${i.name}',
      phone: i.phone,
      description: i.address,
      imageUrl: i.picture,
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => RetailAddPage(item: i),
          ),
        ).then((v) {
          if (v != null) _pagingController.refresh();
        });
      },
      onLongPress: () async {
        if (await confirmDanger(context, title: 'Delete')) {
          delete(i.id);
        }
      },
    );
  }

  @override
  void dispose() {
    _pagingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: const Text('Toko'),
          actions: [
            IconButton(
              icon: Icon(
                  _searchState ? Icons.filter_list_off : Icons.filter_list),
              onPressed: () {
                setState(() {
                  _searchState = !_searchState;
                });
              },
            ),
          ],
        ),
        body: Column(
          children: [
            if (_searchState)
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: ZInputSearch(
                  onChanged: (value) {
                    _searchTerm = value;
                    _pagingController.refresh();
                  },
                ),
              ),
            Expanded(
              child: FListPage(
                pagingController: _pagingController,
                itemBuilder: (context, item, index) =>
                    widgetItemList(item, index),
              ),
            ),
            InfoButtomBar(
              leftText: 'Total Toko : ',
              rightText: totalToko.toCurrency(),
            ),
          ],
        ),
        floatingActionButton: FloatingButtonCenter(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const RetailAddPage(),
              ),
            ).then((v) {
              if (v != null) initData();
            });
          },
        ),
      );
}
