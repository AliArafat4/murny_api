import 'package:shelf/shelf.dart';
import 'dart:convert';

import 'package:supabase/supabase.dart';

import '../../config/supabase.dart';
import '../../logic/check_body.dart';

uploadLicenseHandler(Request req) async {
  try {
    final Map<String, dynamic> body = jsonDecode(await req.readAsString());
    checkBody(keys: ['license'], body: body);
    //Get user object
    final UserResponse user = await SupaBaseIntegration()
        .getUserByToken(token: req.headers['token']!);

    //upload user avatar in [profile] table
    if (user.user!.userMetadata!['type'] != 'driver') {
      throw FormatException("user is not a driver");
    }

    await SupaBaseIntegration().uploadDriverLicense(
      user: user,
      path: 'driver',
      extension: '.png',
      body: body,
    );

    return Response.ok("Image uploaded successfully");
  } on FormatException catch (err) {
    if (err.message == "Unexpected end of input") {
      return Response.badRequest(body: "Body cannot be empty");
    } else {
      return Response.badRequest(body: err.message);
    }
  } on PostgrestException catch (err) {
    return Response.badRequest(
        body: "${err.message} -- try making the field [image] as Uint8List");
  } on TypeError catch (err) {
    return Response.badRequest(
        body: "$err -- try making the field [image] as Uint8List");
  } catch (err) {
    return Response.badRequest(body: err.toString());
  }
}
