import 'package:flutter/material.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import '../pages/connection_failed.dart';

class FListPage<T> extends StatelessWidget {
  final PagingController<int, T> pagingController;
  final Widget Function(BuildContext, T, int) itemBuilder;
  const FListPage(
      {super.key, required this.pagingController, required this.itemBuilder});

  @override
  Widget build(BuildContext context) {
    return PagedListView<int, T>(
      pagingController: pagingController,
      builderDelegate: PagedChildBuilderDelegate<T>(
        firstPageErrorIndicatorBuilder: (_) => ConnectionFailed(
          onPressed: pagingController.refresh,
        ),
        itemBuilder: itemBuilder,
      ),
    );
  }
}
