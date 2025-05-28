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

  Future<List<Absent>> fetchPage(int page) async {
    try {
      String formId = widget.type ? '41' : '42';
      List result = await ApiService().getList('/all/$formId', page, _pageSize);
      List<Absent> newItems = result.map((i) => Absent.fromMap(i)).toList();
      return newItems;
    } catch (error) {
      debugPrint(error.toString());
    }
    return [];
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
