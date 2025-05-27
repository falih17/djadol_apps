import 'package:flutter/material.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

import 'package:djadol_mobile/core/widgets/zui.dart';

import '../../core/utils/api_service.dart';
import '../../core/widgets/flist_page.dart';
import 'product_model.dart';

class ProductListPage extends StatefulWidget {
  const ProductListPage({super.key});

  @override
  State<ProductListPage> createState() => _ProductListPageState();
}

class _ProductListPageState extends State<ProductListPage> {
  static const _pageSize = 20;
  final PagingController<int, Product> _pagingController =
      PagingController(firstPageKey: 0);

  @override
  void initState() {
    super.initState();
    _pagingController.addPageRequestListener(_fetchPage);
  }

  Future<void> _fetchPage(int page) async {
    try {
      List result = await ApiService().getList('/all/30', page, _pageSize);
      List<Product> newItems = result.map((i) => Product.fromMap(i)).toList();
      final isLastPage = newItems.length < _pageSize;
      if (isLastPage) {
        _pagingController.appendLastPage(newItems);
      } else {
        _pagingController.appendPage(newItems, ++page);
      }
    } catch (error) {
      debugPrint(error.toString());
      _pagingController.error = error;
    }
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
        child: ListTile(
          title: Text(i.name),
          subtitle: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Text(i.productIdName),
              // Text(i.count),
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
        body: FListPage(
          pagingController: _pagingController,
          itemBuilder: (context, item, index) => widgetItemList(
            item,
          ),
        ),
      );
}
