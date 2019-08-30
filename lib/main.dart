import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:math';
import 'dart:async';
import 'package:sample_list_project/model/data_model.dart';
import 'package:extended_image/extended_image.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      home: Home(),
    );
  }
}

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final _random = new Random();
  final GlobalKey<AnimatedListState> _listKey = GlobalKey();
  List<Data> _list = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        child: Center(
          child: Icon(Icons.add),
        ),
        onPressed: () {
          Data data = _getData(next(1, 50));
          _list.insert(0, data);
          _listKey.currentState
              .insertItem(0, duration: Duration(milliseconds: 600));
        },
      ),
      body: SafeArea(
        child: AnimatedList(
          key: _listKey,
          initialItemCount: _list.length,
          itemBuilder: (context, index, animation) {
            Data item = _list[index];
            return SizeTransition(
              sizeFactor: CurvedAnimation(
                  parent: animation, curve: Curves.easeInOutQuart),
              axis: Axis.vertical,
              child: Container(
                margin: EdgeInsets.all(20),
                height: 160,
                child: Center(
                  child: CropImage(data: item),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  _getData(int random) {
    return Data(
      name: 'Herro..',
      image: 'https://picsum.photos/id/${random}/1920/1080',
    );
  }

  int next(int min, int max) => min + _random.nextInt(max - min);
}

class CropImage extends StatefulWidget {
  final Data data;

  CropImage({Key key, this.data}) : super(key: key);

  @override
  _CropImageState createState() => _CropImageState();
}

class _CropImageState extends State<CropImage> {
  Future<ImageInfo> _imageInfo() async {
    NetworkImage image = NetworkImage(widget.data.image);
    Completer<ImageInfo> completer = Completer();
    image
        .resolve(new ImageConfiguration())
        .addListener(ImageStreamListener((ImageInfo info, bool _) {
      completer.complete(info);
    }));

    return await completer.future;
  }

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1920 / 1080,
      child: FutureBuilder(
        key: Key('${widget.data.image}'),
        future: _imageInfo(),
        builder: (context, AsyncSnapshot<ImageInfo> snapshot) {
          if (snapshot.hasData) {
            return ExtendedRawImage(
              image: snapshot.data.image,
              fit: BoxFit.cover,
              soucreRect: Rect.fromLTWH(50, 50, 600, 200),
            );
          } else {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
    );
  }
}
