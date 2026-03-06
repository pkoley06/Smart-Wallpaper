import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'auth_provider.g.dart';

@riverpod
class AuthNotifier extends _$AuthNotifier {
  @override
  bool build() {
    // Mocking premium status for demo
    return true;
  }

  void togglePremium() {
    state = !state;
  }
}
