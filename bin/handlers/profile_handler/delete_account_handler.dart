import 'package:shelf/shelf.dart';
import 'package:supabase/supabase.dart';

import '../../config/supabase.dart';

deleteAccountHandler(Request req) async {
  //TODO: FIX DELETE ACCOUNT
  try {
    final UserResponse user = await SupaBaseIntegration()
        .getUserByToken(token: req.headers['token']!);
    SupaBaseIntegration().deleteUser(user: user);
    return Response.ok("Account Deleted Successfully");
  } catch (err) {
    return Response.badRequest(body: err.toString());
  }
}
