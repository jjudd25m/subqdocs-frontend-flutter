import 'package:socket_io_client/socket_io_client.dart' as IO;

class SocketService {
  IO.Socket socket = IO.io('https://dev-api.subqdocs.com', IO.OptionBuilder().setTransports(['websocket']).build());
}
