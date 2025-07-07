import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

class SocketService {
  // IO.Socket socket = IO.io(WebUri(dotenv.get("SOCKET_DEV_URL", fallback: "")).toString(), IO.OptionBuilder().setTransports(['websocket']).build());
  //
  // IO.Socket openAISocket = IO.io(
  //   WebUri(dotenv.get("SOCKET_DEV_URL", fallback: "")).toString(), // Replace with your VITE_REACT_APP_API_URL
  //   IO.OptionBuilder()
  //       .setPath('/status-socket')
  //       .setTransports(['websocket'])
  //       .enableReconnection() // <-- This is crucial!
  //       .build(),
  // );

  IO.Socket socket = IO.io(WebUri(dotenv.get("SOCKET_STAGE_URL", fallback: "")).toString(), IO.OptionBuilder().setTransports(['websocket']).build());

  IO.Socket openAISocket = IO.io(
    WebUri(dotenv.get("SOCKET_STAGE_URL", fallback: "")).toString(), // Replace with your VITE_REACT_APP_API_URL
    IO.OptionBuilder()
        .setTransports(['websocket'])
        .setPath('/status-socket') // <-- This is crucial!
        .build(),
  );

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
