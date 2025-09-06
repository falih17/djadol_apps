import 'package:djadol_mobile/core/utils/ext_currency.dart';
import 'package:djadol_mobile/core/utils/store.dart';
import 'package:djadol_mobile/core/widgets/zui.dart';
import 'package:flutter/material.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

import '../../core/utils/api_service.dart';
import '../../core/widgets/flist_page.dart';
import 'Inquiry_add.dart';
import 'inquiry.dart';

class InquiryListPage extends StatefulWidget {
  const InquiryListPage({super.key});

  @override
  State<InquiryListPage> createState() => _InquiryListPageState();
}

class _InquiryListPageState extends State<InquiryListPage> {
  String totalToko = '0';

  static const _pageSize = 40;
  late final _pagingController = PagingController<int, Inquiry>(
    getNextPageKey: (state) {
      final keys = state.keys;
      final pages = state.pages;
      if (keys == null) return 0;
      if (pages != null && pages.last.length < _pageSize) return null;
      return keys.last + 1;
    },
    fetchPage: (pageKey) => fetchPage(pageKey),
  );
  final bool _searchState = false;

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

  Future<List<Inquiry>> fetchPage(int page) async {
    try {
      Map<String, dynamic> params = {
        'agen_id': Store().userId,
      };
      List result =
          await ApiService().getList('/all/45', page, _pageSize, data: params);
      return result.map((i) => Inquiry.fromMap(i)).toList();
    } catch (error, s) {
      debugPrint(s.toString());
      throw Exception('Failed to fetch data');
    }
  }

  Future<void> delete(String id) async {
    await ApiService().delete('Inquiry', id, context: context);
    initData();
  }

  Widget widgetItemList(Inquiry i, int index) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => InquiryDetailPage(item: i),
          ),
        ).then((value) {
          if (value == true) {
            initData();
          }
        });
      },
      child: Card(
        child: Container(
          padding: const EdgeInsets.all(10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              CircleAvatar(
                backgroundColor: Colors.grey[300],
                child: Icon(
                  Icons.inventory_2_outlined,
                  color: Constants.mColorBlue,
                ),
              ),
              SizedBox(
                width: 10,
              ),
              Flexible(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(i.createdAt.toDateMMMwHourMinutes()),
                        Text(i.description),
                      ],
                    ),
                    (i.status == 'diterima')
                        ? Text(
                            'Diterima',
                            style: TextStyle(
                              color: Colors.green[800],
                              fontWeight: FontWeight.bold,
                            ),
                          )
                        : Text(
                            'Draft',
                            style: TextStyle(
                              color: Colors.orange[800],
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
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
          title: const Text('Plotting Barang'),
          // actions: [
          //   IconButton(
          //     icon: Icon(
          //         _searchState ? Icons.filter_list_off : Icons.filter_list),
          //     onPressed: () {
          //       setState(() {
          //         _searchState = !_searchState;
          //       });
          //     },
          //   ),
          // ],
        ),
        body: Column(
          children: [
            if (_searchState)
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: ZInputSearch(
                  onChanged: (value) {
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
            // InfoButtomBar(
            //   leftText: 'Total Toko : ',
            //   rightText: totalToko.toCurrency(),
            // ),
          ],
        ),
      );
}
