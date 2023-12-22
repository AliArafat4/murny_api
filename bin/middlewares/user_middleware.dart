import 'package:dart_jsonwebtoken/dart_jsonwebtoken.dart';
import 'package:shelf/shelf.dart';

import '../server.dart';

Middleware checkToken() => (innerHandler) => (Request req) async {
      try {
        final jwt =
            JWT.verify(req.headers['token']!, SecretKey("${env["JWT_KEY"]}"));

        return innerHandler(req);
      } catch (err) {
        return Response.unauthorized(
            "Token is Not Correct or Unavailable -- Try Adding [token] in Headers");
      }
    };
