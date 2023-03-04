import 'package:flutter/material.dart';

class AlphabetNode extends StatelessWidget {
  const AlphabetNode({
    required this.text,
    required this.selected,
    required this.textStyle,
    required this.letterKey,
    required this.onCallBack,
    required this.selectedTextStyle,
    Key? key,
  }) : super(key: key);
  final String text;
  final bool selected;
  final TextStyle textStyle;
  final void Function() onCallBack;
  final GlobalKey letterKey;
  final TextStyle? selectedTextStyle;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      key: selected ? letterKey : null,
      onTap: onCallBack,
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: 14,
          vertical: 2,
        ),
        child: Text(
          text.toUpperCase(),
          style: selected ? selectedTextStyle : textStyle,
        ),
      ),
    );
  }
}
