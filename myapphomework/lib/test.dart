import 'package:flutter/material.dart';
import 'package:get/get.dart';

//Practice: Create a simple app
// Screen: Text Field, Button Save
// When click save store data in TextField
// Close app and open it. Make sure data is still there


// //Save to local storage - flutter_secure_storage
//               //1. install package: flutter pub add flutter_secure_storage
//               //2. create object:
//               FlutterSecureStorage f = FlutterSecureStorage();
//               //3. save data
//               f.write(key: 'token', value: 'safdghjjhtre');
//               //4. read data
//               f.read(key: 'token');
//               //5. delete data.
//               f.delete(key: 'token');


void main() {
  Get.put(MyData());
  runApp(
    GetMaterialApp(
      getPages: [GetPage(name: '/home', page: () => HomeScreen())],
      initialRoute: '/home',
    ),
  );
}

class MyData extends GetxController {
  String token = '';
}

class AuthMiddleware extends GetMiddleware {
  @override
  RouteSettings? redirect(String? route) {
    String token = Get.find<MyData>().token;
    if (token.isEmpty) {
      //not yet login
      //redirect to login
      return RouteSettings(name: '/login');
    } else {
      //use is already login
      return null;
    }
  }
}

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Home")),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Get.toNamed('/detail');
          Text("Detail Screen");
        },
      ),
    );
  }
}
