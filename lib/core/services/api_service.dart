import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:sesa/core/models/token.dart';
import 'package:sesa/core/services/http_service.dart';

class ApiService {
  late HttpService _http;
  final Dio dio = Dio();

  ApiService() {
    _http = GetIt.instance.get<HttpService>();
  }

  Future<TokenGenerate> generateToken() async {
    String url = "https://generate-token.vercel.app/api/generateToken";
    TokenGenerate _token = TokenGenerate();
    Response _response = await dio.post(url, data: {
      "channel": "1234",
      "isPublisher": true,
    });
    if (_response.statusCode == 200) {
      _token = TokenGenerate.fromJson(_response.data);
    }
    return _token;
  }

  Future login({required String email, required String pwd}) async {
    Map dataFinal;
    //User data;
    try {
      Response _response = await _http.post(
        '/auth/sign-in',
        body: {
          "username": email,
          "password": pwd,
          'appProvider': 'mobile',
        },
      );
      print("Login response : ${_response}");
      if (_response.statusCode == 200) {
        Map _data = _response.data;

        //print(_data);
        if (_response.statusCode == 200) {
          dataFinal = {
            "status": 200,
            "data": _data,
            "message": "Congratulation the operation was made successfully",
          };
          print("connexion reussi");
          return dataFinal;
        } else {
          dataFinal = {
            "status": _data["status"],
            "message": "Sorry we had an issue with our server",
          };
          print("connexion ECHEC");
          return dataFinal;
        }
      } else {
        dataFinal = {
          "status": 500,
          "message": "Une erreur est survenue",
        };
        print("connexion erreur est survenue");
        return dataFinal;
      }
    } on DioError catch (e) {
      if (e.type == DioErrorType.connectTimeout) {
        //return e.message;
        dataFinal = {
          "status": 500,
          "message": "Connection Timeout please restart the process",
        };
        print("Connection Timeout please restart the process");
        return dataFinal;
      }
      if (e.type == DioErrorType.receiveTimeout) {
        dataFinal = {
          "status": 500,
          "message":
              "Server ERROR : RECEIVE TIMEOUT  please restart the process",
        };
        print("Server ERROR : RECEIVE TIMEOUT  please restart the process");
        return dataFinal;
      }
      if (e.type == DioErrorType.other) {
        dataFinal = {
          "status": 500,
          "message":
              "Server ERROR : Could not send request,  please restart the process",
        };
        print(e.message);
        print(
            "Server ERROR : Could not send request,  please restart the process");
        return dataFinal;
      } else {
        dataFinal = {
          "status": 500,
          "message":
              "Server ERROR : Could not send request, Contact the administrator",
        };
        print(e.message);
        print(
            "Server ERROR : Could not send request, Contact the administrator1");
        return dataFinal;
      }
    } catch (e) {
      print(e);
      dataFinal = {
        "status": 500,
        "message": "Une erreur est survenue",
      };
      print("Une erreur est survenue");
      return dataFinal;
    }
  }

  Future signUp(
      {required String email,
      required String username,
      required String password,
      required String firstName,
      required String tel1}) async {
    Map dataFinal;
    //User data;
    try {
      Response _response = await _http.post(
        '/auth/sign-up',
        body: {
          "email": email,
          "username": username,
          "providerName": "local",
          "using2FA": true,
          "password": password,
          "userType": "patient",
          "verificationType": "tel",
          "tel1": tel1,
          "firstName": firstName
        },
      );
      print("Login response : ${_response}");
      Map _data = _response.data;
      if (_response.statusCode == 201) {
        //print(_data);
        if (_response.statusCode == 201) {
          dataFinal = {
            "status": 201,
            "data": _data,
            "message": "Congratulation the operation was made successfully",
          };
          print("connexion reussi");
          return dataFinal;
        } else {
          dataFinal = {
            "status": _data["status"],
            "message": _data["message"],
          };
          print("connexion ECHEC");
          return dataFinal;
        }
      } else {
        dataFinal = {
          "status": _data["status"],
          "message": _data["message"],
        };
        print("connexion erreur est survenue");
        return dataFinal;
      }
    } on DioError catch (e) {
      if (e.type == DioErrorType.connectTimeout) {
        //return e.message;
        dataFinal = {
          "status": 500,
          "message": "Connection Timeout please restart the process",
        };
        print("Connection Timeout please restart the process");
        return dataFinal;
      }
      if (e.type == DioErrorType.receiveTimeout) {
        dataFinal = {
          "status": 500,
          "message": "Server ERROR : RECEIVE TIMEOUT Contact the administrator",
        };
        print("Server ERROR : RECEIVE TIMEOUT Contact the administrator");
        return dataFinal;
      }
      if (e.type == DioErrorType.other) {
        dataFinal = {
          "status": 500,
          "message":
              "Server ERROR : Could not send request, Contact the administrator",
        };
        print(e.message);
        print(
            "Server ERROR : Could not send request, Contact the administrator");
        return dataFinal;
      }
      if (e.type == DioErrorType.response) {
        dataFinal = {
          "status": 400,
          "message":
              "Une de ses valeur existe dejà veuillez contacté un administrateur pour verifier",
        };
        print(e.message);
        print(
            "Server ERROR : Could not send request, Contact the administrator");
        return dataFinal;
      } else {
        dataFinal = {
          "status": 500,
          "message":
              "Server ERROR : Could not send request, Contact the administrator",
        };
        print(e.message);
        print(
            "Server ERROR : Could not send request, Contact the administrator1");
        return dataFinal;
      }
    } catch (e) {
      print(e);
      dataFinal = {
        "status": 500,
        "message": "Une erreur est survenue",
      };
      print("Une erreur est survenue");
      return dataFinal;
    }
  }

  Future signUpDoctor(
      {required String email,
      required String username,
      required String password,
      required String firstName,
      required String tel1}) async {
    Map dataFinal;
    //User data;
    try {
      Response _response = await _http.post(
        '/auth/sign-up',
        body: {
          "email": email,
          "username": username,
          "providerName": "local",
          "using2FA": true,
          "password": password,
          "userType": "medecin",
          "verificationType": "tel",
          "tel1": tel1,
          "firstName": firstName
        },
      );
      print("Login response : ${_response}");
      if (_response.statusCode == 201) {
        Map _data = _response.data;

        //print(_data);
        if (_response.statusCode == 201) {
          dataFinal = {
            "status": 201,
            "data": _data,
            "message": "Congratulation the operation was made successfully",
          };
          print("connexion reussi");
          return dataFinal;
        } else {
          dataFinal = {
            "status": _data["status"],
            "message": "Sorry we had an issue with our server",
          };
          print("connexion ECHEC");
          return dataFinal;
        }
      } else {
        dataFinal = {
          "status": 500,
          "message": "Une erreur est survenue",
        };
        print("connexion erreur est survenue");
        return dataFinal;
      }
    } on DioError catch (e) {
      if (e.type == DioErrorType.connectTimeout) {
        //return e.message;
        dataFinal = {
          "status": 500,
          "message": "Connection Timeout please restart the process",
        };
        print("Connection Timeout please restart the process");
        return dataFinal;
      }
      if (e.type == DioErrorType.receiveTimeout) {
        dataFinal = {
          "status": 500,
          "message": "Server ERROR : RECEIVE TIMEOUT Contact the administrator",
        };
        print("Server ERROR : RECEIVE TIMEOUT Contact the administrator");
        return dataFinal;
      }
      if (e.type == DioErrorType.other) {
        dataFinal = {
          "status": 500,
          "message":
              "Server ERROR : Could not send request, Contact the administrator",
        };
        print(e.message);
        print(
            "Server ERROR : Could not send request, Contact the administrator");
        return dataFinal;
      } else {
        dataFinal = {
          "status": 500,
          "message":
              "Server ERROR : Could not send request, Contact the administrator",
        };
        print(e.message);
        print(
            "Server ERROR : Could not send request, Contact the administrator1");
        return dataFinal;
      }
    } catch (e) {
      print(e);
      dataFinal = {
        "status": 500,
        "message": "Une erreur est survenue",
      };
      print("Une erreur est survenue");
      return dataFinal;
    }
  }

  Future validateAccount({required String code, required String tel}) async {
    Map dataFinal;
    //User data;
    try {
      Response _response = await _http.post(
        '/auth/user/confirm-account-phone',
        body: {"code": code, "tel": tel},
      );
      print("Login response : ${_response}");
      if (_response.statusCode == 200) {
        Map _data = _response.data;

        //print(_data);
        if (_response.statusCode == 200) {
          dataFinal = {
            "status": 200,
            "data": _data,
            "message": "Congratulation the operation was made successfully",
          };
          print("connexion reussi");
          return dataFinal;
        } else {
          dataFinal = {
            "status": _data["status"],
            "message": "Sorry we had an issue with our server",
          };
          print("connexion ECHEC");
          return dataFinal;
        }
      } else {
        dataFinal = {
          "status": 500,
          "message": "Une erreur est survenue",
        };
        print("connexion erreur est survenue");
        return dataFinal;
      }
    } on DioError catch (e) {
      if (e.type == DioErrorType.connectTimeout) {
        //return e.message;
        dataFinal = {
          "status": 500,
          "message": "Connection Timeout please restart the process",
        };
        print("Connection Timeout please restart the process");
        return dataFinal;
      }
      if (e.type == DioErrorType.receiveTimeout) {
        dataFinal = {
          "status": 500,
          "message": "Server ERROR : RECEIVE TIMEOUT Contact the administrator",
        };
        print("Server ERROR : RECEIVE TIMEOUT Contact the administrator");
        return dataFinal;
      }
      if (e.type == DioErrorType.other) {
        dataFinal = {
          "status": 500,
          "message":
              "Server ERROR : Could not send request, Contact the administrator",
        };
        print(e.message);
        print(
            "Server ERROR : Could not send request, Contact the administrator");
        return dataFinal;
      } else {
        dataFinal = {
          "status": 500,
          "message":
              "Server ERROR : Could not send request, Contact the administrator",
        };
        print(e.message);
        print(
            "Server ERROR : Could not send request, Contact the administrator1");
        return dataFinal;
      }
    } catch (e) {
      print(e);
      dataFinal = {
        "status": 500,
        "message": "Une erreur est survenue",
      };
      print("Une erreur est survenue");
      return dataFinal;
    }
  }

  Future getMe() async {
    Map dataFinal = Map();
    try {
      Response response = await _http.getRequest('/auth/user/me');
      if (response.statusCode == 200) {
        Map _data = response.data;
        //print(_data);
        if (response.statusCode == 200) {
          dataFinal = {
            "status": 200,
            "message": "Get Data sucessfully",
            "data": _data
          };
          //print("connexion reussi");
          return dataFinal;
        }
      } else {
        dataFinal = {
          "status": response.statusCode,
          "message": "Une erreur est survenue",
        };
        print("connexion erreur est survenue");
        return dataFinal;
      }
    } on DioError catch (e) {
      if (e.type == DioErrorType.connectTimeout) {
        //return e.message;
        dataFinal = {
          "status": 500,
          "message": "Connection Timeout please restart the process",
        };
        print("Connection Timeout please restart the process");
        return dataFinal;
      }
      if (e.type == DioErrorType.receiveTimeout) {
        dataFinal = {
          "status": 500,
          "message": "Server ERROR : RECEIVE TIMEOUT Contact the administrator",
        };
        print("Server ERROR : RECEIVE TIMEOUT Contact the administrator");
        return dataFinal;
      }
      if (e.type == DioErrorType.other) {
        dataFinal = {
          "status": 500,
          "message":
              "Server ERROR : Could not send request, Contact the administrator",
        };
        print(
            "Server ERROR : Could not send request, Contact the administrator");
        return dataFinal;
      } else {
        dataFinal = {
          "status": 500,
          "message":
              "Server ERROR : Could not send request, Contact the administrator",
        };
        print(
            "Server ERROR : Could not send request, Contact the administrator");
        return dataFinal;
      }
    } catch (e) {
      print(e);
      dataFinal = {
        "status": 500,
        "message": "Une erreur est survenue",
      };
      print("Une erreur est survenue");
      return dataFinal;
    }
  }

  Future getDoctors() async {
    Map dataFinal;
    //String email = await readStorage(value: "email");
    try {
      Response response = await _http.getRequest("/user/doctor?sortBy=userId");
      //print("the response is $response");
      if (response.statusCode == 200) {
        Map _data = response.data;
        //print(_data);
        if (response.statusCode == 200) {
          dataFinal = {
            "status": 200,
            "message": "Get Data sucessfully",
            "data": _data["content"]
          };
          //print("connexion reussi");
          return dataFinal;
        }
      } else {
        dataFinal = {
          "status": response.statusCode,
          "message": "Une erreur est survenue",
        };
        print("connexion erreur est survenue");
        return dataFinal;
      }
    } on DioError catch (e) {
      if (e.type == DioErrorType.connectTimeout) {
        //return e.message;
        dataFinal = {
          "status": 500,
          "message": "Connection Timeout please restart the process",
        };
        print("Connection Timeout please restart the process");
        return dataFinal;
      }
      if (e.type == DioErrorType.receiveTimeout) {
        dataFinal = {
          "status": 500,
          "message": "Server ERROR : RECEIVE TIMEOUT Contact the administrator",
        };
        print("Server ERROR : RECEIVE TIMEOUT Contact the administrator");
        return dataFinal;
      }
      if (e.type == DioErrorType.other) {
        dataFinal = {
          "status": 500,
          "message":
              "Server ERROR : Could not send request, Contact the administrator",
        };
        print(
            "Server ERROR : Could not send request, Contact the administrator");
        return dataFinal;
      } else {
        dataFinal = {
          "status": 500,
          "message":
              "Server ERROR : Could not send request, Contact the administrator",
        };
        print(
            "Server ERROR : Could not send request, Contact the administrator");
        return dataFinal;
      }
    } catch (e) {
      print(e);
      dataFinal = {
        "status": 500,
        "message": "Une erreur est survenue",
      };
      print("Une erreur est survenue");
      return dataFinal;
    }
  }

  Future getSpeciality() async {
    Map dataFinal;
    //String email = await readStorage(value: "email");
    try {
      Response response = await _http.getRequest("/hospital/active?size=1");
      //print("the response is $response");
      if (response.statusCode == 200) {
        Map _data = response.data;
        //print(_data);
        if (response.statusCode == 200) {
          dataFinal = {
            "status": 200,
            "message": "Get Data sucessfully",
            "data": _data["content"][0]["departments"][0]["specialitys"]
          };
          //print("connexion reussi");
          return dataFinal;
        }
      } else {
        dataFinal = {
          "status": response.statusCode,
          "message": "Une erreur est survenue",
        };
        print("connexion erreur est survenue");
        return dataFinal;
      }
    } on DioError catch (e) {
      if (e.type == DioErrorType.connectTimeout) {
        //return e.message;
        dataFinal = {
          "status": 500,
          "message": "Connection Timeout please restart the process",
        };
        print("Connection Timeout please restart the process");
        return dataFinal;
      }
      if (e.type == DioErrorType.receiveTimeout) {
        dataFinal = {
          "status": 500,
          "message": "Server ERROR : RECEIVE TIMEOUT Contact the administrator",
        };
        print("Server ERROR : RECEIVE TIMEOUT Contact the administrator");
        return dataFinal;
      }
      if (e.type == DioErrorType.other) {
        dataFinal = {
          "status": 500,
          "message":
              "Server ERROR : Could not send request, Contact the administrator",
        };
        print(
            "Server ERROR : Could not send request, Contact the administrator");
        return dataFinal;
      } else {
        dataFinal = {
          "status": 500,
          "message":
              "Server ERROR : Could not send request, Contact the administrator",
        };
        print(
            "Server ERROR : Could not send request, Contact the administrator");
        return dataFinal;
      }
    } catch (e) {
      print(e);
      dataFinal = {
        "status": 500,
        "message": "Une erreur est survenue",
      };
      print("Une erreur est survenue");
      return dataFinal;
    }
  }

  Future getPatient() async {
    Map dataFinal;
    //String email = await readStorage(value: "email");
    try {
      Response response = await _http.getRequest("/patient?sortBy=userId");
      //print("the response is $response");
      if (response.statusCode == 200) {
        Map _data = response.data;
        //print(_data);
        if (response.statusCode == 200) {
          dataFinal = {
            "status": 200,
            "message": "Get Data sucessfully",
            "data": _data["content"]
          };
          //print("connexion reussi");
          return dataFinal;
        }
      } else {
        dataFinal = {
          "status": response.statusCode,
          "message": "Une erreur est survenue",
        };
        print("connexion erreur est survenue");
        return dataFinal;
      }
    } on DioError catch (e) {
      if (e.type == DioErrorType.connectTimeout) {
        //return e.message;
        dataFinal = {
          "status": 500,
          "message": "Connection Timeout please restart the process",
        };
        print("Connection Timeout please restart the process");
        return dataFinal;
      }
      if (e.type == DioErrorType.receiveTimeout) {
        dataFinal = {
          "status": 500,
          "message": "Server ERROR : RECEIVE TIMEOUT Contact the administrator",
        };
        print("Server ERROR : RECEIVE TIMEOUT Contact the administrator");
        return dataFinal;
      }
      if (e.type == DioErrorType.other) {
        dataFinal = {
          "status": 500,
          "message":
              "Server ERROR : Could not send request, Contact the administrator",
        };
        print(
            "Server ERROR : Could not send request, Contact the administrator");
        return dataFinal;
      } else {
        dataFinal = {
          "status": 500,
          "message":
              "Server ERROR : Could not send request, Contact the administrator",
        };
        print(
            "Server ERROR : Could not send request, Contact the administrator");
        return dataFinal;
      }
    } catch (e) {
      print(e);
      dataFinal = {
        "status": 500,
        "message": "Une erreur est survenue",
      };
      print("Une erreur est survenue");
      return dataFinal;
    }
  }

  Future uploadImage({required File file, required int userId}) async {
    Map dataFinal;
    try {
      String fileName = file.path.split('/').last;
      String url = "/$userId/uploadFile?docType=profile";
      print("The url $url");
      FormData formData = FormData.fromMap({
        "file": await MultipartFile.fromFile(
          file.path,
          filename: fileName,
        ),
      });
      Response response = await _http.postImage(url, body: formData);
      print("THe response is : $response");
      if (response.statusCode == 200) {
        //return e.message;
        dataFinal = {
          "status": 200,
          "message": "SUCCESS",
        };
        print("SUCCESS");
        return dataFinal;
      }
    } on DioError catch (e) {
      if (e.type == DioErrorType.connectTimeout) {
        //return e.message;
        dataFinal = {
          "status": 500,
          "message": "Connection Timeout please restart the process",
        };
        print("Connection Timeout please restart the process");
        return dataFinal;
      }
      if (e.type == DioErrorType.receiveTimeout) {
        dataFinal = {
          "status": 500,
          "message": "Server ERROR : RECEIVE TIMEOUT Contact the administrator",
        };
        print("Server ERROR : RECEIVE TIMEOUT Contact the administrator");
        return dataFinal;
      }
      if (e.type == DioErrorType.other) {
        dataFinal = {
          "status": 500,
          "message":
              "Server ERROR : Could not send request, Contact the administrator",
        };
        print(
            "Server ERROR : Could not send request, Contact the administrator");
        return dataFinal;
      } else {
        dataFinal = {
          "status": 500,
          "message":
              "Server ERROR : Could not send request, Contact the administrator",
        };
        print(
            "Server ERROR : Could not send request, Contact the administrator");
        return dataFinal;
      }
    } catch (e) {
      print(e);
      dataFinal = {
        "status": 500,
        "message": "Une erreur est survenue",
      };
      print("Une erreur est survenue");
      return dataFinal;
    }
  }

  Future getDoctorPerSpeciality() async {
    Map dataFinal;
    //String email = await readStorage(value: "email");
    try {
      Response response = await _http.getRequest("/hospital/5/doctor");
      //print("the response is $response");
      if (response.statusCode == 200) {
        Map _data = response.data;
        //print(_data);
        if (response.statusCode == 200) {
          dataFinal = {
            "status": 200,
            "message": "Get Data sucessfully",
            "data": _data["content"]
          };
          //print("connexion reussi");
          return dataFinal;
        }
      } else {
        dataFinal = {
          "status": response.statusCode,
          "message": "Une erreur est survenue",
        };
        print("connexion erreur est survenue");
        return dataFinal;
      }
    } on DioError catch (e) {
      if (e.type == DioErrorType.connectTimeout) {
        //return e.message;
        dataFinal = {
          "status": 500,
          "message": "Connection Timeout please restart the process",
        };
        print("Connection Timeout please restart the process");
        return dataFinal;
      }
      if (e.type == DioErrorType.receiveTimeout) {
        dataFinal = {
          "status": 500,
          "message": "Server ERROR : RECEIVE TIMEOUT Contact the administrator",
        };
        print("Server ERROR : RECEIVE TIMEOUT Contact the administrator");
        return dataFinal;
      }
      if (e.type == DioErrorType.other) {
        dataFinal = {
          "status": 500,
          "message":
              "Server ERROR : Could not send request, Contact the administrator",
        };
        print(
            "Server ERROR : Could not send request, Contact the administrator");
        return dataFinal;
      } else {
        dataFinal = {
          "status": 500,
          "message":
              "Server ERROR : Could not send request, Contact the administrator",
        };
        print(
            "Server ERROR : Could not send request, Contact the administrator");
        return dataFinal;
      }
    } catch (e) {
      print(e);
      dataFinal = {
        "status": 500,
        "message": "Une erreur est survenue",
      };
      print("Une erreur est survenue");
      return dataFinal;
    }
  }

  Future getCategoriesPack() async {
    Map dataFinal;
    //String email = await readStorage(value: "email");
    try {
      Response response = await _http.getRequest("/packsesa/categorie");
      print("the response is ${response.data}");
      if (response.statusCode == 200) {
        //Map _data = response;
        //print(_data);
        if (response.statusCode == 200) {
          dataFinal = {
            "status": 200,
            "message": "Get Data sucessfully",
            "data": response.data
          };
          //print("connexion reussi");
          return dataFinal;
        }
      } else {
        dataFinal = {
          "status": response.statusCode,
          "message": "Une erreur est survenue",
        };
        print("connexion erreur est survenue");
        return dataFinal;
      }
    } on DioError catch (e) {
      if (e.type == DioErrorType.connectTimeout) {
        //return e.message;
        dataFinal = {
          "status": 500,
          "message": "Connection Timeout please restart the process",
        };
        print("Connection Timeout please restart the process");
        return dataFinal;
      }
      if (e.type == DioErrorType.receiveTimeout) {
        dataFinal = {
          "status": 500,
          "message": "Server ERROR : RECEIVE TIMEOUT Contact the administrator",
        };
        print("Server ERROR : RECEIVE TIMEOUT Contact the administrator");
        return dataFinal;
      }
      if (e.type == DioErrorType.other) {
        dataFinal = {
          "status": 500,
          "message":
              "Server ERROR : Could not send request, Contact the administrator",
        };
        print(
            "Server ERROR : Could not send request, Contact the administrator");
        return dataFinal;
      } else {
        dataFinal = {
          "status": 500,
          "message":
              "Server ERROR : Could not send request, Contact the administrator",
        };
        print(
            "Server ERROR : Could not send request, Contact the administrator");
        return dataFinal;
      }
    } catch (e) {
      print(e);
      dataFinal = {
        "status": 500,
        "message": "Une erreur est survenue",
      };
      print("Une erreur est survenue");
      return dataFinal;
    }
  }

  Future getPrestations() async {
    Map dataFinal;
    //String email = await readStorage(value: "email");
    try {
      Response response =
          await _http.getRequest("/medicament/prestationCategorie");
      print("the response is ${response.data}");
      if (response.statusCode == 200) {
        //Map _data = response;
        //print(_data);
        if (response.statusCode == 200) {
          dataFinal = {
            "status": 200,
            "message": "Get Data sucessfully",
            "data": response.data
          };
          //print("connexion reussi");
          return dataFinal;
        }
      } else {
        dataFinal = {
          "status": response.statusCode,
          "message": "Une erreur est survenue",
        };
        print("connexion erreur est survenue");
        return dataFinal;
      }
    } on DioError catch (e) {
      if (e.type == DioErrorType.connectTimeout) {
        //return e.message;
        dataFinal = {
          "status": 500,
          "message": "Connection Timeout please restart the process",
        };
        print("Connection Timeout please restart the process");
        return dataFinal;
      }
      if (e.type == DioErrorType.receiveTimeout) {
        dataFinal = {
          "status": 500,
          "message": "Server ERROR : RECEIVE TIMEOUT Contact the administrator",
        };
        print("Server ERROR : RECEIVE TIMEOUT Contact the administrator");
        return dataFinal;
      }
      if (e.type == DioErrorType.other) {
        dataFinal = {
          "status": 500,
          "message":
              "Server ERROR : Could not send request, Contact the administrator",
        };
        print(
            "Server ERROR : Could not send request, Contact the administrator");
        return dataFinal;
      } else {
        dataFinal = {
          "status": 500,
          "message":
              "Server ERROR : Could not send request, Contact the administrator",
        };
        print(
            "Server ERROR : Could not send request, Contact the administrator");
        return dataFinal;
      }
    } catch (e) {
      print(e);
      dataFinal = {
        "status": 500,
        "message": "Une erreur est survenue",
      };
      print("Une erreur est survenue");
      return dataFinal;
    }
  }

  Future getPrestationsDetails({required int id}) async {
    Map dataFinal;
    //String email = await readStorage(value: "email");
    try {
      Response response =
          await _http.getRequest("/medicament/prestationCategorie/$id");
      print("the response is ${response.data}");
      if (response.statusCode == 200) {
        //Map _data = response;
        //print(_data);
        if (response.statusCode == 200) {
          dataFinal = {
            "status": 200,
            "message": "Get Data sucessfully",
            "data": response.data
          };
          //print("connexion reussi");
          return dataFinal;
        }
      } else {
        dataFinal = {
          "status": response.statusCode,
          "message": "Une erreur est survenue",
        };
        print("connexion erreur est survenue");
        return dataFinal;
      }
    } on DioError catch (e) {
      if (e.type == DioErrorType.connectTimeout) {
        //return e.message;
        dataFinal = {
          "status": 500,
          "message": "Connection Timeout please restart the process",
        };
        print("Connection Timeout please restart the process");
        return dataFinal;
      }
      if (e.type == DioErrorType.receiveTimeout) {
        dataFinal = {
          "status": 500,
          "message": "Server ERROR : RECEIVE TIMEOUT Contact the administrator",
        };
        print("Server ERROR : RECEIVE TIMEOUT Contact the administrator");
        return dataFinal;
      }
      if (e.type == DioErrorType.other) {
        dataFinal = {
          "status": 500,
          "message":
              "Server ERROR : Could not send request, Contact the administrator",
        };
        print(
            "Server ERROR : Could not send request, Contact the administrator");
        return dataFinal;
      } else {
        dataFinal = {
          "status": 500,
          "message":
              "Server ERROR : Could not send request, Contact the administrator",
        };
        print(
            "Server ERROR : Could not send request, Contact the administrator");
        return dataFinal;
      }
    } catch (e) {
      print(e);
      dataFinal = {
        "status": 500,
        "message": "Une erreur est survenue",
      };
      print("Une erreur est survenue");
      return dataFinal;
    }
  }

  Future getMedicaments() async {
    Map dataFinal;
    //String email = await readStorage(value: "email");
    try {
      Response response = await _http.getRequest("/medicament/");
      print("the response is ${response.data}");
      if (response.statusCode == 200) {
        //Map _data = response;
        //print(_data);
        if (response.statusCode == 200) {
          dataFinal = {
            "status": 200,
            "message": "Get Data sucessfully",
            "data": response.data
          };
          //print("connexion reussi");
          return dataFinal;
        }
      } else {
        dataFinal = {
          "status": response.statusCode,
          "message": "Une erreur est survenue",
        };
        print("connexion erreur est survenue");
        return dataFinal;
      }
    } on DioError catch (e) {
      if (e.type == DioErrorType.connectTimeout) {
        //return e.message;
        dataFinal = {
          "status": 500,
          "message": "Connection Timeout please restart the process",
        };
        print("Connection Timeout please restart the process");
        return dataFinal;
      }
      if (e.type == DioErrorType.receiveTimeout) {
        dataFinal = {
          "status": 500,
          "message": "Server ERROR : RECEIVE TIMEOUT Contact the administrator",
        };
        print("Server ERROR : RECEIVE TIMEOUT Contact the administrator");
        return dataFinal;
      }
      if (e.type == DioErrorType.other) {
        dataFinal = {
          "status": 500,
          "message":
              "Server ERROR : Could not send request, Contact the administrator",
        };
        print(
            "Server ERROR : Could not send request, Contact the administrator");
        return dataFinal;
      } else {
        dataFinal = {
          "status": 500,
          "message":
              "Server ERROR : Could not send request, Contact the administrator",
        };
        print(
            "Server ERROR : Could not send request, Contact the administrator");
        return dataFinal;
      }
    } catch (e) {
      print(e);
      dataFinal = {
        "status": 500,
        "message": "Une erreur est survenue",
      };
      print("Une erreur est survenue");
      return dataFinal;
    }
  }

  Future requestPayment(
      {required int userId,
      required int modePayId,
      required int amount,
      required String descriptionPresta,
      required String tokenCode,
      required String paymentNumber,
      required String commisssionAmount}) async {
    Map dataFinal;
    try {
      Response response =
          await _http.postLogin("/prestation/paiement/requestToPay", body: {
        "userId": userId,
        "modePayId": modePayId,
        "amount": amount,
        "descriptionPresta": descriptionPresta,
        "tokenCode": tokenCode,
        "paymentNumber": paymentNumber,
        "commisssionAmount": commisssionAmount
      });
      print(response.data["data"]);
      if (response.statusCode == 201) {
        dataFinal = {
          "status": 200,
          "message": "Get Data sucessfully",
          "data": response.data
        };
        return dataFinal;
      } else {
        dataFinal = {
          "status": response.statusCode,
          "message": "Une erreur est survenue",
        };
        print("connexion erreur est survenue");
        return dataFinal;
      }
    } on DioError catch (e) {
      if (e.type == DioErrorType.connectTimeout) {
        //return e.message;
        dataFinal = {
          "status": 500,
          "message": "Connection Timeout please restart the process",
        };
        print("Connection Timeout please restart the process");
        return dataFinal;
      }
      if (e.type == DioErrorType.receiveTimeout) {
        dataFinal = {
          "status": 500,
          "message": "Server ERROR : RECEIVE TIMEOUT Contact the administrator",
        };
        print("Server ERROR : RECEIVE TIMEOUT Contact the administrator");
        return dataFinal;
      }
      if (e.type == DioErrorType.other) {
        dataFinal = {
          "status": 500,
          "message":
              "Server ERROR : Could not send request, Contact the administrator",
        };
        print(e.message);
        print(
            "Server ERROR : Could not send request, Contact the administrator");
        return dataFinal;
      } else {
        dataFinal = {
          "status": 500,
          "message":
              "Server ERROR : Could not send request, Contact the administrator",
        };
        print(e.message);
        print(
            "Server ERROR : Could not send request, Contact the administrator1");
        return dataFinal;
      }
    } catch (e) {
      print(e);
      dataFinal = {
        "status": 500,
        "message": "Une erreur est survenue",
      };
      print("Une erreur est survenue");
      return dataFinal;
    }
  }

  Future chcekStatus({
    required int modePayId,
    required String adpFootprint,
    required String tokenCode,
  }) async {
    Map dataFinal;
    try {
      Response response =
          await _http.postLogin("/prestation/paiement/paymentStatus", body: {
        "modePayId": modePayId,
        "adpFootprint": adpFootprint,
        "tokenCode": tokenCode,
      });
      print(response.data["data"]);
      if (response.statusCode == 201) {
        dataFinal = {
          "status": 200,
          "message": "Get Data sucessfully",
          "data": response.data
        };
        return dataFinal;
      } else {
        dataFinal = {
          "status": response.statusCode,
          "message": "Une erreur est survenue",
        };
        print("connexion erreur est survenue");
        return dataFinal;
      }
    } on DioError catch (e) {
      if (e.type == DioErrorType.connectTimeout) {
        //return e.message;
        dataFinal = {
          "status": 500,
          "message": "Connection Timeout please restart the process",
        };
        print("Connection Timeout please restart the process");
        return dataFinal;
      }
      if (e.type == DioErrorType.receiveTimeout) {
        dataFinal = {
          "status": 500,
          "message": "Server ERROR : RECEIVE TIMEOUT Contact the administrator",
        };
        print("Server ERROR : RECEIVE TIMEOUT Contact the administrator");
        return dataFinal;
      }
      if (e.type == DioErrorType.other) {
        dataFinal = {
          "status": 500,
          "message":
              "Server ERROR : Could not send request, Contact the administrator",
        };
        print(e.message);
        print(
            "Server ERROR : Could not send request, Contact the administrator");
        return dataFinal;
      } else {
        dataFinal = {
          "status": 500,
          "message":
              "Server ERROR : Could not send request, Contact the administrator",
        };
        print(e.message);
        print(
            "Server ERROR : Could not send request, Contact the administrator1");
        return dataFinal;
      }
    } catch (e) {
      print(e);
      dataFinal = {
        "status": 500,
        "message": "Une erreur est survenue",
      };
      print("Une erreur est survenue");
      return dataFinal;
    }
  }

  Future getCategoriesPackSesa(int id) async {
    Map dataFinal;
    //String email = await readStorage(value: "email");
    try {
      Response response = await _http.getRequest("/packsesa/$id");
      print("the response is ${response.data}");
      if (response.statusCode == 200) {
        //Map _data = response;
        //print(_data);
        if (response.statusCode == 200) {
          dataFinal = {
            "status": 200,
            "message": "Get Data sucessfully",
            "data": response.data
          };
          //print("connexion reussi");
          return dataFinal;
        }
      } else {
        dataFinal = {
          "status": response.statusCode,
          "message": "Une erreur est survenue",
        };
        print("connexion erreur est survenue");
        return dataFinal;
      }
    } on DioError catch (e) {
      if (e.type == DioErrorType.connectTimeout) {
        //return e.message;
        dataFinal = {
          "status": 500,
          "message": "Connection Timeout please restart the process",
        };
        print("Connection Timeout please restart the process");
        return dataFinal;
      }
      if (e.type == DioErrorType.receiveTimeout) {
        dataFinal = {
          "status": 500,
          "message": "Server ERROR : RECEIVE TIMEOUT Contact the administrator",
        };
        print("Server ERROR : RECEIVE TIMEOUT Contact the administrator");
        return dataFinal;
      }
      if (e.type == DioErrorType.other) {
        dataFinal = {
          "status": 500,
          "message":
              "Server ERROR : Could not send request, Contact the administrator",
        };
        print(
            "Server ERROR : Could not send request, Contact the administrator");
        return dataFinal;
      } else {
        dataFinal = {
          "status": 500,
          "message":
              "Server ERROR : Could not send request, Contact the administrator",
        };
        print(
            "Server ERROR : Could not send request, Contact the administrator");
        return dataFinal;
      }
    } catch (e) {
      print(e);
      dataFinal = {
        "status": 500,
        "message": "Une erreur est survenue",
      };
      print("Une erreur est survenue");
      return dataFinal;
    }
  }

  Future updateProfile({
    required int id,
    required String firstName,
    required String lastName,
    required String birthdate,
    required String birthdatePlace,
    required String sexe,
    required String maritalStatus,
    required String nationality,
    required String imageUrl,
  }) async {
    Map dataFinal = Map();
    try {
      Response _response =
          await _http.putRequest('/user/updateprofil/$id', body: {
        "firstName": firstName,
        "lastName": lastName,
        "birthdate": birthdate,
        "birthdatePlace": birthdatePlace,
        "sexe": sexe,
        "maritalStatus": maritalStatus,
        "nationality": nationality,
        "imageUrl": imageUrl,
      });
      if (_response.statusCode == 201) {
        Map _data = _response.data;
        //print(_data);
        if (_response.statusCode == 201) {
          dataFinal = {
            "status": _response.statusCode,
            "message": "Your product was update successfully",
            "data": _data
          };
          //print("connexion reussi");
          return dataFinal;
        } else {
          dataFinal = {
            "status": _response.statusCode,
            "message": "Une erreur est survenue",
          };
          //print("connexion ECHEC");
          return dataFinal;
        }
      } else {
        dataFinal = {
          "status": 500,
          "message": "Une erreur est survenue",
        };
        print("connexion erreur est survenue");
        return dataFinal;
      }
    } on DioError catch (e) {
      if (e.type == DioErrorType.connectTimeout) {
        //return e.message;
        dataFinal = {
          "status": 500,
          "message": "Connection Timeout please restart the process",
        };
        print("Connection Timeout please restart the process");
        return dataFinal;
      }
      if (e.type == DioErrorType.receiveTimeout) {
        dataFinal = {
          "status": 500,
          "message": "Server ERROR : RECEIVE TIMEOUT Contact the administrator",
        };
        print("Server ERROR : RECEIVE TIMEOUT Contact the administrator");
        return dataFinal;
      }
      if (e.type == DioErrorType.other) {
        dataFinal = {
          "status": 500,
          "message":
              "Server ERROR : Could not send request, Contact the administrator",
        };
        print(e.message);
        print(
            "Server ERROR : Could not send request, Contact the administrator");
        return dataFinal;
      } else {
        dataFinal = {
          "status": 500,
          "message":
              "Server ERROR : Could not send request, Contact the administrator",
        };
        print(e.message);
        print(
            "Server ERROR : Could not send request, Contact the administrator1");
        return dataFinal;
      }
    } catch (e) {
      print(e);
      dataFinal = {
        "status": 500,
        "message": "Une erreur est survenue",
      };
      print("Une erreur est survenue");
      return dataFinal;
    }
  }

  Future updateParams({
    required int id,
    required double taille,
    required double poids,
    required double temperature,
    required double frequenceCardiaque,
    required double pouls,
    required double frequenceRespiratoire,
    required double saturationOxygene,
    required double perimetreBranchial,
  }) async {
    Map dataFinal = Map();
    try {
      Response _response =
          await _http.putRequest('/patient/parameter/${id}', body: {
        "taille": taille,
        "poids": poids,
        "temperature": temperature,
        "frequenceCardiaque": frequenceCardiaque,
        "pouls": pouls,
        "frequenceRespiratoire": frequenceRespiratoire,
        "saturationOxygene": saturationOxygene,
        "perimetreBranchial": perimetreBranchial,
      });
      if (_response.statusCode == 201) {
        Map _data = _response.data;
        //print(_data);
        if (_response.statusCode == 201) {
          dataFinal = {
            "status": _response.statusCode,
            "message": "Your product was update successfully",
            "data": _data
          };
          //print("connexion reussi");
          return dataFinal;
        } else {
          dataFinal = {
            "status": _response.statusCode,
            "message": "Une erreur est survenue",
          };
          //print("connexion ECHEC");
          return dataFinal;
        }
      } else {
        dataFinal = {
          "status": 500,
          "message": "Une erreur est survenue",
        };
        print("connexion erreur est survenue");
        return dataFinal;
      }
    } on DioError catch (e) {
      if (e.type == DioErrorType.connectTimeout) {
        //return e.message;
        dataFinal = {
          "status": 500,
          "message": "Connection Timeout please restart the process",
        };
        print("Connection Timeout please restart the process");
        return dataFinal;
      }
      if (e.type == DioErrorType.receiveTimeout) {
        dataFinal = {
          "status": 500,
          "message": "Server ERROR : RECEIVE TIMEOUT Contact the administrator",
        };
        print("Server ERROR : RECEIVE TIMEOUT Contact the administrator");
        return dataFinal;
      }
      if (e.type == DioErrorType.other) {
        dataFinal = {
          "status": 500,
          "message":
              "Server ERROR : Could not send request, Contact the administrator",
        };
        print(e.message);
        print(
            "Server ERROR : Could not send request, Contact the administrator");
        return dataFinal;
      } else {
        dataFinal = {
          "status": 500,
          "message":
              "Server ERROR : Could not send request, Contact the administrator",
        };
        print(e.message);
        print(
            "Server ERROR : Could not send request, Contact the administrator1");
        return dataFinal;
      }
    } catch (e) {
      print(e);
      dataFinal = {
        "status": 500,
        "message": "Une erreur est survenue",
      };
      print("Une erreur est survenue");
      return dataFinal;
    }
  }

  Future addParams({
    required int id,
    required double taille,
    required double poids,
    required double temperature,
    required double frequenceCardiaque,
    required double pouls,
    required double frequenceRespiratoire,
    required double saturationOxygene,
    required double perimetreBranchial,
  }) async {
    Map dataFinal = Map();
    try {
      var body = {
        "id": id,
        "taille": taille,
        "poids": poids,
        "temperature": temperature,
        "frequenceCardiaque": frequenceCardiaque,
        "pouls": pouls,
        "frequenceRespiratoire": frequenceRespiratoire,
        "saturationOxygene": saturationOxygene,
        "perimetreBranchial": perimetreBranchial,
      };
      print(body);
      Response _response =
          await _http.postLogin('/patient/$id/parameter', body: {
        "taille": taille,
        "poids": poids,
        "temperature": temperature,
        "frequenceCardiaque": frequenceCardiaque,
        "pouls": pouls,
        "frequenceRespiratoire": frequenceRespiratoire,
        "saturationOxygene": saturationOxygene,
        "perimetreBranchial": perimetreBranchial,
      });
      if (_response.statusCode == 201) {
        Map _data = _response.data;
        //print(_data);
        if (_response.statusCode == 201) {
          dataFinal = {
            "status": _response.statusCode,
            "message": "Your product was update successfully",
            "data": _data
          };
          //print("connexion reussi");
          return dataFinal;
        } else {
          dataFinal = {
            "status": _response.statusCode,
            "message": "Une erreur est survenue",
          };
          //print("connexion ECHEC");
          return dataFinal;
        }
      } else {
        dataFinal = {
          "status": 500,
          "message": "Une erreur est survenue",
        };
        print("connexion erreur est survenue");
        return dataFinal;
      }
    } on DioError catch (e) {
      if (e.type == DioErrorType.connectTimeout) {
        //return e.message;
        dataFinal = {
          "status": 500,
          "message": "Connection Timeout please restart the process",
        };
        print("Connection Timeout please restart the process");
        return dataFinal;
      }
      if (e.type == DioErrorType.receiveTimeout) {
        dataFinal = {
          "status": 500,
          "message": "Server ERROR : RECEIVE TIMEOUT Contact the administrator",
        };
        print("Server ERROR : RECEIVE TIMEOUT Contact the administrator");
        return dataFinal;
      }
      if (e.type == DioErrorType.other) {
        dataFinal = {
          "status": 500,
          "message":
              "Server ERROR : Could not send request, Contact the administrator",
        };
        print(e.message);
        print(
            "Server ERROR : Could not send request, Contact the administrator");
        return dataFinal;
      } else {
        dataFinal = {
          "status": 500,
          "message":
              "Server ERROR : Could not send request, Contact the administrator",
        };
        print(e.message);
        print(
            "Server ERROR : Could not send request, Contact the administrator1");
        return dataFinal;
      }
    } catch (e) {
      print(e);
      dataFinal = {
        "status": 500,
        "message": "Une erreur est survenue",
      };
      print("Une erreur est survenue");
      return dataFinal;
    }
  }

  Future forgetPassword({required String id}) async {
    Map dataFinal = Map();
    try {
      Response _response = await _http.post('/auth/reset-password', body: {
        "login": "+237" + id,
      });
      if (_response.statusCode == 200) {
        Map _data = _response.data;
        //print(_data);
        if (_response.statusCode == 200) {
          dataFinal = {
            "status": _response.statusCode,
            "message": "Your product was update successfully",
            "data": _data
          };
          //print("connexion reussi");
          return dataFinal;
        } else {
          dataFinal = {
            "status": _response.statusCode,
            "message": "Une erreur est survenue",
          };
          //print("connexion ECHEC");
          return dataFinal;
        }
      } else {
        dataFinal = {
          "status": 500,
          "message": "Une erreur est survenue",
        };
        print("connexion erreur est survenue");
        return dataFinal;
      }
    } on DioError catch (e) {
      if (e.type == DioErrorType.connectTimeout) {
        //return e.message;
        dataFinal = {
          "status": 500,
          "message": "Connection Timeout please restart the process",
        };
        print("Connection Timeout please restart the process");
        return dataFinal;
      }
      if (e.type == DioErrorType.receiveTimeout) {
        dataFinal = {
          "status": 500,
          "message": "Server ERROR : RECEIVE TIMEOUT Contact the administrator",
        };
        print("Server ERROR : RECEIVE TIMEOUT Contact the administrator");
        return dataFinal;
      }
      if (e.type == DioErrorType.other) {
        dataFinal = {
          "status": 500,
          "message":
              "Server ERROR : Could not send request, Contact the administrator",
        };
        print(e.message);
        print(
            "Server ERROR : Could not send request, Contact the administrator");
        return dataFinal;
      } else {
        dataFinal = {
          "status": 500,
          "message":
              "Server ERROR : Could not send request, Contact the administrator",
        };
        print(e.message);
        print(
            "Server ERROR : Could not send request, Contact the administrator1");
        return dataFinal;
      }
    } catch (e) {
      print(e);
      dataFinal = {
        "status": 500,
        "message": "Une erreur est survenue",
      };
      print("Une erreur est survenue");
      return dataFinal;
    }
  }

  Future validate({
    required String id,
    required String password,
    required String code,
  }) async {
    Map dataFinal = Map();
    try {
      Response _response = await _http.post('/auth/confirm-code-phone', body: {
        "tel": "+237" + id,
        "password": password,
        "code": code,
      });
      if (_response.statusCode == 200) {
        Map _data = _response.data;
        //print(_data);
        if (_response.statusCode == 200) {
          dataFinal = {
            "status": _response.statusCode,
            "message": "Your product was update successfully",
            "data": _data
          };
          //print("connexion reussi");
          return dataFinal;
        } else {
          dataFinal = {
            "status": _response.statusCode,
            "message": "Une erreur est survenue",
          };
          //print("connexion ECHEC");
          return dataFinal;
        }
      } else {
        dataFinal = {
          "status": 500,
          "message": "Une erreur est survenue",
        };
        print("connexion erreur est survenue");
        return dataFinal;
      }
    } on DioError catch (e) {
      if (e.type == DioErrorType.connectTimeout) {
        //return e.message;
        dataFinal = {
          "status": 500,
          "message": "Connection Timeout please restart the process",
        };
        print("Connection Timeout please restart the process");
        return dataFinal;
      }
      if (e.type == DioErrorType.receiveTimeout) {
        dataFinal = {
          "status": 500,
          "message": "Server ERROR : RECEIVE TIMEOUT Contact the administrator",
        };
        print("Server ERROR : RECEIVE TIMEOUT Contact the administrator");
        return dataFinal;
      }
      if (e.type == DioErrorType.other) {
        dataFinal = {
          "status": 500,
          "message":
              "Server ERROR : Could not send request, Contact the administrator",
        };
        print(e.message);
        print(
            "Server ERROR : Could not send request, Contact the administrator");
        return dataFinal;
      } else {
        dataFinal = {
          "status": 500,
          "message":
              "Server ERROR : Could not send request, Contact the administrator",
        };
        print(e.message);
        print(
            "Server ERROR : Could not send request, Contact the administrator1");
        return dataFinal;
      }
    } catch (e) {
      print(e);
      dataFinal = {
        "status": 500,
        "message": "Une erreur est survenue",
      };
      print("Une erreur est survenue");
      return dataFinal;
    }
  }

  Future sosDoctor(String sos, String nom) async {
    Map dataFinal;
    String request = 'https://smsvas.com/bulk/public/index.php/api/v1/sendsms';
    String message =
        nom + " a lancé un SOS DOCTOR et voici son message : " + sos;
    try {
      Response response = await dio.post(request,
          data: json.encode({
            "user": "aldrinbambock@gmail.com",
            "password": "NEXA1235",
            "senderid": "SOS SESA",
            "sms": message,
            "mobiles": "237675975698, 237697059705, 237654453889"
          }));
      if (response.statusCode == 200) {
        //Map _data = response;
        //print(_data);
        if (response.statusCode == 200) {
          dataFinal = {
            "status": 200,
            "message": "Get Data sucessfully",
          };
          //print("connexion reussi");
          return dataFinal;
        }
      } else {
        dataFinal = {
          "status": response.statusCode,
          "message": "Une erreur est survenue",
        };
        print("connexion erreur est survenue");
        return dataFinal;
      }
    } on DioError catch (e) {
      if (e.type == DioErrorType.connectTimeout) {
        //return e.message;
        dataFinal = {
          "status": 500,
          "message": "Connection Timeout please restart the process",
        };
        print("Connection Timeout please restart the process");
        return dataFinal;
      }
      if (e.type == DioErrorType.receiveTimeout) {
        dataFinal = {
          "status": 500,
          "message": "Server ERROR : RECEIVE TIMEOUT Contact the administrator",
        };
        print("Server ERROR : RECEIVE TIMEOUT Contact the administrator");
        return dataFinal;
      }
      if (e.type == DioErrorType.other) {
        dataFinal = {
          "status": 500,
          "message":
              "Server ERROR : Could not send request, Contact the administrator",
        };
        print(
            "Server ERROR : Could not send request, Contact the administrator");
        return dataFinal;
      } else {
        dataFinal = {
          "status": 500,
          "message":
              "Server ERROR : Could not send request, Contact the administrator",
        };
        print(
            "Server ERROR : Could not send request, Contact the administrator");
        return dataFinal;
      }
    } catch (e) {
      print(e);
      dataFinal = {
        "status": 500,
        "message": "Une erreur est survenue",
      };
      print("Une erreur est survenue");
      return dataFinal;
    }
  }
}
