import 'package:flutter/material.dart';

class SaldoWidget extends StatelessWidget {
  const SaldoWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 12,
      shadowColor: Colors.red,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(30.0),
      ),
      child: Column(children: [
        ListTile(
          title: Text(
            'Saldo Actual al ' +
                DateTime.now().day.toString() +
                "/" +
                DateTime.now().month.toString() +
                "/" +
                DateTime.now().year.toString(),
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          subtitle: const Text(
            'Numero de cuenta: 23031***111',
            style: TextStyle(color: Colors.blue),
          ),
        ),
        const Padding(
          padding: EdgeInsets.only(left: 10, right: 10, bottom: 10, top: 5),
          child: Row(children: [
            Text(
              '1.250.350',
              style: TextStyle(color: Colors.blue, fontSize: 40),
            ),
            Text(
              ' CLP',
              style: TextStyle(color: Colors.blue, fontSize: 25),
            )
          ]),
        ),
      ]),
    );
  }
}
