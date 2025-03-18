import 'package:flutter/material.dart';
import 'package:voltmanager/helpers/database_helper.dart';

class OutputPage extends StatefulWidget {
  const OutputPage({super.key});
  @override
  OutputPageState createState() => OutputPageState();
}

class OutputPageState extends State<OutputPage> {
  List<Map<String, dynamic>> dataList = [];

  void fetchData() async {
    var dbHelper = DatabaseHelper.instance;
    List<Map<String, dynamic>> rows = await dbHelper.fetchAllRows();
    setState(() {
      dataList = rows;
    });
  }

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Saved Data')),
      body: ListView.builder(
        itemCount: dataList.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(dataList[index]['valu']),
            subtitle: Text('Quantity: ${dataList[index]['quanty']}'),
          );
        },
      ),
    );
  }
}
