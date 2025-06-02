import 'package:djadol_mobile/agen/jurnal/jurnal.dart';
import 'package:djadol_mobile/core/pages/async_value.dart';
import 'package:djadol_mobile/core/pages/empty_page.dart';
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
      print(result);
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
                // Image.network(
                //   value.photo,
                //   height: 200,
                //   width: 200,
                //   fit: BoxFit.cover,
                //   errorBuilder: (context, error, stackTrace) => Icon(
                //     Icons.image,
                //     color: Colors.grey,
                //     size: 100,
                //   ),
                // ),
                // const SizedBox(height: 20),
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
                              child: ListTile(
                                title: Text(detail.productIdName),
                                subtitle: Text(
                                    '${detail.count} x ${detail.price.toString().toCurrency()}'),
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
