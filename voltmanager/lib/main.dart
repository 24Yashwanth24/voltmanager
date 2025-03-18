import 'package:flutter/material.dart';

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
                      IconButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => AddComp()),
                          );
                        },
                        icon: Icon(Icons.add),
                        iconSize: 80,
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      IconButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => ViewComp()),
                          );
                        },
                        icon: Icon(Icons.visibility),
                        iconSize: 80,
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
                      IconButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => UseComp()),
                          );
                        },
                        icon: Icon(Icons.shopping_cart),
                        iconSize: 80,
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      IconButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => CalcComp()),
                          );
                        },
                        icon: Icon(Icons.calculate_sharp),
                        iconSize: 80,
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

  @override
  Widget build(BuildContext context) {
    return Center(
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
                // Handle value change
              },
              validator: (value) {
                if (value == null) {
                  return 'Please select a component';
                }
                return null;
              },
            ),
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
              },
              validator: (value) {
                if (value == null) {
                  return 'Please declare component Type';
                }
                return null;
              },
            ),
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
            Row(
              children: [
                TextFormField(
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
                DropdownButtonFormField<String>(
                  items:
                      ['k', 'm', 'u', 'n', 'M'].map((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                  onChanged: (value) {},
                ),
              ],
            ),
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
    );
  }
}

class ViewComp extends StatelessWidget {
  const ViewComp({super.key});
  @override
  Widget build(BuildContext context) {
    return Center(child: Text('Sorry, this page is not developed yet'));
  }
}

class UseComp extends StatelessWidget {
  const UseComp({super.key});
  @override
  Widget build(BuildContext context) {
    return Center(child: Text('Sorry, this page is not developed yet'));
  }
}

class CalcComp extends StatelessWidget {
  const CalcComp({super.key});
  @override
  Widget build(BuildContext context) {
    return Center(child: Text('Sorry, this page is not developed yet'));
  }
}
