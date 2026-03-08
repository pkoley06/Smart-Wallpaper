import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:smart_wallpaper/core/constants/app_constants.dart';
import 'dart:io';

Future<void> main() async {
  await Supabase.initialize(
    url: 'https://feycrgmmimlmrnfxafmb.supabase.co',
    anonKey: 'sb_publishable_R-6ByLVRzsDVb1vacQStvA_QpMHskX1',
  );

  final client = Supabase.instance.client;

  try {
    final res = await client.from('app_config').select();
    print('APP CONFIG RESULT: $res');
    exit(0);
  } catch (e) {
    print('ERROR FETCHING APP CONFIG: $e');
    exit(1); 
  }
}
