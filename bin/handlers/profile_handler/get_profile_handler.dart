import 'package:shelf/shelf.dart';
import 'dart:convert';
import 'package:supabase/supabase.dart';
import '../../config/supabase.dart';

getProfileHandler(Request req) async {
  try {
    final UserResponse user = await SupaBaseIntegration()
        .getUserByToken(token: req.headers['token']!);

    late final List<Map<String, dynamic>> res;

    if (user.user!.userMetadata!['type'] == 'driver') {
      res = await SupaBaseIntegration().getFromTable(
          tableName: 'driver', user: user, columnCondition: 'user_id');
    } else if (user.user!.userMetadata!['type'] == 'user') {
      res = await SupaBaseIntegration().getFromTable(
          tableName: 'users', user: user, columnCondition: 'user_id');
    } else {
      return Response.badRequest(body: "user is not driver or user");
    }

    return Response.ok(jsonEncode(res.first));
  } on FormatException catch (err) {
    if (err.message == "Unexpected end of input") {
      return Response.badRequest(body: "Body cannot be empty");
    } else {
      return Response.badRequest(body: err.message);
    }
  } catch (err) {
    return Response.badRequest(body: err.toString());
  }
}
