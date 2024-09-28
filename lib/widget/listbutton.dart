import 'package:flutter/material.dart';

class ListButton extends StatelessWidget {
  const ListButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildActionButton(Icons.phone_android, 'Recargar \n celular'),
              _buildActionButton(Icons.design_services, 'Transferir \n '),
              _buildActionButton(
                  Icons.credit_card, 'Créditos  \n pre-aprbado'),
              _buildActionButton(Icons.credit_card, 'Código de \n aprobación'),
            ],
          ),
          const SizedBox(height: 20.0),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildActionButton(Icons.phone_android, 'Promos \n'),
              _buildActionButton(Icons.design_services, 'Tienda \n'),
              _buildActionButton(Icons.credit_card, 'Cambiar \n dólares'),
              _buildActionButton(Icons.hdr_plus, 'Ver Más \n'),
            ],
          )
        ],
      ),
    );
  }
}

Widget _buildTextButton(String label) {
  return TextButton(
    onPressed: () {},
    child: Text(label),
  );
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
          padding: MaterialStateProperty.all(const EdgeInsets.all(15)),
          backgroundColor: MaterialStateProperty.all(
              const Color.fromARGB(255, 253, 254, 255)), // <-- Button color
          overlayColor: MaterialStateProperty.resolveWith<Color?>((states) {
            if (states.contains(MaterialState.pressed)) {
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
