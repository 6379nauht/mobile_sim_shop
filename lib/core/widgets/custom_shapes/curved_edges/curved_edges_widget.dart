
import 'package:flutter/material.dart';

import 'curved_edges.dart';

class AppCurvedEdgeWidget extends StatelessWidget {
  const AppCurvedEdgeWidget({
    super.key, required this.child,
  });

  final Widget child;
  @override
  Widget build(BuildContext context) {
    return ClipPath(
        clipper: CurvedEdgesClipper(),
        child: child
    );
  }
}