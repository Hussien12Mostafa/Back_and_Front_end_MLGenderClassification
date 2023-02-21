import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'MLGenderClassification',
      theme: ThemeData(
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Handwriting-Based Gender Classification System',
          style: TextStyle(color: Colors.black),
        ),
        backgroundColor: Colors.amber,
        centerTitle: true,
      ),
      body: Container(
        decoration: BoxDecoration(
            image: DecorationImage(
          image: AssetImage("../assets/amberBackGround.jpg"),
          fit: BoxFit.cover,
        )),
        child: ChangeNotifierProvider<MyProvider>(
          create: (context) => MyProvider(),
          child: Consumer<MyProvider>(
            builder: (context, provider, child) {
              return Center(
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      if (provider.image != null)
                        Image.network(provider.image.path),
  
                      MaterialButton(
                        onPressed: () async {
                          var image = await ImagePicker()
                              .getImage(source: ImageSource.gallery);
                          provider.setImage(image);
                        },
                        color: Colors.amber,
                        textColor: Colors.black,
                        child: Text('Get image'),
                      ),
                      MaterialButton(
                        onPressed: () {
                          if (provider.image == null) return;
                          String res = provider.makePostRequest() as String;
                          if (res == "error") {
                          } else {
                            provider.image = Null;
                            
                            
                          }
                        },
                        color: Colors.amber,
                        textColor: Colors.black,
                        child: Text('make post request...'),
                      )
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}

class MyProvider extends ChangeNotifier {
  var image;

  Future setImage(img) async {
    this.image = img;
    this.notifyListeners();
  }

  Future makePostRequest() async {
    print("inside post");
    String url = "http://127.0.0.1:8000/";

    Uint8List imagebytes = await this.image.readAsBytes(); //convert to bytes
    String base64string = base64.encode(imagebytes);

    Map<String, String> s1 = {"image": base64string};
    print(s1);
    final response = await http.post(
      Uri.parse(url),
      headers: {"Content-Type": "application/json"},
      body: json.encode(s1),
    );
    if (response.statusCode == 201) {
      print("sent");
      print(response.body);
      return jsonDecode(response.body)["message"];
    } else {
      return "error";
    }
  }
}
