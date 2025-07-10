// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:intl/intl.dart';
// import 'package:subqdocs/widget/time_slot_selected.dart';
//
// import '../utils/app_colors.dart';
// import '../utils/app_fonts.dart';
//
// class VisitTimeSelector extends StatefulWidget {
//
//   List<String> visitTime;
//   FocusNode? focusNode;
//
//
//
//   VisitTimeSelector({required this.visitTime , this.focusNode});
//
//   @override
//   _VisitTimeSelectorState createState() => _VisitTimeSelectorState();
// }
//
// class _VisitTimeSelectorState extends State<VisitTimeSelector> {
//
//
//   void _validateVisitTime() {
//     final input = selectedVisitTimeValue?.trim() ?? '';
//
//     if (input.isEmpty) {
//       setState(() {
//         validationMessage = "Please enter a valid time.";
//       });
//       return;
//     }
//
//     DateTime? selectedTime;
//     try {
//       // Try parsing time with AM/PM
//       selectedTime = DateFormat('hh:mm a').parseStrict(input);
//     } catch (e) {
//       // Parsing failed → invalid time format
//       setState(() {
//         validationMessage = "Please enter a valid time.";
//       });
//       return;
//     }
//
//     final DateTime openingTime = DateFormat('hh:mm a').parse("07:00 AM");
//     final DateTime closingTime = DateFormat('hh:mm a').parse("11:59 PM");
//
//     if (selectedTime.isBefore(openingTime) || selectedTime.isAfter(closingTime)) {
//       setState(() {
//         validationMessage = "This visit is outside normal operating hours and time is not valid.";
//       });
//       return;
//     }
//
//     // All good, clear message
//     setState(() {
//       validationMessage = null;
//     });
//   }
//
//
//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Row(
//           children: [
//             Text("Visit Time", style: AppFonts.regular(14, AppColors.textBlack)),
//             Text("*", style: AppFonts.regular(14, AppColors.redText)),
//             if (validationMessage != null) ...[
//               SizedBox(width: 8),
//               Text(validationMessage!, style: AppFonts.regular(12,AppColors.redText)),
//             ]
//           ],
//         ),
//         SizedBox(height: 8),
//         TimeSlotTypeAhead(
//           focusNode: widget.focusNode,
//           prefixIcon: Icon(Icons.keyboard_arrow_down_rounded, color: AppColors.textDarkGrey),
//           timeSlotSuggestions: widget.visitTime,
//           selectedValue: selectedVisitTimeValue ?? "Select Visit Time",
//           onSelected: (value) {
//             setState(() {
//               selectedVisitTimeValue = value;
//               validationMessage = null; // Clear message on valid select
//             });
//           },
//           onFocusLost: _validateVisitTime,
//         ),
//       ],
//     );
//   }
// }
