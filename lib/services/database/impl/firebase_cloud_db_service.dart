part of '../database_service_factory.dart';

class _FirebaseCloudDbService implements CloudDbService {
  static const tag = '_FirebaseCloudDbService';

  late CollectionReference collectionReference;
  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;
  final _documents = <QueryDocumentSnapshot>[];

  @override
  Future<ServiceAction> initialize({
    required String path,
  }) async {
    collectionReference = _firebaseFirestore.collection(path);
    return ServiceAction.success;
  }

  @override
  Future<(ServiceAction, Map<String, dynamic>)> get({required String id}) async {
    /// populate the `_documents` list first
    if (_documents.isEmpty) {
      try {
        final querySnapshot = await collectionReference.get(const GetOptions(source: Source.server));
        _documents.clear();
        _documents.addAll(querySnapshot.docs);
      } catch (e) {
        Log.e('$tag: get(id: $id) threw exception while querying reference: $e');
      }
    }

    if (_documents.isEmpty) {
      Log.i('$tag: _documents list is empty, falling back to manual fetch');
    } else {
      Log.i('$tag: _documents list is available, doing a smart fetch');
      for (final doc in _documents) {
        final docData = doc.data();
        if (doc.id == id && docData != null) {
          /// if we find the id we need in the documents list, return it
          return (ServiceAction.success, Map<String, dynamic>.from(docData as Map));
        }
      }
    }

    Log.i('$tag: could not locate doc with id $id in the _documents list, falling back to manual fetch');

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
  Future<ServiceAction> update({
    required String id,
    required Map<String, dynamic> data,
  }) async {
    try {
      final documentReference = collectionReference.doc(id);
      await documentReference.update(data);
      return ServiceAction.success;
    } catch (e) {
      Log.e('$tag: update(id: $id, data: $data) threw exception: $e');
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

  @override
  Future<(ServiceAction, List<Map<String, dynamic>>)> getList({required String id, required String listId}) async {
    try {
      final querySnapshot = await collectionReference.doc(id).collection(listId).get(
            const GetOptions(source: Source.server),
          );

      final data = querySnapshot.docs.map<Map<String, dynamic>>((doc) => doc.data()).toList();

      return (ServiceAction.success, data);
    } catch (e) {
      Log.e('$tag: getList(id: $id, listId: $listId) threw exception: $e');
      return (ServiceAction.failure, const <Map<String, dynamic>>[]);
    }
  }

  @override
  Future<ServiceAction> addToList({
    required String id,
    required String listId,
    required Map<String, dynamic> data,
  }) async {
    try {
      final collectionRef = collectionReference.doc(id).collection(listId);
      await collectionRef.add(data);

      return ServiceAction.success;
    } catch (e) {
      Log.e('$tag: addToList(id: $id, listId: $listId) threw exception: $e');
      return ServiceAction.failure;
    }
  }
}
