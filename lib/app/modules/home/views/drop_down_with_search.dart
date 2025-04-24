import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../../../utils/app_colors.dart';
import '../../../../utils/app_fonts.dart';
import '../../../../utils/imagepath.dart';
import '../../../../widget/base_image_view.dart';
import '../../../models/SelectedDoctorMedicationModel.dart';

class DropDownWithSearch extends StatefulWidget {
  DropDownWithSearch({super.key, this.list, required this.receiveParam, required this.selectedId, required this.onChanged});

  int selectedId;

  final void Function(int) receiveParam;
  final void Function(bool, int, int, String) onChanged;
  List<SelectedDoctorModel>? list;

  List<SelectedDoctorModel> filteredList = [];

  TextEditingController searchController = TextEditingController();

  @override
  State<DropDownWithSearch> createState() => _DropDownWithSearchState();
}

class _DropDownWithSearchState extends State<DropDownWithSearch> {
  @override
  void initState() {
    widget.filteredList = List.from(widget.list ?? []);

    super.initState();
  }

  // Update the filteredList when search value changes
  void filterList(String value) {
    setState(() {
      if (value.isEmpty) {
        widget.filteredList = List.from(widget.list ?? []);
      } else {
        widget.filteredList = (widget.list ?? []).where((item) => item.name?.toLowerCase().contains(value.toLowerCase()) ?? false).toList();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(color: AppColors.white, border: Border.all(width: 1, color: AppColors.textfieldBorder), borderRadius: BorderRadius.circular(6)),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(10),
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 8, vertical: 7),
              decoration: BoxDecoration(color: AppColors.white, border: Border.all(width: 1, color: AppColors.textfieldBorder), borderRadius: BorderRadius.circular(6)),
              child: Row(
                children: [
                  SvgPicture.asset(ImagePath.search, height: 25, width: 25),
                  SizedBox(width: 10),
                  Expanded(
                    child: Container(
                      // color: AppColors.redText,
                      // width: 130,
                      child: TextFormField(
                        controller: widget.searchController,

                        onChanged: filterList,
                        maxLines: 1, //or null

                        decoration: InputDecoration.collapsed(hintText: "Search", hintStyle: AppFonts.regular(14, AppColors.textGrey)).copyWith(),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          widget.filteredList.isNotEmpty
              ? Container(
                constraints: BoxConstraints(maxHeight: 250),
                child: ListView.builder(
                  shrinkWrap: true,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      child: Column(
                        children: [
                          GestureDetector(
                            onTap: () {
                              widget.onChanged(widget.filteredList[index].isSelected ?? false, index, widget.filteredList[index].id ?? -1, widget.filteredList[index].name ?? "");
                            },
                            child: Row(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 12.5),
                                  child:
                                      widget.filteredList?[index].isSelected == false
                                          ? SvgPicture.asset(ImagePath.unCheckedBox, width: 14, height: 14)
                                          : SvgPicture.asset(ImagePath.checkedBox, width: 14, height: 14),
                                ),
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(14),
                                  child: BaseImageView(
                                    height: 32,
                                    width: 32,
                                    nameLetters: widget.filteredList?[index].name ?? "",
                                    fontSize: 12,
                                    imageUrl: widget.filteredList?[index].profileImage ?? "",
                                  ),
                                ),
                                SizedBox(width: 10),
                                Text(widget.filteredList?[index].name ?? "", style: AppFonts.medium(14, AppColors.black)),
                              ],
                            ),
                          ),
                          SizedBox(height: 10),
                          if (widget.filteredList?.length != index + 1) Container(color: AppColors.textfieldBorder, height: 1),
                        ],
                      ),
                    );
                  },
                  itemCount: widget.filteredList?.length ?? 0,
                ),
              )
              : Center(child: Padding(padding: const EdgeInsets.all(8.0), child: Text("No Options"))),
        ],
      ),
    );
  }
}
