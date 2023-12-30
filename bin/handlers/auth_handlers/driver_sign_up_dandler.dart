import 'package:shelf/shelf.dart';
import 'dart:convert';
import 'package:supabase/supabase.dart';
import '../../config/supabase.dart';
import '../../logic/check_body.dart';
import '../../response/auth_response/auth_response.dart';

driverSignUpHandler(Request req) async {
  try {
    final keys = ['email', 'password', 'phone', 'name', 'gender', 'city', 'license'];

    final Map<String, dynamic> body = jsonDecode(await req.readAsString());

    checkBody(body: body, keys: keys);

    final SupabaseClient client = SupaBaseIntegration.subaInstance;
    final String email = body['email'];
    final String password = body['password'];

    late AuthResponse user;

    await client.auth.admin
        .createUser(AdminUserAttributes(
            email: email, password: password, emailConfirm: true, userMetadata: {'type': "driver"}))
        .then((value) async {
      try {
        //login to user acc to get user token
        user = await client.auth.signInWithPassword(email: email, password: password);
        body.remove('password');
        body.addAll({'user_id': user.user!.id, 'email': email});
        //add user to [users] table
        await client.from('driver').insert(body);
      } catch (err) {
        return Response.badRequest(body: err);
      }
    });

    return authResponse(user: user, message: "Account Created Successfully");
  } on AuthException catch (err) {
    return Response.badRequest(body: err.message);
  } catch (err) {
    return Response.badRequest(body: err.toString());
  }
}
