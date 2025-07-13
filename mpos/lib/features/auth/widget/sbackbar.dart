import 'package:flutter/material.dart';

class TopSnackbar extends StatefulWidget {
  final String message;
  final Duration duration;

  const TopSnackbar({
    Key? key,
    required this.message,
    this.duration = const Duration(seconds: 3),
  }) : super(key: key);

  @override
  _TopSnackbarState createState() => _TopSnackbarState();
}

class _TopSnackbarState extends State<TopSnackbar> {
  bool _visible = false;

  @override
  void initState() {
    super.initState();
    _showSnackbar();
  }

  void _showSnackbar() async {
    await Future.delayed(const Duration(milliseconds: 20));
    setState(() {
      _visible = true;
    });

    await Future.delayed(widget.duration);
    if (mounted) {
      setState(() {
        _visible = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Align(
        alignment: Alignment.topCenter,
        child: AnimatedSlide(
          offset: _visible ? Offset.zero : const Offset(0, -1),
          duration: const Duration(milliseconds: 500),
          child: Material(
            elevation: 6,
            borderRadius: BorderRadius.circular(12),
            color: Colors.indigo[900],
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
              child: Text(
                widget.message,
                style: const TextStyle(color: Color.fromARGB(255, 255, 255, 255), fontSize: 16, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ),
      ),
    );
  }
}




void showTopSnackbar(BuildContext context, String message) {
  OverlayEntry overlayEntry = OverlayEntry(
    builder: (context) => Positioned(
      top: 0,
      left: 0,
      right: 0,
      child: TopSnackbar(message: message),
    ),
  );

  Overlay.of(context).insert(overlayEntry);

  Future.delayed(const Duration(seconds: 3), () {
    overlayEntry.remove();
  });
}
