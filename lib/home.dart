import 'package:flutter/material.dart';

import './upcomingDuties.dart';

class Home extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Column(
      children: <Widget>[
        Container(
          child: UpcomingDutiesPanel(),
        )
      ],
    );
  }
}
