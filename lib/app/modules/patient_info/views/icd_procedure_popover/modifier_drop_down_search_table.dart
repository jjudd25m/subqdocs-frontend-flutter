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
import '../../model/get_modifier_code_model.dart';

class ModifierDropDrownSearchTable extends StatefulWidget {
  final GlobalKey? procedureContainerKey;

  PatientInfoController controller;
  final int tableRowIndex;
  final List<ProcedurePossibleAlternatives> items;

  // final Function(ProcedurePossibleAlternatives, int) onItemSelected;
  final Function(String, String) onSearchItemSelected;
  final Function() onInitCallBack;

  ModifierDropDrownSearchTable({super.key, this.procedureContainerKey, required this.controller, required this.items, required this.onSearchItemSelected, required this.onInitCallBack, required this.tableRowIndex});

  @override
  State<ModifierDropDrownSearchTable> createState() => _ModifierDropDrownSearchTableState();
}

class _ModifierDropDrownSearchTableState extends State<ModifierDropDrownSearchTable> {
  final GlobalController globalController = Get.find();

  // late List<ProcedurePossibleAlternatives> filteredItems = [];
  TextEditingController searchController = TextEditingController();
  bool isLoading = false;
  bool isPaginationLoading = false;
  int page = 1;
  bool isValid = true;
  Timer? timer;
  List<GetModifierCodeResponseDataData> modifierCodeList = [];

  @override
  void initState() {
    super.initState();

    // filteredItems = List.from(widget.items);
    getModifierCode(isShowLoading: true);
    widget.onInitCallBack();
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
      modifierCodeList.clear();
      getModifierCode(isShowLoading: true);
    });
  }

  Future<bool> getModifierCode({bool isShowLoading = false, bool isShowPaginationLoading = false}) async {
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

    GetModifierCodeModel icd10codeListModel = await widget.controller.getModifierCodeAll(param);

    if (isShowLoading) {
      isLoading = false;
    }

    if (isShowPaginationLoading) {
      isPaginationLoading = false;
    }

    modifierCodeList.addAll(icd10codeListModel.responseData?.data ?? []);

    setState(() {});

    return true;

    // widget
  }

  // void _filterItems(String query) {
  //   setState(() {
  //     filteredItems = widget.items.where((item) => (item.description ?? "").toLowerCase().contains(query.toLowerCase()) || (item.code ?? "").toLowerCase().contains(query.toLowerCase())).toList();
  //   });
  // }

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
                      modifierCodeList.clear();
                      onSearch();
                      // _filterItems(searchController.text);
                    },
                    onSubmit: (text) {
                      customPrint('Submitted search: $text');

                      if (text.isNotEmpty) {
                        setState(() {
                          modifierCodeList.clear();
                          searchController.clear();
                          isValid = false;
                        });
                        // _filterItems(searchController.text);
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
                        getModifierCode(isShowPaginationLoading: true);
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
                            if (modifierCodeList.isNotEmpty) ...[
                              if (modifierCodeList.isNotEmpty) ...[
                                const SizedBox(height: 5),
                                Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 10),
                                  child: ListView.builder(
                                    shrinkWrap: true,
                                    padding: EdgeInsets.zero,
                                    physics: const NeverScrollableScrollPhysics(),
                                    itemCount: modifierCodeList.length,
                                    itemBuilder: (_, index) {
                                      return GestureDetector(
                                        onTap: () {
                                          widget.onSearchItemSelected(modifierCodeList[index].modifier ?? "", modifierCodeList[index].description ?? "");
                                        },
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(vertical: 5),
                                          child: Container(
                                            padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 5),
                                            child: Row(
                                              children: [
                                                Expanded(child: RichText(text: TextSpan(children: [TextSpan(text: "${modifierCodeList[index].modifier}", style: AppFonts.medium(14, AppColors.black)), TextSpan(text: ' (${modifierCodeList[index].description})', style: AppFonts.regular(14, AppColors.textDarkGrey))]))),
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
                            if (modifierCodeList.isEmpty) ...[Text("No data found!", textAlign: TextAlign.start, style: AppFonts.regular(14, AppColors.textDarkGrey))],
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
}
