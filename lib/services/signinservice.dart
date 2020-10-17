import 'package:kaladasava/models/loggedinuser.dart';
import 'package:kaladasava/services/authservice.dart';
import 'package:kaladasava/static/staticadd.dart';

class SignInService{
final AuthService _auth = AuthService();

Future<LoggedinUser>signmein(signInMethod m,{String email,String password}) async {
LoggedinUser _liu; 

switch(m){
  case(signInMethod.Google): _liu = await _auth.signInWithGoogle();break;
  case(signInMethod.Facebook): _liu = await _auth.signInWithFB();break;
  default: _liu = await  _auth.signInWithEmailAndPassword(email,password);break;
}

return _liu;
}


}