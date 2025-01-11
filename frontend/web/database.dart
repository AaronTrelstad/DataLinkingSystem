import 'dart:convert';
import 'dart:html';

void viewDatabase(String databaseName) {
  final workspace = document.querySelector('#workspace');
  workspace?.children.clear();

  workspace?.append(HeadingElement.h2()..text = 'Database Management');
  workspace?.append(DivElement()..id = 'databaseTitle');

  final databaseTable = TableElement()
    ..style.borderCollapse = 'collapse'
    ..style.width = '100%'
    ..innerHtml = '''
      <thead>
        <tr>
          <th style="border: 1px solid #ddd; padding: 8px;">Placeholder</th>
          <th style="border: 1px solid #ddd; padding: 8px;">Value</th>
          <th style="border: 1px solid #ddd; padding: 8px;">Actions</th>
        </tr>
      </thead>
      <tbody id="databaseBody">
      </tbody>
    ''';
  workspace?.append(databaseTable);

  workspace?.append(DivElement()
    ..innerHtml = '''
      <label for="newTitle">Title:</label>
      <input type="text" id="newTitle" placeholder="Enter title">
      <label for="newValue">Value:</label>
      <input type="text" id="newValue" placeholder="Enter value">
    ''');

  workspace?.append(ButtonElement()
    ..text = "Add Value"
    ..onClick.listen((_) => addDatabaseEntry()));

  fetchValues();
}

Future<void> fetchValues() async {
  try {
    final response =
        await HttpRequest.getString('http://localhost:8080/api/database');
    final dbData = jsonDecode(response);

    updateDatabaseUI(dbData);
  } catch (e) {
    window.alert("Failed to fetch data: $e");
  }
}

void updateDatabaseUI(Map<String, dynamic> dbData) {
  final title = dbData['title'];
  final values = dbData['values'];

  final databaseBody = document.querySelector('#databaseBody');
  final titleElement = document.querySelector('#databaseTitle');

  titleElement?.text = title ?? "Unknown Database";
  databaseBody?.children.clear();

  if (values is List && values.isNotEmpty) {
    for (final value in values) {
      addRowToDatabaseTable(value);
    }
  } else {
    databaseBody?.append(TableRowElement()
      ..innerHtml = '''
        <td colspan="3" style="border: 1px solid #ddd; padding: 8px; text-align: center;">
          No data available
        </td>
      ''');
  }
}

void addRowToDatabaseTable(Map<String, dynamic> value) {
  final valueTitle = value['title'] ?? 'No title';
  final valueAmount = value['value'] ?? 0.0;

  final row = TableRowElement();

  final titleCell = TableCellElement()
    ..style.border = '1px solid #ddd'
    ..style.padding = '8px'
    ..text = valueTitle;

  final valueCell = TableCellElement()
    ..style.border = '1px solid #ddd'
    ..style.padding = '8px';
  final valueTextBox = InputElement()
    ..type = 'text'
    ..value = valueAmount.toString()
    ..style.display = 'none';

  final valueText = SpanElement()..text = valueAmount.toString();

  valueCell.append(valueTextBox);
  valueCell.append(valueText);

  late final ButtonElement editButton;
  late final ButtonElement saveButton;

  final actionCell = TableCellElement()
    ..style.border = '1px solid #ddd'
    ..style.padding = '8px';

  saveButton = ButtonElement()
    ..text = 'Save'
    ..style.display = 'none'
    ..onClick.listen((_) async {
      final newValue = valueTextBox.value;
      if (newValue != null && newValue.isNotEmpty) {
        await editValue(valueTitle, double.tryParse(newValue) ?? valueAmount);
      }
      valueText.style.display = 'inline-block';
      valueTextBox.style.display = 'none';
      saveButton.style.display = 'none';
      editButton.style.display = 'inline-block';
    });

  editButton = ButtonElement()
    ..text = 'Edit'
    ..onClick.listen((_) {
      valueText.style.display = 'none';
      valueTextBox.style.display = 'inline-block';
      saveButton.style.display = 'inline-block';
      editButton.style.display = 'none';
    });

  final deleteButton = ButtonElement()
    ..text = 'Delete'
    ..onClick.listen((_) => deleteValue(valueTitle));

  actionCell.append(editButton);
  actionCell.append(saveButton);
  actionCell.append(deleteButton);

  row
    ..append(titleCell)
    ..append(valueCell)
    ..append(actionCell);

  final databaseBody = document.querySelector('#databaseBody');
  databaseBody?.append(row);
}

Future<void> addDatabaseEntry() async {
  final newTitle =
      (document.querySelector('#newTitle') as InputElement?)?.value;
  final newValue =
      (document.querySelector('#newValue') as InputElement?)?.value;

  if (newTitle != null &&
      newValue != null &&
      newTitle.isNotEmpty &&
      newValue.isNotEmpty) {
    final data = {'title': newTitle, 'value': double.tryParse(newValue) ?? 0.0};

    try {
      await HttpRequest.request(
        'http://localhost:8080/api/database',
        method: "POST",
        requestHeaders: {'Content-Type': 'application/json'},
        sendData: jsonEncode(data),
      );
      fetchValues();
    } catch (e) {
      window.alert("Error adding data: $e");
    }
  } else {
    window.alert('Please enter valid key and value!');
  }
}

Future<void> deleteValue(String title) async {
  try {
    await HttpRequest.request(
      'http://localhost:8080/api/database',
      method: "DELETE",
      requestHeaders: {'Content-Type': 'application/json'},
      sendData: jsonEncode({'title': title}),
    );
    fetchValues();
  } catch (e) {
    window.alert("Error deleting data: $e");
  }
}

Future<void> editValue(String title, double value) async {
  try {
    await HttpRequest.request(
      'http://localhost:8080/api/database',
      method: "PUT",
      requestHeaders: {'Content-Type': 'application/json'},
      sendData: jsonEncode({'title': title, 'value': value}),
    );
    fetchValues();
  } catch (e) {
    window.alert("Error editing data: $e");
  }
}
