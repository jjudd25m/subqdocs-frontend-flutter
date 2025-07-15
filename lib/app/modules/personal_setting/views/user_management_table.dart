import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:subqdocs/app/modules/personal_setting/views/personal_setting_view.dart';

import '../../../../utils/app_colors.dart';
import '../../../../utils/app_fonts.dart';
import '../../../../utils/imagepath.dart';
import '../../../../widgets/custom_table.dart';
import '../../visit_main/views/delete_image_dialog.dart';
import '../controllers/personal_setting_controller.dart';
import '../model/get_user_detail_model.dart';

class UserManagementTable extends StatelessWidget {
  final PersonalSettingController controller;

  const UserManagementTable({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Padding(padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 10), child: SizedBox(height: _calculateTableHeight(), child: Column(children: [_buildTableContent()])));
  }

  double _calculateTableHeight() {
    final userCount = controller.filterGetUserOrganizationListModel.value?.responseData?.length ?? 0;
    return userCount == 0 ? 300 : (userCount + 1) * 68;
  }

  Widget _buildTableContent() {
    return Obx(() {
      final users = controller.filterGetUserOrganizationListModel.value?.responseData ?? [];

      return users.isEmpty
          ? _buildNoDataFound()
          : Expanded(child: CustomTable(physics: const NeverScrollableScrollPhysics(), onRefresh: () async {}, rows: _getTableRows(users), columnCount: 7, cellBuilder: _buildTableCell, context: Get.context!, onRowSelected: (rowIndex, rowData) {}, onLoadMore: () async {}, columnWidths: const [0.16, 0.21, 0.20, 0.12, 0.12, 0.12, 0.08], headerBuilder: _buildTableHeader, isLoading: false));
    });
  }

  Widget _buildNoDataFound() {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: Center(child: Column(crossAxisAlignment: CrossAxisAlignment.center, mainAxisAlignment: MainAxisAlignment.center, children: [SvgPicture.asset(ImagePath.patient_no_data, width: 260), const SizedBox(height: 10), Text(textAlign: TextAlign.center, "No data found", style: AppFonts.medium(20, AppColors.textDarkGrey)), const SizedBox(height: 20)])),
    );
  }

  Widget _buildTableHeader(BuildContext context, int colIndex) {
    final headers = ['First Name', 'Email Address', 'Role', 'Admin', 'Status', 'Last Login Date', 'Action'];

    return GestureDetector(
      onTap: () {
        if (colIndex != 5) {
          // controller.patientSorting(colIndex: colIndex, cellData: headers[colIndex]);
        }
      },
      child: Container(color: AppColors.backgroundWhite, height: 40, child: Row(mainAxisAlignment: colIndex == 0 ? MainAxisAlignment.start : MainAxisAlignment.center, children: [Text(headers[colIndex], textAlign: colIndex == 0 ? TextAlign.start : TextAlign.center, style: AppFonts.medium(12, AppColors.black), softWrap: true, overflow: TextOverflow.ellipsis)])),
    );
  }

  List<List<String>> _getTableRows(List<GetUserOrganizationListResponseData> users) {
    return users.map((user) => [user.name ?? "N/A", user.email ?? "N/A", user.role ?? "", user.isAdmin == true ? "Yes" : "No", user.role ?? "", user.lastLoginDate != null ? DateFormat('MM/dd/yyyy').format(DateTime.parse(user.lastLoginDate.toString())) : "-", "Action"]).toList();
  }

  Widget _buildTableCell(BuildContext context, int rowIndex, int colIndex, String cellData, String profileImage) {
    final user = controller.getUserOrganizationListModel.value?.responseData?[rowIndex];

    switch (colIndex) {
      case 0:
        return _buildNameCell(cellData);
      case 1:
        return _buildEmailCell(cellData, user?.id);
      // case 2: return _buildRoleDropdown(user, rowIndex);
      case 3:
        return _buildAdminSwitch(user, rowIndex);
      case 4:
        return _buildStatusCell(user);
      case 6:
        return _buildActionCell(user);
      default:
        return _buildDefaultCell(cellData, colIndex);
    }
  }

  Widget _buildNameCell(String name) {
    return GestureDetector(onTap: () {}, child: Row(children: [Expanded(child: Text(name, maxLines: 2, textAlign: TextAlign.start, style: AppFonts.regular(14, AppColors.textDarkGrey), softWrap: true, overflow: TextOverflow.ellipsis))]));
  }

  Widget _buildEmailCell(String email, int? userId) {
    return email == "N/A" ? GestureDetector(onTap: () => _showEmailDialog(userId ?? 0), child: Text("+ Provide Email", textAlign: TextAlign.center, style: AppFonts.regular(14, AppColors.textPurple))) : Text(email, textAlign: TextAlign.center, style: AppFonts.regular(14, AppColors.textDarkGrey));
  }

  // Widget _buildRoleDropdown(GetUserOrganizationListResponseData? user, int rowIndex) {
  //   return IgnorePointer(
  //       ignoring: user?.suspended ?? false,
  //       child: PopupMenuButton<String>(
  //           offset: const Offset(0, 8),
  //           shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
  //           color: AppColors.white,
  //           position: PopupMenuPosition.under,
  //           padding: EdgeInsetsDirectional.zero,
  //           menuPadding: EdgeInsetsDirectional.zero,
  //           onSelected: (value) {},
  //           style: const ButtonStyle(
  //             padding: WidgetStatePropertyAll(EdgeInsetsDirectional.zero),
  //             tapTargetSize: MaterialTapTargetSize.shrinkWrap,
  //             maximumSize: WidgetStatePropertyAll(Size.zero),
  //             visualDensity: VisualDensity(horizontal: 0, vertical: 0),
  //           ),
  //           itemBuilder: (context) => [
  //           for (var item in controller.userRolesModel.value?.responseData ?? [])
  //       PopupMenuItem(
  //       padding: EdgeInsets.zero,
  //       onTap: () => controller.updateRoleAndAdminControll(
  //         user?.id.toString() ?? "",
  //         item,
  //         user?.isAdmin ?? false,
  //         rowIndex,
  //       ),
  //       child: Padding(
  //         padding: const EdgeInsets.all(8.0),
  //         child: Text(item, style: AppFonts.regular(14, AppColors.textBlack)),
  //       ),
  //       ],
  //   child: Container(
  //   decoration: BoxDecoration(
  //   color: AppColors.dropdownBackgroundColor,
  //   border: Border.all(color: AppColors.dropdownBorderColor, width: 2),
  //   borderRadius: const BorderRadius.all(Radius.circular(23.0)),
  //   width: 100,
  //   height: 38,
  //   child: Row(
  //   children: [
  //   const SizedBox(width: 10),
  //   Text(
  //   user?.role ?? "",
  //   textAlign: TextAlign.start,
  //   style: AppFonts.regular(14, AppColors.textDarkGrey),
  //   softWrap: true,
  //   overflow: TextOverflow.ellipsis,
  //   ),
  //   const Spacer(),
  //   SvgPicture.asset(ImagePath.down_arrow, width: 20, height: 20),
  //   const SizedBox(width: 10),
  //   ],
  //   ),
  //   ),
  //   ),
  //   );
  // }

  Widget _buildAdminSwitch(GetUserOrganizationListResponseData? user, int rowIndex) {
    return IgnorePointer(
      ignoring: user?.suspended ?? false,
      child: SizedBox(
        height: 30,
        child: Transform.scale(
          scale: 0.7,
          child: Switch(
            padding: EdgeInsets.zero,
            materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
            splashRadius: 0,
            value: user?.isAdmin ?? false,
            activeColor: AppColors.backgroundPurple,
            onChanged: (bool value) {
              controller.updateRoleAndAdminControll(user?.id.toString() ?? "", user?.role ?? "", value, rowIndex);
            },
          ),
        ),
      ),
    );
  }

  Widget _buildStatusCell(GetUserOrganizationListResponseData? user) {
    return Padding(
      padding: const EdgeInsets.only(left: 5),
      child: Container(
        decoration: BoxDecoration(color: (user?.suspended == true) ? AppColors.redText.withValues(alpha: 0.2) : AppColors.textPurple.withValues(alpha: 0.2), borderRadius: BorderRadius.circular(16)),
        child: Padding(padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6), child: Text((user?.suspended == true) ? "Suspended" : "Active", maxLines: 2, overflow: TextOverflow.visible, textAlign: TextAlign.center, style: AppFonts.medium(13, (user?.suspended == true) ? AppColors.redText : AppColors.textPurple))),
      ),
    );
  }

  Widget _buildActionCell(GetUserOrganizationListResponseData? user) {
    return GestureDetector(onTap: () => _showDeleteUserDialog(user?.inviteId.toString() ?? ""), child: SvgPicture.asset(ImagePath.user_trash, height: 25, width: 25));
  }

  Widget _buildDefaultCell(String cellData, int colIndex) {
    return Text(cellData, textAlign: colIndex == 0 ? TextAlign.start : TextAlign.center, style: AppFonts.regular(14, AppColors.textDarkGrey), softWrap: true, overflow: TextOverflow.ellipsis);
  }

  void _showEmailDialog(int userId) {
    showEmailDialog(userId, Get.context!, controller);
  }

  void _showDeleteUserDialog(String inviteId) {
    showDialog(
      context: Get.context!,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return DeletePatientDialog(
          title: "Are you sure want to delete user?",
          onDelete: () {
            Get.back();
            controller.deleteUserManagementMember(inviteId);
          },
          header: "Delete user",
        );
      },
    );
  }
}
