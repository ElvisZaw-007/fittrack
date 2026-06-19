// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:fittrack/main.dart';

void main() {
  testWidgets('Counter increments smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const FitTrackApp());

    // Verify that our counter starts at 0.
    expect(find.text('0'), findsOneWidget);
    expect(find.text('1'), findsNothing);

    // Tap the '+' icon and trigger a frame.
    await tester.tap(find.byIcon(Icons.add));
    await tester.pump();

    // Verify that our counter has incremented.
    expect(find.text('0'), findsNothing);
    expect(find.text('1'), findsOneWidget);
  });
}

////////

// import 'package:flutter_test/flutter_test.dart';
// import 'package:mocktail/mocktail.dart';

// import 'package:fittrack/core/errors/failures.dart';
// import 'package:fittrack/features/auth/domain/entities/app_user.dart';
// import 'package:fittrack/features/auth/domain/repositories/auth_repository.dart';
// import 'package:fittrack/features/auth/domain/usecases/register_usecase.dart';

// class MockAuthRepository extends Mock implements AuthRepository {}

// void main() {
//   late MockAuthRepository mockRepository;
//   late RegisterUseCase registerUseCase;

//   setUp(() {
//     mockRepository = MockAuthRepository();
//     registerUseCase = RegisterUseCase(mockRepository);
//   });

//   group('RegisterUseCase', () {
//     test(
//       'throws InvalidEmailFailure when email format is invalid',
//       () {
//         expect(
//           () => registerUseCase(
//             email: 'invalid-email',
//             password: 'password123',
//           ),
//           throwsA(isA<InvalidEmailFailure>()),
//         );
//       },
//     );

//     test(
//       'throws WeakPasswordFailure when password is under 8 characters',
//       () {
//         expect(
//           () => registerUseCase(
//             email: 'test@gmail.com',
//             password: '123',
//           ),
//           throwsA(isA<WeakPasswordFailure>()),
//         );
//       },
//     );

//     test(
//       'returns AppUser when credentials are valid',
//       () async {
//         final user = AppUser(
//           id: '1',
//           email: 'test@gmail.com',
//           createdAt: DateTime.now(),
//         );

//         when(
//           () => mockRepository.register(
//             email: any(named: 'email'),
//             password: any(named: 'password'),
//           ),
//         ).thenAnswer((_) async => user);

//         final result = await registerUseCase(
//           email: 'test@gmail.com',
//           password: 'password123',
//         );

//         expect(result, equals(user));

//         verify(
//           () => mockRepository.register(
//             email: 'test@gmail.com',
//             password: 'password123',
//           ),
//         ).called(1);
//       },
//     );
//   });
// }