import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:visitor_tracker/screens/admin/model/data.dart';

class ShowGroupedChart extends StatefulWidget {
  const ShowGroupedChart({Key? key}) : super(key: key);

  @override
  _ShowGroupedChartState createState() => _ShowGroupedChartState();
}

class _ShowGroupedChartState extends State<ShowGroupedChart> {
 List<StackedColumnSeries<Data, DateTime>> _seriesBarData = [];
  List<Data>? mydata;
  late TooltipBehavior _tooltipBehavior;
  late ZoomPanBehavior _zoomPanBehavior;
  final FirebaseAuth _auth = FirebaseAuth.instance;


  @override
  void initState() {
    _tooltipBehavior = TooltipBehavior(enable: true);
    _zoomPanBehavior = ZoomPanBehavior(
      enablePinching: true, enableDoubleTapZooming: true,
      enableSelectionZooming: true,
      selectionRectBorderColor: Colors.red,
      selectionRectBorderWidth: 2,
      selectionRectColor: Colors.grey,
      enablePanning: true,
      zoomMode: ZoomMode.x,
      // maximumZoomLevel: 0.7
    );
    super.initState();
  }

  _generateData(mydata) {
    print(mydata);
    _seriesBarData = [];
    _seriesBarData.add(
      StackedColumnSeries(
        selectionBehavior:
            SelectionBehavior(enable: true, unselectedOpacity: 0.5),
        name: 'Vaccinated',
        xValueMapper: (Data data, _) => DateTime.parse(data.date),
        yValueMapper: (Data data, _) => int.parse(data.vaccinated_count),
        dataSource: mydata,
        dataLabelSettings: const DataLabelSettings(isVisible: false),
        enableTooltip: true,

        // domainFn: (Data data, _) => DateTime.parse(data.date),
        // measureFn: (Data data, _) => int.parse(data.count),
        // // colorFn: C
        // id: 'Data',
        // data: mydata,
        // labelAccessorFn: (Data row, _) => "${row.date}",
      ),
    );
    _seriesBarData.add(
      StackedColumnSeries(
          selectionBehavior:
            SelectionBehavior(enable: true, unselectedOpacity: 0.5),
        name: 'Not Vaccinated',
        dataLabelSettings: const DataLabelSettings(isVisible: false),
        enableTooltip: true,
        dataSource: mydata,
        xValueMapper: (Data data, _) => DateTime.parse(data.date),
        yValueMapper: (Data data, _) => int.parse(data.not_vaccinated_count),
        // colorFn: C
        // id: 'Not Vaccinated',
        // seriesCategory: 'B',
        // data: mydata,
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
              .collection('time')
              .snapshots(),
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
              
              Expanded(
                child: SfCartesianChart(
                  title: ChartTitle(text: 'Vaccination'),
                  legend: Legend(isVisible: true),
                  tooltipBehavior: _tooltipBehavior,
                  zoomPanBehavior: _zoomPanBehavior,
                  series: _seriesBarData,
                  primaryXAxis: DateTimeAxis(
                      edgeLabelPlacement: EdgeLabelPlacement.shift,
                      dateFormat: DateFormat.MMMd(),
                      intervalType: DateTimeIntervalType.days,
                      interactiveTooltip: InteractiveTooltip(enable: false)),
                  primaryYAxis: NumericAxis(
                      interactiveTooltip: InteractiveTooltip(enable: false),
                      numberFormat: NumberFormat.decimalPattern(),
                      interval: 1),
                ),
                // child: charts.TimeSeriesChart(
                //   _seriesBarData,
                //   defaultRenderer: charts.BarRendererConfig<DateTime>(),
                //   // behaviors: [
                //   //   new charts.DatumLegend(
                //   //     entryTextStyle: charts.TextStyleSpec(
                //   //         color: charts.MaterialPalette.purple.shadeDefault,
                //   //         fontFamily: 'Georgia',
                //   //         fontSize: 18),
                //   //   )
                //   // ],
                //   defaultInteractions: false,
                //   behaviors: [
                //     charts.SelectNearest(),
                //     charts.DomainHighlighter(),
                //   ],
                // ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

