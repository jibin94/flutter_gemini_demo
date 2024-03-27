import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

class ScrollDownButton extends StatefulWidget {
  final ScrollController controller;

  const ScrollDownButton({Key? key, required this.controller}) : super(key: key);

  @override
  State<ScrollDownButton> createState() => _ScrollDownButtonState();
}

class _ScrollDownButtonState extends State<ScrollDownButton> {
  bool isBottom = false;
  double opacity = 1;

  @override
  void initState() {
    super.initState();
    widget.controller.addListener(() {
      if (!widget.controller.hasClients) return;
      if (widget.controller.position.atEdge) {
        setState(() {
          isBottom = widget.controller.position.pixels != 0;
          if (isBottom) opacity = 0;
        });
      } else if (isBottom) {
        setState(() {
          opacity = 1;
          isBottom = false;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedOpacity(
      opacity: opacity,
      duration: 200.ms,
      child: SizedBox(
        height: 30,
        width: 30,
        child: FloatingActionButton(
          onPressed: () {
            if (!isBottom) {
              widget.controller
                  .jumpTo(widget.controller.position.maxScrollExtent);
            }
          },
          child: const Icon(Icons.arrow_downward),
        ),
      ),
    );
  }
}
