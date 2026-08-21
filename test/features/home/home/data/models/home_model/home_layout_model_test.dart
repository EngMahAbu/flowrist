import 'package:flutter_test/flutter_test.dart';

import 'package:flowrist/features/home/home/data/models/home_model/banner_payload_model.dart';
import 'package:flowrist/features/home/home/data/models/home_model/home_layout_model.dart';

void main() {
  group('HomeLayoutModel', () {
    group('fromJson', () {
      test(
        'should create HomeLayoutModel correctly from JSON',
        () {
          // Arrange
          final json = {
            'id': 'layout-1',
            'type': 'banner',
            'title': 'Spring Sale',
            'order': 1,
            'isEnabled': true,
            'payload': {
              'type': 'banner',
                  'imageUrl': "imageUrl" ,
            'clickAction': "clickAction",
            },
          };

          // Act
          final result = HomeLayoutModel.fromJson(json);

          // Assert
          expect(result.id, 'layout-1');
          expect(result.type, 'banner');
          expect(result.title, 'Spring Sale');
          expect(result.order, 1);
          expect(result.isEnabled, true);

          expect(
            result.payload,
            isA<BannerPayloadModel>(),
          );
        },
      );
    });
  });
}