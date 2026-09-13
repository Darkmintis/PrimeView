import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:primeview/features/favorites/repositories/favorites_repository.dart';
import 'package:primeview/features/favorites/services/favorites_service.dart';

class MockFavoritesRepository extends Mock implements FavoritesRepository {}

void main() {
  late FavoritesService service;
  late MockFavoritesRepository mockRepo;

  setUp(() {
    mockRepo = MockFavoritesRepository();
    service = FavoritesService(mockRepo);
  });

  group('FavoritesService', () {
    group('getFavorites', () {
      test('returns all favorites from repository', () {
        when(() => mockRepo.getAll()).thenReturn({'ch-1', 'ch-2', 'ch-3'});

        final result = service.getFavorites();

        expect(result, containsAll(['ch-1', 'ch-2', 'ch-3']));
        expect(result.length, 3);
        verify(() => mockRepo.getAll()).called(1);
      });

      test('returns empty set when no favorites', () {
        when(() => mockRepo.getAll()).thenReturn({});

        final result = service.getFavorites();

        expect(result, isEmpty);
      });
    });

    group('isFavorite', () {
      test('returns true when channel is favorite', () {
        when(() => mockRepo.exists('ch-1')).thenReturn(true);

        expect(service.isFavorite('ch-1'), true);
        verify(() => mockRepo.exists('ch-1')).called(1);
      });

      test('returns false when channel is not favorite', () {
        when(() => mockRepo.exists('ch-99')).thenReturn(false);

        expect(service.isFavorite('ch-99'), false);
      });
    });

    group('toggle', () {
      test('adds channel when not favorite', () async {
        when(() => mockRepo.exists('ch-1')).thenReturn(false);
        when(() => mockRepo.add('ch-1')).thenAnswer((_) async {});

        await service.toggle('ch-1');

        verify(() => mockRepo.add('ch-1')).called(1);
        verifyNever(() => mockRepo.remove(any()));
      });

      test('removes channel when already favorite', () async {
        when(() => mockRepo.exists('ch-1')).thenReturn(true);
        when(() => mockRepo.remove('ch-1')).thenAnswer((_) async {});

        await service.toggle('ch-1');

        verify(() => mockRepo.remove('ch-1')).called(1);
        verifyNever(() => mockRepo.add(any()));
      });

      test('toggle twice removes and re-adds', () async {
        when(() => mockRepo.exists('ch-1')).thenReturn(false);
        when(() => mockRepo.add('ch-1')).thenAnswer((_) async {});

        await service.toggle('ch-1');
        verify(() => mockRepo.add('ch-1')).called(1);

        when(() => mockRepo.exists('ch-1')).thenReturn(true);
        when(() => mockRepo.remove('ch-1')).thenAnswer((_) async {});

        await service.toggle('ch-1');
        verify(() => mockRepo.remove('ch-1')).called(1);
      });
    });
  });
}
