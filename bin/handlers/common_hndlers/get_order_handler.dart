import 'package:shelf/shelf.dart';
import 'package:supabase/supabase.dart';
import '../../config/supabase.dart';

getOrderHandler(Request req) async {
  try {
    final UserResponse user = await SupaBaseIntegration()
        .getUserByToken(token: req.headers['token']!);

    final res = await SupaBaseIntegration().getFromTable(
        tableName: 'order', user: user, columnCondition: 'order_from_id');

    return Response.ok(res.toString());
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
