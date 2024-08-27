import 'package:admin_qurban_mart/components/text/text_component.dart';
import 'package:flutter/material.dart';

class ButtonComponent extends StatelessWidget {
  final Color? color;
  final String text;
  final double size;
  final Function()? onPressed;

  const ButtonComponent(this.text,
      {Key? key,
      this.color = Colors.green,
      this.size = 12,
      required this.onPressed})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
        style: ElevatedButton.styleFrom(backgroundColor: color),
        onPressed: onPressed,
        child: TextComponent(
          text,
          color: Colors.white,
          size: size,
        ));
  }
}
