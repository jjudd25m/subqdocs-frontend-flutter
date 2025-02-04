import 'package:flutter/material.dart';
import 'package:subqdocs/utils/app_fonts.dart';

class ContainerButton extends StatelessWidget {
  final Color borderColor;
  final Color backgroundColor;
  final bool needBorder;
  final VoidCallback onPressed;
  final String text;
  final Color textColor;
  final EdgeInsetsGeometry padding;
  final double radius;

  // Default values for parameters
  const ContainerButton({
    Key? key,
    this.borderColor = Colors.blue, // default border color
    this.backgroundColor = Colors.blueAccent, // default background color
    this.needBorder = true, // default to need border
    required this.onPressed,
    required this.text,
    this.textColor = Colors.white, // default text color
    this.padding = const EdgeInsets.symmetric(vertical: 15, horizontal: 25), // default padding
    this.radius = 8.0, // default border radius
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed, // Call the onPressed function when tapped
      child: Container(
        padding: padding, // Set custom padding
        decoration: BoxDecoration(
          color: backgroundColor, // Background color
          borderRadius: BorderRadius.circular(radius), // Border radius
          border: needBorder
              ? Border.all(color: borderColor) // Set border color if needed
              : null, // No border if needBorder is false
        ),
        child: Center(
          child: Text(text, style: AppFonts.medium(14, textColor)),
        ),
      ),
    );
  }
}
