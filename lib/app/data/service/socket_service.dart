import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

class SocketService {
  IO.Socket socket = IO.io(WebUri(dotenv.get("SOCKET_DEV_URL", fallback: "")).toString(), IO.OptionBuilder().setTransports(['websocket']).build());

  IO.Socket chatBotSocket = IO.io(
    WebUri(dotenv.get("SOCKET_DEV_URL", fallback: "")).toString(), // Replace with your VITE_REACT_APP_API_URL
    IO.OptionBuilder()
        .setPath('chat-bot-socket')
        .setTransports(['websocket'])
        .enableReconnection() // <-- This is crucial!
        .build(),
  );

  IO.Socket openAISocket = IO.io(
    WebUri(dotenv.get("SOCKET_DEV_URL", fallback: "")).toString(), // Replace with your VITE_REACT_APP_API_URL
    IO.OptionBuilder()
        .setPath('status-socket')
        .setTransports(['websocket'])
        .enableReconnection() // <-- This is crucial!
        .build(),
  );

  // IO.Socket socket = IO.io(WebUri(dotenv.get("SOCKET_NGROK_URL", fallback: "")).toString(), IO.OptionBuilder().setTransports(['websocket']).build());

  // IO.Socket noChangeSocket = IO.io(
  //   WebUri(dotenv.get("SOCKET_DEV_URL", fallback: "")).toString(), // Replace with your VITE_REACT_APP_API_URL
  //   IO.OptionBuilder()
  //       .setPath('/no-change-socket')
  //       .setTransports(['websocket'])
  //       .enableReconnection() // <-- This is crucial!
  //       .build(),
  // );

  // IO.Socket openAISocket = IO.io(
  //   WebUri(dotenv.get("SOCKET_NGROK_URL", fallback: "")).toString(), // Replace with your VITE_REACT_APP_API_URL
  //   IO.OptionBuilder()
  //       .setPath('/status-socket')
  //       .setTransports(['websocket'])
  //       .enableReconnection() // <-- This is crucial!
  //       .build(),
  // );

  // IO.Socket socket = IO.io(WebUri(dotenv.get("SOCKET_STAGE_URL", fallback: "")).toString(), IO.OptionBuilder().setTransports(['websocket']).build());
  //
  // IO.Socket openAISocket = IO.io(
  //   WebUri(dotenv.get("SOCKET_STAGE_URL", fallback: "")).toString(), // Replace with your VITE_REACT_APP_API_URL
  //   IO.OptionBuilder()
  //       .setTransports(['websocket'])
  //       .setPath('/status-socket') // <-- This is crucial!
  //       .build(),
  // );

  // IO.Socket socket = IO.io(WebUri(dotenv.get("SOCKET_PROD_URL", fallback: "")).toString(), IO.OptionBuilder().setTransports(['websocket']).build());
  //
  // IO.Socket openAISocket = IO.io(
  //   WebUri(dotenv.get("SOCKET_PROD_URL", fallback: "")).toString(), // Replace with your VITE_REACT_APP_API_URL
  //   IO.OptionBuilder()
  //       .setTransports(['websocket'])
  //       .setPath('/status-socket') // <-- This is crucial!
  //       .build(),
  // );
}

class ChatBotSocketService {
  static final ChatBotSocketService _instance = ChatBotSocketService._internal();
  late IO.Socket _socket;

  factory ChatBotSocketService() {
    return _instance;
  }

  ChatBotSocketService._internal();

  void initializeSocket() {
    _socket = IO.io(
      WebUri(dotenv.get("SOCKET_DEV_URL", fallback: "")).toString(), // e.g., 'http://localhost:3000'
      IO.OptionBuilder()
          .setTransports(['websocket', 'polling']) // transports
          .disableAutoConnect() // wait to connect manually
          .setPath('/chat-bot-socket') // match server's socket path
          .build(),
    );

    _socket.connect();

    _socket.onConnect((_) {
      print('[ChatBotSocket] Connected: ${_socket.id}');
    });

    _socket.onDisconnect((_) {
      print('[ChatBotSocket] Disconnected');
    });

    _socket.onConnectError((err) {
      print('[ChatBotSocket] Connect error: $err');
    });

    _socket.onError((err) {
      print('[ChatBotSocket] Error: $err');
    });

    _socket.on("chatBotResponse", (data) {
      print("Chat bot response is: $data");

      // You can parse the response here, for example:
      // final message = data['message'];
    });
  }

  IO.Socket get socket => _socket;

  void dispose() {
    _socket.dispose();
  }
}
