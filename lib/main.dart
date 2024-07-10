import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:instagram/providers/user_provider.dart';
import 'package:instagram/responsive/mob_screen_layout.dart';
import 'package:instagram/responsive/responsive_screen.dart';
import 'package:instagram/responsive/web_screen_layout.dart';
import 'package:instagram/screens/login_screen.dart';
import 'package:instagram/screens/sgnup_screen.dart';
import 'package:instagram/utils/colors.dart';
import 'package:provider/provider.dart';

import 'firebase_options.dart';


Future<void> main() async{
  WidgetsFlutterBinding.ensureInitialized(); // to initialize flutter widgets
  if (kIsWeb) {
    await Firebase.initializeApp(
      options: const FirebaseOptions(apiKey: "AIzaSyDTTsGrFKDgyNI9kis9I0QTc-axTL9yRqk", appId: "1:883595741941:web:ab39a0606b031111e953bc", messagingSenderId:  "883595741941", projectId: "instaclone-1f2ab",storageBucket: "instaclone-1f2ab.appspot.com",)
    ); 
  } else {
    await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  }
   
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => User_provider()),
      ],
      child: MaterialApp(
        title: 'Instagram Clone',
        debugShowCheckedModeBanner: false,
        theme: ThemeData.dark().copyWith(
          scaffoldBackgroundColor: mobileBackgroundColor,
        ),
        // home: const Res_layout(webscreenlayout: Web_layout(),mobscreenlayout: Mob_layout(),),
        home: StreamBuilder(
          stream: FirebaseAuth.instance.authStateChanges(), // --> runs when user signed in or signed out
          builder: (context,snapshot) {
            if (snapshot.connectionState == ConnectionState.active) {
              if (snapshot.hasData) {
                return const Res_layout(webscreenlayout: Web_layout(), mobscreenlayout: Mob_layout());
              } else if (snapshot.hasError) {
                return Center(child: Text("${snapshot.error}"),);
              }
            }
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator(color: primaryColor,),);
            }

            return const Login_page();
          },
        ),
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(

        backgroundColor: Theme.of(context).colorScheme.inversePrimary,

        title: Text('ok'),
      ),
      body: Container(
      ),
    );
  }

}
