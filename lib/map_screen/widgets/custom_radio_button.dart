import 'package:flutter/material.dart';

class CustomRadioButtonWidget extends StatefulWidget {
  final String label;
  final bool isSelected;
  final Color backgroundColorWhenSelected;
  final Color textColorWhenSelected;
  final Function(bool) onChanged;

  const CustomRadioButtonWidget({
    super.key,
    required this.label,
    required this.onChanged,
    required this.isSelected,
    this.backgroundColorWhenSelected = Colors.redAccent,
    this.textColorWhenSelected = Colors.white,
  });

  @override
  State<CustomRadioButtonWidget> createState() => _CustomRadioButtonWidgetState();
}

class _CustomRadioButtonWidgetState extends State<CustomRadioButtonWidget> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // 重複選択を防ぐため、選択したかどうかの状態を伝える
        widget.onChanged(widget.isSelected);
      },
      child: Container(
        decoration: BoxDecoration(
            color: widget.isSelected ? widget.backgroundColorWhenSelected : const Color(0xFFE9E9E9),
            borderRadius: const BorderRadius.all(Radius.circular(20))
        ),
        padding: const EdgeInsets.all(10),
        margin: const EdgeInsets.all(10),
        child: Center(
          // ボタンに書かれる文
          child: Text(
            widget.label,
            style: TextStyle(
                color: widget.isSelected ? widget.textColorWhenSelected : Colors.black,
                fontSize: 18,
                fontWeight: FontWeight.w400
            ),
          ),
          // ボタンに書かれる文

        ),
      ),
    );
  }
}