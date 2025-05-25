import 'package:djadol_mobile/core/widgets/zui.dart';
import 'package:flutter/material.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import '../../core/utils/api_service.dart';
import '../../core/widgets/flist_page.dart';
import 'absent.dart';
import 'absent_add.dart';

class AbsentListPage extends StatefulWidget {
  final bool type;
  const AbsentListPage({super.key, required this.type});

  @override
  State<AbsentListPage> createState() => _AbsentListPageState();
}

class _AbsentListPageState extends State<AbsentListPage> {
  static const _pageSize = 20;
  final PagingController<int, Absent> _pagingController =
      PagingController(firstPageKey: 0);

  @override
  void initState() {
    super.initState();
    _pagingController.addPageRequestListener(_fetchPage);
  }

  Future<void> _fetchPage(int page) async {
    try {
      String formId = widget.type ? '41' : '42';
      List result = await ApiService().getList('/all/$formId', page, _pageSize);
      List<Absent> newItems = result.map((i) => Absent.fromMap(i)).toList();
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
    await ApiService().delete('Absent', id, context: context);
    _pagingController.refresh();
  }

  Widget widgetItemList(Absent i) {
    return InkWell(
      onTap: () {},
      onLongPress: () async {
        if (await confirmDanger(context, title: 'Delete')) {
          delete(i.id);
        }
      },
      child: ZCard(
        title: i.createdAt,
        icon: Icons.gps_fixed,
      ),
    );
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: Text(widget.type ? 'Presensi Masuk' : ' Presensi Pulang'),
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
            //     return const AbsentAddPage();
            //   },
            // )
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => AbsentAddPage(
                  type: widget.type,
                ),
              ),
            ).then((v) {
              if (v != null) _pagingController.refresh();
            });
          },
          child: const Icon(Icons.add),
        ),
      );
}
