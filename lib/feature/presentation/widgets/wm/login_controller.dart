import 'dart:async';

import 'package:babyfood/feature/presentation/providers/auth_provider.dart';
import 'package:babyfood/feature/presentation/widgets/wm/login_state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class LoginController extends StateNotifier<LoginState>{
  final Ref ref;
  LoginController(this.ref): super(const LoginStateInitial());

  void login(String email, String password)async{
    state= const LoginStateLoading();

    try{
      await ref.read(authRepositoryProvider).signInWithEmailAndPassword(email, password);
      state=const LoginStateSuccess();

    }catch (e){
      state=LoginStateError(e.toString());
    }

  }
  Future<void> signUp(String email, String password)async{
    state= const LoginStateLoading();

    try{
      await ref.read(authRepositoryProvider).createUserWithEmailAndPassword(email, password);
      state=const SignUpStateSuccess();

    }catch (e){
      state=LoginStateError(e.toString());
    }


  }


}

final loginControllerProvider= StateNotifierProvider<LoginController, LoginState>((ref) =>
LoginController(ref));

