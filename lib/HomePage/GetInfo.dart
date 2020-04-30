import 'dart:io';

abstract class GetInfo{

  Future<void> checkInternetStatus();
  void getUserInfo();

}




class UserDetails extends GetInfo{

  String name,constituency;
  int phone;

  @override
  Future<void> checkInternetStatus() async {
    final result = await InternetAddress.lookup('google.com');
    if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
      return "Active";

    }else{
      return "InActive";
    }

  }

  //TODO -- > ASHWITHA
  @override
  void getUserInfo() {

    //get user info from firebase here and use in home page


  }
}