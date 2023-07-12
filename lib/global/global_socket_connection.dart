import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:io';
import 'package:socket_io_client/socket_io_client.dart' as IO;

class GlobalSocketConnection {
  IO.Socket? m_socket;
  IO.Socket connectSocket(String _userId) {
    /*   IO.Socket _socket = IO.io(
        'https://mamaproject.developerconsole.xyz:3000',
        IO.OptionBuilder().setTransports(['websocket']).setQuery({
          'chatID': _userId,
        }).build());*/

    IO.Socket _socket = IO.io('https://mamaproject.developerconsole.xyz:3000',
        IO.OptionBuilder().setTransports(['websocket']).build());

    _socket.connect();

    return _socket;
  }


  setSocket(IO.Socket _socket){
    m_socket = _socket;
  }

  IO.Socket?  getSocket(){
    return m_socket;
  }
}
