import 'package:flutter/material.dart';

class ListOffering extends StatelessWidget {
  const ListOffering({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
        child: ListView(scrollDirection: Axis.horizontal, children: const [
      Padding(
        padding: EdgeInsets.all(5),
        child: SizedBox(
          width: 270,
          height: 15,
          child: Card(
            child: ListTile(
              leading: Icon(Icons.credit_card),
              title: Text('Pizza Hut'),
              subtitle: Text('A solo 8.500 Pesos'),

            ),
          ),
        ),
      ),
      Padding(
        padding: EdgeInsets.all(5),
        child: SizedBox(
          width: 270,
          height: 15,
          child: Card(
            child: ListTile(
              leading: Icon(Icons.credit_card),
              title: Text('2x1 en Kart'),
              subtitle: Text('A solo 45.500 Pesos'),

            ),
          ),
        ),
      ),
      Padding(
        padding: EdgeInsets.all(5),
        child: SizedBox(
          width: 270,
          height: 15,
          child: Card(
            child: ListTile(
              leading: Icon(Icons.credit_card),
              title: Text('Tercera el Sabado'),
              subtitle: Text('A solo 18.500 Pesos'),

            ),
          ),
        ),
      )
    ]));
  }
}
