import 'package:flutter/foundation.dart';

abstract class Database {}

class FireStoreDatabase implements Database {
  final String uid;

  FireStoreDatabase({@required this.uid}) : assert(uid != null);
}
