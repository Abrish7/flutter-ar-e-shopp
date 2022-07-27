import 'package:flutter/material.dart';

class Badge extends StatelessWidget {
  const Badge(
      {Key? key, required this.child, required this.value, required this.color})
      : super(key: key);

  final Widget child;
  final String value;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        child,
        Positioned(
            right: 8,
            top: 5,
            left: 20,
            child: Container(
              padding: const EdgeInsets.all(2),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: color != null ? color : Theme.of(context).accentColor),
              constraints: const BoxConstraints(maxWidth: 16, minHeight: 16),
              child: Text(
                value,
                textAlign: TextAlign.center,
                style:
                    const TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
              ),
            ))
      ],
    );
  }
}
