import 'package:flutter_test/flutter_test.dart';
import 'package:primeview/features/home/viewmodels/home_viewmodel.dart';
import 'package:primeview/core/models/channel_model.dart';
import 'package:primeview/core/constants/app_constants.dart';

void main() {
  group('HomeViewModel', () {
    late HomeViewModel viewModel;

    setUp(() {
      viewModel = HomeViewModel();
    });

    tearDown(() {
      viewModel.dispose();
    });

    test('initial state has default category', () {
      expect(viewModel.state.selectedCategory, AppConstants.categoryAll);
      expect(viewModel.state.featuredChannel, isNull);
    });

    group('selectCategory', () {
      test('updates selected category', () {
        viewModel.selectCategory('Sports');
        expect(viewModel.state.selectedCategory, 'Sports');
      });

      test('can set back to All', () {
        viewModel.selectCategory('Sports');
        viewModel.selectCategory(AppConstants.categoryAll);
        expect(viewModel.state.selectedCategory, AppConstants.categoryAll);
      });
    });

    group('setFeaturedChannel', () {
      test('sets featured channel', () {
        const channel = ChannelModel(
          id: '1', name: 'BBC', url: 'http://bbc.com',
        );

        viewModel.setFeaturedChannel(channel);

        expect(viewModel.state.featuredChannel, channel);
      });

      test('replaces existing featured channel', () {
        const ch1 = ChannelModel(id: '1', name: 'BBC', url: 'http://bbc.com');
        const ch2 = ChannelModel(id: '2', name: 'CNN', url: 'http://cnn.com');

        viewModel.setFeaturedChannel(ch1);
        viewModel.setFeaturedChannel(ch2);

        expect(viewModel.state.featuredChannel, ch2);
      });
    });
  });

  group('HomeState', () {
    test('copyWith preserves unmodified fields', () {
      const state = HomeState(
        selectedCategory: 'Sports',
        featuredChannel: ChannelModel(id: '1', name: 'A', url: 'http://a.com'),
      );

      final newState = state.copyWith(selectedCategory: 'News');

      expect(newState.selectedCategory, 'News');
      expect(newState.featuredChannel, state.featuredChannel);
    });

    test('copyWith clears featured channel', () {
      const state = HomeState(
        featuredChannel: ChannelModel(id: '1', name: 'A', url: 'http://a.com'),
      );

      final newState = state.copyWith();

      expect(newState.featuredChannel, isNotNull);
    });
  });
}
