import 'dart:io';
import 'package:dotenv/dotenv.dart';
import 'package:shelf/shelf_io.dart';
import 'config/supabase.dart';
import 'routes/main_route.dart';

import 'package:shelf_hotreload/shelf_hotreload.dart';

late final DotEnv env;
void main(List<String> args) async {
  env = DotEnv(includePlatformEnvironment: true)..load();

  withHotreload(
    () => createServer(),
    onReloaded: () => print('Reload!'),
    onHotReloadNotAvailable: () => print('No hot-reload :('),
    onHotReloadAvailable: () => print('Yay! Hot-reload :)'),
    onHotReloadLog: (log) => print('Reload Log: ${log.message}'),
    logLevel: Level.INFO,
  );
  // await createServer();
}

Future<HttpServer> createServer() async {
  SupaBaseIntegration().supabase;

  final ip = InternetAddress.anyIPv4;
  final port = int.parse(Platform.environment['PORT'] ?? '8080');

  final server = await serve(MainRoute().route, ip, port);
  print(
      'Server listening on port https://${server.address.host}:${server.port}');
  return server;
}
