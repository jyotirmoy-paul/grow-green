part of '../database_service_factory.dart';

class _FirebaseDbWriteBatch implements DbBatch {
  static const tag = '_FirebaseDbBatchWrite';

  final WriteBatch writeBatch;
  final CollectionReference collectionReference;

  const _FirebaseDbWriteBatch({
    required this.writeBatch,
    required this.collectionReference,
  });

  @override
  Future<ServiceAction> commit() async {
    try {
      await writeBatch.commit();
      return ServiceAction.success;
    } catch (e) {
      Log.d('$tag: commit() thew exception: $e');
    }

    return ServiceAction.failure;
  }

  @override
  ServiceAction delete({required String id}) {
    try {
      writeBatch.delete(collectionReference.doc(id));
      return ServiceAction.success;
    } catch (e) {
      Log.d('$tag: delete(id: $id) thew exception: $e');
    }

    return ServiceAction.failure;
  }

  @override
  ServiceAction write({
    required String id,
    required Map<String, dynamic> data,
  }) {
    try {
      writeBatch.set(
        collectionReference.doc(id),
        data,
        SetOptions(merge: false),
      );
      return ServiceAction.success;
    } catch (e) {
      Log.d('$tag: delete(id: $id) thew exception: $e');
    }

    return ServiceAction.failure;
  }
}
