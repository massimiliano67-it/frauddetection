import 'package:flutter/material.dart';
import 'package:u_credit_card/u_credit_card.dart';

import '../api/listtransaction.dart';
import '../api/statecard.dart';
import '../widget/listoffering.dart';
import '../widget/saldowidget.dart';
import 'chatfirebasegemini.dart';

class HomeScreen extends StatefulWidget {
   HomeScreen({super.key,required this.stateCard});
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
      MaterialPageRoute(builder: (context) => ChatWidget(title:"Cindy",stateCard:widget.stateCard)),
    );

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        floatingActionButton: FloatingActionButton(
          onPressed: _getposition,
          tooltip: 'Increment',
          child: const Icon(Icons.add),
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
              SizedBox(height: 180, width: MediaQuery.of(context).size.width, child:
              const Padding(padding: EdgeInsets.all(10),
              child: SaldoWidget())
              //ListButton())
              ),
              //const ListButton(),
              Expanded(
                child: Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                    side: const BorderSide(
                      color: Color.fromRGBO(33, 89, 186, 1),
                    ),
                  ),
                  child:
                  SingleChildScrollView(
                  child:
                  Column(
                    children: [
                      Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                          side: const BorderSide(
                            color: Color.fromRGBO(33, 89, 186, 1),
                          ),
                        ),
                        elevation: 16,
                        shadowColor: const Color.fromRGBO(33, 89, 186, 1),
                        child:
                        InkWell(
                          onDoubleTap:(){
                            setState(() {
                              widget.stateCard.state = "Activa";
                            });
                            },
                          child:
                         Stack(
                          alignment: Alignment.bottomRight,
                        children: [
                        const CreditCardUi(
                          cardHolderFullName: 'Massimiliano M',
                          cardNumber: '1234567812345678',
                          validFrom: '01/23',
                          validThru: '01/28',
                          topLeftColor: Colors.blue,
                          doesSupportNfc: true,
                          placeNfcIconAtTheEnd: true, // 👈 NFC icon will be at the end,
                        ),
                          Padding(
                            padding: const EdgeInsets.only(right: 10,bottom: 5),
                            child:Text(widget.stateCard.getStatus(), style: const TextStyle(color: Colors.green),)
                          ,)
                        ]))
                      ),
                      const Padding(padding: EdgeInsets.only(bottom: 10.0)),

                      ListView.builder(
                          shrinkWrap: true,

                          itemCount: listtransaction.length,
                          itemBuilder: (context, index) {
                            return Card(
                                child: ListTile(
                                  title: Text(listtransaction[index].name),
                                  subtitle: Text(listtransaction[index].datetransaction),
                                  leading:
                                  listtransaction[index].ammonut.contains("-") ? const CircleAvatar(  child:Icon(
                                    Icons.arrow_downward,
                                    color: Colors.red,
                                    size: 24.0,
                                  )) : const CircleAvatar(  child:Icon(
                                    Icons.arrow_upward,
                                    color: Colors.green,
                                    size: 24.0,
                                  )),

                                     // NetworkImage(
                                       //   "https://images.unsplash.com/photo-1547721064-da6cfb341d50")),
                                  trailing: Text(listtransaction[index].ammonut),
                                ));
                          }),
                    ],
                  )),
                ),
              ),
            ])));
  }
}