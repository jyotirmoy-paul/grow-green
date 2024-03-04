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
  ServiceAction update({
    required String id,
    required Map<String, dynamic> data,
  }) {
    try {
      writeBatch.update(
        collectionReference.doc(id),
        data,
      );
      return ServiceAction.success;
    } catch (e) {
      Log.d('$tag: update(id: $id) thew exception: $e');
    }

    return ServiceAction.failure;
  }

  @override
  ServiceAction setAtList(
    String itemId, {
    required String id,
    required String listId,
    required Map<String, dynamic> data,
  }) {
    try {
      writeBatch.set(
        collectionReference.doc(id).collection(listId).doc(itemId),
        data,
      );

      return ServiceAction.success;
    } catch (e) {
      Log.d('$tag: setAtList(itemId: $itemId, id: $id, listId: $listId) thew exception: $e');
    }

    return ServiceAction.failure;
  }

  @override
  ServiceAction updateAtList(
    String itemId, {
    required String id,
    required String listId,
    required Map<String, dynamic> data,
  }) {
    try {
      writeBatch.update(
        collectionReference.doc(id).collection(listId).doc(itemId),
        data,
      );

      return ServiceAction.success;
    } catch (e) {
      Log.d('$tag: updateAtList(itemId: $itemId, id: $id, listId: $listId) thew exception: $e');
    }

    return ServiceAction.failure;
  }
}
