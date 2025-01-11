import 'dart:html';
import 'documents.dart';
import 'database.dart';

void main() {
  final toolbar = DivElement()..id = 'toolbar';
  toolbar.style.display = 'flex';
  toolbar.style.justifyContent = 'space-between';
  toolbar.style.marginBottom = '10px';

  toolbar.append(ButtonElement()
    ..text = 'Save Document'
    ..onClick.listen((_) => saveDocument()));
  toolbar.append(ButtonElement()
    ..text = 'Preview'
    ..onClick.listen((_) => previewDocument()));

  final sidebar = DivElement()..id = 'sidebar';
  sidebar.style.width = '20%';
  sidebar.style.padding = '10px';
  sidebar.style.borderRight = '1px solid #ddd';
  sidebar.style.height = '100vh';
  sidebar.style.overflowY = 'auto';

  sidebar.innerHtml = '''
    <h3>Options</h3>
    <ul style="list-style: none; padding: 0;">
      <li><a href="#" id="database">Database</a></li>
      <li><a href="#" id="doc1">Document 1</a></li>
      <li><a href="#" id="doc2">Document 2</a></li>
      <li><a href="#" id="doc3">Document 3</a></li>
    </ul>
  ''';

  sidebar.querySelector('#database')?.onClick.listen((_) => viewDatabase('Database'));
  sidebar.querySelector('#doc1')?.onClick.listen((_) => viewDocument('Document 1'));
  sidebar.querySelector('#doc2')?.onClick.listen((_) => viewDocument('Document 2'));
  sidebar.querySelector('#doc3')?.onClick.listen((_) => viewDocument('Document 3'));

  final workspace = DivElement()..id = 'workspace';
  workspace.style.width = '80%';
  workspace.style.padding = '10px';

  workspace.text = 'Select a document to view and edit.';

  final container = DivElement()
    ..id = 'container'
    ..style.display = 'flex';

  container.append(sidebar);
  container.append(workspace);

  document.body?.append(toolbar);
  document.body?.append(container);

  fetchValues();
}






