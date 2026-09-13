import 'package:flutter_test/flutter_test.dart';
import 'package:primeview/core/models/channel_model.dart';

void main() {
  group('ChannelModel', () {
    const channel = ChannelModel(
      id: 'ch-1',
      name: 'BBC News',
      url: 'https://example.com/bbc.m3u8',
      logo: 'https://example.com/bbc.png',
      category: 'News',
      language: 'English',
      country: 'United Kingdom',
      group: 'UK Channels',
      quality: 'HD',
      isActive: true,
    );

    group('constructor', () {
      test('creates instance with all fields', () {
        expect(channel.id, 'ch-1');
        expect(channel.name, 'BBC News');
        expect(channel.url, 'https://example.com/bbc.m3u8');
        expect(channel.logo, 'https://example.com/bbc.png');
        expect(channel.category, 'News');
        expect(channel.language, 'English');
        expect(channel.country, 'United Kingdom');
        expect(channel.group, 'UK Channels');
        expect(channel.quality, 'HD');
        expect(channel.isActive, true);
      });

      test('creates instance with only required fields', () {
        const minimal = ChannelModel(
          id: 'ch-2',
          name: 'CNN',
          url: 'https://example.com/cnn.m3u8',
        );

        expect(minimal.id, 'ch-2');
        expect(minimal.name, 'CNN');
        expect(minimal.url, 'https://example.com/cnn.m3u8');
        expect(minimal.logo, isNull);
        expect(minimal.category, isNull);
        expect(minimal.language, isNull);
        expect(minimal.country, isNull);
        expect(minimal.group, isNull);
        expect(minimal.quality, isNull);
        expect(minimal.isActive, true);
      });
    });

    group('copyWith', () {
      test('returns same instance when no arguments provided', () {
        final copy = channel.copyWith();
        expect(copy, channel);
      });

      test('overrides specified fields', () {
        final copy = channel.copyWith(
          name: 'BBC News HD',
          quality: 'FHD',
          isActive: false,
        );

        expect(copy.name, 'BBC News HD');
        expect(copy.quality, 'FHD');
        expect(copy.isActive, false);
        expect(copy.id, channel.id);
        expect(copy.url, channel.url);
      });

      test('copyWith preserves original when passing same values', () {
        final copy = channel.copyWith(
          name: 'BBC News',
          quality: 'HD',
          isActive: true,
        );

        expect(copy.name, 'BBC News');
        expect(copy.quality, 'HD');
        expect(copy.isActive, true);
        expect(copy.id, channel.id);
        expect(copy.url, channel.url);
      });
    });

    group('equality', () {
      test('two instances with same fields are equal', () {
        const a = ChannelModel(id: '1', name: 'A', url: 'http://a.com');
        const b = ChannelModel(id: '1', name: 'A', url: 'http://a.com');
        expect(a, equals(b));
      });

      test('two instances with different fields are not equal', () {
        const a = ChannelModel(id: '1', name: 'A', url: 'http://a.com');
        const b = ChannelModel(id: '2', name: 'B', url: 'http://b.com');
        expect(a, isNot(equals(b)));
      });

      test('equality considers all fields', () {
        const a = ChannelModel(
          id: '1', name: 'A', url: 'http://a.com',
          logo: 'logo.png', category: 'News', language: 'EN',
          country: 'US', group: 'G1', quality: 'HD', isActive: true,
        );
        const b = ChannelModel(
          id: '1', name: 'A', url: 'http://a.com',
          logo: 'logo.png', category: 'News', language: 'EN',
          country: 'US', group: 'G1', quality: 'HD', isActive: true,
        );
        expect(a, equals(b));
        expect(a.hashCode, equals(b.hashCode));
      });

      test('equality ignores null vs absent optional fields', () {
        const a = ChannelModel(id: '1', name: 'A', url: 'http://a.com');
        const b = ChannelModel(id: '1', name: 'A', url: 'http://a.com', logo: null);
        expect(a, equals(b));
      });
    });

    group('props', () {
      test('contains all fields in correct order', () {
        expect(channel.props, [
          'ch-1', 'BBC News', 'https://example.com/bbc.m3u8',
          'https://example.com/bbc.png', 'News', 'English',
          'United Kingdom', 'UK Channels', 'HD', true,
        ]);
      });
    });
  });
}
