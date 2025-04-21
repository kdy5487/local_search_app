import 'package:flutter_test/flutter_test.dart';
import 'package:local_search_app/data/repository/vworld_repository.dart';

void main() {
  final vworldRepo = VworldRepository();
  test('VworldRepository : findByName test', () async {
    final result = await vworldRepo.findByName('온천동');
    expect(result.isEmpty, false);

    final result2 = await vworldRepo.findByName('asd');
    expect(result2.isEmpty, true);
  });

  test('VworldRepository : findByLatLng test', () async {
    final result = await vworldRepo.findByLatLng(35.2202216, 129.0823133);
    print(result);
    expect(result.isEmpty, false);

    final result2 = await vworldRepo.findByLatLng(32.2202216, 129.0823133);
    expect(result2.isEmpty, true);
  });
}
