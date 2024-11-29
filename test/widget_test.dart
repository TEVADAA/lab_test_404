import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lab_test/main.dart';

void main() {
  testWidgets('Product form widget test', (WidgetTester tester) async {
    // Build the ProductFormPage widget and trigger a frame.
    await tester.pumpWidget(const MaterialApp(home: ProductFormPage()));

    // Verify initial UI state
    expect(find.text('Add Product'), findsOneWidget);
    expect(find.text('Product Name'), findsOneWidget);
    expect(find.text('Category ID'), findsOneWidget);
    expect(find.text('Tap to select an image'), findsOneWidget);

    // Fill out the form fields
    await tester.enterText(
        find.byType(TextFormField).at(0), 'Test Product'); // Product Name
    await tester.enterText(
        find.byType(TextFormField).at(1), 'Test Description'); // Description
    await tester.enterText(
        find.byType(TextFormField).at(2), '123456'); // Barcode
    await tester.enterText(
        find.byType(TextFormField).at(3), '2024-12-31'); // Expired Date
    await tester.enterText(find.byType(TextFormField).at(4), '10'); // Quantity
    await tester.enterText(
        find.byType(TextFormField).at(5), '5.50'); // Unit Price In
    await tester.enterText(
        find.byType(TextFormField).at(6), '6.50'); // Unit Price Out

    // Interact with the dropdown
    await tester.tap(find.byType(DropdownButtonFormField<String>));
    await tester.pumpAndSettle(); // Wait for the dropdown to appear
    await tester.tap(find.text('Category 0001').last);
    await tester.pump(); // Close the dropdown

    // Tap the "Add Product" button
    await tester.tap(find.byType(ElevatedButton));
    await tester.pump(); // Wait for the button to process

    // Verify that the snack bar appears (assuming success)
    expect(find.text('Product added successfully!'), findsOneWidget);
  });
}
