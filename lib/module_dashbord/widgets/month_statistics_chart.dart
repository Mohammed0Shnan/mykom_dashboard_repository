import 'package:flutter/material.dart';
import 'package:my_kom_dist_dashboard/module_dashbord/models/order_state_chart.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:syncfusion_flutter_charts/sparkcharts.dart';

class MonthStatisticsChart extends StatefulWidget {
  final Map<String , OrderStateChart> data;
   MonthStatisticsChart({ required this.data, Key? key}) : super(key: key);

  @override
  State<MonthStatisticsChart> createState() => _MonthStatisticsChartState();
}

class _MonthStatisticsChartState extends State<MonthStatisticsChart> {




  List<_SalesData> _monthes = [

  ];
@override
  void initState() {
    widget.data.forEach((key, value) {
      _monthes.add(_SalesData(key, value.revenue, value.orders));


    });
    print(_monthes);
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Column(children: [
      //Initialize the chart widget
      SfCartesianChart(
          primaryXAxis: CategoryAxis(),
          // Chart title
          title: ChartTitle(text: 'Monthly sales analysis'),
          // Enable legend
          legend: Legend(isVisible: true),
          // Enable tooltip
          tooltipBehavior: TooltipBehavior(enable: true),
          series: <ChartSeries<_SalesData, String>>[
            LineSeries<_SalesData, String>(
                dataSource: _monthes,
                xValueMapper: (_SalesData sales, _) => sales.month,
                yValueMapper: (_SalesData sales, _) => sales.orders,
                name: 'Sales',
                // Enable data label
                dataLabelSettings: DataLabelSettings(isVisible: true))
          ]),
      Expanded(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          //Initialize the spark charts widget
          child: SfSparkLineChart.custom(
            //Enable the trackball
            trackball: SparkChartTrackball(
                activationMode: SparkChartActivationMode.tap),
            //Enable marker
            marker: SparkChartMarker(
                displayMode: SparkChartMarkerDisplayMode.all),
            //Enable data label
            labelDisplayMode: SparkChartLabelDisplayMode.all,
            xValueMapper: (int index) => _monthes[index].month,
            yValueMapper: (int index) => _monthes[index].sales,

            dataCount: _monthes.length,
          ),
        ),
      )
    ]);
  }

}

class _SalesData {
  _SalesData(this.month, this.sales,this.orders);

  final String month;
  final double sales;
  final int orders;
}