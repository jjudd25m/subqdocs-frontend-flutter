import 'package:socket_io_client/socket_io_client.dart' as IO;

class SocketService {
  // IO.Socket socket = IO.io('https://4ef1-103-215-158-90.ngrok-free.app', IO.OptionBuilder().setTransports(['websocket']).build());
  // IO.Socket socket = IO.io('https://stage-api.subqdocs.ai', IO.OptionBuilder().setTransports(['websocket']).build());
  // IO.Socket socket = IO.io('https://app-api.subqdocs.ai', IO.OptionBuilder().setTransports(['websocket']).build());

  IO.Socket socket = IO.io('https://dev-api.subqdocs.ai', IO.OptionBuilder().setTransports(['websocket']).build());
}
