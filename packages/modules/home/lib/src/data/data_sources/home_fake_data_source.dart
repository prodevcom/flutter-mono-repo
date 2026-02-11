import 'package:injectable/injectable.dart';

import '../dtos/home_item_dto.dart';
import 'home_remote_data_source.dart';

@dev
@LazySingleton(as: HomeRemoteDataSource)
class FakeHomeRemoteDataSource implements HomeRemoteDataSource {
  static const _fakeItems = [
    HomeItemDto(
      id: '1',
      title: 'Getting Started',
      description: 'Welcome to MonoApp! This is a sample item to demonstrate the home feed.',
      imageUrl: null,
      isFeatured: true,
    ),
    HomeItemDto(
      id: '2',
      title: 'Architecture Overview',
      description: 'This monorepo uses clean architecture with modules and features separation.',
      imageUrl: null,
      isFeatured: true,
    ),
    HomeItemDto(
      id: '3',
      title: 'Design System',
      description: 'Shared tokens, theme, and reusable widgets across all apps.',
      imageUrl: null,
      isFeatured: false,
    ),
    HomeItemDto(
      id: '4',
      title: 'Multi-App Support',
      description: 'Generate white-label client apps from the boilerplate with custom branding.',
      imageUrl: null,
      isFeatured: false,
    ),
    HomeItemDto(
      id: '5',
      title: 'Internationalization',
      description: 'Built-in i18n with ARB files supporting English, Portuguese, and Spanish.',
      imageUrl: null,
      isFeatured: false,
    ),
  ];

  @override
  Future<List<HomeItemDto>> getHomeItems() async {
    await Future<void>.delayed(const Duration(milliseconds: 500));
    return _fakeItems;
  }

  @override
  Future<HomeItemDto> getHomeItemById(String id) async {
    await Future<void>.delayed(const Duration(milliseconds: 300));
    return _fakeItems.firstWhere((item) => item.id == id);
  }
}
