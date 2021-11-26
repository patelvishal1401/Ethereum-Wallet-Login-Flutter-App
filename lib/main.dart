import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart';
import 'package:web3dart/web3dart.dart';
import 'package:flutter/foundation.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Ethereum Login App',
      debugShowCheckedModeBanner: false,
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}



class _HomePageState extends State<HomePage> {
  String getBalance = "0";
  TextEditingController pktextController = new TextEditingController();
  List<String> _wallets = ['Select Login Wallet'];
  List<String> _privatekeys = new List<String>();
  String _selectedWallet = 'Select Login Wallet';
  Client httpClient;
  Web3Client ethClient;
  // JSON-RPC is a remote procedure call protocol encoded in JSON
  // Remote Procedure Call (RPC) is about executing a block of code on another server
  String rpcUrl = 'http://10.0.2.2:8546';  //android simuletor localhost..

  @override
  void initState() {
   // initialSetup();
    super.initState();
  }

  Future<void> initialSetup() async {
    /// This will start a client that connects to a JSON RPC API, available at RPC URL.
    /// The httpClient will be used to send requests to the [RPC server].
    httpClient = Client();

    /// It connects to an Ethereum [node] to send transactions, interact with smart contracts, and much more!
    ethClient = Web3Client(rpcUrl, httpClient);

    await getCredentials();
  }

  /// This will construct [credentials] with the provided [privateKey]
  /// and load the Ethereum address in [myAdderess] specified by these credentials.
  String privateKey = '';
  Credentials credentials;
  EthereumAddress myAddress;

  Future<void> getCredentials() async {
    credentials = await ethClient.credentialsFromPrivateKey(privateKey);
    myAddress = await credentials.extractAddress();
    debugPrint('myAddress: $myAddress');
    _wallets.add(myAddress.toString());
    _privatekeys.add(privateKey.toString());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topRight,
              end: Alignment.bottomLeft,
              colors: [Colors.green, Colors.purple],
            ),
          ),
          child: Column(
            children: [
              Expanded(
                child: Align(
                  alignment: Alignment.center,
                  child: Text(
                    'Add Ethereum Wallet',
                    style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),

              // Prviate key text feild init

              Expanded(
                child: Align(
                  child: SizedBox(
                    height: 100,
                    width: 350,

                    child: Align(
                      alignment: Alignment.center,
                      child: TextField(
                        controller: pktextController,
                        decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            hintText: 'Enter Your Wallet Private key'
                        ),

                      ),
                    ),
                  ),
                ),
              ),


              Expanded(
                child: Align(
                  alignment: Alignment.center,
                  child: SizedBox(
                    height: 50,
                    width: 350,
                    child: FittedBox(
                      fit: BoxFit.contain,
                      child: FloatingActionButton.extended(
                        heroTag: 'connect_wallet',
                        onPressed: () async {

                          String text = pktextController.text.toString();

                          if(!text.isEmpty && !_privatekeys.contains(text)) {

                            debugPrint('pvKeys text: $text');
                            privateKey = text;
                            initialSetup();
                            pktextController.text = "";
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              content: Text(
                                  "Sucessfully wallet added, Select Wallet for Login"),
                            ));
                            setState(() {});
                          }
                          else
                            {
                              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                content: Text("Private key is empty or all ready added"),
                              ));
                            }

                        },
                        label: Text('Add Wallet'),
                        icon: Icon(Icons.add_circle),
                        backgroundColor: Colors.red,
                      ),
                    ),
                  ),
                ),
              ),

        DropdownButton<String>(
            hint: Text("Please choose a wallet"),
            value: _selectedWallet,
            onChanged: (newVal) {
              _selectedWallet = newVal;
              debugPrint('_selectedWallet: $_selectedWallet');
              setState(() {});
            },
            items: _wallets.map((String val) {
              return new DropdownMenuItem<String>(
                child: new Text(val),
                value: val,
              );
            }).toList(),

        ),

              Expanded(
                child: Align(
                  alignment: Alignment.center,
                  child: SizedBox(
                    height: 50,
                    width: 350,
                    child: FittedBox(
                      fit: BoxFit.contain,
                      child: FloatingActionButton.extended(
                        heroTag: 'connect_wallet',
                        onPressed: () async {

                           if(!_selectedWallet.contains("Select Login Wallet")) {

                             int item = _wallets.indexOf(_selectedWallet,0);
                             debugPrint("Selected Item Position : $item");
                             String keyitem = _privatekeys.elementAt(item-1);
                             debugPrint("Private key selected wallet : $keyitem");
                             credentials = await ethClient.credentialsFromPrivateKey(keyitem);
                             myAddress = await credentials.extractAddress();

                             EtherAmount balance = await ethClient.getBalance(myAddress);
                             print(balance.getInEther.toString());
                             getBalance = balance.getInEther.toString();

                             setState(() {});

                           }
                           else
                             {
                               ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                 content: Text("Please select wallet or Add wallet"),
                               ));
                             }
                        },
                        label: Text('Login'),
                        backgroundColor: Colors.green,
                      ),
                    ),
                  ),
                ),
              ),
              Expanded(

                child: Align(
                  child: SizedBox(
                    height: 100,
                    width: 350,

                    child: Align(
                      alignment: Alignment.center,
                      child: Text(
                        'Your Wallet balance : $getBalance',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),


              ),
            ],
          ),
        ),
      ),
    );
  }
}
