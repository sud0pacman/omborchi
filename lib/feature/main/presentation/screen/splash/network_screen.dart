import 'dart:async';

import 'package:flutter/material.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:omborchi/core/custom/widgets/pop_up_menu.dart';
import 'package:omborchi/core/utils/consants.dart';
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
            )
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
