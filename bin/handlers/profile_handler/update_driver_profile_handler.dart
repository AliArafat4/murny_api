import 'dart:convert';
import 'package:shelf/shelf.dart';
import 'package:supabase/supabase.dart';
import '../../config/supabase.dart';
import '../../logic/check_body.dart';

updateDriverProfileHandler(Request req) async {
  try {
    final Map<String, dynamic> body = jsonDecode(await req.readAsString());
    checkBody(
        keys: ['name', 'location', 'phone', 'city', 'gender'], body: body);

    //Get user object
    final UserResponse user = await SupaBaseIntegration()
        .getUserByToken(token: req.headers['token']!);

    //update user profile in [profile] table
    await SupaBaseIntegration()
        .updateFromTable(tableName: 'driver', body: body, user: user);

    return Response.ok("Profile Updated Successfully");
  } on FormatException catch (err) {
    if (err.message == "Unexpected end of input") {
      return Response.badRequest(body: "Body cannot be empty");
    } else {
      return Response.badRequest(body: err.message);
    }
  } on PostgrestException catch (err) {
    return Response.ok(err.message);
  } catch (err) {
    return Response.ok(err.toString());
  }
}
