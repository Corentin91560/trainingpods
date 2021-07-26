import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:trainingpods/models/Scenario.dart';
import 'package:trainingpods/services/google_auth.dart';

class ExpandableContainer extends StatelessWidget {
  final Scenario scenario;
  final bool expanded;
  final double collapsedHeight;
  final double expandedHeight;
  final Widget child;

  ExpandableContainer({
    required this.scenario,
    required this.child,
    this.collapsedHeight = 0.0,
    this.expandedHeight = 75.0,
    this.expanded = true,
  });

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width,
    expandedHeight = scenario.records.length > 5 ? 75*5 : 75 * scenario.records.length.toDouble();
    return new AnimatedContainer(
      duration: new Duration(milliseconds: 500),
      curve: Curves.easeInOut,
      width: screenWidth,
      height: expanded ? expandedHeight : collapsedHeight,
      child: new Container(
        child: child,
      ),
    );
  }


}
