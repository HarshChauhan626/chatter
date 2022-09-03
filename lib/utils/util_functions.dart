import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';


class UtilFunctions{
  String getRoomId(String senderId,String recieverId){
    return senderId+'-'+recieverId;
  }


  String parseTimeStamp(int? value) {
    try{
      if(value!=null){
        var date = DateTime.fromMillisecondsSinceEpoch(value! * 1000);
        var d12 = DateFormat('hh:mm a').format(date);
        return d12;
      }
      return "";
    }
        catch(e,s){
      debugPrint("Exception coming in parseTimeStamp is ${e.toString()} ${s.toString()}");
      return "";
        }
  }


}
