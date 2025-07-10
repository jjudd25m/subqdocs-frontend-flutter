import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';

import '../../../../utils/app_colors.dart';
import '../../../../utils/app_fonts.dart';
import '../../../../utils/imagepath.dart';
import '../../../../widget/base_image_view.dart';
import '../../../models/SelectedDoctorMedicationModel.dart';
import '../../edit_patient_details/model/patient_detail_model.dart';

class DropDownWithSearchPopup extends StatefulWidget {
  DropDownWithSearchPopup({super.key, required this.receiveParam, required this.selectedId, required this.onChanged, this.searchScrollKey, this.list});

  final int selectedId;
  final void Function(String) receiveParam;
  final void Function(bool, int, int, String) onChanged;
  final GlobalKey? searchScrollKey;
  final List<SelectedDoctorModel>? list;

  @override
  State<DropDownWithSearchPopup> createState() => _DropDownWithSearchPopupState();
}

class _DropDownWithSearchPopupState extends State<DropDownWithSearchPopup> {
  final TextEditingController searchController = TextEditingController();
  final FocusNode searchFocusNode = FocusNode();

  List<SelectedDoctorModel> filteredList = [];

  @override
  void initState() {
    super.initState();
    filteredList = List.from(widget.list ?? []);
    print("DropDown initState: ${filteredList.length} items loaded");
  }

  void filterList(String value) {
    setState(() {
      if (value.isEmpty) {
        filteredList = List.from(widget.list ?? []);
      } else {
        filteredList = (widget.list ?? []).where((item) => item.name?.toLowerCase().contains(value.toLowerCase()) ?? false).toList();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.white,
      child: Container(
        width: double.infinity,
        child: Column(
          children: [
            // Search Box
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
              child: Container(
                decoration: BoxDecoration(color: AppColors.white, border: Border.all(width: 1, color: AppColors.textfieldBorder), borderRadius: BorderRadius.circular(6)),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      SvgPicture.asset(ImagePath.search, height: 25, width: 25),
                      const SizedBox(width: 5),
                      Expanded(
                        child: TextFormField(
                          controller: searchController,
                          focusNode: searchFocusNode,
                          onTap: () {
                            final context = widget.searchScrollKey?.currentContext;
                            if (context != null) {
                              Scrollable.ensureVisible(context, duration: const Duration(milliseconds: 500), curve: Curves.easeInOut);
                            }
                            filterList(searchController.text);
                          },
                          onChanged: filterList,
                          maxLines: 1,
                          decoration: InputDecoration.collapsed(hintText: "Search", hintStyle: AppFonts.regular(14, AppColors.textGrey)),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            // Filtered List or No Options
            if (filteredList.isNotEmpty)
              Container(
                constraints: const BoxConstraints(maxHeight: 250),
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: filteredList.length,
                  itemBuilder: (context, index) {
                    final item = filteredList[index];
                    return GestureDetector(
                      onTap: () {
                        widget.onChanged(item.isSelected ?? false, index, item.id ?? -1, item.name ?? "");
                        setState(() {}); // Optional, only needed if UI reflects selection
                      },
                      child: Container(
                        color: AppColors.white,
                        child: Column(
                          children: [
                            const SizedBox(height: 10),
                            Row(
                              children: [
                                Padding(padding: const EdgeInsets.only(left: 10), child: ClipRRect(borderRadius: BorderRadius.circular(14), child: BaseImageView(height: 32, width: 32, nameLetters: item.name ?? "", fontSize: 12, imageUrl: item.profileImage ?? ""))),
                                const SizedBox(width: 10),
                                Expanded(child: Text(item.name ?? "", maxLines: 2, overflow: TextOverflow.ellipsis, style: AppFonts.medium(14, AppColors.black))),
                              ],
                            ),
                            const SizedBox(height: 10),
                            if (index < filteredList.length - 1) Container(color: AppColors.textfieldBorder, height: 1),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              )
            else
              const Center(child: Padding(padding: EdgeInsets.all(8.0), child: Text("No Options"))),
          ],
        ),
      ),
    );
  }
}

// class DropDownWithSearchPopup extends StatefulWidget {
//   DropDownWithSearchPopup({super.key, this.list, this.searchScrollKey, required this.receiveParam, required this.selectedId, required this.onChanged});
//
//   final int selectedId;
//
//   final void Function(String) receiveParam;
//   final void Function(bool, int, int, String) onChanged;
//   final GlobalKey? searchScrollKey;
//   List<SelectedDoctorModel> filteredList = [];
//
//   List<SelectedDoctorModel>? list;
//
//   @override
//   State<DropDownWithSearchPopup> createState() => _DropDownWithSearchPopupState();
// }
//
// class _DropDownWithSearchPopupState extends State<DropDownWithSearchPopup> {
//   TextEditingController searchController = TextEditingController();
//
//   final searchFocusNode = FocusNode(); // Add this
//
//   @override
//   void initState() {
//     // TODO: implement initState
//     super.initState();
//
//     print("initial state called");
//     widget.filteredList = List.from(widget.list ?? []);
//     print("initState count:- ${widget.filteredList.length}");
//   }
//
//   void filterList(String value) {
//     setState(() {
//       print("filterList called");
//       print("valye is :- ${value.isEmpty}");
//       if (value.isEmpty) {
//         widget.filteredList = List.from(widget.list ?? []);
//         print("empty count:- ${widget.filteredList.length}");
//       } else {
//         widget.filteredList = (widget.list ?? []).where((item) => item.name?.toLowerCase().contains(value.toLowerCase()) ?? false).toList();
//         print("non empty count:- ${widget.filteredList.length}");
//       }
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Material(
//       color: AppColors.white,
//       child: Container(
//         width: double.infinity,
//         decoration: const BoxDecoration(),
//         child: Column(
//           children: [
//             Padding(
//               padding: const EdgeInsets.only(left: 10, right: 5, top: 8, bottom: 8),
//               child: Container(
//                 padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 0),
//                 decoration: BoxDecoration(color: AppColors.white, border: Border.all(width: 1, color: AppColors.textfieldBorder), borderRadius: BorderRadius.circular(6)),
//                 child: Padding(
//                   padding: const EdgeInsets.all(8.0),
//                   child: Row(
//                     children: [
//                       SvgPicture.asset(ImagePath.search, height: 25, width: 25),
//                       const SizedBox(width: 5),
//                       Expanded(
//                         child: TextFormField(
//                           onTap: () {
//                             final context = widget.searchScrollKey?.currentContext;
//                             if (context != null) {
//                               Scrollable.ensureVisible(context, duration: const Duration(milliseconds: 500), curve: Curves.easeInOut);
//                             }
//
//                             filterList(searchController.text);
//                             // FocusScope.of(context!).requestFocus(FocusNode());
//                           },
//                           controller: searchController,
//                           onChanged: filterList,
//                           focusNode: searchFocusNode,
//                           maxLines: 1,
//                           //or null
//                           decoration: InputDecoration.collapsed(hintText: "Search", hintStyle: AppFonts.regular(14, AppColors.textGrey)).copyWith(),
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//             ),
//             widget.filteredList.isNotEmpty
//                 ? Container(
//                   constraints: const BoxConstraints(maxHeight: 250),
//                   child: ListView.builder(
//                     shrinkWrap: true,
//                     itemBuilder: (context, index) {
//                       return GestureDetector(
//                         onTap: () {
//                           widget.onChanged(widget.filteredList[index].isSelected ?? false, index, widget.filteredList[index].id ?? -1, widget.filteredList[index].name ?? "");
//                           setState(() {});
//                         },
//                         child: Container(
//                           color: AppColors.white,
//                           child: Column(
//                             children: [
//                               const SizedBox(height: 10),
//                               Row(
//                                 children: [
//                                   Padding(padding: const EdgeInsets.only(left: 10), child: ClipRRect(borderRadius: BorderRadius.circular(14), child: BaseImageView(height: 32, width: 32, nameLetters: widget.filteredList[index].name ?? "", fontSize: 12, imageUrl: widget.filteredList[index].profileImage ?? ""))),
//                                   const SizedBox(width: 10),
//                                   Expanded(child: Container(color: AppColors.white, child: Text(widget.filteredList[index].name ?? "", maxLines: 2, overflow: TextOverflow.ellipsis, style: AppFonts.medium(14, AppColors.black)))),
//                                 ],
//                               ),
//                               const SizedBox(height: 5),
//                               const SizedBox(height: 10),
//                               if (widget.filteredList.length != index + 1) Container(color: AppColors.textfieldBorder, height: 1),
//                             ],
//                           ),
//                         ),
//                       );
//                     },
//                     itemCount: widget.filteredList.length ?? 0,
//                   ),
//                 )
//                 : const Center(child: Padding(padding: EdgeInsets.all(8.0), child: Text("No Options"))),
//           ],
//         ),
//       ),
//     );
//   }
// }

class VisitRecapDropDownWithSearchPopup extends StatefulWidget {
  VisitRecapDropDownWithSearchPopup({super.key, this.list, required this.receiveParam, required this.selectedId, required this.onChanged});

  final int selectedId;

  final void Function(String) receiveParam;
  final void Function(int) onChanged;

  List<PastVisits>? filteredList;

  // List<SelectedDoctorModel> filteredList = [];

  List<PastVisits>? list;

  @override
  State<VisitRecapDropDownWithSearchPopup> createState() => _VisitRecapDropDownWithSearchPopupState();
}

class _VisitRecapDropDownWithSearchPopupState extends State<VisitRecapDropDownWithSearchPopup> {
  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    widget.filteredList = List.from(widget.list ?? []);
  }

  void filterList(String value) {
    setState(() {
      if (value.isEmpty) {
        widget.filteredList = List.from(widget.list ?? []);
      } else {
        widget.filteredList = (widget.list ?? []).where((item) => fullVisitRecapformatDate(firstDate: item.visitDate?.toLowerCase() ?? "").contains(value.toLowerCase())).toList();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 170,
      decoration: const BoxDecoration(),
      child: Column(
        children: [
          // Padding(
          //   padding: const EdgeInsets.only(left: 10, right: 5, top: 8, bottom: 8),
          //   child: HomeCustomSearchBar(controller: searchController, onChanged: filterList, hintText: "Search", borderRadius: BorderRadius.circular(6), border: Border.all(width: 1, color: AppColors.textfieldBorder), fillColor: AppColors.white, padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 0), showClearButton: searchController.text.isNotEmpty),
          // ),
          Padding(
            padding: const EdgeInsets.all(10),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 0),
              decoration: BoxDecoration(color: AppColors.white, border: Border.all(width: 1, color: AppColors.textfieldBorder), borderRadius: BorderRadius.circular(6)),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    SvgPicture.asset(ImagePath.search, height: 25, width: 25),
                    const SizedBox(width: 5),
                    SizedBox(
                      width: 90,
                      child: TextFormField(
                        controller: searchController,
                        onChanged: filterList,
                        maxLines: 1, //or null
                        decoration: InputDecoration.collapsed(hintText: "Search", hintStyle: AppFonts.regular(14, AppColors.textGrey)).copyWith(),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          widget.filteredList?.isNotEmpty ?? false
              ? Container(
                constraints: const BoxConstraints(maxHeight: 250),
                child: ListView.builder(
                  shrinkWrap: true,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      child: Column(
                        children: [
                          GestureDetector(
                            onTap: () {
                              widget.onChanged(widget.filteredList?[index].id ?? -1);
                              // setState(() {});
                            },
                            child: Row(
                              children: [
                                // Padding(
                                //   padding: const EdgeInsets.only(left: 10),
                                //   child: ClipRRect(
                                //     borderRadius: BorderRadius.circular(14),
                                //     child: BaseImageView(
                                //       height: 32,
                                //       width: 32,
                                //       nameLetters: widget.filteredList[index].name ?? "",
                                //       fontSize: 12,
                                //       imageUrl: widget.filteredList[index].profileImage ?? "",
                                //     ),
                                //   ),
                                // ),
                                const SizedBox(width: 10),
                                Flexible(child: Text(fullVisitRecapformatDate(firstDate: widget.filteredList?[index].visitTime ?? ""), style: AppFonts.medium(14, AppColors.black))),
                              ],
                            ),
                          ),
                          const SizedBox(height: 10),
                          if (widget.filteredList?.length != index + 1) Container(color: AppColors.textfieldBorder, height: 1),
                        ],
                      ),
                    );
                  },
                  itemCount: widget.filteredList?.length ?? 0,
                ),
              )
              : const Center(child: Padding(padding: EdgeInsets.all(8.0), child: Text("No Options"))),
        ],
      ),
    );
  }

  String fullVisitRecapformatDate({required String firstDate}) {
    if (firstDate != "") {
      // Parse the first and second arguments to DateTime objects
      DateTime firstDateTime = DateTime.parse(firstDate).toLocal();

      // Format the first date (for month/day/year format)
      String formattedDate = DateFormat('MM/dd hh:mm a').format(firstDateTime);
      // Return the formatted string in the desired format
      return formattedDate;
    } else {
      return "";
    }
  }
}
