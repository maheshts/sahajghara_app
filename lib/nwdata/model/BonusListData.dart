class BonusListData {
  int? memberID;
  int? bonusID;
  String? mamberName;
  String? bonusTransactionID;
  double? openingBalance;
  double? currentBalance;
  double? bonusAmount;
  double? creditedAmount;
  double? debetedAmount;
  double? amount;
  String? type;
  String? status;
  String? notes;
  String? createdOn;

  BonusListData(
      {this.memberID,
        this.bonusID,
        this.mamberName,
        this.bonusTransactionID,
        this.openingBalance,
        this.currentBalance,
        this.bonusAmount,
        this.creditedAmount,
        this.debetedAmount,
        this.amount,
        this.type,
        this.status,
        this.notes,
        this.createdOn});

  BonusListData.fromJson(Map<String, dynamic> json) {
    memberID = json['memberID'];
    bonusID = json['bonusID'];
    mamberName = json['mamberName'];
    bonusTransactionID = json['bonusTransactionID'];
    openingBalance = json['openingBalance'];
    currentBalance = json['currentBalance'];
    bonusAmount = json['bonusAmount'];
    creditedAmount = json['creditedAmount'];
    debetedAmount = json['debetedAmount'];
    amount = json['amount'];
    type = json['type'];
    status = json['status'];
    notes = json['notes'];
    createdOn = json['createdOn'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['memberID'] = this.memberID;
    data['bonusID'] = this.bonusID;
    data['mamberName'] = this.mamberName;
    data['bonusTransactionID'] = this.bonusTransactionID;
    data['openingBalance'] = this.openingBalance;
    data['currentBalance'] = this.currentBalance;
    data['bonusAmount'] = this.bonusAmount;
    data['creditedAmount'] = this.creditedAmount;
    data['debetedAmount'] = this.debetedAmount;
    data['amount'] = this.amount;
    data['type'] = this.type;
    data['status'] = this.status;
    data['notes'] = this.notes;
    data['createdOn'] = this.createdOn;
    return data;
  }
}
