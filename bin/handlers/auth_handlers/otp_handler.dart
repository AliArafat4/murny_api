import 'dart:convert';

import 'package:shelf/shelf.dart';
import 'package:supabase/supabase.dart';

import '../../config/supabase.dart';
import '../../logic/check_body.dart';

otpHandler(Request req) async {
  try {
    final Map body = jsonDecode(await req.readAsString());

    checkBody(body: body, keys: ['email', 'password']);

    final SupabaseClient client = SupaBaseIntegration.subaInstance;
    final String email = body['email'];
    final String password = body['password'];

    await client.auth.signInWithPassword(email: email, password: password);
    await client.auth.signInWithOtp(email: email, shouldCreateUser: false);

    return Response.ok("OTP has been sent to $email successfully");
  } on AuthException catch (err) {
    return Response.badRequest(body: err.message);
  } catch (err) {
    return Response.badRequest(body: err.toString());
  }
}
