import 'package:bitsoftickets/models/AccessCapabilities.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('AccessCapabilities', () {
    test('interpreta valores booleanos del API', () {
      expect(AccessCapabilities.parseApiBool(1), isTrue);
      expect(AccessCapabilities.parseApiBool('1'), isTrue);
      expect(AccessCapabilities.parseApiBool(true), isTrue);
      expect(AccessCapabilities.parseApiBool('true'), isTrue);
      expect(AccessCapabilities.parseApiBool(0), isFalse);
      expect(AccessCapabilities.parseApiBool(null), isFalse);
    });

    test('acepta login checker sin campos de admin', () {
      final capabilities = AccessCapabilities.fromLoginJson({
        'role_id': 2,
        'es_checker': 1,
      });

      expect(capabilities.esAdmin, isFalse);
      expect(capabilities.esChecker, isTrue);
      expect(capabilities.esDemo, isFalse);
      expect(capabilities.roleLabel, 'Checker');
    });

    test('acepta login admin sin campos de checker', () {
      final capabilities = AccessCapabilities.fromLoginJson({
        'role_id': 1,
        'es_admin': 1,
        'es_demo': 0,
      });

      expect(capabilities.esAdmin, isTrue);
      expect(capabilities.esChecker, isFalse);
      expect(capabilities.esDemo, isFalse);
      expect(capabilities.roleLabel, 'Admin');
    });

    test('acepta login combinado con ambos indicadores', () {
      final capabilities = AccessCapabilities.fromLoginJson({
        'role_id': 1,
        'es_admin': 1,
        'es_checker': 1,
        'es_demo': 0,
      });

      expect(capabilities.esAdmin, isTrue);
      expect(capabilities.esChecker, isTrue);
      expect(capabilities.roleLabel, 'Admin y Checker');
    });

    test('identifica cuenta admin', () {
      const capabilities = AccessCapabilities(
        esAdmin: true,
        esChecker: false,
        esDemo: false,
      );

      expect(capabilities.hasAccess, isTrue);
      expect(capabilities.roleLabel, 'Admin');
    });

    test('identifica cuenta checker', () {
      const capabilities = AccessCapabilities(
        esAdmin: false,
        esChecker: true,
        esDemo: false,
      );

      expect(capabilities.hasAccess, isTrue);
      expect(capabilities.roleLabel, 'Checker');
    });

    test('identifica cuenta combinada', () {
      const capabilities = AccessCapabilities(
        esAdmin: true,
        esChecker: true,
        esDemo: true,
      );

      expect(capabilities.hasAccess, isTrue);
      expect(capabilities.roleLabel, 'Admin y Checker');
      expect(capabilities.esDemo, isTrue);
    });

    test('rechaza cuenta sin capacidades', () {
      const capabilities = AccessCapabilities(
        esAdmin: false,
        esChecker: false,
        esDemo: false,
      );

      expect(capabilities.hasAccess, isFalse);
      expect(capabilities.roleLabel, 'Sin permisos');
    });
  });
}
