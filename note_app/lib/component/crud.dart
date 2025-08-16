import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:path/path.dart';

String _basicAuth = 'Basic ${base64Encode(utf8.encode('wael:wael12345'))}';

Map<String, String> myheaders = {'authorization': _basicAuth};

class Crud {
  getRequest(String url) async {
    try {
      var response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        var responsebody = jsonDecode(response.body);
        return responsebody;
      } else {
        print("error ${response.statusCode}");
      }
    } catch (e) {
      print(" Error ctach : $e ");
    }
  }

  // هسا انا لما اكبس على ساين عالسريع بعمل حساب لانو انا عون شغال على لوكل هوست
  // فبسرعة بجيب البيانات اما لو عامل هوستنج بختلف الوضع فشوي بدي اعمل ديلاي لما اعمل حساب
  postRequest(String url, Map data) async {
    await Future.delayed(Duration(seconds: 1));
    try {
      var response = await http.post(
        Uri.parse(url),
        body: data,
        headers: myheaders,
      );
      if (response.statusCode == 200) {
        var responsebody = jsonDecode(response.body);
        return responsebody;
      } else {
        print("error ${response.statusCode}");
      }
    } catch (e) {
      print(" Error ctach : $e ");
    }
  }

  postRequestWithFile(String url, Map data, File file) async {
    try {
      var request = http.MultipartRequest("POST", Uri.parse(url));
      var mylength = await file.length();
      var stream = http.ByteStream(file.openRead());
      var multipartFile = http.MultipartFile(
        "file",
        stream,
        mylength,
        filename: basename(file.path), // بتجبلك الاسم من المسار
      ); //"file" الي بملف الباك\
      request.headers.addAll(myheaders);
      request.files.add(
        multipartFile,
      ); // هيك انا بحمل الملف على الريكويست الي رايح للسيرفر
      data.forEach((Key, value) {
        request.fields[Key] = value;
      });
      var myrequest = await request
          .send(); // send Future<StreamedResponse> send() انا برسل ستيم فالؤ=ريسبونس ستريم كمان لازم

      var response = await http.Response.fromStream(myrequest);
      if (myrequest.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        print("Error ${myrequest.statusCode}");
      }
    } catch (e) {
      print(" Error ctach : $e ");
    }
  }
}
