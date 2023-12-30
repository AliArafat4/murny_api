import 'package:shelf/shelf.dart';
import 'dart:convert';
import 'package:supabase/supabase.dart';
import '../../config/supabase.dart';
import '../../logic/check_body.dart';
import '../../response/auth_response/auth_response.dart';

userSignInWithAppleHandler(Request req) async {
  try {
    final keys = ['credential', 'rawNonce'];

    final Map<String, dynamic> body = jsonDecode(await req.readAsString());

    checkBody(body: body, keys: keys);

    final credential = body['credential'];
    final rawNonce = body['rawNonce'];

    final AuthResponse user =
        await SupaBaseIntegration().signInWithApple(credential: credential, rawNonce: rawNonce);

    return authResponse(user: user, message: "Account Created Successfully");
  } on AuthException catch (err) {
    return Response.badRequest(body: err.message);
  } catch (err) {
    return Response.badRequest(body: err.toString());
  }
}
