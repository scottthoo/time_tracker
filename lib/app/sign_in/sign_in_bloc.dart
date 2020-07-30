import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:timetracker/services/auth.dart';

class SignInBloc {
  final AuthBase auth;
  final StreamController<bool> _isLoadingController = StreamController<bool>();
  SignInBloc({@required this.auth});
  Stream<bool> get isLoadingStream => _isLoadingController.stream;

  void dispose() {
    _isLoadingController.close();
  }

  void setIsLoading(bool isLoading) => _isLoadingController.add(isLoading);

  Future<User> _signIn(Future<User> Function() signInMethod) async {
    try {
      setIsLoading(true);
      return await signInMethod();
    } catch (e) {
      setIsLoading(false);
      rethrow;
    }
  }

  Future<User> signInAnonymously() async => _signIn(auth.signInAnonymously);
  Future<User> signInWithGoogle() async => _signIn(auth.signInWithGoogle);
  Future<User> signInWithApple() async => _signIn(auth.signInWithApple);
}
