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

  Future<void> createJob(Job job) async {
    final path = APIPath.job(uid, 'job_abc');
    final documentReference = Firestore.instance.document(path);
    await documentReference.setData(job.toMap());
  }
}
