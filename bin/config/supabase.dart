import 'dart:typed_data';
import 'package:supabase/supabase.dart';
import '../server.dart';

class SupaBaseIntegration {
  static late SupabaseClient subaInstance;
  get supabase {
    GotrueAsyncStorage? x;
    final supabase = SupabaseClient(
        "${env["SUPABASE_URL"]}", "${env["SUPABASE_SECRET_KEY"]}",
        authOptions: AuthClientOptions(
          authFlowType: AuthFlowType.implicit,
          pkceAsyncStorage: x,
        ));
    SupaBaseIntegration.subaInstance = supabase;
  }

  //TODO: MAKE IT GET
  Future<UserResponse> getUserByToken({required String token}) async {
    final UserResponse user = await subaInstance.auth.getUser(token);
    return user;
  }

  insertToTable({
    required Map<String, dynamic> body,
    required String tableName,
  }) async {
    await subaInstance.from(tableName).insert(body);
  }

  Future<List<Map<String, dynamic>>> getFromTable({
    required String tableName,
    required UserResponse user,
    required String columnCondition,
  }) async {
    return await subaInstance
        .from(tableName)
        .select()
        .eq(columnCondition, user.user!.id);
  }

  Future<List<Map<String, dynamic>>> getFromTableWithFilter({
    required String tableName,
    required UserResponse user,
    required String columnCondition,
  }) async {
    return await subaInstance
        .from(tableName)
        .select()
        .eq(columnCondition, user.user!.id)
        .order('id', ascending: true);
  }

  Future<List<Map<String, dynamic>>> getFromTableByID({
    required String tableName,
    required String columnCondition,
    required String condition,
  }) async {
    return await subaInstance
        .from(tableName)
        .select()
        .eq(columnCondition, condition);
  }

  Future<List<Map<String, dynamic>>> getFromPublicTable(
      {required String tableName}) async {
    return await subaInstance.from(tableName).select();
  }

  Future<List<Map<String, dynamic>>> filterDriversCarts(
      {required String tableName, required String condition}) async {
    return await subaInstance.from(tableName).select().eq('cart_id', condition);
  }

  Future<void> updateTable(
      {required String tableName,
      required Map<String, dynamic> body,
      required UserResponse user}) async {
    body.addAll({'user_id': user.user!.id});
    await subaInstance.from(tableName).upsert(body, onConflict: 'user_id');
  }

  Future<void> updateOrderTable(
      {required String tableName,
      required Map<String, dynamic> body,
      required UserResponse user}) async {
    await subaInstance
        .from(tableName)
        .upsert(body, onConflict: 'id')
        .eq('driver_id', user.user!.id)
        .eq('order_from_id', body['order_from_id'])
        .eq('order_state', 'just created');
  }

  Future<void> deleteUser({required UserResponse user}) async {
    await subaInstance.from('profile').delete().eq('user_id', user.user!.id);
    await subaInstance.from('users').delete().eq('user_id', user.user!.id);
    await subaInstance.auth.admin.deleteUser(user.user!.id);
  }

  //TODO-----------------------------Merge--------------------------------------
  Future<void> uploadUserAvatar(
      {required UserResponse user,
      required String bucket,
      required String path,
      required String extension,
      required Map<String, dynamic> body}) async {
    final avatars = await subaInstance.storage.from(bucket).list(path: path);

    for (var avatar in avatars) {
      if (avatar.name.startsWith(user.user!.id)) {
        await subaInstance.storage
            .from(bucket)
            .remove(["$path/${avatar.name}"]);
      }
    }

    final newAvatarPath =
        "/$path/${user.user!.id}-${DateTime.now()}.$extension";

    await subaInstance.storage.from(bucket).uploadBinary(
        newAvatarPath, Uint8List.fromList(List.from(body['image'])));

    final avatarURL =
        subaInstance.storage.from(bucket).getPublicUrl(newAvatarPath);

    await updateTable(body: {'image': avatarURL}, tableName: path, user: user);
  }

  uploadDriverLicense(
      {required UserResponse user,
      required String path,
      required String extension,
      required Map<String, dynamic> body}) async {
    final avatars = await subaInstance.storage.from('license').list(path: path);

    for (var avatar in avatars) {
      if (avatar.name.startsWith(user.user!.id)) {
        await subaInstance.storage
            .from('license')
            .remove(["$path/${avatar.name}"]);
      }
    }

    final newLicensePath =
        "/$path/${user.user!.id}-${DateTime.now()}.$extension";

    await subaInstance.storage.from('license').uploadBinary(
        newLicensePath, Uint8List.fromList(List.from(body['license'])));

    final licenseURL =
        subaInstance.storage.from('license').getPublicUrl(newLicensePath);

    await updateTable(
        body: {'license': licenseURL}, tableName: path, user: user);
  }
  //TODO-----------------------------Merge--------------------------------------

  Future<Stream> getChatMessages({
    required String tableName,
    required UserResponse user,
    required String sentTo,
  }) async {
    return subaInstance.from(tableName).stream(primaryKey: [
      'id'
    ]).map((msg) => msg.where((element) =>
        element['sent_from'] == user.user!.id && element['sent_to'] == sentTo ||
        element['sent_to'] == user.user!.id && element['sent_from'] == sentTo));
  }

  Future<AuthResponse> signInWithGoogle(
      {required accessToken, required idToken}) async {
    final SupabaseClient client = SupaBaseIntegration.subaInstance;

    if (accessToken == null) {
      throw 'No Access Token found.';
    }
    if (idToken == null) {
      throw 'No ID Token found.';
    }

    return await client.auth.signInWithIdToken(
      provider: OAuthProvider.apple,
      idToken: idToken,
      accessToken: accessToken,
    );
  }

  Future<AuthResponse> signInWithApple(
      {required credential, required rawNonce}) async {
    final SupabaseClient client = SupaBaseIntegration.subaInstance;

    final idToken = credential.identityToken;
    if (idToken == null) {
      throw const AuthException(
          'Could not find ID Token from generated credential.');
    }

    return await client.auth.signInWithIdToken(
      provider: OAuthProvider.apple,
      idToken: idToken,
      nonce: rawNonce,
    );
  }
}
