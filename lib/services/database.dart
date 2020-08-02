import 'package:flutter/foundation.dart';
import 'package:timetracker/app/home/models/job.dart';
import 'package:timetracker/services/api_path.dart';
import 'package:timetracker/services/firestore_service.dart';

abstract class Database {
  Future<void> createJob(Job job);
  Stream<List<Job>> jobsStream();
}

class FireStoreDatabase implements Database {
  FireStoreDatabase({@required this.uid}) : assert(uid != null);

  final String uid;

  final _service = FirestoreService.instance;

  Future<void> createJob(Job job) async => await _service.setData(
      path: APIPath.job(uid, 'job_abc'), data: job.toMap());

  Stream<List<Job>> jobsStream() => _service.collectionStream(
      path: APIPath.jobs(uid), builder: (data) => Job.fromMap(data));
}
