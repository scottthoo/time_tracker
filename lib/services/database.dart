import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:timetracker/app/home/models/job.dart';
import 'package:timetracker/services/api_path.dart';

abstract class Database {
  Future<void> createJob(Job job);
}

class FireStoreDatabase implements Database {
  FireStoreDatabase({@required this.uid}) : assert(uid != null);

  final String uid;

  Future<void> createJob(Job job) async =>
      await _setData(path: APIPath.job(uid, 'job_abc'), data: job.toMap());

  Future<void> _setData({String path, Map<String, dynamic> data}) async {
    final reference = Firestore.instance.document(path);
    print('$path:$data');
    await reference.setData(data);
  }
}
