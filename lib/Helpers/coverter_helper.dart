import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

mixin ConverterHelper {
  Future<String?> converFileToString(File? file)async{
    if(file == null) return null ;

    Uint8List x = await file.readAsBytes() ;

    return  base64Encode(x) ;
  }
}
// Future<String?> convert (File file)async{
//   if(file == null) return null ;
//   var x = await file.readAsBytes(); ///حمن فايل الى بايت
//   var z = base64Encode(x) ;/// من بايت الى كود
//   return z ;
// }