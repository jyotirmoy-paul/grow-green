part of '../database_service_factory.dart';

class _FirebaseCloudDbService implements CloudDbService {
  static const tag = '_FirebaseCloudDbService';

  late CollectionReference collectionReference;

  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;

  @override
  Future<ServiceAction> initialize({
    required String path,
  }) async {
    collectionReference = _firebaseFirestore.collection(path);
    return ServiceAction.success;
  }

  @override
  Future<(ServiceAction, Map<String, dynamic>)> get({required String id}) async {
    try {
      final documentReference = collectionReference.doc(id);
      final documentSnapshot = await documentReference.get();
      final documentData = documentSnapshot.data();
      if (documentSnapshot.exists && documentData != null) {
        return (ServiceAction.success, Map<String, dynamic>.from(documentData as Map));
      } else {
        throw Exception('No document available at ${documentReference.path}!');
      }
    } catch (e) {
      Log.e('$tag: get(id: $id) threw exception: $e');
    }

    return (ServiceAction.failure, const <String, dynamic>{});
  }

  @override
  Future<ServiceAction> delete({required String id}) async {
    try {
      final documentReference = collectionReference.doc(id);
      await documentReference.delete();
      return ServiceAction.success;
    } catch (e) {
      Log.e('$tag: remove(id: $id) threw exception: $e');
    }

    return ServiceAction.failure;
  }

  @override
  Future<ServiceAction> set({
    required String id,
    required Map<String, dynamic> data,
  }) async {
    try {
      final documentReference = collectionReference.doc(id);
      await documentReference.set(data);
      return ServiceAction.success;
    } catch (e) {
      Log.e('$tag: set(id: $id, data: $data) threw exception: $e');
    }

    return ServiceAction.failure;
  }

  @override
  DbBatch createBatch() {
    return _FirebaseDbWriteBatch(
      writeBatch: _firebaseFirestore.batch(),
      collectionReference: collectionReference,
    );
  }

  @override
  Future<ServiceAction> connect() async {
    try {
      /// enable the network in firebase instance to connect to the server
      await _firebaseFirestore.enableNetwork();

      return ServiceAction.success;
    } on FirebaseException catch (e) {
      Log.e('$tag: connect() threw FirebaseException: $e');
    } catch (e) {
      Log.e('$tag: connect() threw Exception: $e');
    }

    return ServiceAction.failure;
  }

  @override
  Future<ServiceAction> disconnect() async {
    try {
      /// enable the network in firebase instance to connect to the server
      await _firebaseFirestore.disableNetwork();

      return ServiceAction.success;
    } on FirebaseException catch (e) {
      Log.e('$tag: disconnect() threw FirebaseException: $e');
    } catch (e) {
      Log.e('$tag: disconnect() threw Exception: $e');
    }

    return ServiceAction.failure;
  }
}
