import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:subqdocs/utils/imagepath.dart';

import '../../../../utils/app_colors.dart';
import '../../../../utils/app_fonts.dart';
import '../../../../widgets/custom_textfiled.dart';
import '../../visit_main/model/doctor_view_model.dart';
import '../controllers/patient_info_controller.dart';
import '../model/icd10_code_list_model.dart';

class DropDrownSearchTable extends StatefulWidget {
  final List<ProcedurePossibleAlternatives> items;
  final Function(ProcedurePossibleAlternatives, int) onItemSelected;
  final Function() onInitCallBack;

  DropDrownSearchTable({Key? key, required this.items, required this.onItemSelected, required this.onInitCallBack}) : super(key: key);

  @override
  State<DropDrownSearchTable> createState() => _DropDrownSearchTableState();
}

class _DropDrownSearchTableState extends State<DropDrownSearchTable> {
  late List<ProcedurePossibleAlternatives> filteredItems = [];
  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();

    filteredItems = List.from(widget.items);
    widget.onInitCallBack();
  }

  void _filterItems(String query) {
    setState(() {
      filteredItems = widget.items.where((item) => (item.description ?? "").toLowerCase().contains(query.toLowerCase()) || (item.code ?? "").toLowerCase().contains(query.toLowerCase())).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.white,
      child: Container(
        padding: const EdgeInsets.all(10),
        color: Colors.white,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              // height: 40,
              child: TextFormFiledWidget(
                // isValid: isValid,
                hint: "Search",
                prefixIcon: SvgPicture.asset(ImagePath.search, height: 10, width: 10),
                controller: searchController,
                onChanged: (p0) {
                  setState(() {
                    _filterItems(searchController.text);
                    // widget.icd10CodeList.clear();
                  });
                  // onSearch();
                },
                onTap: () {
                  setState(() {
                    // widget.icd10CodeList.clear();
                    // searchController.clear();
                    // isValid = false;
                  });
                  _filterItems(searchController.text);
                },
                // onChanged: _filterItems,
                suffixIcon: const Icon(Icons.highlight_remove, color: AppColors.textDarkGrey, size: 25),
                // decoration: InputDecoration(hintText: "Search...", hintStyle: AppFonts.regular(14, AppColors.textGrey), border: OutlineInputBorder()),
                label: '',
              ),
              // TextField(
              //   controller: searchController,
              //   onChanged: _filterItems,
              //   decoration: InputDecoration(hintText: "Search", hintStyle: AppFonts.regular(14, AppColors.textGrey), border: InputBorder.),
              // )
            ),
            const SizedBox(height: 3),
            if (filteredItems.isEmpty) ...[
              SizedBox(height: 10),
              Text("No data found!", textAlign: TextAlign.start, style: AppFonts.regular(14, AppColors.textDarkGrey)),
            ] else ...[
              SizedBox(height: 10),
              ConstrainedBox(
                constraints: const BoxConstraints(maxHeight: 160),
                child: ListView.builder(
                  padding: EdgeInsets.zero,
                  shrinkWrap: true,
                  itemCount: filteredItems.length,
                  itemBuilder: (_, index) {
                    return GestureDetector(
                      onTap: () {
                        widget.onItemSelected(filteredItems[index], index);
                      },
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 5),
                        child: Container(
                          decoration: BoxDecoration(
                            color: widget.items[index].isPin ? AppColors.dropdownicdCodeBackgroundColor.withValues(alpha: 0.5) : AppColors.clear,
                            borderRadius: BorderRadius.circular(6),
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 5),
                          child: Row(
                            children: [
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 5),
                                  child: RichText(
                                    text: TextSpan(
                                      children: [
                                        TextSpan(text: "${filteredItems[index].code}", style: AppFonts.medium(14, AppColors.black)),
                                        TextSpan(text: ' (${filteredItems[index].description})', style: AppFonts.regular(14, AppColors.textDarkGrey)),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class DiagnosisDropDrownSearchTable extends StatefulWidget {
  PatientInfoController controller;
  final List<ProcedurePossibleAlternatives> items;
  final Function(ProcedurePossibleAlternatives, int) onItemSelected;
  final Function(String, String) onSearchItemSelected;
  final Function() onInitCallBack;
  List<Icd10CodeData> icd10CodeList = [];

  DiagnosisDropDrownSearchTable({Key? key, required this.controller, required this.items, required this.onItemSelected, required this.onSearchItemSelected, required this.onInitCallBack})
    : super(key: key);

  @override
  State<DiagnosisDropDrownSearchTable> createState() => _DiagnosisDropDrownSearchTableState();
}

class _DiagnosisDropDrownSearchTableState extends State<DiagnosisDropDrownSearchTable> {
  late List<ProcedurePossibleAlternatives> filteredItems = [];
  TextEditingController searchController = TextEditingController();
  bool isLoading = false;
  int page = 1;
  bool isValid = true;
  Timer? timer;

  @override
  void initState() {
    super.initState();

    filteredItems = List.from(widget.items);

    getIcd10Code();
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
      getIcd10Code();
    });
  }

  Future<void> getIcd10Code() async {
    isLoading = true;
    Map<String, dynamic> param = {};
    param['page'] = page;
    param['limit'] = "100";

    if (searchController.text.isNotEmpty) {
      param['search'] = searchController.text.trim();
    }

    Icd10CodeListModel icd10codeListModel = await widget.controller.getIcd10CodeList(param);
    isLoading = false;
    setState(() {
      widget.icd10CodeList.addAll(icd10codeListModel.responseData?.data ?? []);
      // widget.icd10CodeList = ;
    });

    // widget
  }

  void _filterItems(String query) {
    setState(() {
      filteredItems = widget.items.where((item) => (item.description ?? "").toLowerCase().contains(query.toLowerCase()) || (item.code ?? "").toLowerCase().contains(query.toLowerCase())).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.white,
      child: Container(
        height: 250,
        color: Colors.white,
        child: Column(
          children: [
            Container(
              // height: 50,
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
              child: TextFormFiledWidget(
                isValid: isValid,
                hint: "Search",
                prefixIcon: SvgPicture.asset(ImagePath.search, height: 10, width: 10),
                controller: searchController,
                onChanged: (p0) {
                  setState(() {
                    widget.icd10CodeList.clear();
                  });
                  onSearch();
                  _filterItems(searchController.text);
                },
                onTap: () {
                  setState(() {
                    widget.icd10CodeList.clear();
                    searchController.clear();
                    isValid = false;
                  });
                  _filterItems(searchController.text);
                  page = 1;
                  onSearch();
                },
                // onChanged: _filterItems,
                suffixIcon: Icon(Icons.highlight_remove, color: AppColors.textDarkGrey, size: 25),
                // decoration: InputDecoration(hintText: "Search...", hintStyle: AppFonts.regular(14, AppColors.textGrey), border: OutlineInputBorder()),
                label: '',
              ),
            ),
            // Text("count ${widget.icd10CodeList.length}"),
            const SizedBox(height: 3),
            Expanded(
              child: NotificationListener<ScrollEndNotification>(
                onNotification: (notification) {
                  // if (notification.metrics.atEdge) {
                  //   print("notification.metrics.atEdge");
                  // }
                  //
                  // // If user reaches the bottom and no data is being loaded
                  if (notification.metrics.extentBefore == notification.metrics.maxScrollExtent && !isLoading) {
                    print("notification.metrics.extentBefore == notification.metrics.maxScrollExtent && !isLoading");
                    page = page + 1;
                    getIcd10Code();
                    // onLoadMore?.call(); // Call the onLoadMore function
                  }
                  return false; // Allow other notifications to propagate
                },
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  child: Column(
                    children: [
                      if (filteredItems.isNotEmpty || widget.icd10CodeList.isNotEmpty) ...[
                        if (filteredItems.isNotEmpty) ...[
                          SizedBox(height: 0),
                          Padding(padding: const EdgeInsets.all(10), child: Row(children: [Text("Pin", style: AppFonts.regular(14, AppColors.black)), Spacer()])),
                          SizedBox(height: 0),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            child: ListView.builder(
                              padding: EdgeInsets.zero,
                              shrinkWrap: true,
                              physics: NeverScrollableScrollPhysics(),
                              itemCount: filteredItems.length,
                              itemBuilder: (_, index) {
                                return GestureDetector(
                                  onTap: () {
                                    widget.onItemSelected(filteredItems[index], index);
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(vertical: 5),
                                    child: Container(
                                      decoration: BoxDecoration(color: widget.items[index].isPin ? AppColors.orange.withValues(alpha: 0.5) : AppColors.clear, borderRadius: BorderRadius.circular(6)),
                                      padding: EdgeInsets.symmetric(vertical: 5, horizontal: 5),
                                      child: Row(
                                        children: [
                                          Expanded(
                                            child: RichText(
                                              text: TextSpan(
                                                children: [
                                                  TextSpan(text: "${filteredItems[index].code}", style: AppFonts.medium(14, AppColors.black)),
                                                  TextSpan(text: ' (${filteredItems[index].description})', style: AppFonts.regular(14, AppColors.textGreyTable)),
                                                ],
                                              ),
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
                        if (filteredItems.isNotEmpty) ...[SizedBox(height: 10), Divider(height: 0.5, thickness: 1)],
                        if (widget.icd10CodeList.isNotEmpty) ...[
                          SizedBox(height: 5),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            child: ListView.builder(
                              shrinkWrap: true,
                              padding: EdgeInsets.zero,
                              physics: NeverScrollableScrollPhysics(),
                              itemCount: widget.icd10CodeList.length,
                              itemBuilder: (_, index) {
                                return GestureDetector(
                                  onTap: () {
                                    widget.onSearchItemSelected(widget.icd10CodeList[index].code ?? "", widget.icd10CodeList[index].description ?? "");
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(vertical: 5),
                                    child: Container(
                                      // decoration: BoxDecoration(color: widget.items[index].isPin ? AppColors.orange : AppColors.clear, borderRadius: BorderRadius.circular(6)),
                                      padding: EdgeInsets.symmetric(vertical: 5, horizontal: 5),
                                      child: Row(
                                        children: [
                                          Expanded(
                                            child: RichText(
                                              text: TextSpan(
                                                children: [
                                                  TextSpan(text: "${widget.icd10CodeList[index].code}", style: AppFonts.medium(14, AppColors.black)),
                                                  TextSpan(text: ' (${widget.icd10CodeList[index].description})', style: AppFonts.regular(14, AppColors.textDarkGrey)),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ], // Text("(${widget.icd10CodeList[index].code}) ${widget.icd10CodeList[index].description}", style: AppFonts.regular(12, AppColors.black)))],
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                        ],
                      ],
                      if (filteredItems.isEmpty && widget.icd10CodeList.isEmpty) ...[Text("No data found!", textAlign: TextAlign.start, style: AppFonts.regular(14, AppColors.textDarkGrey))],
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
