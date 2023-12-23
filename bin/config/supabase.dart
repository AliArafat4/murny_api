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

  Future<List<Map<String, dynamic>>> getFromPublicTable(
      {required String tableName}) async {
    return await subaInstance.from(tableName).select();
  }

  updateTable(
      {required String tableName,
      required Map<String, dynamic> body,
      required UserResponse user}) async {
    body.addAll({'user_id': user.user!.id});
    await subaInstance.from(tableName).upsert(body, onConflict: 'user_id');
  }

  void deleteUser({required UserResponse user}) async {
    await subaInstance.from('profile').delete().eq('user_id', user.user!.id);
    await subaInstance.from('users').delete().eq('user_id', user.user!.id);
    await subaInstance.auth.admin.deleteUser(user.user!.id);
  }

  //TODO-----------------------------Merge--------------------------------------
  uploadUserAvatar(
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
}
