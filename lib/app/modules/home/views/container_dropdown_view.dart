import 'dart:ffi';

import 'package:flutter/cupertino.dart';
import 'package:flutter_svg/svg.dart';

import '../../../../utils/app_colors.dart';
import '../../../../utils/app_diamentions.dart';
import '../../../../utils/imagepath.dart';
import 'chip_list.dart';

class ContainerDropdownView extends StatefulWidget {
  final String name;
  final void Function(bool) receiveParam;
  final List<String> selectedItem;

  final Function(String, int) onRemove;
  const ContainerDropdownView({super.key, required this.name, required this.receiveParam, required this.selectedItem, required this.onRemove});

  @override
  State<ContainerDropdownView> createState() => _ContainerDropdownViewState();
}

class _ContainerDropdownViewState extends State<ContainerDropdownView> {
  bool isExpand = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        isExpand = !isExpand;
        widget.receiveParam(isExpand);
        setState(() {});
      },
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.white,
          border: Border.all(width: 1, color: AppColors.textfieldBorder),
          borderRadius: BorderRadius.circular(6),
        ),
        child: Padding(
          padding: const EdgeInsets.only(top: 8, bottom: 8),
          child: Row(
            children: [
              SizedBox(
                width: 5,
              ),
              widget.selectedItem.isNotEmpty
                  ? Expanded(
                      child: CustomCapsuleList(
                        items: widget.selectedItem,
                        onRemove: (name, index) {
                          widget.onRemove(name, index);
                        },
                      ),
                    )
                  : Padding(
                      padding: const EdgeInsets.only(left: 10),
                      child: Text("${widget.name}"),
                    ),
              if (widget.selectedItem.isEmpty) Spacer(),
              isExpand
                  ? Padding(
                      padding: const EdgeInsets.only(right: 10, left: 10),
                      child: SvgPicture.asset(
                        ImagePath.upArrowDropDown,
                        height: 10,
                        width: 10,
                      ),
                    )
                  : Padding(
                      padding: const EdgeInsets.only(right: 10, left: 10),
                      child: SvgPicture.asset(
                        ImagePath.downArrowDropDown,
                        height: 13,
                        width: 13,
                      ),
                    )
            ],
          ),
        ),
      ),
    );
  }
}
