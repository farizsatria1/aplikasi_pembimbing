import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

const BASE_URL = "http://192.168.174.146/api/";

class Api{
  //API Login
  static Future<Map<String, dynamic>> getLogin(
      String nip, String password) async {
    try {
      var response = await http.post(Uri.parse(BASE_URL + "masuk-pembimbing"),
          body: {
            'nip': nip,
            'password': password
          }).timeout(Duration(seconds: 15));
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final id = data['id'];
        final name = data['nama'];

        return {
          'id': id,
          'name': name,
        };
      } else {
        print("Failed to fetch data: ${response.statusCode}");
        throw Exception("Failed to fetch data");
      }
    } on TimeoutException catch (e) {
      throw e;
    } on Exception catch (e) {
      throw e;
    }
  }

  //API GetPeserta
  static Future<dynamic> getListPeserta() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int idPembimbing = prefs.getInt('id') ?? 0;

    var response = await http.get(
        Uri.parse(BASE_URL + 'peserta/$idPembimbing'));
    if (response.statusCode == 200) {

      return jsonDecode(response.body)["peserta"];

    } else {
      throw Exception('Failed to load data');
    }
  }

  //API all progress peserta
  static Future<List<dynamic>> getAllProgress() async {
    try {
      final response = await http.get(Uri.parse(BASE_URL + "progress"));
      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      }
      throw Exception('Failed to load progress');
    } catch (e) {
      print(e);
      throw Exception('Failed to load progress');
    }
  }

  //API List Progress Peserta
  static Future<List<dynamic>> getDataProgress(int idPeserta) async {
    try {
      var response = await http.get(
        Uri.parse(BASE_URL + 'progress/$idPeserta'),
      ).timeout(Duration(seconds: 15));

      if (response.statusCode == 200) {
        List<dynamic> jsonResponse = json.decode(response.body);
        List<dynamic> filteredList = [];
        if (jsonResponse != null) {
          filteredList = jsonResponse
              .where((progress) =>
          progress['pekerjaan'] != null &&
              progress['pekerjaan']['id_peserta'] == idPeserta)
              .toList();
        }
        return filteredList;
      } else {
        return [];
      }
    } on TimeoutException catch (e) {
      throw e;
    } on Exception catch (e) {
      throw e;
    }
  }

  //API update status progress
  static Future<void> updateStatus(int id, String status) async {
    var url = Uri.parse(BASE_URL + 'progress/$id/update-status');
    var headers = {
      "Content-type": "application/json",
    };
    var body = json.encode({'status': status});

    try {
      var response = await http.put(url, headers: headers, body: body);
      // Handle the response if needed
    } catch (e) {
      print('Terjadi kesalahan: $e');
      // Handle the error if needed
    }
  }

  //API keterangan absen Masuk Peserta
  static Future<List<dynamic>> getMasuk(int id) async {
    var response = await http.get(Uri.parse(BASE_URL + 'masuk?id_peserta=$id'));
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load data from API');
    }
  }

  //API keterangan absen Masuk Semua Peserta
  static Future<List<dynamic>> getAllMasuk(int idPembimbing) async {
    var response = await http.get(Uri.parse(BASE_URL + 'allMasuk/$idPembimbing'));
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load data from API');
    }
  }

  //API keterangan absen Pulang Peserta
  static Future<List<dynamic>> getPulang(int id) async {
    var response = await http.get(Uri.parse(BASE_URL + 'pulang?id_peserta=$id'));
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load data from API');
    }
  }

  //API list Keterangan
  static Future<dynamic> getListKeterangan(int id_peserta) async {
    try{
      var response = await http.get(Uri.parse(BASE_URL + "keterangan/$id_peserta")).timeout(Duration(seconds: 15));
      if(response.statusCode == 200){
        return jsonDecode(response.body)["data"];
      }
    } on TimeoutException catch(e){
      throw e;
    } on Exception catch (e){
      throw e;
    }
    throw "Unexpected Error";
  }

  //API List Progress Dokumentasi Peserta
  static Future<List<dynamic>?> getDokumentasi(int idPembimbing) async {
    try {
      var response = await http.get(
        Uri.parse(BASE_URL + 'allProgress/$idPembimbing'),
      ).timeout(Duration(seconds: 15));

      if (response.statusCode == 200) {
        // Ubah format data yang diambil dari respons HTTP
        return json.decode(response.body)['peserta'];
      }
      return null; // Menambahkan nilai kembalian untuk kondisi lain jika perlu
    } on TimeoutException catch (e) {
      throw e;
    } on Exception catch (e) {
      throw e;
    }
  }


  //API Piket
  static Future<dynamic> getPiket() async {
    var response = await http.get(
        Uri.parse(BASE_URL + 'piket'));
    if (response.statusCode == 200) {
      return jsonDecode(response.body);

    } else {
      throw Exception('Failed to load data');
    }
  }

  //API Carousel
  static Future<dynamic> getGambar() async {
    var response = await http.get(
        Uri.parse(BASE_URL + 'carousel'));
    if (response.statusCode == 200) {
      return jsonDecode(response.body);

    } else {
      throw Exception('Failed to load data');
    }
  }
}