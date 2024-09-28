import 'package:flutter/material.dart';
import 'package:u_credit_card/u_credit_card.dart';

import '../api/listtransaction.dart';
import '../api/statecard.dart';
import '../widget/listbutton.dart';
import '../widget/listoffering.dart';
import 'chat.dart';
import 'chatfirebasegemini.dart';
import 'chatwithgemini.dart';

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
        datetransaction: "05 Mar 2024 - 04:30 pm",
        ammonut: "350.000 CLP"),
    ListTransacion(
        name: "Victor Sosa",
        datetransaction: "21 Mar 2024 - 09:30 am",
        ammonut: "145.000 CLP"),
    ListTransacion(
        name: "Luis Valdez",
        datetransaction: "3 Abr 2024 - 10:30 am",
        ammonut: "250.000 CLP"),
  ];


  Future<void> _getposition() async {
    /*Navigator.push(
      context,
      MaterialPageRoute(builder: (context) =>  ChatPage(stateCard:widget.stateCard)),
    );*/

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
          title: const Text('Hola, Massimiliano'),
          actions: const [
            Icon(Icons.notifications),
            SizedBox(width: 10),
            Icon(Icons.person),
          ],
        ),
        body: Container(
            color: const Color.fromRGBO(33, 89, 186, 1),
            child: Column(children: [
              const SizedBox(height: 90, child: ListOffering()),
              const ListButton(),
              Expanded(
                child: Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                    side: const BorderSide(
                      color: Color.fromRGBO(33, 89, 186, 1),
                    ),
                  ),
                  child: Column(
                    children: [
                      /*Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                          side: const BorderSide(
                            color: Color.fromRGBO(33, 89, 186, 1),
                          ),
                        ),
                        elevation: 16,
                        shadowColor: Color.fromRGBO(33, 89, 186, 1),
                        child: const ListTile(
                          leading: Icon(
                            Icons.account_balance,
                            color: Color.fromRGBO(33, 89, 186, 1),
                          ),
                          title: Text(
                            'Revisar tu saldo',
                            style: TextStyle(
                              fontSize: 20,
                              //COLOR DEL TEXTO TITULO
                              color: Color.fromRGBO(33, 89, 186, 1),
                            ),
                          ),
                        ),
                      ),*/
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
                            padding: const EdgeInsets.only(right: 10),
                            child:Text(widget.stateCard.getStatus(), style: const TextStyle(color: Colors.green),)
                          ,)
                        ])
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
                                  leading: const CircleAvatar(
                                      backgroundImage: NetworkImage(
                                          "https://images.unsplash.com/photo-1547721064-da6cfb341d50")),
                                  trailing: Text(listtransaction[index].ammonut),
                                ));
                          }),



                    ],
                  ),
                ),
              ),
            ])));
  }
}