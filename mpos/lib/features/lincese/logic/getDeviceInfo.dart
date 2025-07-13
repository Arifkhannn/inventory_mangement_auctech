import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:self_bill/features/auth/widget/sbackbar.dart';
import 'package:self_bill/features/home/presentation/home-screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<String> getDeviceId() async {
  final deviceInfo = DeviceInfoPlugin();

  if (Platform.isAndroid) {
    AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
    return androidInfo.id; // Unique Android ID
  } else if (Platform.isIOS) {
    IosDeviceInfo iosInfo = await deviceInfo.iosInfo;
    return iosInfo.identifierForVendor ?? "unknown_ios_device";
  }

  return '';
}

String _generateRandomString(int length) {
  const chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ1234567890';
  final random = Random();
  return String.fromCharCodes(Iterable.generate(
    length,
    (_) => chars.codeUnitAt(random.nextInt(chars.length)),
  ));
}

//license key genration----
Future<void> generateLicenseKey() async {
  try {
    print('🔄 Starting license key generation...');

    final userId = FirebaseAuth.instance.currentUser?.uid;
    if (userId == null) {
      print('❌ No user is signed in. Aborting.');
      return;
    }

    String deviceId = await getDeviceId();
    print('📱 Device ID: $deviceId');

    // 🔍 Check if a key already exists for this userId + deviceId
    final querySnapshot = await FirebaseFirestore.instance
        .collection('licenseKeys')
        .where('userId', isEqualTo: userId)
        .where('deviceId', isEqualTo: deviceId)
        .get();

    if (querySnapshot.docs.isNotEmpty) {
      print('⚠️ License key already exists for this user and device.');
      return;
    }

    final licenseKey = _generateRandomString(16);
    print('🔑 Generated License Key: $licenseKey');

    await FirebaseFirestore.instance.collection('licenseKeys').add({
      'key': licenseKey,
      'userId': userId,
      'deviceId': deviceId,
      'createdAt': FieldValue.serverTimestamp(),
      'isActive': false,
      'email': FirebaseAuth.instance.currentUser?.email,
    });

    print('✅ License key added to Firestore!');
  } catch (e) {
    print('🔥 Error while generating license key: $e');
  }
}

Future verifyLicenseKey(BuildContext context, String enteredKey) async {
  try {
    final userId = FirebaseAuth.instance.currentUser!.uid; // ! is safe here
    final deviceId = await getDeviceId();

    final docRef =
        FirebaseFirestore.instance.collection('licenseKeys').doc(enteredKey);
    final doc = await docRef.get();

    if (!doc.exists) {
      showTopSnackbar(context, "License key not found.");
      return;
    }

    final data = doc.data();
    if (data == null) {
      showTopSnackbar(context, "Invalid license data.");
      return;
    }

    final isValid = data['userId'] == userId && data['deviceId'] == deviceId;

    if (isValid) {
     
      final pref= await SharedPreferences.getInstance();
     await pref.setBool('licValid', true);
     
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => MyWidget()),
      );
    } else {
      showTopSnackbar(
          context, "License key does not match this device or user.");
    }
  } catch (e) {
    print(e);
    showTopSnackbar(context, "Verification failed: ${e.toString()}");
  }
}
