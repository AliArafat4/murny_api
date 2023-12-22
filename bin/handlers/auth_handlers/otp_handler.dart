import 'dart:convert';

import 'package:shelf/shelf.dart';
import 'package:supabase/supabase.dart';

import '../../config/supabase.dart';
import '../../logic/check_body.dart';

otpHandler(Request req) async {
  //TODO: FIX OTP - issue from package/ might use version 1.11.1
  //TODO IT IS FIXED ?
  try {
    final Map body = jsonDecode(await req.readAsString());

    checkBody(body: body, keys: ['email']);

    final SupabaseClient client = SupaBaseIntegration.subaInstance;
    final String email = body['email'];

    await client.auth.signInWithOtp(
      email: email,
      shouldCreateUser: false,
    );

    return Response.ok("OTP has been sent to $email successfully");
  } catch (err) {
    return Response.badRequest(body: err.toString());
  }
}
