import 'dart:async';

import 'package:expense_tracker/data/google_sheets_api.dart';
import 'package:expense_tracker/theme.dart';
import 'package:expense_tracker/widget/loading.dart';
import 'package:expense_tracker/widget/plus_button.dart';
import 'package:expense_tracker/widget/top_card.dart';
import 'package:expense_tracker/widget/transaction_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // collect user input
  final _textControllerAmount = TextEditingController();
  final _textControllerItem = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _isIncome = false;

  // enter the new trans to gsheets and local var
  void _enterTransaction() {
    GoogleSheetsApi.insert(
      _textControllerItem.text,
      _textControllerAmount.text,
      _isIncome,
    );
    setState(() {});
    _textControllerAmount.clear();
    _textControllerItem.clear();
    _isIncome = false;
  }

  // new trans
  void _newTransaction() {
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (BuildContext context) {
          return StatefulBuilder(
            builder: (BuildContext context, setState) {
              return AlertDialog(
                title: Text(
                  'NEW TRANSACTION',
                  style:
                      blackTextStyle(fontSize: 20).copyWith(letterSpacing: 8),
                  textAlign: TextAlign.center,
                ),
                content: SingleChildScrollView(
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Text(
                            'Expense',
                            style: blackTextStyle(fontSize: 16),
                          ),
                          Switch(
                            value: _isIncome,
                            onChanged: (newValue) {
                              setState(() {
                                _isIncome = newValue;
                              });
                            },
                          ),
                          Text(
                            'Income',
                            style: blackTextStyle(fontSize: 16),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 12,
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: Form(
                              key: _formKey,
                              child: Column(
                                children: [
                                  TextFormField(
                                    keyboardType:
                                        const TextInputType.numberWithOptions(
                                            decimal: true),
                                    inputFormatters: <TextInputFormatter>[
                                      FilteringTextInputFormatter.allow(
                                          RegExp(r'^\d*\.?\d{0,2}$')),
                                    ],
                                    decoration: InputDecoration(
                                      border: const OutlineInputBorder(
                                        borderRadius: BorderRadius.all(
                                          Radius.circular(16),
                                        ),
                                      ),
                                      hintText: 'Amount?',
                                      hintStyle: hintTextStyle(fontSize: 14),
                                    ),
                                    validator: (text) {
                                      if (text == null || text.isEmpty) {
                                        return 'Enter an amount';
                                      }
                                      return null;
                                    },
                                    controller: _textControllerAmount,
                                  ),
                                  const SizedBox(
                                    height: 12,
                                  ),
                                  Row(
                                    children: [
                                      Expanded(
                                        child: TextFormField(
                                          validator: (value) {
                                            if (value == null ||
                                                value.isEmpty) {
                                              return 'Enter a title';
                                            }
                                            return null;
                                          },
                                          style: blackTextStyle(),
                                          decoration: InputDecoration(
                                            border: const OutlineInputBorder(
                                              borderRadius: BorderRadius.all(
                                                Radius.circular(16),
                                              ),
                                            ),
                                            hintText: 'For what?',
                                            hintStyle:
                                                hintTextStyle(fontSize: 14),
                                          ),
                                          controller: _textControllerItem,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                actions: <Widget>[
                  MaterialButton(
                    color: Colors.grey[600],
                    child: Text(
                      'Cancel',
                      style: whiteTextStyle(fontSize: 16),
                    ),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                  MaterialButton(
                    color: purpleColor,
                    child: Text(
                      'Enter',
                      style: whiteTextStyle(fontSize: 16),
                    ),
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        _enterTransaction();
                        Navigator.of(context).pop();
                      }
                    },
                  )
                ],
              );
            },
          );
        });
  }

  // wait for the data to be fetched from google sheets
  bool timerHasStarted = false;
  void startLoading() {
    timerHasStarted = true;
    Timer.periodic(const Duration(seconds: 1), (timer) {
      if (GoogleSheetsApi.loading == false) {
        setState(() {});
        timer.cancel();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    // start loading until data arrives
    if (GoogleSheetsApi.loading == true && timerHasStarted == false) {
      startLoading();
    }
    return Scaffold(
      floatingActionButton: PlusButton(
        function: _newTransaction,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      backgroundColor: Colors.grey[300],
      body: SafeArea(
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.only(
            top: 25,
            right: 25,
            left: 25,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TopNeuCard(
                balance: GoogleSheetsApi.calculateBalance(),
                expense: GoogleSheetsApi.calculateExpense(),
                income: GoogleSheetsApi.calculateIncome(),
              ),
              const SizedBox(
                height: 20,
              ),
              Expanded(
                child: GoogleSheetsApi.loading == true
                    ? const LoadingTransaction()
                    : ListView.builder(
                        itemCount: GoogleSheetsApi.currentTransaction.length,
                        itemBuilder: (context, index) {
                          return TransactionItem(
                            transactionName:
                                GoogleSheetsApi.currentTransaction[index][0],
                            money: double.parse(
                              GoogleSheetsApi.currentTransaction[index][1],
                            ),
                            incomeOrExpense:
                                GoogleSheetsApi.currentTransaction[index][2],
                          );
                        },
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
