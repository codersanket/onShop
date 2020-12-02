import 'package:firebase_auth/firebase_auth.dart';

class authServices{
	FirebaseAuth _firebaseAuth=FirebaseAuth.instance;

	verifyNumber({String phoneNumber})async{
		await  _firebaseAuth.verifyPhoneNumber(phoneNumber: phoneNumber,
				verificationCompleted: (PhoneAuthCredential _credational)async{
				return await _firebaseAuth.signInWithCredential(_credational);

				},
				verificationFailed:(FirebaseAuthException e){
					throw e;
				},
				codeSent: (String verificationId,int resendToken){

				},
				codeAutoRetrievalTimeout:(string){});
	}
}