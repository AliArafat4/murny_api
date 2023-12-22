import 'package:shelf/shelf.dart';

getRatingHandler(Request req) {
  return Response.ok(req.toString());
}
