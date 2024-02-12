enum Month { jan, feb, mar, apr, may, jun, jul, aug, sep, oct, nov, dec }

extension MonthExtension on Month {
  int get index => this.index + 1;

  bool operator >(Month other) {
    return this.index > other.index;
  }

  bool operator <(Month other) {
    return this.index < other.index;
  }

  // Adding months
  Month operator +(int monthsToAdd) {
    int newIndex = (this.index - 1 + monthsToAdd) % 12;
    if (newIndex < 0) {
      newIndex += 12; // Ensure the index stays within the 0-11 range
    }
    return Month.values[newIndex];
  }

  // Subtracting months
  Month operator -(int monthsToSubtract) {
    return this + (-monthsToSubtract); // Utilize the + operator for subtraction
  }

  // Adding >= operator
  bool operator >=(Month other) {
    return this.index >= other.index;
  }

  // Adding «= operator
  bool operator <=(Month other) {
    return this.index <= other.index;
  }
}

void main() {
  // Example usage
  Month currentMonth = Month.jan;
  Month nextMonth = currentMonth + 1;
  print("Current month: ${currentMonth.name}, Next month: ${nextMonth.name}");

  Month previousMonth = currentMonth - 1;
  print("Current month: ${currentMonth.name}, Previous month: ${previousMonth.name}");

  // Comparison example
  if (Month.feb > Month.jan) {
    print("February is after January");
  } else {
    print("January is after February");
  }
}
