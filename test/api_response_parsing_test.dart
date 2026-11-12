import 'package:sahajghara/screens/contractor/ContractorReposne.dart' as contractor;
import 'package:flutter_test/flutter_test.dart';
import 'package:sahajghara/screens/utils/JsonHelper.dart';
import 'package:sahajghara/screens/auth/model/OtpResponse.dart' as auth;
import 'package:sahajghara/screens/home/HomePageResponse.dart' as home;
import 'package:sahajghara/screens/vendor/EnquiryDetailResponse.dart'
    as enquiry;
import 'package:sahajghara/screens/profile/model/ProfileResponse.dart'
    as profile;
import 'package:sahajghara/nwdata/model/notification_model.dart';
import 'package:sahajghara/nwdata/model/wallet_data.dart' as wallet;
import 'package:sahajghara/nwdata/api/api_helper.dart';
import 'package:dio/dio.dart';

void main() {
  test('contractor parses numeric flags and mixed specializations', () {
    final item = contractor.Contractorlist.fromJson({
      'is_sample': 1, 'numberofproject': '3.0',
      'specializations': [123, 'building', null], 'portfolioList': {},
    });
    expect(item.isSample, true);
    expect(item.numberofproject, 3);
    expect(item.specializations, ['123', 'building']);
    expect(item.portfolioList, isEmpty);
  });
  test('scalar conversions preserve nulls and reject invalid numbers', () {
    expect(JsonHelper.toInt(' 12.0 '), 12);
    expect(JsonHelper.toInt(12.5), isNull);
    expect(JsonHelper.toInt(double.infinity), isNull);
    expect(JsonHelper.toDouble('NaN'), isNull);
    expect(JsonHelper.toDouble(12), 12.0);
    expect(JsonHelper.toNullableBool(' YES '), true);
    expect(JsonHelper.toNullableBool('0'), false);
    expect(JsonHelper.toNullableBool(null), isNull);
    expect(JsonHelper.toNullableBool('unknown'), isNull);
    expect(JsonHelper.toStringValue(null), isNull);
    expect(JsonHelper.toStringValue({'id': 1}), isNull);
  });

  test('auth accepts mixed OTP, phone, status and flag types', () {
    final response = auth.OtpResponse.fromJson({
      'HasError': '0',
      'Message': 200,
      'result': {
        'otp': '123456',
        'register': 1,
        'user': {'phone': 9876543210, 'status': '1'}
      }
    });
    expect(response.hasError, false);
    expect(response.message, '200');
    expect(response.result!.otp, 123456);
    expect(response.result!.register, true);
    expect(response.result!.user!.phone, '9876543210');
    expect(auth.OtpResponse.fromJson({'result': []}).result, isNull);
  });

  test('home skips malformed list entries and parses numeric flags', () {
    final response = home.HomePageResponse.fromJson({
      'result': {
        'enable_vendor': '1',
        'enable_contractor': 0,
        'category': [
          null,
          42,
          {'title': 123}
        ],
        'brand': {},
      }
    });
    expect(response.result!.enableVendor, true);
    expect(response.result!.enableContractor, false);
    expect(response.result!.category!.single.title, '123');
    expect(response.result!.brand, isEmpty);
    expect(response.result!.vendorCode, isNull);
  });

  test('enquiry tracking and amounts tolerate mixed types and structures', () {
    final response = enquiry.EnquiryDetailResponse.fromJson({
      'result': {
        'details': {
          'phone': 123,
          'order_quantity': '2.0',
          'price_per_quantity': 100
        },
        'tracking': {
          'is_closed': '1',
          'steps': [
            false,
            {'status': '2'}
          ],
          'timeline': {}
        },
        'messages': {
          'bad': false,
          '1': {'customer': 42}
        }
      }
    });
    expect(response.result!.details!.orderQuantity, 2);
    expect(response.result!.details!.pricePerQuantity, 100.0);
    expect(response.result!.tracking!.isClosed, true);
    expect(response.result!.tracking!.steps!.single.status, 2);
    expect(response.result!.tracking!.timeline, isEmpty);
    expect(response.result!.messages!['1']!.customer, '42');
  });

  test('profile supports alternate phone and Mongo extended date keys', () {
    final response = profile.ProfileResponse.fromJson({
      'result': {
        'alternate_number': 123,
        'createdAt': {
          r'$date': {r'$numberLong': 1700000000000}
        }
      }
    });
    expect(response.result!.alternateNumber, '123');
    expect(response.result!.createdAt!.date!.numberLong, '1700000000000');
  });

  test('notification and wallet scalar types are normalized', () {
    final notification =
        NotificationModel.fromJson({'_id': 3, 'is_read': '0', 'is_vendor': 1});
    expect(notification.id, '3');
    expect(notification.isRead, false);
    expect(notification.isVendor, true);
    final response = wallet.WalletResponse.fromJson({
      'wallet_balance': '10.5',
      'bonus_balance': 2,
      'result': [
        {'walletID': '7', 'amount': 3},
        null
      ]
    });
    expect(response.walletBalance, 10.5);
    expect(response.bonusBalance, 2.0);
    expect(response.result!.single.walletID, 7);
    expect(response.result!.single.amount, 3.0);
  });

  test('API boundary decodes JSON text and normalizes flags without a server',
      () async {
    final api = APIHelper();
    api.dio.interceptors.insert(0,
        InterceptorsWrapper(onRequest: (options, handler) {
      handler.resolve(
          Response(
              requestOptions: options,
              statusCode: 200,
              data: '{"HasError":"0","success":1,"result":{"id":7}}'),
          true);
    }));
    final response = await api.getMethod(url: 'https://example.invalid/test');
    expect(response.data['HasError'], false);
    expect(response.data['success'], true);
    expect(response.data['result']['id'], 7);
  });
}
