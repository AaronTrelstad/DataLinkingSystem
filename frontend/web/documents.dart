import 'dart:html';

void saveDocument() {
  window.alert('Document saved!');
}

void previewDocument() {
  window.alert('Previewing document with placeholders rendered!');
}

void viewDocument(String docName) {
  final workspace = document.querySelector('#workspace');
  workspace?.children.clear();

  workspace?.append(DivElement()
    ..text = 'Now editing: $docName'
    ..style.fontWeight = 'bold');

  workspace?.append(DivElement()
    ..text = 'Add placeholders into the following text boxes.');

  final textBox1 = TextAreaElement()
    ..id = 'textBox1'
    ..placeholder = 'Enter text here'
    ..style.marginBottom = '10px';
  final button1 = ButtonElement()
    ..text = 'Add Placeholder'
    ..onClick.listen((_) => showPlaceholderOptions('textBox1'));

  final textBox2 = TextAreaElement()
    ..id = 'textBox2'
    ..placeholder = 'Enter text here'
    ..style.marginBottom = '10px';
  final button2 = ButtonElement()
    ..text = 'Add Placeholder'
    ..onClick.listen((_) => showPlaceholderOptions('textBox2'));

  final textBox3 = TextAreaElement()
    ..id = 'textBox3'
    ..placeholder = 'Enter text here'
    ..style.marginBottom = '10px';
  final button3 = ButtonElement()
    ..text = 'Add Placeholder'
    ..onClick.listen((_) => showPlaceholderOptions('textBox3'));

  workspace?.append(textBox1);
  workspace?.append(button1);
  workspace?.append(DivElement()..id = 'options1');
  workspace?.append(textBox2);
  workspace?.append(button2);
  workspace?.append(DivElement()..id = 'options2');
  workspace?.append(textBox3);
  workspace?.append(button3);
  workspace?.append(DivElement()..id = 'options3');
  workspace?.append(DivElement()..id = 'placeholders');
}

void showPlaceholderOptions(String targetBoxId) {
  final optionsDiv =
      document.querySelector('#placeholders') as DivElement? ?? DivElement();

  optionsDiv.children.clear();

  final placeholders = [
    'Dataset1.Revenue',
    'Dataset1.Expenses',
    'Dataset1.Profit',
  ];

  for (var placeholder in placeholders) {
    final placeholderLink = ButtonElement()
      ..text = placeholder
      ..onClick.listen((_) => insertPlaceholder(targetBoxId, placeholder));
    optionsDiv.append(placeholderLink);
  }
}

void insertPlaceholder(String targetBoxId, String placeholder) {
  final textBox = document.querySelector('#$targetBoxId') as TextAreaElement;
  textBox.value = '{{$placeholder}}';
}
