import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:timetracker/app/home/models/job.dart';
import 'package:timetracker/common_widgets/platform_alert_dialog.dart';
import 'package:timetracker/common_widgets/platform_exception_alert_dialog.dart';
import 'package:timetracker/services/database.dart';
import 'package:flutter/services.dart';

class EditJobPage extends StatefulWidget {
  const EditJobPage({Key key, @required this.database, this.job})
      : super(key: key);
  final Database database;
  final Job job;

  static Future<void> show(BuildContext context,
      {Database database, Job job}) async {
    await Navigator.of(context, rootNavigator: true).push(MaterialPageRoute(
      builder: (context) => EditJobPage(
        database: database,
        job: job,
      ),
      fullscreenDialog: true,
    ));
  }

  @override
  _EditJobPageState createState() => _EditJobPageState();
}

class _EditJobPageState extends State<EditJobPage> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _ratePerHourController = TextEditingController();
  final FocusNode _nameFocusNode = FocusNode();
  final FocusNode _ratePerHourFocusNode = FocusNode();

  String _name;
  int _ratePerHour;

  @override
  void initState() {
    super.initState();
    if (widget.job != null) {
      _name = widget.job.name;
      _ratePerHour = widget.job.ratePerHour;
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _ratePerHourController.dispose();
    _nameFocusNode.dispose();
    _ratePerHourFocusNode.dispose();
    super.dispose();
  }

  bool _validateAndSaveForm() {
    final form = _formKey.currentState;
    if (form.validate()) {
      form.save();
      return true;
    } else
      return false;
  }

  Future<void> _submit() async {
    if (_validateAndSaveForm()) {
      try {
        final jobs = await widget.database.jobsStream().first;
        final allNames = jobs.map((job) => job.name).toList();
        if (widget.job != null) {
          allNames.remove(widget.job.name);
        }
        if (allNames.contains(_name)) {
          PlatformAlertDialog(
            title: 'Name Already used',
            content: 'Please choose a different job name',
            defaultActionText: 'OK',
          ).show(context);
        } else {
          final id = widget.job?.id ?? documentIdFromCurrentDate();
          final job = Job(id: id, name: _name, ratePerHour: _ratePerHour);
          await widget.database.setJob(job);
          Navigator.of(context).pop();
        }
      } on PlatformException catch (e) {
        PlatformExceptionAlertDialog(
          title: 'Operation failed',
          exception: e,
        ).show(context);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.job == null ? 'New Job' : 'Edit Job'),
        elevation: 2.0,
        actions: <Widget>[
          FlatButton(
            child: Text(
              'Save',
              style: TextStyle(
                fontSize: 18,
                color: Colors.white,
              ),
            ),
            onPressed: _submit,
          )
        ],
      ),
      body: _buildContents(),
      backgroundColor: Colors.grey[200],
    );
  }

  Widget _buildContents() {
    return SingleChildScrollView(
        child: Padding(
      padding: const EdgeInsets.all(16.0),
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: _buildForm(),
        ),
      ),
    ));
  }

  Widget _buildForm() {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: _buildFormChildren(),
      ),
    );
  }

  List<Widget> _buildFormChildren() {
    return [
      TextFormField(
//        controller: _nameController,
        focusNode: _nameFocusNode,
        decoration: InputDecoration(labelText: 'Job name'),
        initialValue: _name,
        onSaved: (value) => _name = value,
        validator: (value) => value.isNotEmpty ? null : 'Name can\'t be empty.',
        onEditingComplete: () =>
            FocusScope.of(context).requestFocus(_ratePerHourFocusNode),
      ),
      TextFormField(
//        controller: _ratePerHourController,
        focusNode: _ratePerHourFocusNode,
        decoration: InputDecoration(labelText: 'Rate per hour'),
        initialValue: _ratePerHour != null ? '$_ratePerHour' : null,
        keyboardType: TextInputType.numberWithOptions(
          signed: false,
          decimal: true,
        ),
        onSaved: (value) => _ratePerHour = int.tryParse(value) ?? 0,
        onEditingComplete: () {},
      )
    ];
  }
}
