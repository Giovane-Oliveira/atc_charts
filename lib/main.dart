import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ATC Charts',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.wewqewe
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'ATC Charts Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late List<SalesData> _chartData;
  late TooltipBehavior _tooltipBehavior;

   _recuperarDados() async {

    String url = "http://192.168.200.11/read.php";
    http.Response response;
    response = await http.get(Uri.parse(url));
    Map<String, dynamic> retorno = json.decode( response.body );
    String empresa = retorno["cod_empresa"].toString();
    String carga = retorno["cod_carga"].toString();
    print("Empresa $empresa");
    print("Carga $carga");

  }

  @override
  void initState() {
    _chartData = getChartData();
    _tooltipBehavior = TooltipBehavior(enable: true);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
            body: SfCartesianChart(
              title: ChartTitle(text: 'Vendas Anuais'),
              legend: Legend(isVisible: true),
              tooltipBehavior: _tooltipBehavior,
              series: <ChartSeries>[
                LineSeries<SalesData, dynamic>(
                    name: 'Vendas',
                    dataSource: _chartData,
                    xValueMapper: (SalesData sales, _) => sales.year,
                    yValueMapper: (SalesData sales, _) => sales.sales,
                    dataLabelSettings: DataLabelSettings(isVisible: true),
                    enableTooltip: true)
              ],
              primaryXAxis: NumericAxis(
                edgeLabelPlacement: EdgeLabelPlacement.shift,
              ),
              primaryYAxis: NumericAxis(
                 // labelFormat: '{value}M',

                  numberFormat: NumberFormat.simpleCurrency(locale: 'pt_BR', decimalDigits: 2)),
            )));
  }

  List<SalesData> getChartData() {

    _recuperarDados();
    final List<SalesData> chartData = [
      SalesData(2016, 25.50),
      SalesData(2017, 12),
      SalesData(2018, 40),
      SalesData(2019, 18),
      SalesData(2020, 30)
    ];
    return chartData;
  }
}

class SalesData {
  SalesData(this.year, this.sales);

  final double year;
  final double sales;

}