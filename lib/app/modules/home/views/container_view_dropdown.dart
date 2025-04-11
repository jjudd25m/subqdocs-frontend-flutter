import 'dart:ffi';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../../../utils/app_colors.dart';
import '../../../../utils/app_diamentions.dart';
import '../../../../utils/imagepath.dart';
import 'chip_list.dart';

class ContainerDropdownViewPopUp extends StatefulWidget {
  final String name;
  final void Function(bool) receiveParam;
  const ContainerDropdownViewPopUp({super.key, required this.name, required this.receiveParam});

  @override
  State<ContainerDropdownViewPopUp> createState() => _ContainerDropdownViewState();
}

class _ContainerDropdownViewState extends State<ContainerDropdownViewPopUp> {
  bool isExpand = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      // onTap: () {
      //   isExpand = !isExpand;
      //   widget.receiveParam(isExpand);
      //   setState(() {});
      // },
      child: Container(
        height: 40,
        decoration: BoxDecoration(
          color: AppColors.white,
          border: Border.all(width: 1, color: AppColors.textfieldBorder),
          borderRadius: BorderRadius.circular(6),
        ),
        child: Row(
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 10),
              child: Text("${widget.name}"),
            ),
            Spacer(),
            isExpand
                ? Padding(
                    padding: const EdgeInsets.only(right: 10),
                    child: SvgPicture.asset(
                      ImagePath.upArrowDropDown,
                      height: 10,
                      width: 10,
                    ),
                  )
                : Padding(
                    padding: const EdgeInsets.only(right: 10),
                    child: SvgPicture.asset(
                      ImagePath.downArrowDropDown,
                      height: 13,
                      width: 13,
                    ),
                  )
          ],
        ),
      ),
    );
  }
}
