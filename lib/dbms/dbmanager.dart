import 'package:postgres/postgres.dart';

class DataConnection {
  late final Connection connection;
  Future<Connection> openConnection(String host, String database,
      String username, String password, int port) async {
    connection = await Connection.open(Endpoint(
      host: host,
      database: database,
      username: username,
      password: password,
      port: port,
    ),settings: const ConnectionSettings(sslMode: SslMode.verifyFull));

    return connection;
  }

  Future<List<List<dynamic>>> fetchData(String query) async {
    return await connection.execute(query);
  }
}

