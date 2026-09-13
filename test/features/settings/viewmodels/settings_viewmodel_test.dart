import 'dart:io';
import 'package:flutter_test/flutter_test.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:primeview/features/settings/viewmodels/settings_viewmodel.dart';
import 'package:primeview/core/constants/app_constants.dart';

void main() {
  setUpAll(() async {
    TestWidgetsFlutterBinding.ensureInitialized();
    final dir = Directory.systemTemp.createTempSync('primeview_settings_test_');
    Hive.init(dir.path);
    await Hive.openBox(AppConstants.hiveBoxName);
  });

  tearDown(() async {
    await Hive.box(AppConstants.hiveBoxName).clear();
  });

  group('SettingsViewModel', () {
    test('loads default settings from Hive', () {
      final viewModel = SettingsViewModel();

      expect(viewModel.state.playlistUrl, AppConstants.defaultPlaylistUrl);
      expect(viewModel.state.autoPlay, true);
      expect(viewModel.state.rememberLastChannel, true);

      viewModel.dispose();
    });

    test('loads persisted settings', () async {
      final box = Hive.box(AppConstants.hiveBoxName);
      await box.put('playlist_url', 'http://custom.com/playlist.m3u');
      await box.put('auto_play', false);
      await box.put('remember_last_channel', false);

      final vm = SettingsViewModel();

      expect(vm.state.playlistUrl, 'http://custom.com/playlist.m3u');
      expect(vm.state.autoPlay, false);
      expect(vm.state.rememberLastChannel, false);

      vm.dispose();
    });

    group('setPlaylistUrl', () {
      test('persists and updates URL', () async {
        final viewModel = SettingsViewModel();
        await viewModel.setPlaylistUrl('http://new.com/playlist.m3u');

        expect(viewModel.state.playlistUrl, 'http://new.com/playlist.m3u');
        expect(Hive.box(AppConstants.hiveBoxName).get('playlist_url'), 'http://new.com/playlist.m3u');

        viewModel.dispose();
      });
    });

    group('setAutoPlay', () {
      test('toggles auto-play setting', () async {
        final viewModel = SettingsViewModel();
        await viewModel.setAutoPlay(false);

        expect(viewModel.state.autoPlay, false);
        expect(Hive.box(AppConstants.hiveBoxName).get('auto_play'), false);

        viewModel.dispose();
      });
    });

    group('setRememberLastChannel', () {
      test('toggles remember setting', () async {
        final viewModel = SettingsViewModel();
        await viewModel.setRememberLastChannel(false);

        expect(viewModel.state.rememberLastChannel, false);
        expect(Hive.box(AppConstants.hiveBoxName).get('remember_last_channel'), false);

        viewModel.dispose();
      });
    });
  });

  group('SettingsState', () {
    test('copyWith preserves unmodified fields', () {
      const state = SettingsState(
        playlistUrl: 'http://old.com',
        autoPlay: false,
        rememberLastChannel: false,
      );

      final newState = state.copyWith(playlistUrl: 'http://new.com');

      expect(newState.playlistUrl, 'http://new.com');
      expect(newState.autoPlay, false);
      expect(newState.rememberLastChannel, false);
    });

    test('default values', () {
      const state = SettingsState();

      expect(state.playlistUrl, AppConstants.defaultPlaylistUrl);
      expect(state.autoPlay, true);
      expect(state.rememberLastChannel, true);
    });
  });
}
