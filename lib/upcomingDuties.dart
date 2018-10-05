// Copyright 2016 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

/* ToDo: Find a way to pass multiple duties as elements in an array to the build method, to create a variable number of panels
*  ToDo: See if it is possible to condense the body of the panel to keep the wasted space to a minimum
* */

import 'package:flutter/material.dart';

typedef DutyItemBodyBuilder<T> = Widget Function(DutyItem<T> item);
typedef ValueToString<T> = String Function(T value);

class DualHeaderWithHint extends StatelessWidget {
  const DualHeaderWithHint(
      {this.day,
      this.date,
      this.time,
      this.place,
      this.unitType,
      this.crew,
      this.showHint //hint ist in diesem Fall Day anstatt time
      });

  final String day;
  final String date;
  final String time;
  final String place;
  final String unitType;
  final String crew;

  final bool showHint;

  Widget _crossFade(Widget first, Widget second, bool isExpanded) {
    return AnimatedCrossFade(
      firstChild: first,
      secondChild: second,
      firstCurve: const Interval(0.0, 0.6, curve: Curves.fastOutSlowIn),
      secondCurve: const Interval(0.4, 1.0, curve: Curves.fastOutSlowIn),
      sizeCurve: Curves.fastOutSlowIn,
      crossFadeState:
          isExpanded ? CrossFadeState.showSecond : CrossFadeState.showFirst,
      duration: const Duration(milliseconds: 200),
    );
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final TextTheme textTheme = theme.textTheme;

    return Row(children: <Widget>[
      Expanded(
        flex: 2,
        child: Container(
          margin: const EdgeInsets.only(left: 24.0),
          child: FittedBox(
            fit: BoxFit.scaleDown,
            alignment: Alignment.centerLeft,
            child: Text(
              date,
              style: textTheme.body1.copyWith(fontSize: 15.0),
            ),
          ),
        ),
      ),
      Expanded(
          flex: 3,
          child: Container(
              margin: const EdgeInsets.only(left: 24.0),
              child: _crossFade(
                  Text(time, style: textTheme.caption.copyWith(fontSize: 15.0)),
                  Text(day, style: textTheme.caption.copyWith(fontSize: 15.0)),
                  showHint)))
    ]);
  }
}

class CollapsibleBody extends StatelessWidget {
  const CollapsibleBody({
    this.margin = EdgeInsets.zero,
    this.child,

    ///
    //this.onSave,
    //this.onCancel
    ///destoy
  });

  final EdgeInsets margin;
  final Widget child;

  ///
  //final VoidCallback onSave;
  //final VoidCallback onCancel;
  ///destroy
  ///
  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final TextTheme textTheme = theme.textTheme;

    return Column(children: <Widget>[
      Container(
          margin: const EdgeInsets.only(
                left: 24.0,
                right: 24.0,
                bottom: 14.0,
              ) -
              margin,
          child: Center(
              child: DefaultTextStyle(
                  style: textTheme.caption.copyWith(fontSize: 15.0),
                  child: child))),
    ]);
  }
}

class DutyItem<T> {
  DutyItem(
      {this.day,
      this.date,
      this.time,
      this.place,
      this.unitType,
      this.crew,

      ///???
      this.builder,
      this.valueToString

      ///
      });

  final String day;
  final String date;
  final String time;
  final String place;
  final String unitType;
  final String crew;

  final DutyItemBodyBuilder<T> builder;
  final ValueToString<T> valueToString;
  T value;
  bool isExpanded = false;

  ExpansionPanelHeaderBuilder get headerBuilder {
    return (BuildContext context, bool isExpanded) {
      return DualHeaderWithHint(
          date: date, time: time, day: day, showHint: isExpanded);
    };
  }

  Widget build() => builder(this);
}

class UpcomingDutiesPanel extends StatefulWidget {
  static const String routeName = '/material/expansion_panels';

  @override
  _UpcomingDutiesPanelState createState() => _UpcomingDutiesPanelState();
}

class _UpcomingDutiesPanelState extends State<UpcomingDutiesPanel> {
  List<DutyItem<dynamic>> _dutyItems;

  @override
  void initState() {
    super.initState();

    _dutyItems = <DutyItem<dynamic>>[
      DutyItem<String>(
        date: '05.10.2018',
        time: '18:00 - 21:30',
        day: 'Freitag',
        place: 'Kalsdorf',
        unitType: 'RTW',
        crew: 'Seybold Mark, Ing',
        valueToString: (String value) => value,
        builder: (DutyItem<String> duty) {
          return Container(
            child: Builder(
              builder: (BuildContext context) {
                return CollapsibleBody(
                  margin: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16.0,
                      ),
                      child: Column(
                        children: <Widget>[
                          Row(
                            children: <Widget>[
                              Icon(
                                Icons.location_on,
                                size: 15.0,
                                color: Colors.grey,
                              ),
                              Expanded(child: Text(duty.place)),
                              Icon(
                                Icons.drive_eta,
                                size: 15.0,
                                color: Colors.grey,
                              ),
                              Expanded(child: Text(duty.unitType)),
                            ],
                          ),
                          Row(
                            children: <Widget>[
                              Icon(
                                Icons.access_time,
                                size: 15.0,
                                color: Colors.grey,
                              ),
                              Expanded(child: Text(duty.time)),
                            ],
                          ),
                          Row(
                            children: <Widget>[
                              Icon(
                                Icons.people,
                                size: 15.0,
                                color: Colors.grey,
                              ),
                              Text(duty.crew),
                            ],
                          )
                        ],
                      )),
                );
              },
            ),
          );
        },
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: SafeArea(
          top: false,
          bottom: false,
          child: Container(
            margin: const EdgeInsets.all(10.0),
            child: ExpansionPanelList(
                expansionCallback: (int index, bool isExpanded) {
                  setState(() {
                    _dutyItems[index].isExpanded = !isExpanded;
                  });
                },
                children:
                    _dutyItems.map<ExpansionPanel>((DutyItem<dynamic> duty) {
                  return ExpansionPanel(
                      isExpanded: duty.isExpanded,
                      headerBuilder: duty.headerBuilder,
                      body: duty.build());
                }).toList()),
          ),
        ),
      ),
    );
  }
}

Widget upcomingDutiesList() {
  //todo:
  return SafeArea(
      child: Column(
    children: <Widget>[
      UpcomingDutiesPanel(),
    ],
  ));
}
