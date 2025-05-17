import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AppMainScreen extends StatefulWidget {
  Widget body;

  Widget? appBar;

  bool withScroll;
  Color? color ;

  AppMainScreen({
    super.key,
    this.appBar,
    required this.body,
    this.withScroll = true,
    this.color
  });

  @override
  State<AppMainScreen> createState() => _AppMainScreenState();
}

class _AppMainScreenState extends State<AppMainScreen> {
  @override
  Widget build(BuildContext context) {
    return Material(
      color: Theme.of(context).scaffoldBackgroundColor,
      child: SafeArea(
        child: Scaffold(
          backgroundColor: widget.color ??Colors.white,
          body: SingleChildScrollView(
            physics:
                widget.withScroll
                    ? AlwaysScrollableScrollPhysics()
                    : NeverScrollableScrollPhysics(),
            child: Column(
              children: [
                widget.appBar ?? SizedBox.shrink(),
                ConstrainedBox(
                  constraints: BoxConstraints(
                    minHeight: MediaQuery.sizeOf(context).height,
                  ),
                  child: widget.body,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
