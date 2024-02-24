import 'package:flutter/material.dart';
import 'package:gsheets/gsheets.dart';

class GoogleSheetsApi {
  // creds
  static const _creds = r'''
{
  "type": "service_account",
  "project_id": "belajar-flutter-gsheets",
  "private_key_id": "addd97c4177a16e4add9a40fa2ddf56abf4d5e12",
  "private_key": "-----BEGIN PRIVATE KEY-----\nMIIEvQIBADANBgkqhkiG9w0BAQEFAASCBKcwggSjAgEAAoIBAQC9yH+hTUGEDGYQ\np3SKHoy1W2KgbgGX1eUNYIb6eRuK9/8OyeD0Tm4CvMOioxbv8zUTFSNA9oGn7nd0\nEtTVaEz52Tck8yje9uw+AmsfpIDKG4BjQkZ8CWbcREmILesqfvvF+PBAvMtfbNX+\nlyn0ylAeF/dsxMfHLbe7lWIQTEOsyWGpPfp0Rx6YfOwAdnv6lo9to8PTKADN6wDR\nmfsTFDUPEhtU0jZ4J2qxyf8GGqp292zq8KCH5OoxJ8G46/K4P0kEBUJYe7qJn2zQ\nog8luKTSlptq33xksPZmshGV+BP3Jd2FLrYshJ8s7EVMkA4hLsaxZr98zoJCOJRK\nG5TUe0ypAgMBAAECggEAAbY/ydAybEMCXq8WrYebWagdNSOY5Go7r98JiKk0AZES\nyMAzGnEPVqX7lnQl06dGzh5thtCnwxXdwlBzLAj4p3Oj/DOB+wo7f6Rc8VhLXcdZ\nZUvRP/LZGIPjLT/LdG2DJDoxIfGyB0Z/jarbvYdfqU3VCl2iDF68tAv5FPrjIg6x\nAHk2KoXn+7UjKOKlGLyT20dd2e0jadok44jwGvfKYcowdrJ/rWobNHHBwyNRdJiq\nEiYPv2zs9neUwdtJB6oUIcs9IjyvoGypnX9AEJouxgxBNKQZUdH5RoY43uxaPqKt\n8PFhDJAjBHO1jKxz/5qDm0nOInOaZ66D1i01fLaUOwKBgQDlpTrt1EVvolPpB3TS\nS8rmX4HiPTrk7x0a3z72VQY/pMuxPsmQXA6jUxHa58DVab9QFn1ffM6tj37jm128\nvtAFn3+9M88PFyfDTeJ4pAqAPk057BcxwiHItAEaCJkFLJ4VQcp41wVyOppgAcPl\nsqhMwgqLg/PP+g7mchhdtqT4jwKBgQDTkCcl2zrXnkXLUSSaSfc2gXD/2AqygDta\ngHfmQPNRwzv72pQ2//h3KcKpQJk7gMoepJ0o3unl/1JzZchulI+c8XXjxf0O2scJ\nN1Af/TTfaMDvXJWkhrey2/nDc7mim6Z+vMsXLd14wzyaki0VttZ/gXpVNILZ2qNI\npUE2t5xTRwKBgDl6IIS0M2jcdSoG/rs/0xnT37tTXfE808kNBUI8R6MYSQ8kyuhB\n0jwYp4hlpwMDQ6n05w5GO6h/GOA4275I9+HgaOVfGT0Kq54bWUqerC4q6cNMjwWa\nNEB6pSfx7PK5lxt06wtRrgBIIKlU58YO8Ea97ku7DAQK7z3IYsbZ1vKLAoGBAK+7\nDJmIWX8ii6zPkMzL5ZmTuW36YSBWHXcWQQG0L6hZuCiCLhzlT9iDipsV+nIPj1QW\nvihlyPlvtGgAQpV/ty7Q7nCtU38UQMGp/Vck9tcf5yqrx+zqrgnWaMduB+NG0Oxz\nG2r8gPs/iMaH5wUjY1Z0EU5XGN2mm3zLL7komKQfAoGALjP9VBUklPuInSau2qgN\nP/y92hxOJFfqxpJFSsik4PFdujGpxJPa+qtjGk2W/cdMEQxF1sz0fW3qIWcuY7RR\nzlPJwG9l6dYc12/78gdlkvs8pV209kRSjyrbwvXzRFWr0s0ci8GKl0oQ8yvx+tRy\nEp4IGHq430ae3QPOyj+KTUg=\n-----END PRIVATE KEY-----\n",
  "client_email": "belajar-flutter-gsheets@belajar-flutter-gsheets.iam.gserviceaccount.com",
  "client_id": "112420700514724941135",
  "auth_uri": "https://accounts.google.com/o/oauth2/auth",
  "token_uri": "https://oauth2.googleapis.com/token",
  "auth_provider_x509_cert_url": "https://www.googleapis.com/oauth2/v1/certs",
  "client_x509_cert_url": "https://www.googleapis.com/robot/v1/metadata/x509/belajar-flutter-gsheets%40belajar-flutter-gsheets.iam.gserviceaccount.com",
  "universe_domain": "googleapis.com"
}
''';
  // set up and connect
  static const _spreadsheetId = '1qcH4igHDBGTQ4BhVeIExYYMECemdvbJclHnBg0KIt1k';
  static final _gsheets = GSheets(_creds);
  static Worksheet? _worksheet;

  // some variables to keep track
  static int numberOfTransaction = 0;
  static List<List<dynamic>> currentTransaction = [];
  static bool loading = true;

  // init spreadsheet
  Future init() async {
    final ss = await _gsheets.spreadsheet(_spreadsheetId);
    _worksheet = ss.worksheetByTitle('worksheet1');
    countRows();
  }

  // count number of trans
  static Future countRows() async {
    while ((await _worksheet!.values
            .value(column: 1, row: numberOfTransaction + 1)) !=
        '') {
      numberOfTransaction++;
    }
    // now we know how many trans to load, lets load them
    loadTransaction();
  }

  // load trans from spreadsheet
  static Future loadTransaction() async {
    if (_worksheet == null) return;
    for (var i = 1; i < numberOfTransaction; i++) {
      final String transactionName =
          await _worksheet!.values.value(column: 1, row: i + 1);
      final String transactionAmount =
          await _worksheet!.values.value(column: 2, row: i + 1);
      final String transactionType =
          await _worksheet!.values.value(column: 3, row: i + 1);
      if (currentTransaction.length < numberOfTransaction) {
        currentTransaction.add(
          [
            transactionName,
            transactionAmount,
            transactionType,
          ],
        );
      }
    }
    debugPrint(currentTransaction.toString());
    // loading done
    loading = false;
  }

  // insert new trans
  static Future insert(String name, String amount, bool isIncome) async {
    if (_worksheet == null) return;
    numberOfTransaction++;
    currentTransaction.add(
      [
        name,
        amount,
        isIncome ? 'income' : 'expense',
      ],
    );
    await _worksheet!.values.appendRow(
      [
        name,
        amount,
        isIncome ? 'income' : 'expense',
      ],
    );
  }

  // calculate total income
  static double calculateIncome() {
    double totalIncome = 0;
    for (var i = 0; i < currentTransaction.length; i++) {
      String val = currentTransaction[i][2];
      String amount = currentTransaction[i][1];
      if (val == 'income') {
        totalIncome += double.parse(amount);
      }
    }
    return totalIncome;
  }

  // calculate total expense
  static double calculateExpense() {
    double totalExpense = 0;
    for (var i = 0; i < currentTransaction.length; i++) {
      String val = currentTransaction[i][2];
      String amount = currentTransaction[i][1];
      if (val == 'expense') {
        totalExpense += double.parse(amount);
      }
    }
    return totalExpense;
  }

  // calculate balance
  static double calculateBalance() {
    return calculateIncome() - calculateExpense();
  }
}
