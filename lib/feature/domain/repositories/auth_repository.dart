import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:rxdart/rxdart.dart';

class AuthRepository {
  final FirebaseAuth _auth;

  const AuthRepository(this._auth);


  Stream<User?> get authStateChanges => _auth.idTokenChanges();
  Stream<User?> get userChanges => _auth.userChanges();
  Stream<User?> get userListener => BehaviorSubject<User?>().stream;

  bool get emailVerified => _auth.currentUser!.emailVerified;

  Future<void> reload() async => _auth.currentUser!.reload();


  Future<User?> createUserWithEmailAndPassword(
    String email,
    String password,
  ) async {
    try {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
    } on FirebaseAuthException catch (e) {
      if (kDebugMode) {
        print(e.code);
      }
      if (e.code == 'email-already-in-use') {
        throw AuthException(
            'Такой Email уже используется, повторите попытку с использованием другого Email');
      } else {
        throw AuthException(
            'Неизвестная ошибка! Попробуйте еще раз или обратитесь в поддержку.');
      }
    }
  }

  Future<void> sendEmailVerification() async {
    try {
      await FirebaseAuth.instance.currentUser!.sendEmailVerification;
    } on FirebaseAuthException catch (e) {
      if (kDebugMode) {
        print(e.code);
      }
        throw AuthException(
            'Неизвестная ошибка! Попробуйте еще раз или обратитесь в поддержку.');
    }
  }

  Future<User?> signInWithEmailAndPassword(
    String email,
    String password,
  ) async {
    try {
      final result = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      return result.user;
    } on FirebaseAuthException catch (e) {
      if (kDebugMode) {
        print(e.code);
      }

      if (e.code == 'user-not-found' ||
          e.code == 'wrong-password' ||
          e.code == 'invalid-credential') {
        throw AuthException('Неправильный email или пароль. Повторите попытку');
      } else {
        throw AuthException(
            'Неизвестная ошибка! Попробуйте еще раз или обратитесь в поддержку.');
      }
      //throw e;
    }
  }

  Future<void> signOut() async {
    await _auth.signOut();
  }
}

class AuthException implements Exception {
  final String message;

  AuthException(this.message);

  @override
  String toString() {
    return message;
  }
}
