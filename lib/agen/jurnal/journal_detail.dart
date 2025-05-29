import 'package:djadol_mobile/agen/jurnal/jurnal.dart';
import 'package:djadol_mobile/core/pages/async_value.dart';
import 'package:djadol_mobile/core/utils/ext_currency.dart';
import 'package:flutter/material.dart';

import '../../core/utils/api_service.dart';

class JurnalDetailPage extends StatelessWidget {
  final Jurnal item;
  const JurnalDetailPage({super.key, required this.item});

  Future<AsyncValue<Jurnal>> fetchData() async {
    try {
      await Future.delayed(const Duration(milliseconds: 1000));
      final data = {
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
        title: const Text('Journal Detail'),
      ),
      body: ZPageFuture<Jurnal>(
        future: fetchData(),
        success: (value) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(value.retailIdName,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    )),
                const SizedBox(height: 20),
                Expanded(
                  child: ListView.builder(
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
              ],
            ),
          );
        },
      ),
    );
  }
}
