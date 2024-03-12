import 'package:flutter/material.dart';
import 'package:pdfx/pdfx.dart';

const String _documentPath = 'assets/pdfs/dummy.pdf';
const String _imgPath = 'assets/images/qrcode.png';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Load PDF - Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  bool _isLoaded = false;
  bool _isLoadedImage = false;
  Offset position = const Offset(100, 100);

  final pdfController = PdfController(
    document: PdfDocument.openAsset(_documentPath),
  );

  void updatePosition(Offset newPosition) =>
      setState(() => position = newPosition);

  get qrcode => SizedBox(
        height: 120.0,
        width: 120.0,
        child: Center(
          child: Image.asset(_imgPath),
        ),
      );

  loadDocument() async {
    setState(() => _isLoaded = true);
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Center(
          child: Stack(
            children: [
              !_isLoaded
                  ? const Center(child: Text('Press to load document'))
                  : PdfView(
                      controller: pdfController,
                    ),
              Positioned(
                left: position.dx,
                top: position.dy,
                child: !_isLoadedImage
                    ? const Text('Press to load image')
                    : Draggable(
                        feedback: qrcode,
                        childWhenDragging: Container(),
                        onDragEnd: (details) => updatePosition(details.offset),
                        child: qrcode),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            onPressed: () {
              loadImage();
            },
            tooltip: 'Add resource',
            child: const Icon(Icons.add_a_photo),
          ),
          const Padding(padding: EdgeInsets.all(10)),
          ElevatedButton(
            onPressed: () async {
              await loadDocument();
            },
            child: const Text('Load PDF'),
          ),
          const Padding(padding: EdgeInsets.all(10)),
          FloatingActionButton(
            onPressed: () {},
            tooltip: 'Save',
            child: const Icon(Icons.save),
          ),
        ],
      ),
    );
  }

  void loadImage() {
    setState(() {
      _isLoadedImage = true;
    });
  }
}
