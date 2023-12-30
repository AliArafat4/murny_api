import 'dart:convert';

import 'package:shelf/shelf.dart';
import 'package:supabase/supabase.dart';

Response authResponse({required AuthResponse user, required message}) {
  return Response.ok(
      jsonEncode({
        "message": message,
        "token": user.session!.accessToken,
        "expires_at": user.session!.expiresAt,
        "refresh_token": user.session!.refreshToken,
        "token_type": user.session!.tokenType,
        "user_type": user.session!.user.userMetadata!['type']
      }),
      headers: {
        "Content-Type": "application/json",
      });
}
