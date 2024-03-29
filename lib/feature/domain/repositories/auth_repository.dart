import 'dart:async';
import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthRepository {
  final FirebaseAuth _auth;

  AuthRepository(this._auth);

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

  Future<void> sendEmail() async {
    try {
      await _auth.currentUser!.sendEmailVerification();
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
  }

  Future<void> streamCheck({required VoidCallback onDone}) async {
    final stream =
        Stream.periodic(const Duration(seconds: 2), (t) => t).listen((_) async {
      await reload();
      if (_auth.currentUser!.emailVerified) {
        onDone();
      }
    });
  }

  String _phone = '';

  String get phone => _phone;

  set phone(String phone) {
    _phone = phone;
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
