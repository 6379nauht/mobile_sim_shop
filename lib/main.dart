import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:mobile_sim_shop/core/dependency_injection/locator.dart';
import 'package:mobile_sim_shop/features/store/presentation/pages/search/search.dart';
import 'package:mobile_sim_shop/firebase_options.dart';
import 'package:mobile_sim_shop/typesense_sync.dart';
import 'package:typesense/typesense.dart';

import 'app.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await dotenv.load(fileName: ".env");
  User? user = FirebaseAuth.instance.currentUser;
  if(user != null) {
    await TypesenseSync.reloadAllData();
  }
  Stripe.publishableKey = dotenv.env['PublishableKey'] ?? ''; // Thay bằng Publishable Key từ Stripe Dashboard
  await Stripe.instance.applySettings();
  TypesenseSync.startSync();
  //Initialize GetIt
  await setupLocator();
  runApp( const App());

}