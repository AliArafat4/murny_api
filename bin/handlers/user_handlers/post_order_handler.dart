import 'package:shelf/shelf.dart';

postOrderHandler(Request req) {
  return Response.ok(req.toString());
}
