import 'dart:async';

import 'package:timetracker/app/sign_in/email_sign_in_model.dart';

class EmailSignInBloc {
  // StreamController
  final StreamController<EmailSignInModel> _modelController =
      StreamController<EmailSignInModel>();

  // Stream
  Stream<EmailSignInModel> get modelStream => _modelController.stream;
  EmailSignInModel _model = EmailSignInModel();

  // Dispose
  void dispose() {
    _modelController.close();
  }

  void doSomething() {
    _modelController.add(null);
  }

  void updateWith({
    String email,
    String password,
    EmailSignInFormType formType,
    bool isLoading,
    bool submitted,
  }) {
    // update model
    // add update model to stream controller _modelController
    _model = _model.copyWith(
      email: email,
      password: password,
      formType: formType,
      isLoading: isLoading,
      submitted: submitted,
    );

    _modelController.add(_model);
  }
}
