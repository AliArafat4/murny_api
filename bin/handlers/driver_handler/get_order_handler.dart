import 'package:shelf/shelf.dart';

getOrderHandler(Request req) {
  return Response.ok(req.toString());
}
