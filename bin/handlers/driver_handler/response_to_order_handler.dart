import 'package:shelf/shelf.dart';
import 'dart:convert';
import 'package:supabase/supabase.dart';
import '../../config/supabase.dart';
import '../../logic/check_body.dart';

responseToOrderHandler(Request req) async {
  try {
    final Map<String, dynamic> body = jsonDecode(await req.readAsString());
    checkBody(
        keys: ['order_from_id', 'id', 'order_state', 'cart_id'], body: body);

    //Get user object
    final UserResponse user = await SupaBaseIntegration()
        .getUserByToken(token: req.headers['token']!);

    if (user.user!.userMetadata!['type'] == 'driver') {
      //update user profile in [profile] table
      body.addAll({"driver_id": user.user!.id, "id": body['id']});
      await SupaBaseIntegration()
          .updateOrderTable(tableName: 'order', body: body, user: user);
    } else {
      return Response.badRequest(body: "user is not of type [driver]");
    }

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
