import 'package:flutter/material.dart';

class CustomRadioButtonWidget extends StatefulWidget {
  final String label; // ボタンに表示する内容
  final bool isSelected; // ボタンが選択されたかどうかの状態
  final Color backgroundColorWhenSelected; // 選択された際の背景色
  final Color textColorWhenSelected; // 選択された際のテキスト色
  final Function(bool) onChanged; // 選択したボタンが変わった際に実行する

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
        // ボタンの現在選択されたかどうかの状態を渡す
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
          // ボタンに表示するテキスト
          child: Text(
            widget.label,
            style: TextStyle(
                color: widget.isSelected ? widget.textColorWhenSelected : Colors.black,
                fontSize: 18,
                fontWeight: FontWeight.w400
            ),
          ),
          // ボタンに表示するテキスト

        ),
      ),
    );
  }
}