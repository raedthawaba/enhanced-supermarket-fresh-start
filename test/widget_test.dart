// This is a basic Flutter widget test for the login screen.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:supermarket_app/main.dart';

void main() {
  testWidgets('Login screen loads correctly', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const SupermarketApp());

    // Verify that our login screen loads with the title.
    expect(find.text('متجر السوبر ماركت'), findsOneWidget);
    expect(find.text('مرحباً بك، سجل دخولك للمتابعة'), findsOneWidget);
    expect(find.text('البريد الإلكتروني'), findsOneWidget);
    expect(find.text('كلمة المرور'), findsOneWidget);
    expect(find.text('تسجيل الدخول'), findsOneWidget);
    expect(find.text('إنشاء حساب جديد'), findsOneWidget);

    // Verify that the email and password input fields are present.
    expect(find.byType(TextFormField), findsNWidgets(2));
    
    // Verify that the login button is present.
    expect(find.byType(ElevatedButton), findsOneWidget);
  });
}