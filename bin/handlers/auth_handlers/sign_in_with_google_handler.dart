import 'package:shelf/shelf.dart';
import 'dart:convert';
import 'package:supabase/supabase.dart';
import '../../config/supabase.dart';
import '../../logic/check_body.dart';

userSignInWithGoogleHandler(Request req) async {
  try {
    final keys = ['accessToken', 'idToken'];

    final Map<String, dynamic> body = jsonDecode(await req.readAsString());

    checkBody(body: body, keys: keys);

    final accessToken = body['accessToken'];
    final idToken = body['idToken'];

    final AuthResponse user = await SupaBaseIntegration()
        .signInWithGoogle(accessToken: accessToken, idToken: idToken);

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
