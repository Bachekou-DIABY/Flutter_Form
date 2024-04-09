
import 'package:flutter/material.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: const DestinationScreen(),
      theme: ThemeData.from(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.pink.shade700)),
      debugShowCheckedModeBanner: false,
    );
  }
}

class DestinationScreen extends StatelessWidget {
  const DestinationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Où partons-nous ?'),
          centerTitle: false,
          actions: [
            if (Authentication.isLoggedIn)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Text('Utilisateur connecté'),
              ),
            if (!Authentication.isLoggedIn)
            IconButton(
              onPressed: () => Navigator.of(context).push(MaterialPageRoute(builder: (context) => const LoginScreen())) ,
              icon: const Icon(Icons.account_box),
              color: Colors.pink.shade700),
            if (Authentication.isLoggedIn)
            IconButton(
              onPressed: () => Navigator.of(context).push(MaterialPageRoute(builder: (context) => const LogoutScreen())) ,
              icon: const Icon(Icons.logout),
              color: Colors.pink.shade700              
            )                 
          ],
          bottom: const TabBar(
            isScrollable: true,
            tabs: [
              Tab(
                text: 'Campagne',
                icon: Icon(Icons.house_siding),
              ),
              Tab(
                text: 'Sur l\'eau',
                icon: Icon(Icons.houseboat_outlined),
              ),
              Tab(
                text: 'Avec vue',
                icon: Icon(Icons.panorama),
              ),
              Tab(
                text: 'Bord de mer',
                icon: Icon(Icons.scuba_diving),
              ),
            ],
          ),
        ),
               body: TabBarView(
          children: [
            ListView.separated(
              itemCount: 3,
              itemBuilder: (context, index) => DestinationDetails(),
              separatorBuilder: (context, index) => const Divider(
                height:32
              ),
            ),
            Text('B'),
            Text('C'),
            Text('D'),
          ],
        ),
      ),
    );
  }
}

class LogoutScreen extends StatelessWidget {
  const LogoutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:Center(
        child: ElevatedButton(
          child:Text('Logout'),
          onPressed: () => {Navigator.of(context).push(MaterialPageRoute(builder: (context) => const DestinationScreen())),
            Authentication.isLoggedIn=false
          } 
        )
      ,)
    );
  }
}

class DestinationDetails extends StatelessWidget {
  const DestinationDetails({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [DestinationPhoto(), const DestinationInfos()],
    );
  }
}

class DestinationPhoto extends StatelessWidget {
  const DestinationPhoto({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        AspectRatio(
          aspectRatio: 1,
          child: Image.asset('/img.png',
            fit: BoxFit.cover,
            errorBuilder: (context, _, __) =>
                const Icon(Icons.warning, color: Colors.red),
          ),
        ),
        Align(
          alignment: Alignment.topRight,
          child: IconButton(
            onPressed: () {},
            icon: Icon(Icons.favorite_border),
          ),
        ),
        Positioned(left: 8, top: 8, child: MembersFavorite())
      ],
    );
  }
}

class MembersFavorite extends StatelessWidget {
  const MembersFavorite({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: Colors.white70,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.favorite, color: Colors.pink),
          /*SizedBox(width: 12),*/
          Padding(
            padding: const EdgeInsets.only(left: 8.0),
            child: Text('Coup de coeur Voyageurs'),
          )
        ],
      ),
    );
  }
}

class DestinationInfos extends StatelessWidget {
  const DestinationInfos({super.key});

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Text('Paris, France'),
              Spacer(),
              Icon(Icons.star, color: Colors.orange),
              Text('4.78')
            ],
          ),
          Text('3-9 avril'),
          Text('120€ nuit'),
        ],
      ),
    );
  }
}

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  Map<String, dynamic> userData = {
    'Email': null,
    'Password': null,
  };
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar: AppBar(
        title: Text('Se connecter'),
      ),
      body:Form(
        key:formKey,
        child: Column(
          children: [
            Padding(padding: EdgeInsets.all(25.0),
              child:TextFormField(
                decoration: InputDecoration(label: Text('Email')),
                controller: emailController,
                validator: (String? value) {
                  return value?.isNotEmpty == true && value == 'test@mail.com' ? null : 'Identifiant invalide';
                },
                onSaved: (String? value) => userData['Email'] = value,
              ),
            ),
            Padding(padding: EdgeInsets.all(25.0),
              child:TextFormField(
                decoration: InputDecoration(label: Text('Password')),
                controller: passwordController,
                validator: (String? value) {
                  return value?.isNotEmpty == true && value == 'test' ? null : 'Mot de passe invalide';
                },
                onSaved: (String? value) => userData['Password'] = value,
              ),
            ),
            Padding(padding: EdgeInsets.all(25.0),
              child:ElevatedButton(
                child: const Text('Valider'),
                  onPressed: () => formKey.currentState!.validate()
                    ? {Navigator.of(context).push(MaterialPageRoute(builder: (context) => const DestinationScreen())),
                    Authentication.isLoggedIn = true
                    }

                    : print('INVALID'),
              ),
            ),

          ],
        ),

      )
    );
  }
}

class Authentication {
  static bool isLoggedIn = false;


  static void logIn() {
    isLoggedIn = true;
  }

  static void logOut() {
    isLoggedIn = false;
  }
}