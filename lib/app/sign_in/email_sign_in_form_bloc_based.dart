import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:timetracker/app/sign_in/email_sign_in_bloc.dart';
import 'package:timetracker/app/sign_in/valitators.dart';
import 'package:timetracker/common_widgets/form_submit_button.dart';
import 'package:timetracker/common_widgets/platform_alert_dialog.dart';
import 'package:timetracker/common_widgets/platform_exception_alert_dialog.dart';
import 'package:timetracker/services/auth.dart';

import 'email_sign_in_model.dart';

class EmailSignInFormBlocBased extends StatefulWidget
    with EmailAndPasswordValidators {
  EmailSignInFormBlocBased({@required this.bloc});
  final EmailSignInBloc bloc;

  static Widget create(BuildContext context) {
    final AuthBase auth = Provider.of<AuthBase>(context);
    return Provider<EmailSignInBloc>(
      create: (context) => EmailSignInBloc(auth: auth),
      child: Consumer<EmailSignInBloc>(
        builder: (context, bloc, _) => EmailSignInFormBlocBased(
          bloc: bloc,
        ),
      ),
      dispose: (context, bloc) => bloc.dispose(),
    );
  }

  @override
  _EmailSignInFormStatefulState createState() =>
      _EmailSignInFormStatefulState();
}

class _EmailSignInFormStatefulState extends State<EmailSignInFormBlocBased> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final FocusNode _emailFocusNode = FocusNode();
  final FocusNode _passwordFocusNode = FocusNode();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _emailFocusNode.dispose();
    _passwordFocusNode.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    try {
      await widget.bloc.submit();
      Navigator.of(context).pop();
    } on PlatformException catch (e) {
      PlatformExceptionAlertDialog(
        title: 'Sign in failed',
        exception: e,
      ).show(context);
    }
  }

  void _emailEditingComplete(EmailSignInModel model) {
    final newFocus = widget.emailValidator.isValid(model.email)
        ? _passwordFocusNode
        : _emailFocusNode;
    FocusScope.of(context).requestFocus(newFocus);
  }

  void _toggleFormType() {
    widget.bloc.toggleFormType();
    _emailController.clear();
    _passwordController.clear();
  }

  List<Widget> _buildChildren(EmailSignInModel model) {
    final primaryText = model.formType == EmailSignInFormType.signIn
        ? 'Sign in'
        : 'Create an account';
    final secondaryText = model.formType == EmailSignInFormType.signIn
        ? 'Need an account? Register'
        : 'Have an account? Sign in';

    bool submitEnabled = widget.emailValidator.isValid(model.email) &&
        widget.passwordValidator.isValid(model.password) &&
        !model.isLoading;

    return [
      _buildEmailTextField(model),
      SizedBox(height: 8),
      buildPasswordTextField(model),
      SizedBox(height: 8),
      FormSubmitButton(
        text: primaryText,
        onPressed: submitEnabled ? _submit : null,
      ),
      SizedBox(height: 8),
      FlatButton(
        child: Text(secondaryText),
        onPressed: !model.isLoading ? () => _toggleFormType() : null,
      ),
    ];
  }

  TextField buildPasswordTextField(EmailSignInModel model) {
    bool showErrorText =
        model.submitted && !widget.emailValidator.isValid(model.password);

    return TextField(
      controller: _passwordController,
      focusNode: _passwordFocusNode,
      decoration: InputDecoration(
        labelText: 'Password',
        errorText: showErrorText ? widget.invalidPasswordErrorText : null,
        enabled: model.isLoading == false,
      ),
      obscureText: true,
      textInputAction: TextInputAction.go,
      onChanged: widget.bloc.updatePassword,
      onEditingComplete: _submit,
    );
  }

  TextField _buildEmailTextField(EmailSignInModel model) {
    bool showErrorText =
        model.submitted && !widget.emailValidator.isValid(model.email);
    return TextField(
      controller: _emailController,
      focusNode: _emailFocusNode,
      decoration: InputDecoration(
        labelText: 'Email',
        hintText: 'your@email.com',
        errorText: showErrorText ? widget.invalidEmailErrorText : null,
        enabled: model.isLoading == false,
      ),
      autocorrect: false,
      keyboardType: TextInputType.emailAddress,
      textInputAction: TextInputAction.next,
      onChanged: widget.bloc.updateEmail,
      onEditingComplete: () => _emailEditingComplete(model),
    );
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<EmailSignInModel>(
        stream: widget.bloc.modelStream,
        initialData: EmailSignInModel(),
        builder: (context, snapshot) {
          final EmailSignInModel model = snapshot.data;
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisSize: MainAxisSize.min,
              children: _buildChildren(model),
            ),
          );
        });
  }
}