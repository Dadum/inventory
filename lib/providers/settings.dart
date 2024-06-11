import 'dart:convert';

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'settings.freezed.dart';
part 'settings.g.dart';

@freezed
class SettingsState with _$SettingsState {
  const factory SettingsState({
    @Default(true) bool showBank,
    @Default(true) bool showMaterials,
  }) = _SettingsState;

  factory SettingsState.fromJson(Map<String, dynamic> json) =>
      _$SettingsStateFromJson(json);
}

@riverpod
class Settings extends _$Settings {
  static const _settingsKey = 'settings';
  @override
  SettingsState build() {
    SharedPreferences.getInstance().then(
      (value) {
        final json = value.getString(_settingsKey);

        if (json != null) {
          state = SettingsState.fromJson(jsonDecode(json));
        }
      },
    );

    return const SettingsState();
  }

  Future<void> _save() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString(_settingsKey, jsonEncode(state.toJson()));
  }

  void toggleBank() {
    state = state.copyWith(showBank: !state.showBank);
    _save();
  }

  void toggleMaterials() {
    state = state.copyWith(showMaterials: !state.showMaterials);
    _save();
  }
}
