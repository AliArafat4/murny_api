import 'dart:convert';
import 'package:shelf/shelf.dart';
import 'package:supabase/supabase.dart';
import '../../config/supabase.dart';
import '../../logic/check_body.dart';

postRatingHandler(Request req) async {
  try {
    final Map<String, dynamic> body = jsonDecode(await req.readAsString());
    checkBody(keys: ['stars', 'comment', 'driver_id'], body: body);

    final UserResponse user = await SupaBaseIntegration()
        .getUserByToken(token: req.headers['token']!);

    if (user.user!.userMetadata!['type'] == 'user') {
      body.addAll({'created_by_id': user.user!.id});

      await SupaBaseIntegration().insertToTable(tableName: 'rate', body: body);
    } else {
      return Response.badRequest(body: "user is not of type [user]");
    }

    return Response.ok("rating has been made successfully");
  } on FormatException catch (err) {
    if (err.message == "Unexpected end of input") {
      return Response.badRequest(body: "Body cannot be empty");
    } else {
      return Response.badRequest(body: err.message);
    }
  } on PostgrestException catch (err) {
    return Response.badRequest(body: err.message);
  } catch (err) {
    return Response.badRequest(body: err.toString());
  }
}
