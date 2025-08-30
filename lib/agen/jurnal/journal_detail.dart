import 'package:djadol_mobile/agen/jurnal/jurnal.dart';
import 'package:djadol_mobile/core/pages/async_value.dart';
import 'package:djadol_mobile/core/pages/empty_page.dart';
import 'package:djadol_mobile/core/utils/constans.dart';
import 'package:djadol_mobile/core/utils/ext_currency.dart';
import 'package:flutter/material.dart';

import '../../core/utils/api_service.dart';

class JurnalDetailPage extends StatelessWidget {
  final Jurnal item;
  const JurnalDetailPage({super.key, required this.item});

  Future<AsyncValue<Jurnal>> fetchData() async {
    try {
      await Future.delayed(const Duration(milliseconds: 1000));
      Map<String, dynamic> data = {
        'jurnal_id': item.id,
      };
      List result = await ApiService().getList('/all/33', 0, 1000, data: data);
      item.detail = result.map((i) => JurnalDetail.fromMap(i)).toList();
      return AsyncValue.success(item);
    } catch (e) {
      debugPrint(e.toString());
      return AsyncValue.failure("Error Loading Data");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Sales'),
        // title: Row(
        //   mainAxisAlignment: MainAxisAlignment.center,
        //   children: [
        //     Text(item.retailIdName),
        //     item.isNew == '1'
        //         ? const Icon(Icons.new_releases, color: Colors.green)
        //         : const SizedBox.shrink()
        //   ],
        // ),
      ),
      body: ZPageFuture<Jurnal>(
        future: fetchData(),
        success: (value) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(item.retailIdName,
                    style:
                        TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                SizedBox(
                  height: 10,
                ),
                Expanded(
                  child: (value.detail.isEmpty)
                      ? EmptyPage()
                      : ListView.builder(
                          itemCount: value.detail.length,
                          itemBuilder: (context, index) {
                            final detail = value.detail[index];
                            return Card(
                              color: Colors.white,
                              child: Row(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(8),
                                      child: detail.picture.isNotEmpty
                                          ? Image.network(
                                              detail.picture,
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
                                  ),
                                  Flexible(
                                    child: ListTile(
                                      title: Text(
                                        detail.productName,
                                        style: TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      subtitle: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                              '${detail.count} x ${detail.price.toString().toCurrency()}'),
                                          Text(
                                            (detail.subtotal * -1)
                                                .toString()
                                                .toCurrency(),
                                            style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                              color: Constants.mColorBlue,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                ),
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Total: ',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        value.total.toString().toCurrency(),
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 20,
                )
              ],
            ),
          );
        },
      ),
    );
  }
}
