import 'package:flutter/material.dart';

import 'found_driver_details.dart';
import 'searching_driver_details.dart';

class DriverCard extends StatefulWidget {
  const DriverCard({super.key});

  @override
  State<DriverCard> createState() => _DriverCardState();
}

class _DriverCardState extends State<DriverCard> {
  bool _isDriverFound = false;

  @override
  void initState() {
    super.initState();
    // Simulate finding a driver after 2.5 seconds
    Future.delayed(const Duration(milliseconds: 2500), () {
      if (mounted) {
        setState(() {
          _isDriverFound = true;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 500),
      transitionBuilder: (child, animation) {
        return FadeTransition(
          opacity: animation,
          child: SizeTransition(
            sizeFactor: animation,
            axisAlignment: -1.0,
            child: child,
          ),
        );
      },
      child: _isDriverFound
          ? const FoundDriverDetails(key: ValueKey('found'))
          : const SearchingDriverDetails(key: ValueKey('searching')),
    );
  }
}
