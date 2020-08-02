import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:timetracker/services/auth.dart';

class SignInManager {
  SignInManager({@required this.auth, @required this.isLoading});
  final AuthBase auth;
  final ValueNotifier<bool> isLoading;

//  final StreamController<bool> _isLoadingController = StreamController<bool>();
//  Stream<bool> get isLoadingStream => _isLoadingController.stream;
//  void dispose() {
//    _isLoadingController.close();
//  }
//  void setIsLoading(bool isLoading) => _isLoadingController.add(isLoading);

  Future<User> _signIn(Future<User> Function() signInMethod) async {
    try {
      isLoading.value = true;
      return await signInMethod();
    } catch (e) {
      isLoading.value = false;
      rethrow;
    }
  }

  Future<User> signInAnonymously() async => _signIn(auth.signInAnonymously);
  Future<User> signInWithGoogle() async => _signIn(auth.signInWithGoogle);
  Future<User> signInWithApple() async => _signIn(auth.signInWithApple);
}
