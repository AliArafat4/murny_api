import 'dart:convert';

import 'package:shelf/shelf.dart';
import 'package:supabase/supabase.dart';
import '../../config/supabase.dart';

getAllDriversHandler(Request req) async {
  try {
    final res =
        await SupaBaseIntegration().getFromPublicTable(tableName: 'driver');

    return Response.ok(jsonEncode(res), headers: {
      "Content-Type": "application/json",
    });
  } on PostgrestException catch (err) {
    return Response.badRequest(body: err.message);
  } catch (err) {
    return Response.badRequest(body: err.toString());
  }
}
