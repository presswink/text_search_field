import 'package:material_ui/material_ui.dart';

/// this is for testing [widget]
class MyWidgetTester extends StatelessWidget {
  final Widget widget;
  const MyWidgetTester({super.key, required this.widget});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Container(
          height: 500,
          alignment: Alignment.center,
          child: widget,
        ),
      ),
    );
  }
}
