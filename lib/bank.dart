// creating an abstract class BankAccount

//
abstract class InterestBearing {
  double calculateInterest();
}

// Creating a abstaract class BankAccount
abstract class BankAccount {
  // Private fields
  String _accountNumber;
  String _holderName;
  double _balance;

  BankAccount(this._accountNumber, this._holderName, this._balance);

  // creating a proper getters/setters

  String get accountNumber => _accountNumber;
  String get holderName => _holderName;

  double get balance => _balance;

  set holderName(String name) {
    // using .isNotEmpty to check the property of name whether it is True or False
    if (name.isNotEmpty) {
      _holderName = name;
    }
  }

  // Protected method to modify balance internally
  void updateBalance(double amount) {
    _balance += amount;
  }

  // Abstract method
  void deposit(double amount);
  void withdraw(double amount);

  // Method to display account information

  void displayInfo() {
    print("Account no       : $_accountNumber");
    print("Account holder   : $_holderName");
    print("Balance          : $_balance");
  }
}

// Creating a three types of accounts that inherit from BankAccount

// 1. Saving Account
class SavingAccount extends BankAccount implements InterestBearing {
  static const double minBalance = 500.0;
  int withdrawCount = 0;

  SavingAccount(super.number, super.name, super._balance);

  @override
  void deposit(double amount) {
    updateBalance(amount);
    print("Deposited \$${amount}. New balance: \$${balance}");
  }

  @override
  void withdraw(double amount) {
    if (withdrawCount >= 3) {
      print("Withdrawal limit reached (3 per month.");

      return;
    }

    if (balance - amount < minBalance) {
      print("Cannot withdraw. Minimum balance of \$500 required.");
      return;
    }

    updateBalance(-amount);
    withdrawCount++;
    print("Withdrawal $amount . New balance: \$$balance");
  }

  @override
  double calculateInterest() {
    return balance * 0.02;
  }
}

// Checking Account

class CheckingAccount extends BankAccount {
  CheckingAccount(super.number, super.name, super.balance);

  @override
  void deposit(double amount) {
    updateBalance(amount);
    print("Deposited \$$amount. New balance: \$$balance");
  }

  @override
  void withdraw(double amount) {
    updateBalance(-amount);
    print("Withdrawn \$${amount}. New balance: \$${balance}");

    if (balance < 0) {
      updateBalance(-35); // overdraft fee
      print("Overdraft fee applied! New balance: \$${balance}");
    }
  }
}

// Premium account

class PremiumAccount extends BankAccount implements InterestBearing {
  static const double minBalance = 10000.0;

  PremiumAccount(super.number, super.name, super.balance);

  @override
  void deposit(double amount) {
    updateBalance(amount);
    print("Deposited \$${amount}. New balance: \$${balance}");
  }

  @override
  void withdraw(double amount) {
    if (balance - amount < minBalance) {
      print("Cannot withdraw. Minimum balance of \$10,000 required.");
      return;
    }

    updateBalance(-amount);
    print("Withdrawn \$${amount}. New balance: \$${balance}");
  }

  @override
  double calculateInterest() {
    return balance * 0.05;
  }
}
// Bank class

class Bank {
  List<BankAccount> accounts = [];

  void createAccount(BankAccount acc) {
    accounts.add(acc);
    print("Account created for ${acc.holderName}");
  }

  BankAccount? findAccount(String accNo) {
    for (var acc in accounts) {
      if (acc.accountNumber == accNo) {
        return acc;
      }
    }
    return null;
  }

  void transfer(String fromAcc, String toAcc, double amount) {
    var sender = findAccount(fromAcc);
    var receiver = findAccount(toAcc);

    if (sender == null || receiver == null) {
      print("Error: One or both accounts not found.");
      return;
    }

    sender.withdraw(amount);
    receiver.deposit(amount);

    print("Transferred \$${amount} from $fromAcc to $toAcc");
  }

  void generateReport() {
    print("\n------------ BANK ACCOUNTS REPORT ------------");
    for (var acc in accounts) {
      acc.displayInfo();
    }
  }
}

// Main function

void main() {
  Bank bank = Bank();

  var acc1 = SavingAccount("S101", "Rabin Tamang", 1500);
  // var acc2 = CheckingAccount("C202", "Dipen Tamang", 200);
  // var acc3 = PremiumAccount("P303", "Joseph Tamang", 15000);

  bank.createAccount(acc1);
  // bank.createAccount(acc2);
  // bank.createAccount(acc3);

  // Test operations
  acc1.withdraw(300);
  acc1.withdraw(200);
  acc1.withdraw(100);
  acc1.withdraw(50); // 4th attempt → blocked

  bank.transfer("P303", "S101", 2000);

  bank.generateReport();
}
