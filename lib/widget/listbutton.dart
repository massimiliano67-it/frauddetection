import 'package:flutter/material.dart';

class ListButton extends StatelessWidget {
  const ListButton({super.key});

  @override
  Widget build(BuildContext context) {

    return Container(
      child: ListView(scrollDirection: Axis.horizontal, children:_getListData()),
        /*Padding(
          padding: const EdgeInsets.only(left: 5, right: 15, top: 5, bottom: 5),
          child: SizedBox(
            //width: 10,
            height: 15,
            child: _buildActionButton(Icons.design_services, 'Transferir \n '),
          ),
        ),*/
       /* Padding(
          padding: const EdgeInsets.only(left: 5, right: 8, top: 5, bottom: 5),
          child: SizedBox(
            //width: 10,
            height: 15,
            child: _buildActionButton(Icons.credit_card, 'Créditos  \n pre-aprbado'),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 5, right: 15, top: 5, bottom: 5),
          child: SizedBox(
            //width: 10,
            height: 15,
            child: _buildActionButton(Icons.credit_card, 'Lista \n movimientos'),
          ),
        ),*/
        /*Padding(
          padding: const EdgeInsets.only(left: 5, right: 15, top: 5, bottom: 5),
          child: SizedBox(
            //width: 10,
            height: 15,
            child: _buildActionButton(Icons.phone_android, 'Promos \n'),
          ),

        ),
        Padding(
          padding: const EdgeInsets.only(left: 5, right: 15, top: 5, bottom: 5),
          child: SizedBox(
            //width: 10,
            height: 15,
            child: _buildActionButton(Icons.design_services, 'Tienda \n'),
          ),

        ),
        Padding(
          padding: const EdgeInsets.only(left: 5, right: 15, top: 5, bottom: 5),
          child: SizedBox(
            //width: 10,
            height: 15,
            child: _buildActionButton(Icons.credit_card, 'Cambiar \n dólares'),
          ),

        ),*/
    );
  }
}

_getListData() {
  List<Widget> widgets = [];
  for (int i = 0; i < 100; i++) {
    widgets.add(Padding(
        padding: EdgeInsets.all(10.0),
        child: Column(
          children: <Widget>[
            Expanded(
              child: Container(),
            ),
            ElevatedButton(
                onPressed: () => {},
                //color: Colors.orange,
                //padding: EdgeInsets.all(10.0),
                child: Column(
                  // Replace with a Row for horizontal icon + text
                  children: <Widget>[Icon(Icons.add), Text("Add")],
                )),
          ],
        )));
  }
  return widgets;
}

Widget _buildActionButton(IconData icon, String label) {
  return Column(
    children: [
      ElevatedButton(
        onPressed: () {},
        style: ButtonStyle(
          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
              const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.elliptical(20, 18)),
          )),
          padding: WidgetStateProperty.all(const EdgeInsets.all(15)),
          backgroundColor: WidgetStateProperty.all(
              const Color.fromARGB(255, 253, 254, 255)), // <-- Button color
          overlayColor: WidgetStateProperty.resolveWith<Color?>((states) {
            if (states.contains(WidgetState.pressed)) {
              return const Color.fromARGB(15, 186, 190, 202); // <-- Splash color
            }
          }),
        ),
        child: Icon(
          icon,
          color: Colors.blueAccent,
        ),
      ),
      Text(
        label,
        textAlign: TextAlign.center,
        style: const TextStyle(color: Colors.white),
      )
    ],
  );
}
