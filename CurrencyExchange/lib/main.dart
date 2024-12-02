
import 'package:flutter/material.dart';

void main() => runApp(CurrencyExchangeApp());

class CurrencyExchangeApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: CurrencyExchangeScreen(),
    );
  }
}

class CurrencyExchangeScreen extends StatefulWidget {
  @override
  _CurrencyExchangeScreenState createState() => _CurrencyExchangeScreenState();
}

class _CurrencyExchangeScreenState extends State<CurrencyExchangeScreen> {
  final TextEditingController amountController = TextEditingController();
  final TextEditingController otherAmountController = TextEditingController();

  String fromCurrency = 'USD';
  String toCurrency = 'USD';
  String otherFromCurrency = 'USD';
  String toOther = 'gold';

  double convertedResult = 0.0;
  double otherConvertedResult = 0.0;

  final Map<String, Map<String, double>> currencyRates = {
    'USD': {'USD': 1, 'EUR': 0.92, 'LBP': 90000, 'JPY': 145.3},
    'EUR': {'USD': 1.09, 'EUR': 1, 'LBP': 95000, 'JPY': 157.8},
    'LBP': {'USD': 0.000011, 'EUR': 0.0000105, 'LBP': 1, 'JPY': 0.0017},
    'JPY': {'USD': 0.0069, 'EUR': 0.0063, 'LBP': 596, 'JPY': 1},
  };

  final Map<String, double> metalRates = {
    'gold': 60.0,
    'silver': 0.7,
    'aluminum': 0.002,
    'bitcoin': 27000.0,
  };

  void convertCurrency() {
    double amount = double.tryParse(amountController.text) ?? 0.0;
    if (amount <= 0) {
      showAlert('Please enter a valid amount.');
      return;
    }

    setState(() {
      double rate = currencyRates[fromCurrency]?[toCurrency] ?? 1.0;
      convertedResult = amount * rate;
    });
  }

  void convertToOther() {
    double amount = double.tryParse(otherAmountController.text) ?? 0.0;
    if (amount <= 0) {
      showAlert('Please enter a valid amount.');
      return;
    }

    setState(() {
      double usdAmount =
          amount * (currencyRates[otherFromCurrency]?['USD'] ?? 1.0);
      otherConvertedResult = usdAmount / (metalRates[toOther] ?? 1.0);
    });
  }

  void showAlert(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Error'),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('OK'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Currency Exchange'),
        backgroundColor: Colors.green,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'Currency Converter',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 20),
              TextField(
                controller: amountController,
                decoration: InputDecoration(
                  labelText: 'Enter Amount',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
              ),
              SizedBox(height: 10),
              Row(
                children: [
                  Expanded(
                    child: DropdownButtonFormField<String>(
                      value: fromCurrency,
                      decoration: InputDecoration(
                        labelText: 'From',
                        border: OutlineInputBorder(),
                      ),
                      items: currencyRates.keys
                          .map((e) => DropdownMenuItem(
                                value: e,
                                child: Text(e),
                              ))
                          .toList(),
                      onChanged: (value) {
                        setState(() {
                          fromCurrency = value!;
                        });
                      },
                    ),
                  ),
                  SizedBox(width: 10),
                  Expanded(
                    child: DropdownButtonFormField<String>(
                      value: toCurrency,
                      decoration: InputDecoration(
                        labelText: 'To',
                        border: OutlineInputBorder(),
                      ),
                      items: currencyRates.keys
                          .map((e) => DropdownMenuItem(
                                value: e,
                                child: Text(e),
                              ))
                          .toList(),
                      onChanged: (value) {
                        setState(() {
                          toCurrency = value!;
                        });
                      },
                    ),
                  ),
                ],
              ),
              SizedBox(height: 10),
              ElevatedButton(
                onPressed: convertCurrency,
                child: Text('Convert'),
                style: ElevatedButton.styleFrom(
                  primary: Colors.green,
                ),
              ),
              SizedBox(height: 10),
              Text(
                'Converted Amount: ${convertedResult.toStringAsFixed(2)}',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              Divider(),
              Text(
                'Currency to Metals & Crypto Converter',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 20),
              TextField(
                controller: otherAmountController,
                decoration: InputDecoration(
                  labelText: 'Enter Amount',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
              ),
              SizedBox(height: 10),
              Row(
                children: [
                  Expanded(
                    child: DropdownButtonFormField<String>(
                      value: otherFromCurrency,
                      decoration: InputDecoration(
                        labelText: 'Currency',
                        border: OutlineInputBorder(),
                      ),
                      items: currencyRates.keys
                          .map((e) => DropdownMenuItem(
                                value: e,
                                child: Text(e),
                              ))
                          .toList(),
                      onChanged: (value) {
                        setState(() {
                          otherFromCurrency = value!;
                        });
                      },
                    ),
                  ),
                  SizedBox(width: 10),
                  Expanded(
                    child: DropdownButtonFormField<String>(
                      value: toOther,
                      decoration: InputDecoration(
                        labelText: 'To Metals & Crypto',
                        border: OutlineInputBorder(),
                      ),
                      items: metalRates.keys
                          .map((e) => DropdownMenuItem(
                                value: e,
                                child: Text(e),
                              ))
                          .toList(),
                      onChanged: (value) {
                        setState(() {
                          toOther = value!;
                        });
                      },
                    ),
                  ),
                ],
              ),
              SizedBox(height: 10),
              ElevatedButton(
                onPressed: convertToOther,
                child: Text('Convert'),
                style: ElevatedButton.styleFrom(
                  primary: Colors.brown,
                ),
              ),
              SizedBox(height: 10),
              Text(
                'Converted Value: ${otherConvertedResult.toStringAsFixed(4)}',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
