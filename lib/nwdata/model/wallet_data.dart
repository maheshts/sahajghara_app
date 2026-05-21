class WalletResponse {
  double? walletBalance;
  double? bonusBalance;
  List<Result>? result;

  WalletResponse({this.walletBalance, this.bonusBalance, this.result});

  WalletResponse.fromJson(Map<String, dynamic> json) {
    walletBalance = json['wallet_balance'];
    bonusBalance = json['bonus_balance'];
    if (json['result'] != null) {
      result = <Result>[];
      json['result'].forEach((v) {
        result!.add(new Result.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['wallet_balance'] = this.walletBalance;
    data['bonus_balance'] = this.bonusBalance;
    if (this.result != null) {
      data['result'] = this.result!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Result {
  int? walletID;
  int? memberID;
  double? openingBalance;
  double? currentBalance;
  double? currentWalletBalance;
  double? currentBonusBalance;
  double? creditedAmount;
  double? debitedAmount;
  double? amount;
  String? type;
  String? walletTransactionID;
  String? bankTransactionID;
  String? transactionDate;

  Result(
      {this.walletID,
        this.memberID,
        this.openingBalance,
        this.currentBalance,
        this.currentWalletBalance,
        this.currentBonusBalance,
        this.creditedAmount,
        this.debitedAmount,
        this.amount,
        this.type,
        this.walletTransactionID,
        this.bankTransactionID,
        this.transactionDate});

  Result.fromJson(Map<String, dynamic> json) {
    walletID = json['walletID'];
    memberID = json['memberID'];
    openingBalance = json['openingBalance'];
    currentBalance = json['currentBalance'];
    currentWalletBalance = json['currentWalletBalance'];
    currentBonusBalance = json['currentBonusBalance'];
    creditedAmount = json['creditedAmount'];
    debitedAmount = json['debitedAmount'];
    amount = json['amount'];
    type = json['type'];
    walletTransactionID = json['walletTransactionID'];
    bankTransactionID = json['bankTransactionID'];
    transactionDate = json['transactionDate'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['walletID'] = this.walletID;
    data['memberID'] = this.memberID;
    data['openingBalance'] = this.openingBalance;
    data['currentBalance'] = this.currentBalance;
    data['currentWalletBalance'] = this.currentWalletBalance;
    data['currentBonusBalance'] = this.currentBonusBalance;
    data['creditedAmount'] = this.creditedAmount;
    data['debitedAmount'] = this.debitedAmount;
    data['amount'] = this.amount;
    data['type'] = this.type;
    data['walletTransactionID'] = this.walletTransactionID;
    data['bankTransactionID'] = this.bankTransactionID;
    data['transactionDate'] = this.transactionDate;
    return data;
  }
}
