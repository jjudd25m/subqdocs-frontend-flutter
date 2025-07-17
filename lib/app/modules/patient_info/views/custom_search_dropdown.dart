import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../models/SelectedDoctorMedicationModel.dart';
import '../../home/views/drop_down_with_search_popup.dart';

class CustomSearchDropdown<T extends SelectedDoctorModel> extends StatefulWidget {
  final List<T> items;
  final String currentValue;
  final Function(T value, int index, int selectedId, String name) onChanged;
  final int selectedId;
  final double? dropdownWidth;

  const CustomSearchDropdown({Key? key, required this.items, required this.currentValue, required this.onChanged, required this.selectedId, this.dropdownWidth}) : super(key: key);

  @override
  _CustomSearchDropdownState<T> createState() => _CustomSearchDropdownState<T>();
}

class _CustomSearchDropdownState<T extends SelectedDoctorModel> extends State<CustomSearchDropdown<T>> {
  bool _isDropdownOpen = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _toggleDropdown,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        decoration: BoxDecoration(border: Border.all(color: Colors.grey), borderRadius: BorderRadius.circular(4)),
        child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [Text(widget.currentValue, style: const TextStyle(fontSize: 14)), Icon(_isDropdownOpen ? Icons.arrow_drop_up : Icons.arrow_drop_down, color: Colors.grey)]),
      ),
    );
  }

  void _toggleDropdown() {
    if (_isDropdownOpen) {
      Navigator.of(context).pop();
      _isDropdownOpen = false;
    } else {
      _showDialog();
      _isDropdownOpen = true;
    }
  }

  void _showDialog() {
    final renderBox = context.findRenderObject() as RenderBox;
    final position = renderBox.localToGlobal(Offset.zero);
    final size = renderBox.size;

    showDialog(
      context: context,
      barrierDismissible: true,
      barrierColor: Colors.transparent,
      builder: (context) {
        return Stack(
          children: [
            // Transparent barrier
            Positioned.fill(
              child: GestureDetector(
                onTap: () {
                  Navigator.of(context).pop();
                  _isDropdownOpen = false;
                },
                behavior: HitTestBehavior.translucent,
              ),
            ),
            // Dropdown positioned under the button
            Positioned(
              left: position.dx,
              top: position.dy + size.height + 4,
              child: Material(
                elevation: 4,
                borderRadius: BorderRadius.circular(6),
                child: Container(
                  width: widget.dropdownWidth ?? size.width,
                  constraints: BoxConstraints(maxHeight: MediaQuery.of(context).size.height * 0.5),
                  child: SingleChildScrollView(
                    child: DropDownWithSearchPopup(
                      key: UniqueKey(),
                      onChanged: (value, index, selectedId, name) {
                        widget.onChanged(value as T, index, selectedId, name);
                        Navigator.of(context).pop();
                        _isDropdownOpen = false;
                      },
                      list: widget.items,
                      receiveParam: (String value) {},
                      selectedId: widget.selectedId,
                    ),
                  ),
                ),
              ),
            ),
          ],
        );
      },
    ).then((_) {
      _isDropdownOpen = false;
    });
  }
}
