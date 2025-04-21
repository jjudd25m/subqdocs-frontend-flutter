import 'package:flutter/material.dart';

import '../../../../utils/app_colors.dart';
import '../../../../utils/app_fonts.dart';

class DropDrownSearchTable extends StatefulWidget {
  final List<String> items;
  final Function(String) onItemSelected;

  const DropDrownSearchTable({Key? key, required this.items, required this.onItemSelected}) : super(key: key);

  @override
  State<DropDrownSearchTable> createState() => _DropDrownSearchTableState();
}

class _DropDrownSearchTableState extends State<DropDrownSearchTable> {
  late List<String> filteredItems;
  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    filteredItems = List.from(widget.items);
  }

  void _filterItems(String query) {
    setState(() {
      filteredItems = widget.items.where((item) => item.toLowerCase().contains(query.toLowerCase())).toList();
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
          TextField(controller: searchController, onChanged: _filterItems, decoration: InputDecoration(hintText: "Search...", hintStyle: AppFonts.regular(14, AppColors.textGrey), border: OutlineInputBorder())),
          const SizedBox(height: 8),
          ConstrainedBox(
            constraints: BoxConstraints(maxHeight: 200),
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: filteredItems.length,
              itemBuilder: (_, index) {
                return ListTile(
                  title: Text(filteredItems[index], style: AppFonts.regular(14, AppColors.black)),
                  onTap: () {
                    widget.onItemSelected(filteredItems[index]);
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
