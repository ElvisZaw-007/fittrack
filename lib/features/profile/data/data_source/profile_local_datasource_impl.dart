import 'dart:convert';

import 'package:fittrack/core/hive/hive_service.dart';
import 'package:hive/hive.dart';

import '../models/profile_model.dart';
import 'profile_local_datasource.dart';

class ProfileLocalDataSourceImpl implements ProfileLocalDatasource {
  static const _key = 'cached_profile';

  Box<String> get _box => HiveService.profileBox;

  @override
  Future<ProfileModel?> getCachedProfile() async {
    final raw = _box.get(_key);

    if (raw == null) return null;

    final json = jsonDecode(raw) as Map<String, dynamic>;

    return ProfileModel.fromJson(json);
  }

  @override
  Future<void> cacheProfile(ProfileModel profile) async {
    final json = jsonEncode(profile.toJson());

    await _box.put(_key, json);
  }

  @override
  Future<void> clearCache() async {
    await _box.delete(_key);
  }
}
