import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/material.dart';

import 'FireStore/firestore_service.dart';
import 'firebase_messaging_config.dart';
import 'firebase_options.dart';

final remoteConfig = FirebaseRemoteConfig.instance;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();



  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  FirebaseMessagingConfig().configFirebaseMessaging();

  // await Firebase.initializeApp(
  //   options: const FirebaseOptions(
  //     apiKey: "AIzaSyAKByLyNqZehGxs_vv59cY4t4ZnRVLaX28",
  //     authDomain: "udemyfirebaseex.firebaseapp.com",
  //     projectId: "udemyfirebaseex",
  //     storageBucket: "udemyfirebaseex.firebasestorage.app",
  //     messagingSenderId: "110656260145",
  //     appId: "1:110656260145:web:926e9ff4e7cdd72f85ad10",
  //     measurementId: "G-7KBL1373GX",
  //   ),
  // );


  await remoteConfig.setConfigSettings(RemoteConfigSettings(
    fetchTimeout: const Duration(minutes: 1),
    minimumFetchInterval: Duration.zero,
  ));
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // TRY THIS: Try running your application with "flutter run". You'll see
        // the application has a purple toolbar. Then, without quitting the app,
        // try changing the seedColor in the colorScheme below to Colors.green
        // and then invoke "hot reload" (save your changes or press the "hot
        // reload" button in a Flutter-supported IDE, or press "r" if you used
        // the command line to start the app).
        //
        // Notice that the counter didn't reset back to zero; the application
        // state is not lost during the reload. To reset the state, use hot
        // restart instead.
        //
        // This works for code too, not just values: Most code changes can be
        // tested with just a hot reload.
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  String baseURL = '';
  
  Color color = Colors.white;

  void _incrementCounter() {
    FireStoreService fireStoreService = FireStoreService();
    // Create a new user with a first and last name
    // final user = <String, dynamic>{
    //   "first": "Ada",
    //   "last": "Lovelace",
    //   "born": 1815
    // };
    // fireStoreService.addData(user);

    // fireStoreService.searchUser("Ada");
   // fireStoreService.updateUser("Ada", 'Ahmed');

    //fireStoreService.signIN('ahmedhafez@gmail.com', "password333");

    //fireStoreService.getAllUsers();
    setState(() {
      // This call to setState tells the Flutter framework that something has
      // changed in this State, which causes it to rerun the build method below
      // so that the display can reflect the updated values. If we changed
      // _counter without calling setState(), then the build method would not be
      // called again, and so nothing would appear to happen.
      _counter++;
    });
  }

  @override
  void initState(){
    getRemoteConfig();
    FireStoreService().checkState();
    super.initState();
  }

  getRemoteConfig()async{

   await remoteConfig.fetchAndActivate();
   setState(() {
     baseURL=remoteConfig.getString('baseURL');
     
     String colorString = remoteConfig.getString('backgroundColor');

     color = Color(int.parse('FF$colorString',radix: 8));
   });
   
  }

  @override
  Widget build(BuildContext context) {
    // FireStoreService().getAllUsers();
    // FireStoreService().deleteUser();
    // FireStoreService().searchUser('Ada');



    //FireStoreService().signIN('ahmedhafez@gmail.com', "password333");

   //FireStoreService().signOut();



    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      backgroundColor: color,
      appBar: AppBar(
        // TRY THIS: Try changing the color here to a specific color (to
        // Colors.amber, perhaps?) and trigger a hot reload to see the AppBar
        // change color while the other colors stay the same.
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: Column(

        children: [

          Text(baseURL),
          Expanded(
            child: StreamBuilder(
              stream: FireStoreService().db.collection('users').snapshots(),
              builder: (context, snapshot) {
                if(snapshot.connectionState == ConnectionState.waiting){
                  return const Center(child: CircularProgressIndicator(color: Colors.deepPurple,),);
                }
                if(snapshot.hasError){
                  return const Center(child: Text('There is no data'),);
                }
                if(snapshot.hasData){
                  return ListView.builder(
                    itemCount:snapshot.data!.docs.length ,
                    itemBuilder: (context,index){
                      return ListTile(
                        title: Text(snapshot.data!.docs[index]['first'].toString()  + snapshot.data!.docs[index]['last'].toString()),
                        subtitle: Text(snapshot.data!.docs[index]['born'].toString()),
                      );
                    },
                  );
                }


                return Container();

              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
