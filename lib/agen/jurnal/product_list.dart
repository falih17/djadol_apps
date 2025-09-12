import 'package:djadol_mobile/core/utils/ext_currency.dart';
import 'package:djadol_mobile/core/widgets/zui.dart';
import 'package:flutter/material.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

import '../../core/utils/api_service.dart';
import '../../core/utils/store.dart';
import '../../core/widgets/flist_page.dart';
import 'product_model.dart';

class ProductListPage extends StatefulWidget {
  const ProductListPage({super.key});

  @override
  State<ProductListPage> createState() => _ProductListPageState();
}

class _ProductListPageState extends State<ProductListPage> {
  static const _pageSize = 20;
  String _searchTerm = '';

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

  Future<List<Product>> fetchPage(int page) async {
    try {
      Map<String, dynamic> params = {
        'page': page,
        'size': _pageSize,
        'name': _searchTerm,
        'count_min': 1,
        'agen_id': Store().userId
      };
      List result =
          await ApiService().getList('/all/39', page, _pageSize, data: params);
      List<Product> newItems = result.map((i) => Product.fromMap(i)).toList();
      return newItems;
    } catch (error) {
      debugPrint(error.toString());
    }
    return [];
  }

  Future<void> delete(String id) async {
    await ApiService().delete('Product', id, context: context);
    _pagingController.refresh();
  }

  Widget widgetItemList(Product i) {
    return InkWell(
      onTap: () {
        Navigator.pop(context, i);
      },
      child: Card(
        margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: i.picture.isNotEmpty
                    ? Image.network(
                        i.picture,
                        width: 60,
                        height: 60,
                        fit: BoxFit.cover,
                      )
                    : Container(
                        width: 60,
                        height: 60,
                        color: Colors.grey[200],
                        child: const Icon(
                          Icons.image,
                          color: Colors.grey,
                          size: 32,
                        ),
                      ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      i.name,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Text(
                              i.priceSale.toString().toCurrency(),
                              style: const TextStyle(
                                fontSize: 14,
                                color: Colors.red,
                              ),
                            ),
                            if (i.priceSale2 > 0) ...[
                              Text(' | '),
                              Text(
                                i.priceSale2.toString().toCurrency(),
                                style: const TextStyle(
                                  fontSize: 14,
                                  color: Colors.green,
                                ),
                              ),
                            ],
                            if (i.priceSale3 > 0) ...[
                              Text(' | '),
                              Text(
                                i.priceSale3.toString().toCurrency(),
                                style: const TextStyle(
                                  fontSize: 14,
                                  color: Colors.blue,
                                ),
                              ),
                            ]
                          ],
                        ),
                        Text(
                          'Stok: ${i.count}',
                          style: const TextStyle(
                            fontSize: 16,
                            color: Colors.blue,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    )
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
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: const Text('Product'),
        ),
        body: Column(
          children: [
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
                itemBuilder: (context, item, index) => widgetItemList(
                  item,
                ),
              ),
            ),
          ],
        ),
      );
}
