import 'dart:convert';

import 'package:shelf/shelf.dart';
import 'package:supabase/supabase.dart';
import '../../config/supabase.dart';
import '../../logic/check_body.dart';

filterDriversHandler(Request req) async {
  try {
    final Map<String, dynamic> body = jsonDecode(await req.readAsString());
    checkBody(keys: ['cart_id'], body: body);
    final res = await SupaBaseIntegration()
        .getFromPublicTable(tableName: 'driver', condition: body['cart_id']);

    return Response.ok(jsonEncode(res), headers: {
      "Content-Type": "application/json",
    });
  } on PostgrestException catch (err) {
    return Response.badRequest(body: err.message);
  } catch (err) {
    return Response.badRequest(body: err.toString());
  }
}
