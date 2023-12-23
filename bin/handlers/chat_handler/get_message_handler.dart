import 'dart:convert';

import 'package:shelf/shelf.dart';
import 'package:supabase/supabase.dart';

import '../../config/supabase.dart';
import '../../logic/check_body.dart';

getMessageHandler(Request req) async {
  try {
    final Map<String, dynamic> body = jsonDecode(await req.readAsString());
    checkBody(keys: ['chat_with'], body: body);

    final UserResponse user = await SupaBaseIntegration()
        .getUserByToken(token: req.headers['token']!);
    final String chatWithID = body['chat_with'];
    body.addAll({'sent_from': user.user!.id});

    final Stream res = await SupaBaseIntegration()
        .getChatMessages(tableName: 'chat', user: user, sentTo: chatWithID);

    return Response.ok(res.toString(), headers: {
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
