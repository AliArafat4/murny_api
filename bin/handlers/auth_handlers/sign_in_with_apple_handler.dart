import 'package:shelf/shelf.dart';
import 'dart:convert';
import 'package:supabase/supabase.dart';
import '../../config/supabase.dart';
import '../../logic/check_body.dart';

userSignInWithAppleHandler(Request req) async {
  try {
    final keys = ['credential', 'rawNonce'];

    final Map<String, dynamic> body = jsonDecode(await req.readAsString());

    checkBody(body: body, keys: keys);

    final credential = body['credential'];
    final rawNonce = body['rawNonce'];

    final AuthResponse user = await SupaBaseIntegration()
        .signInWithApple(credential: credential, rawNonce: rawNonce);

    return Response.ok(jsonEncode({
      "message": "Account Created Successfully",
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
