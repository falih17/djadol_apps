import 'package:djadol_mobile/core/widgets/zui.dart';
import 'package:flutter/material.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import '../../core/utils/api_service.dart';
import '../../core/widgets/flist_page.dart';
import 'jurnal.dart';
import 'jurnal_add.dart';

class JurnalListPage extends StatefulWidget {
  const JurnalListPage({super.key});

  @override
  State<JurnalListPage> createState() => _JurnalListPageState();
}

class _JurnalListPageState extends State<JurnalListPage> {
  static const _pageSize = 20;
  final PagingController<int, Jurnal> _pagingController =
      PagingController(firstPageKey: 0);

  @override
  void initState() {
    super.initState();
    _pagingController.addPageRequestListener(_fetchPage);
  }

  Future<void> _fetchPage(int page) async {
    try {
      List result = await ApiService().getList('/all/33', page, _pageSize);
      print(result);
      List<Jurnal> newItems = result.map((i) => Jurnal.fromMap(i)).toList();
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
    await ApiService().delete('Jurnal', id, context: context);
    _pagingController.refresh();
  }

  Widget widgetItemList(Jurnal i) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => JurnalAddPage(item: i),
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
      child: Card(
        child: ListTile(
          title: Text(i.retailIdName),
          subtitle: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(i.productIdName),
              Text(i.count),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: const Text('Jurnal'),
        ),
        body: FListPage(
          pagingController: _pagingController,
          itemBuilder: (context, item, index) => widgetItemList(
            item,
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            // showModalBottomSheet(
            //   context: context,
            //   clipBehavior: Clip.antiAliasWithSaveLayer,
            //   builder: (BuildContext context) {
            //     return const JurnalAddPage();
            //   },
            // )
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
