import 'package:flutter/material.dart';

void main() {
  runApp(const TipCalculatorApp());
}

class TipCalculatorApp extends StatelessWidget {
  const TipCalculatorApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Tip & Bill Split Calculator',
      theme: ThemeData(primarySwatch: Colors.teal),
      home: const TipCalculatorScreen(),
    );
  }
}

class TipCalculatorScreen extends StatefulWidget {
  const TipCalculatorScreen({super.key});

  @override
  State<TipCalculatorScreen> createState() => _TipCalculatorScreenState();
}

class _TipCalculatorScreenState extends State<TipCalculatorScreen> {
  final TextEditingController _billController = TextEditingController();

  double _billAmount = 0.0;
  double _tipPercentage = 15.0;
  int _personCount = 1;

  double get _totalTip => (_billAmount * _tipPercentage) / 100;
  double get _totalBill => _billAmount + _totalTip;
  double get _perPersonAmount => _personCount > 0 ? _totalBill / _personCount : 0.0;

  void _onBillChanged(String value) {
    setState(() {
      _billAmount = double.tryParse(value) ?? 0.0;
    });
  }

  @override
  Widget build(BuildContext context) {
    const primaryColor = Color(0xFF00796B);
    const cardBgColor = Color(0xFFE0F2F1);

    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        title: const Text('Tip & Bill Splitter', style: TextStyle(color: Colors.white)),
        backgroundColor: primaryColor,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            // Display Results Card
            Card(
              color: cardBgColor,
              elevation: 3,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  children: [
                    const Text(
                      'Total Per Person',
                      style: TextStyle(fontSize: 16, color: Colors.black54, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '\$${_perPersonAmount.toStringAsFixed(2)}',
                      style: const TextStyle(
                        fontSize: 40,
                        fontWeight: FontWeight.bold,
                        color: primaryColor,
                      ),
                    ),
                    const Divider(height: 30),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Total Tip: \$${_totalTip.toStringAsFixed(2)}', style: const TextStyle(fontSize: 14)),
                        Text('Total Bill: \$${_totalBill.toStringAsFixed(2)}', style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 25),

            // Input Bill Amount
            TextField(
              controller: _billController,
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              onChanged: _onBillChanged,
              decoration: InputDecoration(
                labelText: 'Bill Amount (\$)',
                prefixIcon: const Icon(Icons.attach_money),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                filled: true,
                fillColor: Colors.white,
              ),
            ),
            const SizedBox(height: 25),

            // Split Count Controls
            Card(
              elevation: 1,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Split Among:', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                    Row(
                      children: [
                        IconButton(
                          icon: const Icon(Icons.remove_circle_outline, color: primaryColor),
                          onPressed: () {
                            if (_personCount > 1) {
                              setState(() => _personCount--);
                            }
                          },
                        ),
                        Text('$_personCount', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                        IconButton(
                          icon: const Icon(Icons.add_circle_outline, color: primaryColor),
                          onPressed: () {
                            setState(() => _personCount++);
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 25),

            // Tip Percentage Selection
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Tip Percentage:', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                    Text('${_tipPercentage.round()}%', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: primaryColor)),
                  ],
                ),
                Slider(
                  value: _tipPercentage,
                  min: 0,
                  max: 30,
                  divisions: 30,
                  activeColor: primaryColor,
                  onChanged: (val) {
                    setState(() {
                      _tipPercentage = val;
                    });
                  },
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [10, 15, 20, 25].map((percentage) {
                    final isSelected = _tipPercentage.round() == percentage;
                    return ChoiceChip(
                      label: Text('$percentage%'),
                      selected: isSelected,
                      selectedColor: primaryColor,
                      labelStyle: TextStyle(color: isSelected ? Colors.white : Colors.black),
                      onSelected: (selected) {
                        if (selected) {
                          setState(() {
                            _tipPercentage = percentage.toDouble();
                          });
                        }
                      },
                    );
                  }).toList(),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
