import 'dart:convert';

import 'package:shelf/shelf.dart';
import 'package:supabase/supabase.dart';

import '../../config/supabase.dart';
import '../../logic/check_body.dart';

signInHandler(Request req) async {
  try {
    final Map body = jsonDecode(await req.readAsString());

    checkBody(body: body, keys: ['email', 'password']);

    final SupabaseClient client = SupaBaseIntegration.subaInstance;
    final String email = body['email'];
    final String password = body['password'];

    final AuthResponse user =
        await client.auth.signInWithPassword(email: email, password: password);
    return Response.ok(jsonEncode({
      "message": "Login Successfully",
      "token": user.session!.accessToken,
      "expires_at": user.session!.expiresAt,
      "refresh_token": user.session!.refreshToken,
      "token_type": user.session!.tokenType,
    }));
  } on AuthException catch (err) {
    return Response.badRequest(body: err.message);
  } catch (err) {
    return Response.badRequest(body: err.toString());
  }
}
