import 'package:flutter/material.dart';
import 'helpers/database_helper.dart';

void main() => runApp(MyApp());

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
  String? _selectedValue;
  String? _selectedType;
  void _saveData(BuildContext context) async {
    if (_formKey.currentState!.validate()) {
      String val = _selectedValue!;
      String typ = _selectedType!;
      int qty = int.parse(quantityController.text);

      var dbHelper = DatabaseHelper.instance;
      await dbHelper.insert({'valu': val, 'type': typ, 'quanty': qty});
    }
  }

  @override
  Widget build(BuildContext context) {
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
                  _selectedValue = value;
                },
                validator: (value) {
                  if (value == null) {
                    return 'Please select a component';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),
              DropdownButtonFormField<String>(
                decoration: InputDecoration(labelText: 'Component Type'),
                items:
                    ['SMD', 'Through-Hole', 'Others'].map((String value) {
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
                          ['k', 'm', 'u', 'n', 'M'].map((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            );
                          }).toList(),
                      onChanged: (value) {},
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

class ViewComp extends StatelessWidget {
  const ViewComp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(body: Text('Sorry, this page is not developed yet')),
    );
  }
}

class UseComp extends StatelessWidget {
  const UseComp({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(body: Text('Sorryii, this page is not developed yet'));
  }
}

class CalcComp extends StatelessWidget {
  const CalcComp({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(body: Text('Sorryii, this page is not developed yet'));
  }
}
