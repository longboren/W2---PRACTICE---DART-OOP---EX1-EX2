// Custom exceptions for better error handling
class InsufficientBalanceException implements Exception {
  final String message;
  InsufficientBalanceException(this.message);
  @override
  String toString() => message;
}

class InvalidAmountException implements Exception {
  final String message;
  InvalidAmountException(this.message);
  @override
  String toString() => message;
}

class DuplicateAccountException implements Exception {
  final String message;
  DuplicateAccountException(this.message);
  @override
  String toString() => message;
}

class InvalidTransferException implements Exception {
  final String message;
  InvalidTransferException(this.message);
  @override
  String toString() => message;
}

class BankAccount {
  final int id;
  final String ownerName;
  double _balance = 0;
  final List<String> _transactionHistory = [];

  BankAccount({
    required this.id,
    required this.ownerName,
    double initialBalance = 0,
  }) {
    if (initialBalance < 0) {
      throw InvalidAmountException('Initial balance cannot be negative');
    }
    _balance = initialBalance;
    _addTransaction('Account opened with initial balance: \$${initialBalance.toStringAsFixed(2)}');
  }

  double get balance => _balance;

  String get formattedBalance => '\$${_balance.toStringAsFixed(2)}';

  List<String> get transactionHistory => List.unmodifiable(_transactionHistory);

  void _addTransaction(String transaction) {
    _transactionHistory.add('${DateTime.now()}: $transaction');
  }

  void credit(double amount) {
    if (amount <= 0) {
      throw InvalidAmountException('Credit amount must be positive!');
    }
    _balance += amount;
    _addTransaction('Credited: \$${amount.toStringAsFixed(2)}');
  }

  void withdraw(double amount) {
    if (amount <= 0) {
      throw InvalidAmountException('Withdraw amount must be positive!');
    }
    if (amount > _balance) {
      throw InsufficientBalanceException('Insufficient balance for withdrawal of \$${amount.toStringAsFixed(2)}');
    }
    _balance -= amount;
    _addTransaction('Withdrawn: \$${amount.toStringAsFixed(2)}');
  }

  void deposit(double amount) => credit(amount);

  /// Transfer amount from this account to [other]. Throws on error.
  void transferTo(BankAccount other, double amount) {
    if (other.id == id) {
      throw InvalidTransferException('Cannot transfer to same account');
    }
    withdraw(amount);
    other.credit(amount);
    _addTransaction('Transferred: \$${amount.toStringAsFixed(2)} to Account #${other.id}');
  }
}

class Bank {
  final String name;
  final Map<int, BankAccount> _accounts = {};

  Bank({required this.name});

  BankAccount createAccount(int accountId, String accountOwner, [double initialBalance = 0]) {
    if (_accounts.containsKey(accountId)) {
      throw DuplicateAccountException('Account with ID $accountId already exists!');
    }

    final newAccount = BankAccount(
      id: accountId, 
      ownerName: accountOwner,
      initialBalance: initialBalance
    );
    _accounts[accountId] = newAccount;
    return newAccount;
  }

  BankAccount? getAccount(int accountId) => _accounts[accountId];

  List<BankAccount> get allAccounts => List.unmodifiable(_accounts.values);
}

void main() {
    Bank myBank = Bank(name: "CADT Bank");

    // Create accounts with initial balances
    BankAccount ronanAccount = myBank.createAccount(100, 'Ronan', 100.0);
    BankAccount honlgyAccount = myBank.createAccount(101, 'Honlgy', 50.0);

    print('Initial balances:');
    print('Ronan: ${ronanAccount.formattedBalance}');
    print('Honlgy: ${honlgyAccount.formattedBalance}');

    // Demonstrate operations with custom exceptions
    try {
      ronanAccount.withdraw(-50); // Should throw InvalidAmountException
    } catch (e) {
      print('\nExpected error: $e');
    }

    try {
      ronanAccount.transferTo(honlgyAccount, 200); // Should throw InsufficientBalanceException
    } catch (e) {
      print('Expected error: $e');
    }

    // Successful operations
    print('\nPerforming valid operations:');
    ronanAccount.deposit(150);
    honlgyAccount.credit(75);
    
    print('\nAfter deposits:');
    print('Ronan: ${ronanAccount.formattedBalance}');
    print('Honlgy: ${honlgyAccount.formattedBalance}');

    // Transfer
    ronanAccount.transferTo(honlgyAccount, 100);
    print('\nAfter transfer of \$100 from Ronan to Honlgy:');
    print('Ronan: ${ronanAccount.formattedBalance}');
    print('Honlgy: ${honlgyAccount.formattedBalance}');

    // Show transaction history
    print('\nRonan\'s Transaction History:');
    for (var transaction in ronanAccount.transactionHistory) {
        print(transaction);
    }
}