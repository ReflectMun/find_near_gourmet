import 'package:flutter/material.dart';

class CustomDistanceRadioButton extends StatefulWidget {
  final String label;
  bool isSelected;
  final Function(bool) onChanged;

  CustomDistanceRadioButton({
    super.key,
    required this.label,
    required this.onChanged,
    required this.isSelected,
  });

  @override
  State<CustomDistanceRadioButton> createState() => _CustomDistanceRadioButtonState();
}

class _CustomDistanceRadioButtonState extends State<CustomDistanceRadioButton> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        widget.onChanged(!widget.isSelected);
      },
      child: Container(
        decoration: BoxDecoration(
            color: widget.isSelected ? Colors.redAccent : const Color(0xFFE9E9E9),
            borderRadius: const BorderRadius.all(Radius.circular(20))
        ),
        padding: const EdgeInsets.all(10),
        margin: const EdgeInsets.all(10),
        child: Center(
          child: Text(
            widget.label,
            style: TextStyle(
                color: widget.isSelected ? Colors.white : Colors.black,
                fontSize: 18,
                fontWeight: FontWeight.w400
            ),
          ),
        ),
      ),
    );
  }
}