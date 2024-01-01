import 'dart:convert';

import 'package:shelf/shelf.dart';
import 'package:supabase/supabase.dart';

import '../../config/supabase.dart';
import '../../logic/check_body.dart';

getDriverByIDHandler(Request req) async {
  try {
    final Map<String, dynamic> body = jsonDecode(await req.readAsString());

    checkBody(keys: ['driver_id'], body: body);
    final res = await SupaBaseIntegration().getFromTableByID(
        tableName: 'driver',
        columnCondition: 'user_id',
        condition: body['driver_id']);

    return Response.ok(jsonEncode(res.first), headers: {
      "Content-Type": "application/json",
    });
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
