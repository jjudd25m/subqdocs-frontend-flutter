// class DropDrownSearchTable extends StatefulWidget {
//   PatientInfoController controller;
//   final GlobalKey? procedureContainerKey;
//   final List<ProcedurePossibleAlternatives> items;
//   final int tableRowIndex;
//   final Function(ProcedurePossibleAlternatives, int) onItemSelected;
//   final Function() onInitCallBack;
//   final Function(String, String) onSearchItemSelected;
//
//   DropDrownSearchTable({super.key, required this.controller, this.procedureContainerKey, required this.items, required this.onItemSelected, required this.onInitCallBack, required this.tableRowIndex, required this.onSearchItemSelected});
//
//   @override
//   State<DropDrownSearchTable> createState() => _DropDrownSearchTableState();
// }
//
// class _DropDrownSearchTableState extends State<DropDrownSearchTable> {
//   bool isLoading = false;
//   bool isPaginationLoading = false;
//   int page = 1;
//   Timer? timer;
//   final GlobalController globalController = Get.find();
//   late List<ProcedurePossibleAlternatives> filteredItems = [];
//   TextEditingController searchController = TextEditingController();
//   List<GetCPTCodeResponseDataData> cptCodeList = [];
//   bool isValid = true;
//
//   @override
//   void initState() {
//     super.initState();
//
//     filteredItems = List.from(widget.items);
//     getCPTCode(isShowLoading: true);
//
//     widget.onInitCallBack();
//   }
//
//   void _filterItems(String query) {
//     setState(() {
//       filteredItems = widget.items.where((item) => (item.description ?? "").toLowerCase().contains(query.toLowerCase()) || (item.code ?? "").toLowerCase().contains(query.toLowerCase())).toList();
//     });
//   }
//
//   @override
//   void dispose() {
//     timer?.cancel();
//     timer = null;
//     super.dispose();
//   }
//
//   void onSearch() {
//     timer?.cancel();
//     timer = Timer(const Duration(milliseconds: 500), () {
//       page = 1;
//       cptCodeList.clear();
//       getCPTCode(isShowLoading: true);
//     });
//   }
//
//   Future<bool> getCPTCode({bool isShowLoading = false, bool isShowPaginationLoading = false}) async {
//     if (isShowLoading) {
//       isLoading = true;
//     }
//
//     if (isShowPaginationLoading) {
//       isPaginationLoading = true;
//     }
//     setState(() {});
//
//     Map<String, dynamic> param = {};
//     param['page'] = page;
//     param['limit'] = "100";
//
//     if (searchController.text.isNotEmpty) {
//       param['search'] = searchController.text.trim();
//     }
//
//     GetCPTCodeModel getCPTCodeModel = await widget.controller.getCPTCodeAll(param);
//
//     if (isShowLoading) {
//       isLoading = false;
//     }
//
//     if (isShowPaginationLoading) {
//       isPaginationLoading = false;
//     }
//
//     cptCodeList.addAll(getCPTCodeModel.responseData?.data ?? []);
//
//     setState(() {});
//
//     return true;
//
//     // widget
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Material(
//       color: AppColors.white,
//       child: KeyboardDismissOnTap(
//         child: SingleChildScrollView(
//           // physics: const ClampingScrollPhysics(), // Add this
//           child: Container(
//             height: 250,
//             // height: 250 + (MediaQuery.of(context).viewInsets.bottom / 2.25),
//             color: Colors.white,
//             child: Column(
//               children: [
//                 Container(
//                   // height: 50,
//                   padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
//                   child: CustomSearchBar(
//                     onTap: (value) {
//                       final context = widget.procedureContainerKey?.currentContext;
//                       if (context != null) {
//                         Scrollable.ensureVisible(context, duration: const Duration(milliseconds: 500), curve: Curves.easeInOut);
//                       }
//                     },
//                     controller: searchController,
//                     hintText: 'Search',
//                     onChanged: (text) {
//                       customPrint('Search text changed: $text');
//                       page = 1;
//                       cptCodeList.clear();
//                       onSearch();
//                       _filterItems(searchController.text);
//                     },
//                     onSubmit: (text) {
//                       customPrint('Submitted search: $text');
//
//                       if (text.isNotEmpty) {
//                         setState(() {
//                           cptCodeList.clear();
//                           searchController.clear();
//                           isValid = false;
//                         });
//                         _filterItems(searchController.text);
//                         page = 1;
//                         onSearch();
//                       }
//
//                       // Perform search operation here
//                     },
//                   ),
//                 ),
//                 // Text("count ${widget.icd10CodeList.length}"),
//                 const SizedBox(height: 3),
//                 Expanded(
//                   child: NotificationListener<ScrollEndNotification>(
//                     onNotification: (notification) {
//                       // // If user reaches the bottom and no data is being loaded
//                       if (notification.metrics.extentBefore == notification.metrics.maxScrollExtent && !isLoading) {
//                         customPrint("notification.metrics.extentBefore == notification.metrics.maxScrollExtent && !isLoading");
//                         page = page + 1;
//                         // getIcd10Code();
//                         getCPTCode(isShowPaginationLoading: true);
//                       }
//                       return false; // Allow other notifications to propagate
//                     },
//                     child: SingleChildScrollView(
//                       physics: const BouncingScrollPhysics(),
//                       child: Column(
//                         children: [
//                           if (isLoading) ...[
//                             const SizedBox(height: 10),
//                             const Center(child: CircularProgressIndicator(color: AppColors.textPurple, strokeWidth: 2)),
//                             const SizedBox(height: 10),
//                           ] else ...[
//                             if (filteredItems.isNotEmpty || cptCodeList.isNotEmpty) ...[
//                               if (filteredItems.isNotEmpty) ...[
//                                 const SizedBox(height: 0),
//                                 Padding(padding: const EdgeInsets.all(10), child: Row(children: [Text("Pin", style: AppFonts.regular(14, AppColors.black)), const Spacer()])),
//                                 const SizedBox(height: 0),
//                                 Padding(
//                                   padding: const EdgeInsets.symmetric(horizontal: 10),
//                                   child: ListView.builder(
//                                     padding: EdgeInsets.zero,
//                                     shrinkWrap: true,
//                                     physics: const NeverScrollableScrollPhysics(),
//                                     itemCount: filteredItems.length,
//                                     itemBuilder: (_, index) {
//                                       return GestureDetector(
//                                         onTap: () {
//                                           FocusScope.of(context).unfocus(); // Removes focus and hides keyboard
//                                           widget.onItemSelected(filteredItems[index], index);
//                                         },
//                                         child: Padding(
//                                           padding: const EdgeInsets.symmetric(vertical: 5),
//                                           child: Container(
//                                             decoration: BoxDecoration(color: widget.items[index].isPin ? AppColors.dropdownicdCodeBackgroundColor.withValues(alpha: 0.5) : AppColors.clear, borderRadius: BorderRadius.circular(6)),
//                                             padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 5),
//                                             child: Row(
//                                               children: [
//                                                 Expanded(
//                                                   child: RichText(
//                                                     text: TextSpan(children: [TextSpan(text: "${filteredItems[index].code}", style: AppFonts.medium(14, AppColors.black)), TextSpan(text: (filteredItems[index].shortDescription?.isNotEmpty ?? false) ? ' (${filteredItems[index].shortDescription})' : ' (${filteredItems[index].description})', style: AppFonts.regular(14, AppColors.textGreyTable))]),
//                                                   ),
//                                                 ),
//                                               ],
//                                             ),
//                                             // Text("(${filteredItems[index].code}) ${filteredItems[index].description}", style: AppFonts.regular(12, AppColors.black)))]),
//                                           ),
//                                         ),
//                                       );
//                                     },
//                                   ),
//                                 ),
//                               ],
//                               if (filteredItems.isNotEmpty) ...[const SizedBox(height: 10), const Divider(height: 0.5, thickness: 1)],
//                               if (cptCodeList.isNotEmpty) ...[
//                                 const SizedBox(height: 5),
//                                 Padding(
//                                   padding: const EdgeInsets.symmetric(horizontal: 10),
//                                   child: ListView.builder(
//                                     shrinkWrap: true,
//                                     padding: EdgeInsets.zero,
//                                     physics: const NeverScrollableScrollPhysics(),
//                                     itemCount: cptCodeList.length,
//                                     itemBuilder: (_, index) {
//                                       return GestureDetector(
//                                         onTap: () {
//                                           widget.onSearchItemSelected(cptCodeList[index].code ?? "", cptCodeList[index].description ?? "");
//                                         },
//                                         child: Padding(
//                                           padding: const EdgeInsets.symmetric(vertical: 5),
//                                           child: Container(
//                                             padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 5),
//                                             child: Row(
//                                               children: [
//                                                 Expanded(child: RichText(text: TextSpan(children: [TextSpan(text: "${cptCodeList[index].code}", style: AppFonts.medium(14, AppColors.black)), TextSpan(text: ' (${cptCodeList[index].description})', style: AppFonts.regular(14, AppColors.textDarkGrey))]))),
//                                               ], // Text("(${widget.icd10CodeList[index].code}) ${widget.icd10CodeList[index].description}", style: AppFonts.regular(12, AppColors.black)))],
//                                             ),
//                                           ),
//                                         ),
//                                       );
//                                     },
//                                   ),
//                                 ),
//                                 if (isPaginationLoading) ...[const SizedBox(height: 10), const Center(child: CircularProgressIndicator(color: AppColors.textPurple, strokeWidth: 2)), const SizedBox(height: 10)],
//                               ],
//                             ],
//                             if (filteredItems.isEmpty && cptCodeList.isEmpty) ...[Text("No data found!", textAlign: TextAlign.start, style: AppFonts.regular(14, AppColors.textDarkGrey))],
//                           ],
//                         ],
//                       ),
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
//
//   // @override
//   // Widget build(BuildContext context) {
//   //   return Material(
//   //     color: AppColors.white,
//   //     child: KeyboardDismissOnTap(
//   //       child: SingleChildScrollView(
//   //         child: Container(
//   //           height: 250,
//   //           // height: 250 + (MediaQuery.of(context).viewInsets.bottom / 2.5),
//   //           padding: const EdgeInsets.all(10),
//   //           color: Colors.white,
//   //           child: Column(
//   //             mainAxisSize: MainAxisSize.min,
//   //             children: [
//   //               SizedBox(
//   //                 // height: 40,
//   //                 child: CustomSearchBar(
//   //                   onTap: (value) {
//   //                     final context = widget.procedureContainerKey?.currentContext;
//   //                     if (context != null) {
//   //                       Scrollable.ensureVisible(context, duration: Duration(milliseconds: 500), curve: Curves.easeInOut);
//   //                     }
//   //                   },
//   //                   controller: searchController,
//   //                   hintText: 'Search',
//   //                   onChanged: (text) {
//   //                     print('Search text changed: $text');
//   //                     setState(() {
//   //                       _filterItems(searchController.text);
//   //                     });
//   //                   },
//   //                   onSubmit: (text) {
//   //                     print('Submitted search: $text');
//   //                     setState(() {});
//   //                     _filterItems(searchController.text);
//   //                     // Perform search operation here
//   //                   },
//   //                 ),
//   //               ),
//   //               const SizedBox(height: 3),
//   //               if (filteredItems.isEmpty) ...[
//   //                 const SizedBox(height: 10),
//   //                 Text("No data found!", textAlign: TextAlign.start, style: AppFonts.regular(14, AppColors.textDarkGrey)),
//   //               ] else ...[
//   //                 const SizedBox(height: 10),
//   //                 ConstrainedBox(
//   //                   constraints: const BoxConstraints(maxHeight: 160),
//   //                   child: ListView.builder(
//   //                     padding: EdgeInsets.zero,
//   //                     shrinkWrap: true,
//   //                     itemCount: filteredItems.length,
//   //                     itemBuilder: (_, index) {
//   //                       return GestureDetector(
//   //                         onTap: () {
//   //                           widget.onItemSelected(filteredItems[index], index);
//   //                         },
//   //                         child: Padding(
//   //                           padding: const EdgeInsets.symmetric(vertical: 5),
//   //                           child: Container(
//   //                             decoration: BoxDecoration(color: widget.items[index].isPin ? AppColors.dropdownicdCodeBackgroundColor.withValues(alpha: 0.5) : AppColors.clear, borderRadius: BorderRadius.circular(6)),
//   //                             padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 5),
//   //                             child: Row(
//   //                               children: [
//   //                                 Expanded(
//   //                                   child: Padding(
//   //                                     padding: const EdgeInsets.symmetric(horizontal: 5),
//   //                                     child: RichText(text: TextSpan(children: [TextSpan(text: "${filteredItems[index].code}", style: AppFonts.medium(14, AppColors.black)), TextSpan(text: ' (${filteredItems[index].description})', style: AppFonts.regular(14, AppColors.textDarkGrey))])),
//   //                                   ),
//   //                                 ),
//   //                               ],
//   //                             ),
//   //                           ),
//   //                         ),
//   //                       );
//   //                     },
//   //                   ),
//   //                 ),
//   //               ],
//   //             ],
//   //           ),
//   //         ),
//   //       ),
//   //     ),
//   //   );
//   // }
// }

//-----------------------------------------------------------

// class DiagnosisDropDrownSearchTable extends StatefulWidget {
//   final GlobalKey? diagnosisContainerKey;
//
//   PatientInfoController controller;
//   final int tableRowIndex;
//   final List<ProcedurePossibleAlternatives> items;
//   final Function(ProcedurePossibleAlternatives, int) onItemSelected;
//   final Function(String, String) onSearchItemSelected;
//   final Function() onInitCallBack;
//
//   DiagnosisDropDrownSearchTable({super.key, this.diagnosisContainerKey, required this.controller, required this.items, required this.onItemSelected, required this.onSearchItemSelected, required this.onInitCallBack, required this.tableRowIndex});
//
//   @override
//   State<DiagnosisDropDrownSearchTable> createState() => _DiagnosisDropDrownSearchTableState();
// }
//
// class _DiagnosisDropDrownSearchTableState extends State<DiagnosisDropDrownSearchTable> {
//   final GlobalController globalController = Get.find();
//
//   late List<ProcedurePossibleAlternatives> filteredItems = [];
//   TextEditingController searchController = TextEditingController();
//   bool isLoading = false;
//   bool isPaginationLoading = false;
//   int page = 1;
//   bool isValid = true;
//   Timer? timer;
//   List<Icd10CodeData> icd10CodeList = [];
//
//   @override
//   void initState() {
//     super.initState();
//
//     filteredItems = List.from(widget.items);
//     getIcd10Code(isShowLoading: true);
//     widget.onInitCallBack();
//   }
//
//   @override
//   void dispose() {
//     timer?.cancel();
//     timer = null;
//     super.dispose();
//   }
//
//   void onSearch() {
//     timer?.cancel();
//     timer = Timer(const Duration(milliseconds: 500), () {
//       page = 1;
//       icd10CodeList.clear();
//       getIcd10Code(isShowLoading: true);
//     });
//   }
//
//   Future<bool> getIcd10Code({bool isShowLoading = false, bool isShowPaginationLoading = false}) async {
//     if (isShowLoading) {
//       isLoading = true;
//     }
//
//     if (isShowPaginationLoading) {
//       isPaginationLoading = true;
//     }
//     setState(() {});
//
//     Map<String, dynamic> param = {};
//     param['page'] = page;
//     param['limit'] = "100";
//
//     if (searchController.text.isNotEmpty) {
//       param['search'] = searchController.text.trim();
//     }
//
//     Icd10CodeListModel icd10codeListModel = await widget.controller.getIcd10CodeList(param);
//
//     if (isShowLoading) {
//       isLoading = false;
//     }
//
//     if (isShowPaginationLoading) {
//       isPaginationLoading = false;
//     }
//
//     icd10CodeList.addAll(icd10codeListModel.responseData?.data ?? []);
//
//     setState(() {});
//
//     return true;
//
//     // widget
//   }
//
//   void _filterItems(String query) {
//     setState(() {
//       filteredItems = widget.items.where((item) => (item.description ?? "").toLowerCase().contains(query.toLowerCase()) || (item.code ?? "").toLowerCase().contains(query.toLowerCase())).toList();
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Material(
//       color: AppColors.white,
//       child: KeyboardDismissOnTap(
//         child: SingleChildScrollView(
//           // physics: const ClampingScrollPhysics(), // Add this
//           child: Container(
//             height: 250,
//             // height: 250 + (MediaQuery.of(context).viewInsets.bottom / 2.25),
//             color: Colors.white,
//             child: Column(
//               children: [
//                 Container(
//                   // height: 50,
//                   padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
//                   child: CustomSearchBar(
//                     onTap: (value) {
//                       final context = widget.diagnosisContainerKey?.currentContext;
//                       if (context != null) {
//                         Scrollable.ensureVisible(context, duration: const Duration(milliseconds: 500), curve: Curves.easeInOut);
//                       }
//                     },
//                     controller: searchController,
//                     hintText: 'Search',
//                     onChanged: (text) {
//                       customPrint('Search text changed: $text');
//                       page = 1;
//                       icd10CodeList.clear();
//                       onSearch();
//                       _filterItems(searchController.text);
//                     },
//                     onSubmit: (text) {
//                       customPrint('Submitted search: $text');
//
//                       if (text.isNotEmpty) {
//                         setState(() {
//                           icd10CodeList.clear();
//                           searchController.clear();
//                           isValid = false;
//                         });
//                         _filterItems(searchController.text);
//                         page = 1;
//                         onSearch();
//                       }
//
//                       // Perform search operation here
//                     },
//                   ),
//                 ),
//                 // Text("count ${widget.icd10CodeList.length}"),
//                 const SizedBox(height: 3),
//                 Expanded(
//                   child: NotificationListener<ScrollEndNotification>(
//                     onNotification: (notification) {
//                       // // If user reaches the bottom and no data is being loaded
//                       if (notification.metrics.extentBefore == notification.metrics.maxScrollExtent && !isLoading) {
//                         customPrint("notification.metrics.extentBefore == notification.metrics.maxScrollExtent && !isLoading");
//                         page = page + 1;
//                         // getIcd10Code();
//                         getIcd10Code(isShowPaginationLoading: true);
//                       }
//                       return false; // Allow other notifications to propagate
//                     },
//                     child: SingleChildScrollView(
//                       physics: const BouncingScrollPhysics(),
//                       child: Column(
//                         children: [
//                           if (isLoading) ...[
//                             const SizedBox(height: 10),
//                             const Center(child: CircularProgressIndicator(color: AppColors.textPurple, strokeWidth: 2)),
//                             const SizedBox(height: 10),
//                           ] else ...[
//                             if (filteredItems.isNotEmpty || icd10CodeList.isNotEmpty) ...[
//                               if (filteredItems.isNotEmpty) ...[
//                                 const SizedBox(height: 0),
//                                 Padding(padding: const EdgeInsets.all(10), child: Row(children: [Text("Pin", style: AppFonts.regular(14, AppColors.black)), const Spacer()])),
//                                 const SizedBox(height: 0),
//                                 Padding(
//                                   padding: const EdgeInsets.symmetric(horizontal: 10),
//                                   child: ListView.builder(
//                                     padding: EdgeInsets.zero,
//                                     shrinkWrap: true,
//                                     physics: const NeverScrollableScrollPhysics(),
//                                     itemCount: filteredItems.length,
//                                     itemBuilder: (_, index) {
//                                       return GestureDetector(
//                                         onTap: () {
//                                           FocusScope.of(context).unfocus(); // Removes focus and hides keyboard
//                                           widget.onItemSelected(filteredItems[index], index);
//                                         },
//                                         child: Padding(
//                                           padding: const EdgeInsets.symmetric(vertical: 5),
//                                           child: Container(
//                                             decoration: BoxDecoration(color: widget.items[index].isPin ? AppColors.dropdownicdCodeBackgroundColor.withValues(alpha: 0.5) : AppColors.clear, borderRadius: BorderRadius.circular(6)),
//                                             padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 5),
//                                             child: Row(
//                                               children: [
//                                                 Expanded(child: RichText(text: TextSpan(children: [TextSpan(text: "${filteredItems[index].code}", style: AppFonts.medium(14, AppColors.black)), TextSpan(text: ' (${filteredItems[index].description})', style: AppFonts.regular(14, AppColors.textGreyTable))]))),
//                                               ],
//                                             ),
//                                             // Text("(${filteredItems[index].code}) ${filteredItems[index].description}", style: AppFonts.regular(12, AppColors.black)))]),
//                                           ),
//                                         ),
//                                       );
//                                     },
//                                   ),
//                                 ),
//                               ],
//                               if (filteredItems.isNotEmpty) ...[const SizedBox(height: 10), const Divider(height: 0.5, thickness: 1)],
//                               if (icd10CodeList.isNotEmpty) ...[
//                                 const SizedBox(height: 5),
//                                 Padding(
//                                   padding: const EdgeInsets.symmetric(horizontal: 10),
//                                   child: ListView.builder(
//                                     shrinkWrap: true,
//                                     padding: EdgeInsets.zero,
//                                     physics: const NeverScrollableScrollPhysics(),
//                                     itemCount: icd10CodeList.length,
//                                     itemBuilder: (_, index) {
//                                       return GestureDetector(
//                                         onTap: () {
//                                           widget.onSearchItemSelected(icd10CodeList[index].code ?? "", icd10CodeList[index].description ?? "");
//                                         },
//                                         child: Padding(
//                                           padding: const EdgeInsets.symmetric(vertical: 5),
//                                           child: Container(
//                                             padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 5),
//                                             child: Row(
//                                               children: [
//                                                 Expanded(child: RichText(text: TextSpan(children: [TextSpan(text: "${icd10CodeList[index].code}", style: AppFonts.medium(14, AppColors.black)), TextSpan(text: ' (${icd10CodeList[index].description})', style: AppFonts.regular(14, AppColors.textDarkGrey))]))),
//                                               ], // Text("(${widget.icd10CodeList[index].code}) ${widget.icd10CodeList[index].description}", style: AppFonts.regular(12, AppColors.black)))],
//                                             ),
//                                           ),
//                                         ),
//                                       );
//                                     },
//                                   ),
//                                 ),
//                                 if (isPaginationLoading) ...[const SizedBox(height: 10), const Center(child: CircularProgressIndicator(color: AppColors.textPurple, strokeWidth: 2)), const SizedBox(height: 10)],
//                               ],
//                             ],
//                             if (filteredItems.isEmpty && icd10CodeList.isEmpty) ...[Text("No data found!", textAlign: TextAlign.start, style: AppFonts.regular(14, AppColors.textDarkGrey))],
//                           ],
//                         ],
//                       ),
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }

//--------------- Modifier dropdown

// class ModifierDropDrownSearchTable extends StatefulWidget {
//   final GlobalKey? procedureContainerKey;
//
//   PatientInfoController controller;
//   final int tableRowIndex;
//   final List<ProcedurePossibleAlternatives> items;
//
//   // final Function(ProcedurePossibleAlternatives, int) onItemSelected;
//   final Function(String, String) onSearchItemSelected;
//   final Function() onInitCallBack;
//
//   ModifierDropDrownSearchTable({super.key, this.procedureContainerKey, required this.controller, required this.items, required this.onSearchItemSelected, required this.onInitCallBack, required this.tableRowIndex});
//
//   @override
//   State<ModifierDropDrownSearchTable> createState() => _ModifierDropDrownSearchTableState();
// }
//
// class _ModifierDropDrownSearchTableState extends State<ModifierDropDrownSearchTable> {
//   final GlobalController globalController = Get.find();
//
//   // late List<ProcedurePossibleAlternatives> filteredItems = [];
//   TextEditingController searchController = TextEditingController();
//   bool isLoading = false;
//   bool isPaginationLoading = false;
//   int page = 1;
//   bool isValid = true;
//   Timer? timer;
//   List<GetModifierCodeResponseDataData> modifierCodeList = [];
//
//   @override
//   void initState() {
//     super.initState();
//
//     // filteredItems = List.from(widget.items);
//     getModifierCode(isShowLoading: true);
//     widget.onInitCallBack();
//   }
//
//   @override
//   void dispose() {
//     timer?.cancel();
//     timer = null;
//     super.dispose();
//   }
//
//   void onSearch() {
//     timer?.cancel();
//     timer = Timer(const Duration(milliseconds: 500), () {
//       page = 1;
//       modifierCodeList.clear();
//       getModifierCode(isShowLoading: true);
//     });
//   }
//
//   Future<bool> getModifierCode({bool isShowLoading = false, bool isShowPaginationLoading = false}) async {
//     if (isShowLoading) {
//       isLoading = true;
//     }
//
//     if (isShowPaginationLoading) {
//       isPaginationLoading = true;
//     }
//     setState(() {});
//
//     Map<String, dynamic> param = {};
//     param['page'] = page;
//     param['limit'] = "100";
//
//     if (searchController.text.isNotEmpty) {
//       param['search'] = searchController.text.trim();
//     }
//
//     GetModifierCodeModel icd10codeListModel = await widget.controller.getModifierCodeAll(param);
//
//     if (isShowLoading) {
//       isLoading = false;
//     }
//
//     if (isShowPaginationLoading) {
//       isPaginationLoading = false;
//     }
//
//     modifierCodeList.addAll(icd10codeListModel.responseData?.data ?? []);
//
//     setState(() {});
//
//     return true;
//
//     // widget
//   }
//
//   // void _filterItems(String query) {
//   //   setState(() {
//   //     filteredItems = widget.items.where((item) => (item.description ?? "").toLowerCase().contains(query.toLowerCase()) || (item.code ?? "").toLowerCase().contains(query.toLowerCase())).toList();
//   //   });
//   // }
//
//   @override
//   Widget build(BuildContext context) {
//     return Material(
//       color: AppColors.white,
//       child: KeyboardDismissOnTap(
//         child: SingleChildScrollView(
//           // physics: const ClampingScrollPhysics(), // Add this
//           child: Container(
//             height: 250,
//             // height: 250 + (MediaQuery.of(context).viewInsets.bottom / 2.25),
//             color: Colors.white,
//             child: Column(
//               children: [
//                 Container(
//                   // height: 50,
//                   padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
//                   child: CustomSearchBar(
//                     onTap: (value) {
//                       final context = widget.procedureContainerKey?.currentContext;
//                       if (context != null) {
//                         Scrollable.ensureVisible(context, duration: const Duration(milliseconds: 500), curve: Curves.easeInOut);
//                       }
//                     },
//                     controller: searchController,
//                     hintText: 'Search',
//                     onChanged: (text) {
//                       customPrint('Search text changed: $text');
//                       page = 1;
//                       modifierCodeList.clear();
//                       onSearch();
//                       // _filterItems(searchController.text);
//                     },
//                     onSubmit: (text) {
//                       customPrint('Submitted search: $text');
//
//                       if (text.isNotEmpty) {
//                         setState(() {
//                           modifierCodeList.clear();
//                           searchController.clear();
//                           isValid = false;
//                         });
//                         // _filterItems(searchController.text);
//                         page = 1;
//                         onSearch();
//                       }
//
//                       // Perform search operation here
//                     },
//                   ),
//                 ),
//                 // Text("count ${widget.icd10CodeList.length}"),
//                 const SizedBox(height: 3),
//                 Expanded(
//                   child: NotificationListener<ScrollEndNotification>(
//                     onNotification: (notification) {
//                       // // If user reaches the bottom and no data is being loaded
//                       if (notification.metrics.extentBefore == notification.metrics.maxScrollExtent && !isLoading) {
//                         customPrint("notification.metrics.extentBefore == notification.metrics.maxScrollExtent && !isLoading");
//                         page = page + 1;
//                         // getIcd10Code();
//                         getModifierCode(isShowPaginationLoading: true);
//                       }
//                       return false; // Allow other notifications to propagate
//                     },
//                     child: SingleChildScrollView(
//                       physics: const BouncingScrollPhysics(),
//                       child: Column(
//                         children: [
//                           if (isLoading) ...[
//                             const SizedBox(height: 10),
//                             const Center(child: CircularProgressIndicator(color: AppColors.textPurple, strokeWidth: 2)),
//                             const SizedBox(height: 10),
//                           ] else ...[
//                             if (modifierCodeList.isNotEmpty) ...[
//                               if (modifierCodeList.isNotEmpty) ...[
//                                 const SizedBox(height: 5),
//                                 Padding(
//                                   padding: const EdgeInsets.symmetric(horizontal: 10),
//                                   child: ListView.builder(
//                                     shrinkWrap: true,
//                                     padding: EdgeInsets.zero,
//                                     physics: const NeverScrollableScrollPhysics(),
//                                     itemCount: modifierCodeList.length,
//                                     itemBuilder: (_, index) {
//                                       return GestureDetector(
//                                         onTap: () {
//                                           widget.onSearchItemSelected(modifierCodeList[index].modifier ?? "", modifierCodeList[index].description ?? "");
//                                         },
//                                         child: Padding(
//                                           padding: const EdgeInsets.symmetric(vertical: 5),
//                                           child: Container(
//                                             padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 5),
//                                             child: Row(
//                                               children: [
//                                                 Expanded(child: RichText(text: TextSpan(children: [TextSpan(text: "${modifierCodeList[index].modifier}", style: AppFonts.medium(14, AppColors.black)), TextSpan(text: ' (${modifierCodeList[index].description})', style: AppFonts.regular(14, AppColors.textDarkGrey))]))),
//                                               ], // Text("(${widget.icd10CodeList[index].code}) ${widget.icd10CodeList[index].description}", style: AppFonts.regular(12, AppColors.black)))],
//                                             ),
//                                           ),
//                                         ),
//                                       );
//                                     },
//                                   ),
//                                 ),
//                                 if (isPaginationLoading) ...[const SizedBox(height: 10), const Center(child: CircularProgressIndicator(color: AppColors.textPurple, strokeWidth: 2)), const SizedBox(height: 10)],
//                               ],
//                             ],
//                             if (modifierCodeList.isEmpty) ...[Text("No data found!", textAlign: TextAlign.start, style: AppFonts.regular(14, AppColors.textDarkGrey))],
//                           ],
//                         ],
//                       ),
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
