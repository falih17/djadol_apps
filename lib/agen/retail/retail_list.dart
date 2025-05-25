import 'package:djadol_mobile/core/widgets/zui.dart';
import 'package:flutter/material.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import '../../core/utils/api_service.dart';
import '../../core/widgets/flist_page.dart';
import 'retail.dart';
import 'retail_add.dart';

class RetailListPage extends StatefulWidget {
  const RetailListPage({super.key});

  @override
  State<RetailListPage> createState() => _RetailListPageState();
}

class _RetailListPageState extends State<RetailListPage> {
  static const _pageSize = 20;
  final PagingController<int, Retail> _pagingController =
      PagingController(firstPageKey: 0);
  String _searchTerm = '';
  bool _searchState = false;

  @override
  void initState() {
    super.initState();
    _pagingController.addPageRequestListener(_fetchPage);
  }

  Future<void> _fetchPage(int page) async {
    try {
      Map<String, dynamic> params = {
        'page': page,
        'size': _pageSize,
        'name': _searchTerm
      };
      List result =
          await ApiService().getList('/all/31', page, _pageSize, data: params);
      List<Retail> newItems = result.map((i) => Retail.fromMap(i)).toList();
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
    await ApiService().delete('Retail', id, context: context);
    _pagingController.refresh();
  }

  Widget widgetItemList(Retail i) {
    return ProductCard(
      name: i.name,
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
          title: const Text('Retail'),
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
                itemBuilder: (context, item, index) => widgetItemList(
                  item,
                ),
              ),
            ),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            // showModalBottomSheet(
            //   context: context,
            //   clipBehavior: Clip.antiAliasWithSaveLayer,
            //   builder: (BuildContext context) {
            //     return const RetailAddPage();
            //   },
            // )
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const RetailAddPage(),
              ),
            ).then((v) {
              if (v != null) _pagingController.refresh();
            });
          },
          child: const Icon(Icons.add),
        ),
      );
}
