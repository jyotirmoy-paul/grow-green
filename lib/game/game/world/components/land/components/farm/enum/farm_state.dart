enum FarmState {
  /// farm is not bought yet
  notBought,

  /// farm is initialized with only crops, and we are waiting as it's not the correct time for sow
  onlyCropsWaiting,

  /// farm is initialized with crops & trees, and we are waiting for the crops as it's not correct sow time
  treesAndCropsButCropsWaiting,

  /// farm is at work, crops & trees / crops are getting grown
  functioning,

  /// farm has trees, but crops are harvested
  functioningOnlyTrees,

  /// farm had potention of trees as well, but farm has only crops currently & trees are harvested
  functioningOnlyCrops,

  /// nothing in the farm to act on
  notFunctioning,

  /// nothing can be done now, the farm is completely lost!
  barren,
}
