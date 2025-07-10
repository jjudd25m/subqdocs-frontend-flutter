import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../utils/app_colors.dart';
import '../../../../../utils/app_fonts.dart';
import '../../../../../widget/custom_search_bar.dart';
import '../../../../../widget/keyboard_dismiss_on_tap.dart';
import '../../../../core/common/global_controller.dart';
import '../../../../core/common/logger.dart';
import '../../../visit_main/model/doctor_view_model.dart';
import '../../controllers/patient_info_controller.dart';
import '../../model/get_CPT_code_model.dart';

class DropDrownSearchTable extends StatefulWidget {
  PatientInfoController controller;
  final GlobalKey? procedureContainerKey;
  final List<ProcedurePossibleAlternatives> items;
  final int tableRowIndex;
  final Function(ProcedurePossibleAlternatives, int) onItemSelected;
  final Function() onInitCallBack;
  final Function(String, String) onSearchItemSelected;

  DropDrownSearchTable({super.key, required this.controller, this.procedureContainerKey, required this.items, required this.onItemSelected, required this.onInitCallBack, required this.tableRowIndex, required this.onSearchItemSelected});

  @override
  State<DropDrownSearchTable> createState() => _DropDrownSearchTableState();
}

class _DropDrownSearchTableState extends State<DropDrownSearchTable> {
  bool isLoading = false;
  bool isPaginationLoading = false;
  int page = 1;
  Timer? timer;
  final GlobalController globalController = Get.find();
  late List<ProcedurePossibleAlternatives> filteredItems = [];
  TextEditingController searchController = TextEditingController();
  List<GetCPTCodeResponseDataData> cptCodeList = [];
  bool isValid = true;

  @override
  void initState() {
    super.initState();

    filteredItems = List.from(widget.items);
    getCPTCode(isShowLoading: true);

    widget.onInitCallBack();
  }

  void _filterItems(String query) {
    setState(() {
      filteredItems = widget.items.where((item) => (item.description ?? "").toLowerCase().contains(query.toLowerCase()) || (item.code ?? "").toLowerCase().contains(query.toLowerCase())).toList();
    });
  }

  @override
  void dispose() {
    timer?.cancel();
    timer = null;
    super.dispose();
  }

  void onSearch() {
    timer?.cancel();
    timer = Timer(const Duration(milliseconds: 500), () {
      page = 1;
      cptCodeList.clear();
      getCPTCode(isShowLoading: true);
    });
  }

  Future<bool> getCPTCode({bool isShowLoading = false, bool isShowPaginationLoading = false}) async {
    if (isShowLoading) {
      isLoading = true;
    }

    if (isShowPaginationLoading) {
      isPaginationLoading = true;
    }
    setState(() {});

    Map<String, dynamic> param = {};
    param['page'] = page;
    param['limit'] = "100";

    if (searchController.text.isNotEmpty) {
      param['search'] = searchController.text.trim();
    }

    GetCPTCodeModel getCPTCodeModel = await widget.controller.getCPTCodeAll(param);

    if (isShowLoading) {
      isLoading = false;
    }

    if (isShowPaginationLoading) {
      isPaginationLoading = false;
    }

    cptCodeList.addAll(getCPTCodeModel.responseData?.data ?? []);

    setState(() {});

    return true;

    // widget
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.white,
      child: KeyboardDismissOnTap(
        child: SingleChildScrollView(
          // physics: const ClampingScrollPhysics(), // Add this
          child: Container(
            height: 250,
            // height: 250 + (MediaQuery.of(context).viewInsets.bottom / 2.25),
            color: Colors.white,
            child: Column(
              children: [
                Container(
                  // height: 50,
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                  child: CustomSearchBar(
                    onTap: (value) {
                      final context = widget.procedureContainerKey?.currentContext;
                      if (context != null) {
                        Scrollable.ensureVisible(context, duration: const Duration(milliseconds: 500), curve: Curves.easeInOut);
                      }
                    },
                    controller: searchController,
                    hintText: 'Search',
                    onChanged: (text) {
                      customPrint('Search text changed: $text');
                      page = 1;
                      cptCodeList.clear();
                      onSearch();
                      _filterItems(searchController.text);
                    },
                    onSubmit: (text) {
                      customPrint('Submitted search: $text');

                      if (text.isNotEmpty) {
                        setState(() {
                          cptCodeList.clear();
                          searchController.clear();
                          isValid = false;
                        });
                        _filterItems(searchController.text);
                        page = 1;
                        onSearch();
                      }

                      // Perform search operation here
                    },
                  ),
                ),
                // Text("count ${widget.icd10CodeList.length}"),
                const SizedBox(height: 3),
                Expanded(
                  child: NotificationListener<ScrollEndNotification>(
                    onNotification: (notification) {
                      // // If user reaches the bottom and no data is being loaded
                      if (notification.metrics.extentBefore == notification.metrics.maxScrollExtent && !isLoading) {
                        customPrint("notification.metrics.extentBefore == notification.metrics.maxScrollExtent && !isLoading");
                        page = page + 1;
                        // getIcd10Code();
                        getCPTCode(isShowPaginationLoading: true);
                      }
                      return false; // Allow other notifications to propagate
                    },
                    child: SingleChildScrollView(
                      physics: const BouncingScrollPhysics(),
                      child: Column(
                        children: [
                          if (isLoading) ...[
                            const SizedBox(height: 10),
                            const Center(child: CircularProgressIndicator(color: AppColors.textPurple, strokeWidth: 2)),
                            const SizedBox(height: 10),
                          ] else ...[
                            if (filteredItems.isNotEmpty || cptCodeList.isNotEmpty) ...[
                              if (filteredItems.isNotEmpty) ...[
                                const SizedBox(height: 0),
                                Padding(padding: const EdgeInsets.all(10), child: Row(children: [Text("Pin", style: AppFonts.regular(14, AppColors.black)), const Spacer()])),
                                const SizedBox(height: 0),
                                Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 10),
                                  child: ListView.builder(
                                    padding: EdgeInsets.zero,
                                    shrinkWrap: true,
                                    physics: const NeverScrollableScrollPhysics(),
                                    itemCount: filteredItems.length,
                                    itemBuilder: (_, index) {
                                      return GestureDetector(
                                        onTap: () {
                                          FocusScope.of(context).unfocus(); // Removes focus and hides keyboard
                                          widget.onItemSelected(filteredItems[index], index);
                                        },
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(vertical: 5),
                                          child: Container(
                                            decoration: BoxDecoration(color: widget.items[index].isPin ? AppColors.dropdownicdCodeBackgroundColor.withValues(alpha: 0.5) : AppColors.clear, borderRadius: BorderRadius.circular(6)),
                                            padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 5),
                                            child: Row(
                                              children: [
                                                Expanded(
                                                  child: RichText(
                                                    text: TextSpan(children: [TextSpan(text: "${filteredItems[index].code}", style: AppFonts.medium(14, AppColors.black)), TextSpan(text: (filteredItems[index].shortDescription?.isNotEmpty ?? false) ? ' (${filteredItems[index].shortDescription})' : ' (${filteredItems[index].description})', style: AppFonts.regular(14, AppColors.textGreyTable))]),
                                                  ),
                                                ),
                                              ],
                                            ),
                                            // Text("(${filteredItems[index].code}) ${filteredItems[index].description}", style: AppFonts.regular(12, AppColors.black)))]),
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                ),
                              ],
                              if (filteredItems.isNotEmpty) ...[const SizedBox(height: 10), const Divider(height: 0.5, thickness: 1)],
                              if (cptCodeList.isNotEmpty) ...[
                                const SizedBox(height: 5),
                                Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 10),
                                  child: ListView.builder(
                                    shrinkWrap: true,
                                    padding: EdgeInsets.zero,
                                    physics: const NeverScrollableScrollPhysics(),
                                    itemCount: cptCodeList.length,
                                    itemBuilder: (_, index) {
                                      return GestureDetector(
                                        onTap: () {
                                          widget.onSearchItemSelected(cptCodeList[index].code ?? "", cptCodeList[index].description ?? "");
                                        },
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(vertical: 5),
                                          child: Container(
                                            padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 5),
                                            child: Row(
                                              children: [
                                                Expanded(child: RichText(text: TextSpan(children: [TextSpan(text: "${cptCodeList[index].code}", style: AppFonts.medium(14, AppColors.black)), TextSpan(text: ' (${cptCodeList[index].description})', style: AppFonts.regular(14, AppColors.textDarkGrey))]))),
                                              ], // Text("(${widget.icd10CodeList[index].code}) ${widget.icd10CodeList[index].description}", style: AppFonts.regular(12, AppColors.black)))],
                                            ),
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                ),
                                if (isPaginationLoading) ...[const SizedBox(height: 10), const Center(child: CircularProgressIndicator(color: AppColors.textPurple, strokeWidth: 2)), const SizedBox(height: 10)],
                              ],
                            ],
                            if (filteredItems.isEmpty && cptCodeList.isEmpty) ...[Text("No data found!", textAlign: TextAlign.start, style: AppFonts.regular(14, AppColors.textDarkGrey))],
                          ],
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // @override
  // Widget build(BuildContext context) {
  //   return Material(
  //     color: AppColors.white,
  //     child: KeyboardDismissOnTap(
  //       child: SingleChildScrollView(
  //         child: Container(
  //           height: 250,
  //           // height: 250 + (MediaQuery.of(context).viewInsets.bottom / 2.5),
  //           padding: const EdgeInsets.all(10),
  //           color: Colors.white,
  //           child: Column(
  //             mainAxisSize: MainAxisSize.min,
  //             children: [
  //               SizedBox(
  //                 // height: 40,
  //                 child: CustomSearchBar(
  //                   onTap: (value) {
  //                     final context = widget.procedureContainerKey?.currentContext;
  //                     if (context != null) {
  //                       Scrollable.ensureVisible(context, duration: Duration(milliseconds: 500), curve: Curves.easeInOut);
  //                     }
  //                   },
  //                   controller: searchController,
  //                   hintText: 'Search',
  //                   onChanged: (text) {
  //                     print('Search text changed: $text');
  //                     setState(() {
  //                       _filterItems(searchController.text);
  //                     });
  //                   },
  //                   onSubmit: (text) {
  //                     print('Submitted search: $text');
  //                     setState(() {});
  //                     _filterItems(searchController.text);
  //                     // Perform search operation here
  //                   },
  //                 ),
  //               ),
  //               const SizedBox(height: 3),
  //               if (filteredItems.isEmpty) ...[
  //                 const SizedBox(height: 10),
  //                 Text("No data found!", textAlign: TextAlign.start, style: AppFonts.regular(14, AppColors.textDarkGrey)),
  //               ] else ...[
  //                 const SizedBox(height: 10),
  //                 ConstrainedBox(
  //                   constraints: const BoxConstraints(maxHeight: 160),
  //                   child: ListView.builder(
  //                     padding: EdgeInsets.zero,
  //                     shrinkWrap: true,
  //                     itemCount: filteredItems.length,
  //                     itemBuilder: (_, index) {
  //                       return GestureDetector(
  //                         onTap: () {
  //                           widget.onItemSelected(filteredItems[index], index);
  //                         },
  //                         child: Padding(
  //                           padding: const EdgeInsets.symmetric(vertical: 5),
  //                           child: Container(
  //                             decoration: BoxDecoration(color: widget.items[index].isPin ? AppColors.dropdownicdCodeBackgroundColor.withValues(alpha: 0.5) : AppColors.clear, borderRadius: BorderRadius.circular(6)),
  //                             padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 5),
  //                             child: Row(
  //                               children: [
  //                                 Expanded(
  //                                   child: Padding(
  //                                     padding: const EdgeInsets.symmetric(horizontal: 5),
  //                                     child: RichText(text: TextSpan(children: [TextSpan(text: "${filteredItems[index].code}", style: AppFonts.medium(14, AppColors.black)), TextSpan(text: ' (${filteredItems[index].description})', style: AppFonts.regular(14, AppColors.textDarkGrey))])),
  //                                   ),
  //                                 ),
  //                               ],
  //                             ),
  //                           ),
  //                         ),
  //                       );
  //                     },
  //                   ),
  //                 ),
  //               ],
  //             ],
  //           ),
  //         ),
  //       ),
  //     ),
  //   );
  // }
}
