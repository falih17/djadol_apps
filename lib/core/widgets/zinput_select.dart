import 'zinput_style.dart';
import 'package:flutter/material.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

import '../utils/api_service.dart';
import 'flist_page.dart';
import 'zcard.dart';

class ZInputSelect extends StatefulWidget {
  final String? label;
  final String url;
  final String vKey;
  final String vData;
  final String? id;

  final ValueChanged<String> onChanged;
  const ZInputSelect({
    super.key,
    required this.label,
    required this.url,
    required this.onChanged,
    this.vKey = 'id',
    this.vData = 'name',
    this.id,
  });

  @override
  State<ZInputSelect> createState() => _ZInputSelectState();
}

class _ZInputSelectState extends State<ZInputSelect> {
  String display = 'Select';

  @override
  void initState() {
    super.initState();
    getOneData();
  }

  Future<void> getOneData() async {
    if (widget.id!.isNotEmpty) {
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
                  Expanded(child: Text(display)),
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
  const ZInputSelectPage({
    super.key,
    required this.title,
    required this.url,
    required this.vKey,
    required this.vData,
  });

  @override
  State<ZInputSelectPage> createState() => _ZInputSelectPageState();
}

class _ZInputSelectPageState extends State<ZInputSelectPage> {
  static const _pageSize = 20;
  final PagingController<int, dynamic> _pagingController =
      PagingController(firstPageKey: 1);

  @override
  void initState() {
    super.initState();
    _pagingController.addPageRequestListener(_fetchPage);
  }

  Future<void> _fetchPage(int page) async {
    try {
      List<dynamic> newItems =
          await ApiService().getList(widget.url, page, _pageSize);
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

  Widget widgetItemList(Map i) {
    return InkWell(
      onTap: () {
        Navigator.pop(context, i);
      },
      child: ZCard(title: i[widget.vData]),
    );
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
        ),
        body: FListPage(
          pagingController: _pagingController,
          itemBuilder: (context, item, index) => widgetItemList(
            item,
          ),
        ),
      );
}
