import 'package:supabase_flutter/supabase_flutter.dart';

import '../models/profile_model.dart';
import 'profile_remote_datasource.dart';

class ProfileRemoteDataSourceImpl implements ProfileRemoteDataSource {
  final SupabaseClient _supabase;
  const ProfileRemoteDataSourceImpl(this._supabase);

  @override
  Future<ProfileModel?> getProfile() async {
    final userId = _supabase.auth.currentUser?.id;

    if (userId == null) {
      return null;
    }

    final response = await _supabase
        .from('profiles')
        .select()
        .eq('user_id', userId)
        .maybeSingle();

    if (response == null) {
      return null;
    }

    return ProfileModel.fromJson(response);
  }

  @override
  Future<ProfileModel> saveProfile(Map<String, dynamic> payload) async {
    final response = await _supabase
        .from('profiles')
        .upsert(payload)
        .select()
        .single();

    return ProfileModel.fromJson(response);
  }
}
