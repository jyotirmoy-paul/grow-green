import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../../../../../services/log/log.dart';
import '../../../../../grow_green_game.dart';
import '../../../../../services/game_services/monetary/enums/transaction_type.dart';
import '../../../../../services/game_services/monetary/models/money_model.dart';
import '../achievement/models/offer.dart';

typedef Doc = DocumentSnapshot<Map<String, dynamic>>;

class RedeemService {
  static const String redeemCollection = 'redeemCodes';
  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;
  final GrowGreenGame game;

  RedeemService({required this.game});
  // Generate random 6 charater alphanumeric code

  Future<Doc> _getRedeemCodeDoc(String code) async {
    final collectionRef = _firebaseFirestore.collection(redeemCollection);
    return collectionRef.doc(code).get();
  }

  // Redeem code
  Future<bool> _checkIfCodePresent(String code) async {
    /// FIXME: We don't have to fetch docs everytime!
    final codeDocument = await _getRedeemCodeDoc(code);
    return codeDocument.exists;
  }

  Future<void> _deleteRedeemCode(String code) async {
    final collectionRef = _firebaseFirestore.collection(redeemCollection);
    await collectionRef.doc(code).delete();
  }

  Future<RedeemCodeResponse> redeemCode(String code) async {
    try {
      final isPresent = await _checkIfCodePresent(code);
      if (!isPresent) {
        return RedeemCodeResponse.codeNotFound;
      }
      final doc = await _getRedeemCodeDoc(code);

      await _addMoney(code, doc);
      await _deleteRedeemCode(code);

      return RedeemCodeResponse.success;
    } catch (e) {
      Log.e("error in redeeming code: $e");
      return RedeemCodeResponse.serverError;
    }
  }

  Future<MoneyModel?> getMoneyIfPresent(String code) async {
    final isPresent = await _checkIfCodePresent(code);
    if (!isPresent) {
      return null;
    }
    final doc = await _getRedeemCodeDoc(code);
    final amount = GwalletOffer.fromJson(doc.data()!).value.value;
    return MoneyModel(value: amount);
  } 

  Future<void> _addMoney(String code, Doc doc) async {
    final amount = GwalletOffer.fromJson(doc.data()!).value.value;

    game.monetaryService.transact(
      transactionType: TransactionType.credit,
      value: MoneyModel(value: amount),
    );
  }

  Future<void> addRedeemCode(RedeemCodeModel redeemCodeModel) async {
    final collectionRef = _firebaseFirestore.collection(redeemCollection);
    await collectionRef.doc(redeemCodeModel.code).set({
      'amount': redeemCodeModel.amount,
    });
  }
}

class RedeemCodeModel {
  final String code;
  final int amount;

  RedeemCodeModel({required this.code, required this.amount});

  factory RedeemCodeModel.generateFor(int amount) {
    return RedeemCodeModel(code: generateRandomCode, amount: amount);
  }

  static String get generateRandomCode {
    const chars = '0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ';
    final random = Random.secure();
    return List.generate(6, (index) => chars[random.nextInt(chars.length)]).join();
  }
}

enum RedeemCodeResponse {
  success,
  codeNotFound,
  serverError,
}
