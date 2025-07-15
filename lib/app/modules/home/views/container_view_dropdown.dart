import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../../../utils/imagepath.dart';

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
      child: SizedBox(
        height: 20,
        // decoration: BoxDecoration(color: AppColors.white, border: Border.all(width: 1, color: AppColors.textfieldBorder), borderRadius: BorderRadius.circular(6)),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Flexible(child: Padding(padding: const EdgeInsets.only(left: 0), child: Text((widget.name.isNotEmpty) ? widget.name : " N/A ", textAlign: TextAlign.start))),
            const SizedBox(width: 5),
            isExpand ? Padding(padding: const EdgeInsets.only(right: 15), child: SvgPicture.asset(ImagePath.upArrowDropDown, height: 7, width: 7)) : Padding(padding: const EdgeInsets.only(right: 15), child: SvgPicture.asset(ImagePath.downArrowDropDown, height: 10, width: 10)),
          ],
        ),
      ),
    );
  }
}
