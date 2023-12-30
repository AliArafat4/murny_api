import 'dart:convert';

import 'package:shelf/shelf.dart';
import 'package:supabase/supabase.dart';

import '../../config/supabase.dart';
import '../../logic/check_body.dart';

resendOtpHandler(Request req) async {
  try {
    final Map body = jsonDecode(await req.readAsString());

    checkBody(body: body, keys: ['email']);

    final SupabaseClient client = SupaBaseIntegration.subaInstance;
    final String email = body['email'];

    await client.auth.signInWithOtp(email: email, shouldCreateUser: false);

    return Response.ok("OTP has been re-sent to $email successfully");
  } on AuthException catch (err) {
    return Response.badRequest(body: err.message);
  } catch (err) {
    return Response.badRequest(body: err.toString());
  }
}
