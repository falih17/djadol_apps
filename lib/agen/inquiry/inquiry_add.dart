import 'package:djadol_mobile/agen/inquiry/inquiry.dart';
import 'package:djadol_mobile/core/pages/async_value.dart';
import 'package:djadol_mobile/core/pages/empty_page.dart';
import 'package:djadol_mobile/core/widgets/zui.dart';
import 'package:flutter/material.dart';

import '../../core/utils/api_service.dart';

class InquiryDetailPage extends StatefulWidget {
  final Inquiry item;
  const InquiryDetailPage({super.key, required this.item});

  @override
  State<InquiryDetailPage> createState() => _InquiryDetailPageState();
}

class _InquiryDetailPageState extends State<InquiryDetailPage> {
  List<InquiryDetail> inquiryDetail = [];

  Future<AsyncValue<Inquiry>> fetchData() async {
    try {
      await Future.delayed(const Duration(milliseconds: 1000));
      Map<String, dynamic> data = {
        'jurnal_id': widget.item.id,
      };
      List result = await ApiService().getList('/all/46', 0, 1000, data: data);
      inquiryDetail = result.map((i) => InquiryDetail.fromMap(i)).toList();
      return AsyncValue.success(widget.item);
    } catch (e) {
      debugPrint(e.toString());
      return AsyncValue.failure("Error Loading Data");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Daftar Barang'),
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
      body: ZPageFuture<Inquiry>(
        future: fetchData(),
        success: (value) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(widget.item.description,
                    style:
                        TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                SizedBox(
                  height: 10,
                ),
                Expanded(
                  child: (inquiryDetail.isEmpty)
                      ? EmptyPage()
                      : ListView.builder(
                          itemCount: inquiryDetail.length,
                          itemBuilder: (context, index) {
                            final detail = inquiryDetail[index];
                            return Card(
                              color: Colors.white,
                              child: Row(
                                children: [
                                  // Padding(
                                  //   padding: const EdgeInsets.all(8.0),
                                  //   child: ClipRRect(
                                  //     borderRadius: BorderRadius.circular(8),
                                  //     child: detail.picture.isNotEmpty
                                  //         ? Image.network(
                                  //             detail.picture,
                                  //             width: 60,
                                  //             height: 60,
                                  //             fit: BoxFit.cover,
                                  //           )
                                  //         : Container(
                                  //             width: 60,
                                  //             height: 60,
                                  //             color: Colors.grey[200],
                                  //             child: const Icon(
                                  //               Icons.image,
                                  //               color: Colors.grey,
                                  //               size: 32,
                                  //             ),
                                  //           ),
                                  //   ),
                                  // ),
                                  Flexible(
                                    child: ListTile(
                                      title: Text(
                                        '${index + 1}. ${detail.productName}',
                                        style: TextStyle(
                                          fontSize: 12,
                                        ),
                                      ),
                                      trailing: Text(
                                        '${detail.count}',
                                        style: TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      // subtitle: Row(
                                      //   mainAxisAlignment:
                                      //       MainAxisAlignment.spaceBetween,
                                      //   children: [
                                      //     Text(
                                      //         '${detail.count} x ${detail.price.toString().toCurrency()}'),
                                      //     Text(
                                      //       (detail.subtotal * -1)
                                      //           .toString()
                                      //           .toCurrency(),
                                      //       style: TextStyle(
                                      //         fontSize: 16,
                                      //         fontWeight: FontWeight.bold,
                                      //         color: Constants.mColorBlue,
                                      //       ),
                                      //     ),
                                      //   ],
                                      // ),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                ),
                (widget.item.status == 'diterima')
                    ? Text(
                        'Sudah diterima',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      )
                    : Padding(
                        padding: const EdgeInsets.all(30),
                        child: ZButton(
                          text: 'Terima Ploting',
                          onPressed: () async {
                            bool? result = await showDialog(
                              context: context,
                              builder: (context) => AlertDialog(
                                title: const Text('Konfirmasi'),
                                content: const Text(
                                    'Apakah anda yakin ingin menerima ploting ini?'),
                                actions: [
                                  TextButton(
                                    onPressed: () =>
                                        Navigator.of(context).pop(false),
                                    child: const Text('Batal'),
                                  ),
                                  ElevatedButton(
                                    onPressed: () =>
                                        Navigator.of(context).pop(true),
                                    child: const Text('Terima'),
                                  ),
                                ],
                              ),
                            );
                            if (result == true) {
                              Map<String, dynamic> data = {
                                'id': widget.item.id,
                                'form_id': 45,
                                'status': 'diterima',
                                'description': widget.item.description,
                                'agen_id': widget.item.agenId,
                              };
                              await ApiService()
                                  .post('/form_action', data)
                                  .then((value) {
                                Navigator.pop(context, true);
                              });
                            }
                          },
                        ),
                      ),
                // Padding(
                //   padding: const EdgeInsets.all(20),
                //   child: Row(
                //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                //     children: [
                //       const Text(
                //         'Total: ',
                //         style: TextStyle(
                //           fontSize: 20,
                //           fontWeight: FontWeight.bold,
                //         ),
                //       ),
                //       // Text(
                //       //   value.total.toString().toCurrency(),
                //       //   style: const TextStyle(
                //       //     fontSize: 20,
                //       //     fontWeight: FontWeight.bold,
                //       //   ),
                //       // ),
                //     ],
                //   ),
                // ),
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
