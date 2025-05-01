import 'dart:async';

import 'package:flutter/material.dart';

import '../../../../utils/app_colors.dart';
import '../../../../utils/app_fonts.dart';
import '../../../../widgets/custom_textfiled.dart';
import '../../visit_main/model/doctor_view_model.dart';
import '../controllers/patient_info_controller.dart';
import '../model/icd10_code_list_model.dart';

class DropDrownSearchTable extends StatefulWidget {
  final List<ProcedurePossibleAlternatives> items;
  final Function(ProcedurePossibleAlternatives, int) onItemSelected;

  DropDrownSearchTable({Key? key, required this.items, required this.onItemSelected}) : super(key: key);

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
  }

  void _filterItems(String query) {
    setState(() {
      filteredItems = widget.items.where((item) => (item.description ?? "").toLowerCase().contains(query.toLowerCase()) || (item.code ?? "").toLowerCase().contains(query.toLowerCase())).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      color: Colors.white,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            height: 40,
            child: TextField(
              controller: searchController,
              onChanged: _filterItems,
              decoration: InputDecoration(hintText: "Search...", hintStyle: AppFonts.regular(14, AppColors.textGrey), border: OutlineInputBorder()),
            ),
          ),
          const SizedBox(height: 3),
          ConstrainedBox(
            constraints: BoxConstraints(maxHeight: 160),
            child: ListView.builder(
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
                      decoration: BoxDecoration(color: widget.items[index].isPin ? AppColors.orange : AppColors.clear, borderRadius: BorderRadius.circular(6)),
                      padding: EdgeInsets.symmetric(vertical: 5, horizontal: 5),
                      child: Expanded(
                        child: Row(children: [Expanded(child: Text("(${filteredItems[index].code}) ${filteredItems[index].description}", style: AppFonts.regular(12, AppColors.black)))]),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class DiagnosisDropDrownSearchTable extends StatefulWidget {
  PatientInfoController controller;
  final List<ProcedurePossibleAlternatives> items;
  final Function(ProcedurePossibleAlternatives, int) onItemSelected;
  final Function(String, String) onSearchItemSelected;

  List<Icd10CodeData> icd10CodeList = [];

  DiagnosisDropDrownSearchTable({Key? key, required this.controller, required this.items, required this.onItemSelected, required this.onSearchItemSelected}) : super(key: key);

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
  }

  @override
  void dispose() {
    timer?.cancel();
    timer = null;
    super.dispose();
  }

  void onSearch() {
    timer?.cancel();
    timer = Timer(Duration(seconds: 2), () {
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
    return Container(
      height: 250,
      padding: const EdgeInsets.all(10),
      color: Colors.white,
      child: Column(
        children: [
          SizedBox(
            height: 50,
            child: TextFormFiledWidget(
              isValid: isValid,
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
                physics: BouncingScrollPhysics(),
                child: Column(
                  children: [
                    if (filteredItems.isNotEmpty) ...[
                      ListView.builder(
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
                                decoration: BoxDecoration(color: widget.items[index].isPin ? AppColors.orange : AppColors.clear, borderRadius: BorderRadius.circular(6)),
                                padding: EdgeInsets.symmetric(vertical: 5, horizontal: 5),
                                child: Row(children: [Expanded(child: Text("(${filteredItems[index].code}) ${filteredItems[index].description}", style: AppFonts.regular(12, AppColors.black)))]),
                              ),
                            ),
                          );
                        },
                      ),
                    ],
                    ListView.builder(
                      shrinkWrap: true,
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
                                children: [Expanded(child: Text("(${widget.icd10CodeList[index].code}) ${widget.icd10CodeList[index].description}", style: AppFonts.regular(12, AppColors.black)))],
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                    // ConstrainedBox(
                    //   constraints: BoxConstraints(maxHeight: 160),
                    //   child: Column(
                    //     children: [
                    //
                    //     ],
                    //   ),
                    // ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
