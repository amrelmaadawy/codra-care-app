import 'package:flutter_test/flutter_test.dart';
import 'package:medical_erp/features/patient_management/data/models/patient_list_model.dart';
import 'package:medical_erp/features/patient_management/data/models/patient_page_model.dart';

void main() {
  group('PatientListModel', () {
    test('fromJson parses valid map correctly', () {
      final json = {
        'id': 42,
        'code': 'P-0042',
        'name': 'أحمد إبراهيم',
        'phone': '01012345678',
        'gender': 'male',
        'age': 35,
        'last_visit_date': '2026-09-20',
      };

      final model = PatientListModel.fromJson(json);

      expect(model.id, 42);
      expect(model.code, 'P-0042');
      expect(model.name, 'أحمد إبراهيم');
      expect(model.phone, '01012345678');
      expect(model.gender, 'male');
      expect(model.age, 35);
      expect(model.lastVisitDate, '2026-09-20');
    });

    test('fromJson handles null optional fields gracefully', () {
      final json = {
        'id': 1,
        'code': 'P-0001',
        'name': 'مريم علي',
        'phone': null,
        'gender': null,
        'age': null,
        'last_visit_date': null,
      };

      final model = PatientListModel.fromJson(json);

      expect(model.id, 1);
      expect(model.code, 'P-0001');
      expect(model.name, 'مريم علي');
      expect(model.phone, isNull);
      expect(model.gender, isNull);
      expect(model.age, isNull);
      expect(model.lastVisitDate, isNull);
    });

    test('toJson produces correct map', () {
      const model = PatientListModel(
        id: 10,
        code: 'P-10',
        name: 'سارة',
        phone: '01111111111',
        gender: 'female',
        age: 28,
        lastVisitDate: '2026-09-15',
      );

      final json = model.toJson();

      expect(json['id'], 10);
      expect(json['code'], 'P-10');
      expect(json['name'], 'سارة');
      expect(json['phone'], '01111111111');
      expect(json['gender'], 'female');
      expect(json['age'], 28);
      expect(json['last_visit_date'], '2026-09-15');
    });
  });

  group('PatientPageModel', () {
    test('fromJson parses envelope correctly', () {
      final json = {
        'data': {
          'items': [
            {
              'id': 1,
              'code': 'P-1',
              'name': 'سعيد',
              'phone': '010',
              'gender': 'male',
              'age': 40,
              'last_visit_date': null,
            },
          ],
          'meta': {
            'current_page': 1,
            'last_page': 3,
            'per_page': 20,
            'total': 45,
          },
        },
      };

      final page = PatientPageModel.fromJson(json);

      expect(page.items.length, 1);
      expect(page.items.first.name, 'سعيد');
      expect(page.currentPage, 1);
      expect(page.lastPage, 3);
      expect(page.perPage, 20);
      expect(page.total, 45);
      expect(page.hasMore, isTrue);
    });
  });
}
