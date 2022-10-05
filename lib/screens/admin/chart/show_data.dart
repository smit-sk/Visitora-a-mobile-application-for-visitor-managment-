import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:visitor_tracker/screens/admin/model/data.dart';

class ShowData extends StatefulWidget {
  const ShowData({Key? key}) : super(key: key);

  @override
  _ShowDataState createState() => _ShowDataState();
}

class _ShowDataState extends State<ShowData> {
  List<charts.Series<Data, dynamic>> _seriesBarData = [];
  List<Data>? mydata;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  _generateData(mydata) {
    print(mydata);
    _seriesBarData = [];
    _seriesBarData.add(
      charts.Series(
        domainFn: (Data data, _) => data.date,
        measureFn: (Data data, _) => int.parse(data.count),
        // colorFn: C
        id: 'Data',
        data: mydata,
        // labelAccessorFn: (Data row, _) => "${row.date}",
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _buildBody(context),
    );
  }

  Widget _buildBody(BuildContext context) {
    return SafeArea(
      child: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance
              .collection('shop')
              .doc(_auth.currentUser!.uid)
              .collection('time').snapshots(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return LinearProgressIndicator();
            } else {
              List<Data> data = snapshot.data!.docs
                  .map((e) => Data.fromMap(e.data() as Map<String, dynamic>))
                  .toList();

              return _buildChart(context, data);
            }
          }),
    );
  }

  Widget _buildChart(BuildContext context, List<Data> data) {
    mydata = data;
    _generateData(mydata);
    return Padding(
      padding: EdgeInsets.all(8.0),
      child: Container(
        child: Center(
          child: Column(
            children: <Widget>[
              Text(
                'User by Day',
                style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
              ),
              SizedBox(
                height: 10.0,
              ),
              Expanded(
                flex: 1,
                child: charts.PieChart(
                  _seriesBarData,
                    defaultRenderer: new charts.ArcRendererConfig(arcRendererDecorators: [new charts.ArcLabelDecorator()])
                  // behaviors: [
                  //   new charts.DatumLegend(
                  //     entryTextStyle: charts.TextStyleSpec(
                  //         color: charts.MaterialPalette.purple.shadeDefault,
                  //         fontFamily: 'Georgia',
                  //         fontSize: 18),
                  //   )
                  // ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
