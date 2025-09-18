import 'zcard.dart';
import 'zinput_search.dart';
import 'zinput_style.dart';
import 'package:flutter/material.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:djadol_mobile/core/utils/store.dart';


import '../utils/api_service.dart';
import 'flist_page.dart';

class ZInputSelect extends StatefulWidget {
  final String? label;
  final String url;
  final String vKey;
  final String vData;
  final String? vDesc;
  final String? id;
  final String? vDisplay;

  final ValueChanged<String> onChanged;
  const ZInputSelect({
    super.key,
    this.label,
    required this.url,
    required this.onChanged,
    this.vKey = 'id',
    this.vData = 'name',
    this.vDesc,
    this.id,
    this.vDisplay,
  });

  @override
  State<ZInputSelect> createState() => _ZInputSelectState();
}

class _ZInputSelectState extends State<ZInputSelect> {
  String display = 'Select';

  @override
  void initState() {
    super.initState();
    // getOneData();
  }

  Future<void> getOneData() async {
    if (widget.id != null) {
      final result = await ApiService().get(
        '${widget.url}/${widget.id}',
      );
      setState(() {
        display = result[widget.vData];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.label != null) ...[
          Padding(
            padding: const EdgeInsets.only(top: 10),
            child: Text(
              widget.label!,
              style: inputLabelStyle,
            ),
          )
        ],
        ZInputContainer(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 12),
            child: InkWell(
              child: Row(
                children: [
                  Expanded(child: Text(widget.vDisplay ?? display)),
                  const Icon(Icons.arrow_drop_down)
                ],
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ZInputSelectPage(
                      title: widget.label ?? 'Select',
                      url: widget.url,
                      vKey: widget.vKey,
                      vData: widget.vData,
                      vDesc: widget.vDesc,
                    ),
                  ),
                ).then((v) {
                  if (v != null) {
                    setState(() {
                      display = v[widget.vData];
                      widget.onChanged(v[widget.vKey]);
                    });
                  }
                });
              },
            ),
          ),
        ),
      ],
    );
  }
}

class ZInputSelectPage extends StatefulWidget {
  final String title;
  final String url;
  final String vKey;
  final String vData;
  final String? vDesc;
  const ZInputSelectPage({
    super.key,
    required this.title,
    required this.url,
    required this.vKey,
    required this.vData,
    this.vDesc,
  });

  @override
  State<ZInputSelectPage> createState() => _ZInputSelectPageState();
}

class _ZInputSelectPageState extends State<ZInputSelectPage> {
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

  Future<List<dynamic>> fetchPage(
    int page,
  ) async {
    try {
      var data = {'name': _searchTerm,'created_by':Store().userId};
      List<dynamic> newItems =
          await ApiService().getList(widget.url, page, _pageSize, data: data);
      return newItems;
    } catch (error) {
      debugPrint(error.toString());
    }
    return [];
  }

  Widget widgetItemList(Map i) {
    return InkWell(
      onTap: () {
        Navigator.pop(context, i);
      },
      child: ZCard(title: i[widget.vData],subtitle:(widget.vDesc != null)?i[widget.vDesc] :null,),
    );
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
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
