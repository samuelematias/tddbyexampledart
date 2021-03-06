import 'package:tddbyexample_dart/part1/bank.dart';
import 'package:tddbyexample_dart/part1/expression.dart';
import 'package:tddbyexample_dart/part1/money.dart';
import 'package:tddbyexample_dart/part1/sum.dart';
import 'package:test/test.dart';

void main() {
  test("franc != dollar", () {
    expect(false, Money.franc(10).equals(Money.dollar(10)));
    expect(true, Money(10, "CHF").equals(Money.franc(10)));
  });

  test("currency", () {
    expect(Money.dollar(10).currency, equals("USD"));
    expect(Money.franc(10).currency, equals("CHF"));
  });

  test("dollar should add", () {
    Money five = Money.dollar(5);
    Expression sum = five.plus(five);
    
    Bank bank = new Bank();
    Money result = bank.reduce(sum, "USD");

    expect(true, result.equals(Money.dollar(10)));
  });

  test('dollar should multiply', () {
    Money five = Money.dollar(5);
    var product = five.times(2);
    expect(true, Money.dollar(10).equals(product));
    product = five.times(3);
    expect(true, Money.dollar(15).equals(product));
  });

  test('dollar equality', () {
    expect(true, Money.dollar(5).equals(Money.dollar(5)));
    expect(false, Money.dollar(6).equals(Money.dollar(5)));
  });

  test('franc should multiply', () {
    Money five = Money.franc(5);
    var product = five.times(2);
    expect(true, Money.franc(10).equals(product));
    product = five.times(3);
    expect(true, Money.franc(15).equals(product));
  });

  test("franc should add", () {
    Money five = Money.franc(5);
    Expression sum = five.plus(five);
    
    Bank bank = new Bank();
    Money result = bank.reduce(sum, "CHF");

    expect(true, result.equals(Money.franc(10)));
  });

  test("should add same currency", () {
    var five = Money.dollar(5);
    Expression sum = five.plus(five);
    Bank bank = Bank();

    // With this we are saying that we want the bank
    // to be responsible for the reduction, not the
    // expression, as would be if we wrote:
    // reduced = sum.reduce("USD", bank);
    Money reduced = bank.reduce(sum, "USD");
    expect(true, Money.dollar(10).equals(reduced));
  });

  test("plus should return sum", () {
    var five = Money.dollar(5);
    Expression result = five.plus(five);
    Sum sum = result as Sum;

    expect(five, equals(sum.augend));
    expect(five, equals(sum.addend));
  });

  test("sum should reduce", () {
    Expression sum = Sum(Money.dollar(3), Money.dollar(4));
    Bank bank = Bank();

    Money result = bank.reduce(sum, "USD");
    expect(true, result.equals(Money.dollar(7)));
  });

  test("money should reduce to convert in between currencies", () {
    Money aFranc = Money.franc(2);
    
    Bank bank = Bank()
      ..addRate("CHF", "USD", 2);
    Money result = aFranc.reduce(bank, "USD");

    expect(true, result.equals(Money.dollar(1)));
  });

  test("sum should accept dollar+franc", () {
    Money aDollar = Money.dollar(1);
    Money aFranc = Money.franc(2);
    
    Bank bank = Bank()
      ..addRate("CHF", "USD", 2);

    Expression expr = aDollar.plus(aFranc);
    Money result = bank.reduce(expr, "USD");

    print(result);
    expect(true, result.equals(Money.dollar(2)));
  });
}