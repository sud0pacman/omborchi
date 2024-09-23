import 'dart:async';

import 'package:flutter/material.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:popover/popover.dart';

class InternetConnectivityListener extends StatefulWidget {
  const InternetConnectivityListener({super.key});

  @override
  _InternetConnectivityListenerState createState() =>
      _InternetConnectivityListenerState();
}

class _InternetConnectivityListenerState
    extends State<InternetConnectivityListener> {
  late InternetConnectionChecker _internetChecker;
  late StreamSubscription<InternetConnectionStatus> _listener;
  bool _isConnected = true;

  @override
  void initState() {
    super.initState();
    _internetChecker = InternetConnectionChecker();
    _listener = _internetChecker.onStatusChange.listen((status) {
      final isConnected = status == InternetConnectionStatus.connected;
      setState(() {
        _isConnected = isConnected;
      });
      if (isConnected) {
        print("Connected to the internet");
      } else {
        print("No internet connection");
      }
    });
  }

  @override
  void dispose() {
    _listener.cancel(); // Clean up the listener
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Internet Connectivity Listener")),
      body: Column(
        children: [
          Center(
            child: TextButton(
              onPressed: () {
              },
              child: Text(
                _isConnected ? "Connected" : "Disconnected",
                style: const TextStyle(fontSize: 24),
              ),
            ),
          ),

          PopupMenuButton(
              itemBuilder: (ctx) => [
                _buildPopupMenuItem('Search'),
                _buildPopupMenuItem('Upload'),
                _buildPopupMenuItem('Copy'),
                _buildPopupMenuItem('Exit'),
              ],
            ),

          const Button(),
        ],
      ),
    );
  }

  PopupMenuItem _buildPopupMenuItem(String title) {
    return PopupMenuItem(
      child: Text(title),
    );
  }
}


class Button extends StatelessWidget {
  const Button({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 80,
      height: 40,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(Radius.circular(5)),
        boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 5)],
      ),
      child: GestureDetector(
        child: const Center(child: Text('Click Me')),
        onTap: () {
          showPopover(
            context: context,
            bodyBuilder: (context) => const ListItems(),
            onPop: () => print('Popover was popped!'),
            direction: PopoverDirection.bottom,
            backgroundColor: Colors.white,
            width: 200,
            height: 400,
            arrowHeight: 15,
            arrowWidth: 30,
          );
        },
      ),
    );
  }
}

class ListItems extends StatelessWidget {
  const ListItems({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: ListView(
        padding: const EdgeInsets.all(8),
        children: [
          InkWell(
            onTap: () {
              // Navigator.of(context)
              //   ..pop()
              //   ..push(
              //     MaterialPageRoute<SecondRoute>(
              //       builder: (context) => SecondRoute(),
              //     ),
              //   );
            },
            child: Container(
              height: 50,
              color: Colors.amber[100],
              child: const Center(child: Text('Entry A')),
            ),
          ),
          const Divider(),
          Container(
            height: 50,
            color: Colors.amber[200],
            child: const Center(child: Text('Entry B')),
          ),
          const Divider(),
          Container(
            height: 50,
            color: Colors.amber[300],
            child: const Center(child: Text('Entry C')),
          ),
          const Divider(),
          Container(
            height: 50,
            color: Colors.amber[400],
            child: const Center(child: Text('Entry D')),
          ),
          const Divider(),
          Container(
            height: 50,
            color: Colors.amber[500],
            child: const Center(child: Text('Entry E')),
          ),
          const Divider(),
          Container(
            height: 50,
            color: Colors.amber[600],
            child: const Center(child: Text('Entry F')),
          ),
        ],
      ),
    );
  }
}
