import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart' hide Text;
import 'package:filesystem_picker/filesystem_picker.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:text_editor/home.dart';

class Editor extends StatefulWidget {
  const Editor({Key key}) : super(key: key);

  @override
  _EditorState createState() => _EditorState();
}

class _EditorState extends State<Editor> {
  QuillController _controller = QuillController.basic();
  ScrollController _scrollController;
  FocusNode _focusNode;
  final TextEditingController _txtController = TextEditingController();
  var toolbar;
  String url;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _scrollController = ScrollController();
    _focusNode = FocusNode();

    toolbar = QuillToolbar.basic(
        controller: _controller, onImagePickCallback: _onImagePickCallback);
    // toolbar = QuillToolbar(children: <Widget>[
    //   IconButton(
    //     icon: Icon(Icons.format_bold),
    //     onPressed: () {},
    //   )
    // ]);
  }

  Future<String> _onImagePickCallback(File file) async {
    // Copies the picked file from temporary cache to applications directory
    final appDocDir = await getApplicationDocumentsDirectory();
    final copiedFile =
        await file.copy('${appDocDir.path}/${basename(file.path)}');
    return copiedFile.path.toString();
  }

  _addNetWorkImg() {}

  @override
  Widget build(BuildContext context) {
    _reNavigate() => Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (ctx) => Home(
                  textData: _controller.document.toPlainText(),
                )));

    _dialogShow() => showDialog<void>(
        context: context,
        builder: (ctx) => AlertDialog(
            title: Text('Insert image url here'),
            actions: [
              ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                    url = _txtController.text;
                    _txtController.clear();
                  },
                  child: Text('Done')),
            ],
            content: TextField(
              controller: _txtController,
            )));

    return Scaffold(
      appBar: AppBar(
        title: Text('Text Editor'),
        actions: [
          IconButton(
            icon: Icon(Icons.done),
            onPressed: _reNavigate,
          )
        ],
      ),
      body: Container(
        child: Column(
          children: [
            Container(child: toolbar),
            Row(
              children: [
                ElevatedButton(
                    onPressed: () {
                      _dialogShow();
                      // AlertDialog(
                      //     title: Text('Insert image url here'),
                      //     content: TextField(
                      //       controller: _txtController,
                      //     ));
                      // _addNetworkImg();
                    },
                    child: Text('Image Url')),
              ],
            ),
            Divider(),
            Container(
              height: MediaQuery.of(context).size.height * 0.75,
              child: QuillEditor(
                onLaunchUrl: (s) => print(s),
                controller: _controller,
                scrollController: ScrollController(),
                scrollable: true,
                focusNode: _focusNode,
                autoFocus: true,
                readOnly: false,
                placeholder: 'Add content',
                expands: true,
                padding: EdgeInsets.symmetric(horizontal: 10),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
