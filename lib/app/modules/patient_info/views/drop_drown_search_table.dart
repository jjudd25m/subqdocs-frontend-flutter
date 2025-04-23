import 'package:flutter/material.dart';

import '../../../../utils/app_colors.dart';
import '../../../../utils/app_fonts.dart';
import '../../visit_main/model/doctor_view_model.dart';

class DropDrownSearchTable extends StatefulWidget {
  final List<ProcedurePossibleAlternatives> items;
  final Function(ProcedurePossibleAlternatives, int) onItemSelected;

  const DropDrownSearchTable({Key? key, required this.items, required this.onItemSelected}) : super(key: key);

  @override
  State<DropDrownSearchTable> createState() => _DropDrownSearchTableState();
}

class _DropDrownSearchTableState extends State<DropDrownSearchTable> {
  late List<ProcedurePossibleAlternatives> filteredItems = [];
  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();

    // print("DropDrownSearchTable data:- ${widget.items.first.toJson()}");

    filteredItems = List.from(widget.items);
  }

  void _filterItems(String query) {
    setState(() {
      filteredItems = widget.items.where((item) => (item.description ?? "").toLowerCase().contains(query.toLowerCase()) || (item.code ?? "").toLowerCase().contains(query.toLowerCase())).toList();
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
          SizedBox(
            height: 40,
            child: TextField(
              controller: searchController,
              onChanged: _filterItems,
              decoration: InputDecoration(hintText: "Search...", hintStyle: AppFonts.regular(14, AppColors.textGrey), border: OutlineInputBorder()),
            ),
          ),
          const SizedBox(height: 3),
          ConstrainedBox(
            constraints: BoxConstraints(maxHeight: 160),
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: filteredItems.length,
              itemBuilder: (_, index) {
                return ListTile(
                  dense: true,
                  contentPadding: EdgeInsets.zero,
                  title: Text("(${filteredItems[index].code}) ${filteredItems[index].description}", style: AppFonts.regular(12, AppColors.black)),
                  onTap: () {
                    widget.onItemSelected(filteredItems[index], index);
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
