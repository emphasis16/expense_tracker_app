import 'package:expense_tracker/theme.dart';
import 'package:flutter/material.dart';

class TransactionItem extends StatelessWidget {
  final String transactionName;
  final double money;
  final String incomeOrExpense;
  const TransactionItem({
    super.key,
    required this.transactionName,
    required this.money,
    required this.incomeOrExpense,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: Container(
          padding: const EdgeInsets.all(15),
          color: Colors.grey[100],
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(5),
                    decoration: BoxDecoration(
                        shape: BoxShape.circle, color: Colors.grey[500]),
                    child: const Center(
                      child: Icon(
                        Icons.attach_money_outlined,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Text(
                    transactionName,
                    style: blackTextStyle(fontSize: 16),
                  ),
                ],
              ),
              Text(
                "${incomeOrExpense == 'expense' ? '-' : '+'}\$$money",
                style: blackTextStyle(fontSize: 16).copyWith(
                  color:
                      incomeOrExpense == 'expense' ? Colors.red : Colors.green,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
