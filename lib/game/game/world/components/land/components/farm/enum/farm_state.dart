enum FarmState {
  /// farm is not bought yet
  notBought,

  /// farm is bought, but non further action is taken
  notInitialized,

  /// farm is at work, crops & trees / crops are getting grown
  functioning,

  /// farm has trees, but crops are harvested
  functioningOnlyTrees,

  /// farm had potention of trees as well, but farm has only crops currently & trees are harvested
  functioningOnlyCrops,

  /// nothing in the farm to act on
  notFunctioning,
}
