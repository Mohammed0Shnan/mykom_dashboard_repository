import 'package:charts_flutter/flutter.dart' as charts;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:my_kom_dist_dashboard/consts/colors.dart';
import 'package:my_kom_dist_dashboard/module_dashbord/models/product_model.dart';

class OrderStateChart{
  late final DateTime dateTime;
  late final int index;
  late final int orders;
  late final double revenue;
  late final ProductModel productModel;
  late final
  charts.Color?barColor;

  OrderStateChart({
    required this.index,
    required this.orders,
    required this.dateTime,
    required this.revenue
}){
    barColor =charts.ColorUtil.fromDartColor(ColorsConst.mainColor);
  }

  factory OrderStateChart.fromSnapshot(DocumentSnapshot snap , int index){

    return OrderStateChart(dateTime: snap['dateTime'].toDate(),
    index: index,
      orders: snap['orders'],
        revenue:snap['revenue']
    );
  }
  factory OrderStateChart.fromJson(Map<String,dynamic> snap , int index){

    return OrderStateChart(dateTime: snap['dateTime'],
        index: index,
        orders: snap['orders'],
        revenue:snap['revenue']
    );
  }
  static final List<OrderStateChart> data=[
    // OrderStateChart(index: 0, orders: 10, dateTime: DateTime.now()),
    // OrderStateChart(index: 1, orders: 15, dateTime: DateTime.now()),
    // OrderStateChart(index: 2, orders: 12, dateTime: DateTime.now()),
    // OrderStateChart(index: 3, orders: 10, dateTime: DateTime.now()),
    // OrderStateChart(index: 4, orders: 11, dateTime: DateTime.now()),
    // OrderStateChart(index: 5, orders: 13, dateTime: DateTime.now()),
  ];

}