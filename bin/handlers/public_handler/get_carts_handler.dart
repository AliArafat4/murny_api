import 'package:shelf/shelf.dart';
import 'package:supabase/supabase.dart';
import '../../config/supabase.dart';

getCartsHandler(Request req) async {
  try {
    final res =
        await SupaBaseIntegration().getFromPublicTable(tableName: 'car_tier');

    return Response.ok(res.toString(), headers: {
      "Content-Type": "application/json",
    });
  } on PostgrestException catch (err) {
    return Response.badRequest(body: err.message);
  } catch (err) {
    return Response.badRequest(body: err.toString());
  }
}