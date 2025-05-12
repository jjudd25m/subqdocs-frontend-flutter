import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:subqdocs/utils/imagepath.dart';

import '../../../../utils/app_colors.dart';
import '../../../../utils/app_fonts.dart';
import '../../../core/common/global_controller.dart';
import '../../visit_main/model/doctor_view_model.dart';
import '../controllers/patient_info_controller.dart';
import '../model/icd10_code_list_model.dart';

class DropDrownSearchTable extends StatefulWidget {
  final List<ProcedurePossibleAlternatives> items;
  final int tableRowIndex;
  final Function(ProcedurePossibleAlternatives, int) onItemSelected;
  final Function() onInitCallBack;

  DropDrownSearchTable({Key? key, required this.items, required this.onItemSelected, required this.onInitCallBack, required this.tableRowIndex}) : super(key: key);

  @override
  State<DropDrownSearchTable> createState() => _DropDrownSearchTableState();
}

class _DropDrownSearchTableState extends State<DropDrownSearchTable> {
  final GlobalController globalController = Get.find();

  late List<ProcedurePossibleAlternatives> filteredItems = [];
  TextEditingController searchController = TextEditingController();

  // late ScrollController _scrollController;

  @override
  void initState() {
    super.initState();

    // print("bottom inset:- ${MediaQuery.of(context).viewInsets.bottom}");

    // _scrollController = ScrollController();
    filteredItems = List.from(widget.items);
    widget.onInitCallBack();
  }

  void _filterItems(String query) {
    setState(() {
      filteredItems = widget.items.where((item) => (item.description ?? "").toLowerCase().contains(query.toLowerCase()) || (item.code ?? "").toLowerCase().contains(query.toLowerCase())).toList();
    });
  }

  @override
  void dispose() {
    // _searchFocusNode.dispose();
    // _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.white,
      child: KeyboardDismissOnTap(
        child: SingleChildScrollView(
          // controller: _scrollController,
          padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom / 2.0),
          child: Container(
            padding: const EdgeInsets.all(10),
            color: Colors.white,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(
                  // height: 40,
                  child: CustomSearchBar(
                    controller: searchController,
                    hintText: 'Search',
                    onChanged: (text) {
                      print('Search text changed: $text');

                      setState(() {
                        _filterItems(searchController.text);
                        // widget.icd10CodeList.clear();
                      });
                      // onSearch();
                    },
                    onSubmit: (text) {
                      print('Submitted search: $text');
                      setState(() {
                        // widget.icd10CodeList.clear();
                        // searchController.clear();
                        // isValid = false;
                      });
                      _filterItems(searchController.text);
                      // Perform search operation here
                    },
                  ),
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
        ),
      ),
    );
  }
}

class DiagnosisDropDrownSearchTable extends StatefulWidget {
  PatientInfoController controller;
  final int tableRowIndex;
  final List<ProcedurePossibleAlternatives> items;
  final Function(ProcedurePossibleAlternatives, int) onItemSelected;
  final Function(String, String) onSearchItemSelected;
  final Function() onInitCallBack;
  List<Icd10CodeData> icd10CodeList = [];

  DiagnosisDropDrownSearchTable({
    Key? key,
    required this.controller,
    required this.items,
    required this.onItemSelected,
    required this.onSearchItemSelected,
    required this.onInitCallBack,
    required this.tableRowIndex,
  }) : super(key: key);

  @override
  State<DiagnosisDropDrownSearchTable> createState() => _DiagnosisDropDrownSearchTableState();
}

class _DiagnosisDropDrownSearchTableState extends State<DiagnosisDropDrownSearchTable> {
  final GlobalController globalController = Get.find();

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
    setState(() {
      isLoading = true;
    });

    Map<String, dynamic> param = {};
    param['page'] = page;
    param['limit'] = "100";

    if (searchController.text.isNotEmpty) {
      param['search'] = searchController.text.trim();
    }

    Icd10CodeListModel icd10codeListModel = await widget.controller.getIcd10CodeList(param);

    setState(() {
      isLoading = false;
    });

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
              child: CustomSearchBar(
                controller: searchController,
                hintText: 'Search',
                onChanged: (text) {
                  print('Search text changed: $text');
                  onSearch();
                  _filterItems(searchController.text);
                },
                onSubmit: (text) {
                  print('Submitted search: $text');

                  setState(() {
                    widget.icd10CodeList.clear();
                    searchController.clear();
                    isValid = false;
                  });
                  _filterItems(searchController.text);
                  page = 1;
                  onSearch();
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
                      if (isLoading) ...[
                        SizedBox(height: 10),
                        Center(child: CircularProgressIndicator(color: AppColors.textPurple, strokeWidth: 2)),
                        SizedBox(height: 10),
                      ] else ...[
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
                                        decoration: BoxDecoration(
                                          color: widget.items[index].isPin ? AppColors.dropdownicdCodeBackgroundColor.withValues(alpha: 0.5) : AppColors.clear,
                                          borderRadius: BorderRadius.circular(6),
                                        ),
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

class CustomSearchBar extends StatefulWidget {
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onSubmit;
  final String hintText;
  final TextEditingController? controller;
  final BorderRadius? borderRadius;
  final Border? border;
  final Color? fillColor;
  final EdgeInsetsGeometry? padding;
  final TextStyle? hintStyle;
  final double? iconSize;
  final Color? iconColor;

  const CustomSearchBar({
    Key? key,
    this.onChanged,
    this.onSubmit,
    this.hintText = 'Search',
    this.controller,
    this.borderRadius,
    this.border,
    this.fillColor,
    this.padding,
    this.hintStyle,
    this.iconSize = 20.0,
    this.iconColor,
  }) : super(key: key);

  @override
  _CustomSearchBarState createState() => _CustomSearchBarState();
}

class _CustomSearchBarState extends State<CustomSearchBar> {
  late TextEditingController _controller;
  final FocusNode _focusNode = FocusNode();
  final ValueNotifier<bool> _showClearButton = ValueNotifier(false);

  @override
  void initState() {
    super.initState();
    _controller = widget.controller ?? TextEditingController();
    _controller.addListener(_onTextChanged);
  }

  @override
  void dispose() {
    _controller.removeListener(_onTextChanged);
    if (widget.controller == null) {
      _controller.dispose();
    }
    _focusNode.dispose();
    _showClearButton.dispose();
    super.dispose();
  }

  void _onTextChanged() {
    _showClearButton.value = _controller.text.isNotEmpty;
    widget.onChanged?.call(_controller.text);
  }

  void _onClearPressed() {
    _controller.clear();
    widget.onChanged?.call('');
  }

  void _onSearchIconPressed() {
    FocusScope.of(context).requestFocus(_focusNode);
  }

  void _onSubmitted(String value) {
    widget.onSubmit?.call(value);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final defaultBorderRadius = widget.borderRadius ?? BorderRadius.circular(12.0);
    final defaultBorder = widget.border ?? Border.all(color: AppColors.textfieldBorder, width: 1.0);
    final fillColor = widget.fillColor ?? theme.cardColor;
    final iconColor = widget.iconColor ?? theme.iconTheme.color;
    final hintStyle = widget.hintStyle ?? theme.textTheme.bodyMedium?.copyWith(color: theme.hintColor);

    return Container(
      height: 40,
      decoration: BoxDecoration(color: Colors.white, borderRadius: defaultBorderRadius, border: defaultBorder),
      child: Row(
        children: [
          // Search icon button
          GestureDetector(onTap: () => _onSearchIconPressed, child: Padding(padding: const EdgeInsets.all(8.0), child: SvgPicture.asset(ImagePath.search, height: 25, width: 25))),

          // Text field
          Expanded(
            child: Padding(
              padding: widget.padding ?? const EdgeInsets.symmetric(vertical: 2),
              child: TextField(
                controller: _controller,
                focusNode: _focusNode,
                onSubmitted: _onSubmitted,
                decoration: InputDecoration(hintText: widget.hintText, hintStyle: hintStyle, border: InputBorder.none, isDense: true, contentPadding: EdgeInsets.zero),
              ),
            ),
          ),

          // Clear button with ValueListenableBuilder for smooth appearance
          ValueListenableBuilder<bool>(
            valueListenable: _showClearButton,
            builder: (context, showClear, child) {
              return AnimatedSwitcher(
                duration: const Duration(milliseconds: 200),
                child:
                    showClear
                        ? IconButton(key: const ValueKey('clear-button'), icon: Icon(Icons.clear, size: widget.iconSize), color: iconColor, onPressed: _onClearPressed)
                        : const SizedBox(width: 0), // Maintain consistent width
              );
            },
          ),
        ],
      ),
    );
  }
}

class HomeCustomSearchBar extends StatefulWidget {
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onSubmit;
  final String hintText;
  final TextEditingController? controller;
  final BorderRadius? borderRadius;
  final Border? border;
  final Color? fillColor;
  final EdgeInsetsGeometry? padding;
  final TextStyle? hintStyle;
  final double? iconSize;
  final Color? iconColor;

  const HomeCustomSearchBar({
    Key? key,
    this.onChanged,
    this.onSubmit,
    this.hintText = 'Search',
    this.controller,
    this.borderRadius,
    this.border,
    this.fillColor,
    this.padding,
    this.hintStyle,
    this.iconSize = 20.0,
    this.iconColor,
  }) : super(key: key);

  @override
  _HomeCustomSearchBarState createState() => _HomeCustomSearchBarState();
}

class _HomeCustomSearchBarState extends State<HomeCustomSearchBar> {
  late TextEditingController _controller;
  final FocusNode _focusNode = FocusNode();
  final ValueNotifier<bool> _showClearButton = ValueNotifier(false);

  @override
  void initState() {
    super.initState();
    _controller = widget.controller ?? TextEditingController();
    _controller.addListener(_onTextChanged);
  }

  @override
  void dispose() {
    _controller.removeListener(_onTextChanged);
    if (widget.controller == null) {
      _controller.dispose();
    }
    _focusNode.dispose();
    _showClearButton.dispose();
    super.dispose();
  }

  void _onTextChanged() {
    _showClearButton.value = _controller.text.isNotEmpty;
    widget.onChanged?.call(_controller.text);
  }

  void _onClearPressed() {
    _controller.clear();
    widget.onChanged?.call('');
  }

  void _onSearchIconPressed() {
    FocusScope.of(context).requestFocus(_focusNode);
  }

  void _onSubmitted(String value) {
    widget.onSubmit?.call(value);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final defaultBorderRadius = widget.borderRadius ?? BorderRadius.circular(8.0);
    final defaultBorder = widget.border ?? Border.all(color: AppColors.textGrey.withValues(alpha: 0.5), width: 1.0);
    final fillColor = widget.fillColor ?? theme.cardColor;
    final iconColor = widget.iconColor ?? theme.iconTheme.color;
    final hintStyle = widget.hintStyle ?? theme.textTheme.bodyMedium?.copyWith(color: theme.hintColor);

    return Container(
      // height: 40,
      decoration: BoxDecoration(color: Colors.white, borderRadius: defaultBorderRadius, border: defaultBorder),
      child: Row(
        children: [
          // Search icon button
          GestureDetector(onTap: () => _onSearchIconPressed, child: Padding(padding: const EdgeInsets.all(8.0), child: SvgPicture.asset(ImagePath.search, height: 25, width: 25))),

          // Text field
          Expanded(
            child: Padding(
              padding: widget.padding ?? const EdgeInsets.symmetric(vertical: 2),
              child: TextField(
                controller: _controller,
                focusNode: _focusNode,
                onSubmitted: _onSubmitted,
                decoration: InputDecoration(hintText: widget.hintText, hintStyle: hintStyle, border: InputBorder.none, isDense: true, contentPadding: EdgeInsets.zero),
              ),
            ),
          ),

          // Clear button with ValueListenableBuilder for smooth appearance
          ValueListenableBuilder<bool>(
            valueListenable: _showClearButton,
            builder: (context, showClear, child) {
              return AnimatedSwitcher(
                duration: const Duration(milliseconds: 200),
                child:
                    showClear
                        ? IconButton(key: const ValueKey('clear-button'), icon: Icon(Icons.clear, size: widget.iconSize), color: iconColor, onPressed: _onClearPressed)
                        : const SizedBox(width: 0), // Maintain consistent width
              );
            },
          ),
        ],
      ),
    );
  }
}

class KeyboardDismissOnTap extends StatelessWidget {
  final Widget child;

  const KeyboardDismissOnTap({Key? key, required this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: child,
    );
  }
}
