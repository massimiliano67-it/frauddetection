import 'package:flutter/material.dart';
import 'package:u_credit_card/u_credit_card.dart';

import '../api/listtransaction.dart';
import '../api/statecard.dart';
import '../widget/listoffering.dart';
import '../widget/saldowidget.dart';
import 'chatfirebasegemini.dart';

class HomeScreen extends StatefulWidget {
  HomeScreen({super.key, required this.stateCard});

  final StateCard stateCard;

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late var docData; //docData

  List<ListTransacion> listtransaction = [
    ListTransacion(
        name: "Raul Ramos",
        datetransaction: "12 Sept 2024 - 04:30 pm",
        ammonut: "350.000 CLP"),
    ListTransacion(
        name: "Victor Sosa",
        datetransaction: "21 Sep 2024 - 09:30 am",
        ammonut: "145.000 CLP"),
    ListTransacion(
        name: "Luis Valdez",
        datetransaction: "29 Sep 2024 - 10:30 am",
        ammonut: "-250.000 CLP"),
    ListTransacion(
        name: "Luis baeza",
        datetransaction: "30 Sep 2024 - 22:30 pm",
        ammonut: "-150.000 CLP"),
  ];

  Future<void> _getposition() async {
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) =>
              ChatWidget(title: "Cyndi", stateCard: widget.stateCard)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        floatingActionButton: FloatingActionButton(
          onPressed: _getposition,
          tooltip: 'Increment',
          child: const Icon(Icons.chat),
        ),
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: const Text('Hola, Massimiliano'),
          actions: const [
            Icon(Icons.notifications),
            SizedBox(width: 10),
            Icon(Icons.person),
          ],
        ),
        body: Container(
            color: const Color.fromRGBO(4, 23, 102, 1),
            child: Column(children: [
              const SizedBox(height: 90, child: ListOffering()),
              SizedBox(
                  height: 180,
                  width: MediaQuery.of(context).size.width,
                  child: const Padding(
                      padding: EdgeInsets.all(10), child: SaldoWidget())
                  //ListButton())
                  ),
              //const ListButton(),
              Expanded(
                child: Padding(
                    padding: EdgeInsets.all(10),
                    child: SizedBox(
                        height: double.infinity,
                        width: MediaQuery.of(context).size.width,
                        child: Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                            side: const BorderSide(
                              color: Color.fromRGBO(33, 89, 186, 1),
                            ),
                          ),
                          child: SingleChildScrollView(
                              child: Column(
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              Card(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(15),
                                    side: const BorderSide(
                                      color: Color.fromRGBO(33, 89, 186, 1),
                                    ),
                                  ),
                                  elevation: 16,
                                  shadowColor:
                                      const Color.fromRGBO(33, 89, 186, 1),
                                  child: InkWell(
                                      onDoubleTap: () {
                                        setState(() {
                                          widget.stateCard.state = "Activa";
                                        });
                                      },
                                      child: Stack(
                                          alignment: Alignment.bottomRight,
                                          children: [
                                            const CreditCardUi(
                                              cardProviderLogo: Image(
                                                  image: AssetImage(
                                                      'assets/images/visa_logo.png')),
                                              cardHolderFullName:
                                                  'Massimiliano M',
                                              cardNumber: '1234567812345678',
                                              validFrom: '01/23',
                                              validThru: '01/28',
                                              topLeftColor: Colors.blue,
                                              doesSupportNfc: true,
                                              placeNfcIconAtTheEnd:
                                                  true, // 👈 NFC icon will be at the end,
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  right: 10, bottom: 5),
                                              child: Text(
                                                widget.stateCard.getStatus(),
                                                style: const TextStyle(
                                                    color: Colors.green),
                                              ),
                                            )
                                          ]))),
                              Padding(
                                  padding: EdgeInsets.only(
                                      top: 40.0, left: 3, right: 3),
                                  child: Row(
                                    children: [
                                      _buildActionCard(
                                          "Cuentas", Icons.account_balance),
                                      _buildActionCard(
                                          "Crédito", Icons.credit_score),
                                      _buildActionCard(
                                          "Seguros", Icons.assured_workload)
                                    ],
                                  )),
                              Padding(
                                  padding: EdgeInsets.only(
                                      top: 25.0, left: 3, right: 3),
                                  child: Row(
                                    children: [
                                      _buildActionCard(
                                          "Inversiones", Icons.inventory),
                                      _buildActionCard(
                                          "Beneficios", Icons.bento),
                                      _buildActionCard(
                                          "Recargas", Icons.charging_station)
                                    ],
                                  )),
                            ],
                          )),
                        ))),
              ),
            ])));
  }
}

Widget _buildActionCard(String title, IconData icondata) {
  return InkWell(
      onTap: () {},
      child:
      Card(
        elevation: 8,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10), // if you need this
          side: BorderSide(
            color: Colors.grey.withOpacity(0.2),
            width: 1,
          ),
        ),
        child: Container(
          //color: Colors.white,
          width: 130,
          height: 100,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              const SizedBox(height: 8.0),
              Icon(
                icondata,
                color: Colors.blue[500],
                size: 45,
              ),
              const SizedBox(height: 16.0),
              Text(
                title,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16.0,
                ),
              ),
            ],
          ),
        ),
      ));
}
