// ignore_for_file: must_be_immutable

import 'package:cached_network_image/cached_network_image.dart';
import 'package:craft_dynamic/src/util/widget_util.dart';
import 'package:flutter/material.dart';
import 'package:craft_dynamic/craft_dynamic.dart';

class ListWidget extends StatelessWidget {
  ListWidget(
      {Key? key,
      required this.scrollable,
      this.dynamicList = const [],
      this.summary = const [],
      this.controlID,
      this.serviceParamID,
      this.moduleItem})
      : super(key: key);

  final bool scrollable;
  String? controlID, serviceParamID;
  ModuleItem? moduleItem;
  List<dynamic>? dynamicList, summary;

  List<Map> mapItems = [];
  List<Map> summaryItems = [];

  @override
  Widget build(BuildContext context) {
    // return Text(jsonTxt!.toString());
    mapItems.clear();
    summaryItems.clear();

    if (dynamicList != null) {
      for (var item in dynamicList ?? []) {
        mapItems.add(item);
      }
    }

    if (summary != null) {
      for (var item in summary ?? []) {
        summaryItems.add(item);
      }
    }

    AppLogger.appLogD(tag: "summary list", message: summaryItems);

    return dynamicList != null && dynamicList!.isNotEmpty
        ? Column(children: [
            summaryItems.isNotEmpty
                ? Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "Summary",
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 20),
                        ),
                        ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: summaryItems.length,
                          itemBuilder: (context, index) {
                            var mapItem = summaryItems[index];
                            mapItem.removeWhere(
                                (key, value) => key == null || value == null);
                            return Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 0, vertical: 0.0),
                                child: Column(
                                  mainAxisSize: MainAxisSize.max,
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 4.0, vertical: 0.0),
                                      child: Column(
                                        children: mapItem
                                            .map((key, value) => MapEntry(
                                                key,
                                                Container(
                                                    padding: const EdgeInsets
                                                        .symmetric(vertical: 2),
                                                    child: Column(
                                                      children: [
                                                        Row(
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .spaceBetween,
                                                          children: [
                                                            Text(
                                                              "$key:",
                                                              style: TextStyle(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                  color: Theme.of(
                                                                          context)
                                                                      .primaryColor),
                                                            ),
                                                            Flexible(
                                                                child: Text(
                                                              value.toString(),
                                                              style: TextStyle(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .normal,
                                                                  color: WidgetUtil
                                                                      .getTextColor(
                                                                          value
                                                                              .toString(),
                                                                          key.toString())),
                                                              textAlign:
                                                                  TextAlign
                                                                      .right,
                                                            )),
                                                          ],
                                                        ),
                                                        const Divider(
                                                          color: Colors.grey,
                                                        )
                                                      ],
                                                    ))))
                                            .values
                                            .toList(),
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 12,
                                    )
                                  ],
                                ));
                          },
                        ),
                        Divider(
                          height: 1,
                          color: Theme.of(context).primaryColor.withOpacity(.6),
                        )
                      ],
                    ))
                : const SizedBox(),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4),
              child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("${mapItems.length} transactions found"),
                    CachedNetworkImage(
                      imageUrl: moduleItem?.moduleUrl ?? "",
                      errorWidget: (context, url, error) => const SizedBox(),
                      height: 64,
                      width: 64,
                      fit: BoxFit.contain,
                    )
                  ]),
            ),
            const SizedBox(
              height: 4,
            ),
            Expanded(
                child: ListView.builder(
              shrinkWrap: true,
              itemCount: mapItems.length,
              padding: const EdgeInsets.symmetric(horizontal: 4),
              itemBuilder: (context, index) {
                var mapItem = mapItems[index];
                var status = mapItem["Status"]?.toLowerCase();
                Color color = getItemColor(context, status);

                mapItem
                    .removeWhere((key, value) => key == null || value == null);
                return Card(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8)),
                    child: InkWell(
                        borderRadius: BorderRadius.circular(8),
                        onTap: () {
                          PDFUtil.downloadReceipt(
                              receiptdetails: mapItem as Map<String, dynamic>);
                        },
                        child: IntrinsicHeight(
                            child: Row(
                          children: [
                            Container(
                              width: 12,
                              decoration: BoxDecoration(
                                  color: color,
                                  borderRadius: const BorderRadius.only(
                                      topLeft: Radius.circular(8),
                                      bottomLeft: Radius.circular(8))),
                            ),
                            Expanded(
                                child: Column(children: [
                              Container(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 4.0),
                                child: Column(
                                  children: mapItem
                                      .map((key, value) => MapEntry(
                                          key,
                                          Container(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      vertical: 4,
                                                      horizontal: 4),
                                              child: Column(
                                                children: [
                                                  Row(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
                                                      Text(
                                                        "$key:",
                                                        style: TextStyle(
                                                            color: Theme.of(
                                                                    context)
                                                                .primaryColor),
                                                      ),
                                                      Flexible(
                                                          child: Text(
                                                        value.toString(),
                                                        style: TextStyle(
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            fontSize: 12,
                                                            color: getTextColor(
                                                                context,
                                                                value
                                                                    .toString()
                                                                    .toLowerCase())),
                                                        textAlign:
                                                            TextAlign.right,
                                                      ))
                                                    ],
                                                  ),
                                                ],
                                              ))))
                                      .values
                                      .toList(),
                                ),
                              ),
                            ])),
                          ],
                        ))));
              },
            ))
          ])
        : Center(
            child: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                "packages/craft_dynamic/assets/images/empty.png",
                height: 64,
                width: 64,
                fit: BoxFit.cover,
              ),
              const SizedBox(
                height: 14,
              ),
              Text(
                "Nothing found!",
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: APIService.appPrimaryColor),
              )
            ],
          ));
  }

  Color getItemColor(BuildContext context, String? status) {
    if (status == "success") {
      return Colors.green;
    }
    if (status == "fail") {
      return Colors.red;
    }
    if (status == "pending" || status == "processing") {
      return Colors.blue;
    }
    return Colors.white;
  }

  Color getTextColor(BuildContext context, String? status) {
    if (status == "success") {
      return Colors.green;
    }
    if (status == "fail") {
      return Colors.red;
    }
    if (status == "pending" || status == "processing") {
      return Colors.blue;
    }
    return Colors.black;
  }
}
