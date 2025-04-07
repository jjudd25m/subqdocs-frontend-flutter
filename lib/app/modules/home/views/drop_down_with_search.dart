import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../../../utils/app_colors.dart';
import '../../../../utils/app_diamentions.dart';
import '../../../../utils/app_fonts.dart';
import '../../../../utils/imagepath.dart';
import '../../../../widget/base_image_view.dart';
import '../../../models/MedicalDoctorModel.dart';

class DropDownWithSearch extends StatelessWidget {
  DropDownWithSearch({super.key, this.list, required this.receiveParam, required this.selectedId});

  int selectedId;

  final void Function(int id) receiveParam;
  MedicalDoctorModel? list;
  @override
  Widget build(BuildContext context) {
    return Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: AppColors.white,
          border: Border.all(width: 1, color: AppColors.textfieldBorder),
          borderRadius: BorderRadius.circular(6),
        ),
        child: list != null && list?.responseData != null && list?.responseData?.length != 0
            ? Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(10),
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 7),
                      decoration: BoxDecoration(
                        color: AppColors.white,
                        border: Border.all(width: 1, color: AppColors.textfieldBorder),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Row(
                        children: [
                          SvgPicture.asset(
                            ImagePath.search,
                            height: 25,
                            width: 25,
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          SizedBox(
                            width: 130,
                            child: TextFormField(
                              onChanged: (value) {},
                              maxLines: 1, //or null

                              decoration: InputDecoration.collapsed(hintText: "Search", hintStyle: AppFonts.regular(14, AppColors.textGrey)).copyWith(),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Container(
                    constraints: BoxConstraints(maxHeight: 250),
                    child: ListView.builder(
                      shrinkWrap: true,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          child: Column(
                            children: [
                              Row(
                                children: [
                                  Padding(
                                      padding: const EdgeInsets.symmetric(horizontal: 12.5),
                                      child: selectedId != list?.responseData?[index].id
                                          ? SvgPicture.asset(
                                              ImagePath.unCheckedBox,
                                              width: 14,
                                              height: 14,
                                            )
                                          : SvgPicture.asset(
                                              ImagePath.checkedBox,
                                              width: 14,
                                              height: 14,
                                            )),
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(14),
                                    child: BaseImageView(
                                      height: 32,
                                      width: 32,
                                      nameLetters: list?.responseData?[index].name ?? "",
                                      fontSize: 12,
                                      imageUrl: list?.responseData?[index].profileImage ?? "",
                                    ),
                                  ),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Text(
                                    list?.responseData?[index].name ?? "",
                                    style: AppFonts.medium(14, AppColors.black),
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              if (list?.responseData?.length != index + 1)
                                Container(
                                  color: AppColors.textfieldBorder,
                                  height: 1,
                                )
                            ],
                          ),
                        );
                      },
                      itemCount: list?.responseData?.length ?? 0,
                    ),
                  )
                ],
              )
            : Center(
                child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text("No Data Found"),
              )));
  }
}
