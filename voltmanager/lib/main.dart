import 'package:flutter/material.dart';
import 'helpers/database_helper.dart';

void main() => runApp(MyApp());

//my app
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Builder(
                        builder: (context) {
                          return IconButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => AddComp(),
                                ),
                              );
                            },
                            icon: Icon(Icons.add),
                            iconSize: 80,
                          );
                        },
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Builder(
                        builder: (context) {
                          return IconButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => ViewComp(),
                                ),
                              );
                            },
                            icon: Icon(Icons.visibility),
                            iconSize: 80,
                          );
                        },
                      ),
                    ],
                  ),
                ],
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Builder(
                        builder: (context) {
                          return IconButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => UseComp(),
                                ),
                              );
                            },
                            icon: Icon(Icons.shopping_cart),
                            iconSize: 80,
                          );
                        },
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Builder(
                        builder: (context) {
                          return IconButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => CalcComp(),
                                ),
                              );
                            },
                            icon: Icon(Icons.calculate_sharp),
                            iconSize: 80,
                          );
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
//my app

// addcomp page
class AddComp extends StatefulWidget {
  const AddComp({super.key});

  @override
  State<AddComp> createState() => AddCompState();
}

class AddCompState extends State<AddComp> {
  final _formKey = GlobalKey<FormState>();
  final rangeController = TextEditingController();
  final valueController = TextEditingController();
  final quantityController = TextEditingController();
  String? _selectedComp;
  bool? _componentTypeornot;
  String? _selectedType;
  List<String> units = [];
  void _saveData(BuildContext context) async {
    if (_formKey.currentState!.validate()) {
      String val = _selectedComp!;
      String typ = _selectedType!;
      int qty = int.parse(quantityController.text);
      var dbHelper = DatabaseHelper.instance;
      await dbHelper.insert({'valu': val, 'type': typ, 'quanty': qty});
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_selectedComp == 'Resistor') {
      units = ['mΩ', 'Ω', 'kΩ', 'MΩ'];
    } else if (_selectedComp == 'Capacitor') {
      units = ['pF', 'nF', 'μF', 'mF'];
    } else if (_selectedComp == 'Inductor') {
      units = ['μH', 'mH', 'H'];
    } else {
      units = ['Unknown'];
    }
    return Scaffold(
      // Add Scaffold here
      appBar: AppBar(title: Text('Add Component')),
      body: SingleChildScrollView(
        // Enables scrolling
        padding: EdgeInsets.only(
          left: 16.0,
          right: 16.0,
          bottom:
              MediaQuery.of(context).viewInsets.bottom +
              16.0, // Adapts for keyboard and screen size
        ),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              DropdownButtonFormField<String>(
                decoration: InputDecoration(labelText: 'Select Component'),
                items:
                    [
                      'Resistor',
                      'Capacitor',
                      'Inductor',
                      'Diode',
                      'Transistor',
                      'IC',
                      'LED',
                      'PCB',
                      'Battery',
                      'Others',
                    ].map((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                onChanged: (value) {
                  setState(() {
                    // Handle value change
                    _selectedComp = value;
                    _componentTypeornot = [
                      'Resistor',
                      'Capacitor',
                      'Inductor',
                      'IC',
                    ].contains(value);
                  });
                },
                validator: (value) {
                  if (value == null) {
                    return 'Please select a component';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),
              if (_componentTypeornot == true)
                DropdownButtonFormField<String>(
                  decoration: InputDecoration(labelText: 'Component Type'),
                  items:
                      ['SMD', 'Through-Hole'].map((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                  onChanged: (value) {
                    // Handle value change
                    _selectedType = value;
                  },
                  validator: (value) {
                    if (value == null) {
                      return 'Please declare component Type';
                    }
                    return null;
                  },
                ),
              SizedBox(height: 20),
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Range',
                  hintText: 'Enter component Range',
                ),
                validator: (value) {
                  return null;
                },
                controller: rangeController,
              ),
              SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      decoration: InputDecoration(
                        labelText: 'Value',
                        hintText: 'Component Value',
                      ),
                      validator: (value) {
                        return null;
                      },
                      keyboardType: TextInputType.number, // Numeric keyboard
                      controller: valueController,
                    ),
                  ),
                  SizedBox(height: 10),

                  Expanded(
                    child: DropdownButtonFormField<String>(
                      items:
                          units.map((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            );
                          }).toList(),
                      onChanged: (value) {
                        // Handle value change
                        setState(() {
                          // Update the selected value
                          // You might want to store this value and use it later
                        });
                      },
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20),
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Quantity',
                  hintText: 'Component Quantity',
                ),
                validator: (value) {
                  if (value == null) {
                    return 'Please enter component Quantity';
                  }
                  return null;
                },
                keyboardType: TextInputType.number, // Numeric keyboard
                controller: quantityController,
              ),
              SizedBox(height: 30),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    // Save data to database
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          'Components added to database successfully!!',
                        ),
                      ),
                    );
                    //send the data to db
                    _saveData(context);
                    // reset the form
                    _formKey.currentState!.reset();
                    rangeController.clear();
                    valueController.clear();
                    quantityController.clear();
                  }
                },
                child: Text("Add"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
//addcomp page

//viewcomp page
class ViewComp extends StatefulWidget {
  const ViewComp({super.key});
  @override
  ViewCompState createState() => ViewCompState();
}

class ViewCompState extends State<ViewComp> {
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
// viewcomp page

//usecomp page
class UseComp extends StatelessWidget {
  const UseComp({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(body: Text('Sorryii, this page is not developed yet'));
  }
}
//usecomp page

//calccomp page
class CalcComp extends StatelessWidget {
  const CalcComp({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(body: Text('Sorryii, this page is not developed yet'));
  }
}
