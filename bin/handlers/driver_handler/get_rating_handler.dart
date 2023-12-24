import 'package:shelf/shelf.dart';
import 'package:supabase/supabase.dart';
import '../../config/supabase.dart';

getRatingHandler(Request req) async {
  try {
    final UserResponse user = await SupaBaseIntegration()
        .getUserByToken(token: req.headers['token']!);

    late final List<Map<String, dynamic>> res;
    if (user.user!.userMetadata!['type'] == 'driver') {
      res = await SupaBaseIntegration().getFromTable(
          tableName: 'rate', user: user, columnCondition: 'driver_id');
      print(res);
      print("res");
    } else {
      return Response.badRequest(body: "user is not of type [driver]");
    }

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
