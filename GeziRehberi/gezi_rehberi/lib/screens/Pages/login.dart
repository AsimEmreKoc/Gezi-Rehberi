import 'dart:async';

import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:gezi_rehberi/screens/home/HomePage.dart';
import 'package:gezi_rehberi/main.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class login extends StatefulWidget {
  final VoidCallback onClickedSignUp;

  const login({
    Key? key,
    required this.onClickedSignUp,
  }) : super(key: key);
  @override
  State<login> createState() => _loginState();
}

class _loginState extends State<login> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  Widget build(BuildContext context) => SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(height: 120),
            Text(
              'Hoşgeldiniz',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 50, fontWeight: FontWeight.w800),
            ),
            SizedBox(
              height: 110,
            ),
            TextField(
              controller: emailController,
              cursorColor: Colors.white,
              textInputAction: TextInputAction.next,
              decoration: InputDecoration(labelText: 'Email'),
            ),
            SizedBox(
              height: 4,
            ),
            TextField(
              controller: passwordController,
              textInputAction: TextInputAction.done,
              decoration: InputDecoration(labelText: 'Şifre'),
              obscureText: true,
            ),
            SizedBox(
              height: 20,
            ),
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                  minimumSize: Size.fromHeight(50), primary: Colors.green),
              icon: Icon(
                Icons.lock_open,
                size: 32,
              ),
              label: Text(
                'Giriş Yap',
                style: TextStyle(fontSize: 24),
              ),
              onPressed: GirisYap,
            ),
            SizedBox(
              height: 24,
            ),
            GestureDetector(
              child: Text(
                'Şifremi unuttum',
                style: TextStyle(
                  decoration: TextDecoration.underline,
                  color: Colors.black,
                  fontSize: 20,
                ),
              ),
              onTap: () => Navigator.of(context)
                  .push(MaterialPageRoute(builder: (context) => sifreRes())),
            ),
            RichText(
                text: TextSpan(
                    style: TextStyle(color: Colors.black, fontSize: 18),
                    text: 'Hesabın yok mu?',
                    children: [
                  TextSpan(
                    recognizer: TapGestureRecognizer()
                      ..onTap = widget.onClickedSignUp,
                    text: 'Kayıt Ol',
                    style: TextStyle(
                      decoration: TextDecoration.underline,
                      color: Theme.of(context).colorScheme.secondary,
                    ),
                  )
                ])),
          ],
        ),
      );

  Future GirisYap() async {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => Center(
              child: CircularProgressIndicator(),
            ));

    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );
    } on FirebaseAuthException catch (e) {
      print(e);
    }
    navigatorKey.currentState!.popUntil((route) => route.isFirst);
  }
}

class loginRef extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Scaffold(
        body: StreamBuilder<User?>(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState) {
              return Center(
                child: CircularProgressIndicator(),
              );
            } else if (snapshot.hasError) {
              return Center(
                child: Text('Bir Şeyler Ters Gitti!'),
              );
            } else if (snapshot.hasData) {
              return HomePage();
            } else {
              return AuthPage();
            }
          },
        ),
      );
}

class CikisYap extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser!;

    return Scaffold(
      body: Padding(
        padding: EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Giriş Yapıldı;',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(
              height: 8,
            ),
            Text(
              user.email!,
              style: TextStyle(
                fontSize: 20,
              ),
            ),
            SizedBox(
              height: 40,
            ),
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                  minimumSize: Size.fromHeight(50), primary: Colors.green),
              icon: Icon(Icons.arrow_back, size: 32),
              label: Text(
                'ÇIKIŞ YAP',
                style: TextStyle(fontSize: 24),
              ),
              onPressed: () => FirebaseAuth.instance.signOut(),
            )
          ],
        ),
      ),
    );
  }
}

class AuthPage extends StatefulWidget {
  @override
  State<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  bool isLogin = true;

  @override
  Widget build(BuildContext context) => isLogin
      ? login(
          onClickedSignUp: toggle,
        )
      : SignUpWidget(onClickedSignIn: toggle);

  void toggle() => setState(() => isLogin = !isLogin);
}

class SignUpWidget extends StatefulWidget {
  final Function() onClickedSignIn;
  const SignUpWidget({
    Key? key,
    required this.onClickedSignIn,
  }) : super(key: key);

  @override
  State<SignUpWidget> createState() => _SignUpWidgetState();
}

class _SignUpWidgetState extends State<SignUpWidget> {
  final formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  TextEditingController t1 = TextEditingController();
  TextEditingController t2 = TextEditingController();
  TextEditingController t3 = TextEditingController();

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Form(
          key: formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(height: 120),
              Text(
                'Hoşgeldiniz',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 50, fontWeight: FontWeight.w800),
              ),
              SizedBox(
                height: 80,
              ),
              TextFormField(
                controller: t1,
                cursorColor: Colors.white,
                textInputAction: TextInputAction.next,
                decoration: InputDecoration(labelText: 'Ad'),
                autovalidateMode: AutovalidateMode.onUserInteraction,
                validator: (value) => value != null && value.length < 3
                    ? 'En az 3 karakter giriniz'
                    : null,
              ),
              SizedBox(
                height: 4,
              ),
              TextFormField(
                controller: t2,
                cursorColor: Colors.white,
                textInputAction: TextInputAction.next,
                decoration: InputDecoration(labelText: 'Soyad'),
                autovalidateMode: AutovalidateMode.onUserInteraction,
                validator: (value) => value != null && value.length < 2
                    ? 'En az 2 karakter giriniz'
                    : null,
              ),
              SizedBox(
                height: 4,
              ),
              TextFormField(
                controller: emailController,
                cursorColor: Colors.white,
                textInputAction: TextInputAction.next,
                decoration: InputDecoration(labelText: 'Email'),
                autovalidateMode: AutovalidateMode.onUserInteraction,
                validator: (email) =>
                    email != null && !EmailValidator.validate(email)
                        ? 'Geçerli email giriniz'
                        : null,
              ),
              SizedBox(
                height: 4,
              ),
              TextFormField(
                controller: passwordController,
                textInputAction: TextInputAction.done,
                decoration: InputDecoration(labelText: 'Şifre'),
                obscureText: true,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                validator: (value) => value != null && value.length < 6
                    ? 'En az 6 karakter giriniz'
                    : null,
              ),
              SizedBox(
                height: 20,
              ),
              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                    minimumSize: Size.fromHeight(50), primary: Colors.green),
                icon: Icon(
                  Icons.lock_open,
                  size: 32,
                ),
                label: Text(
                  'Kayıt Ol',
                  style: TextStyle(fontSize: 24),
                ),
                onPressed: KayitOl,
              ),
              SizedBox(
                height: 24,
              ),
              RichText(
                  text: TextSpan(
                      style: TextStyle(color: Colors.black, fontSize: 18),
                      text: 'Hesabın var mı?',
                      children: [
                    TextSpan(
                      recognizer: TapGestureRecognizer()
                        ..onTap = widget.onClickedSignIn,
                      text: 'Giriş Yap',
                      style: TextStyle(
                        decoration: TextDecoration.underline,
                        color: Theme.of(context).colorScheme.secondary,
                      ),
                    )
                  ])),
            ],
          ),
        ),
      );

  FirebaseAuth auth = FirebaseAuth.instance;

  Future KayitOl() async {
    final isValid = formKey.currentState!.validate();
    if (!isValid) return;

    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => Center(
              child: CircularProgressIndicator(),
            ));
    try {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );
    } on FirebaseAuthException catch (e) {
      print(e);

      Utils.showSnackBar(e.message);
    }
    navigatorKey.currentState!.popUntil((route) => route.isFirst);
    FirebaseFirestore.instance
        .collection('KullanıcıBilgisi')
        .doc(auth.currentUser?.uid)
        .set({
      'KullanıcıId': auth.currentUser?.uid,
      'Ad': t1.text,
      'Soyad': t2.text
    });
  }
}

final messengerKey = GlobalKey<ScaffoldMessengerState>();

class Utils {
  static var messengerKey;

  static showSnackBar(String? text) {
    if (text == null) return;

    final snackBar = SnackBar(
      content: Text(text),
      backgroundColor: Colors.red,
    );
  }
}

class sifreRes extends StatefulWidget {
  @override
  State<sifreRes> createState() => _sifreResState();
}

class _sifreResState extends State<sifreRes> {
  final formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  @override
  void dispose() {
    emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          title: Text('Şifreyi Sıfırla'),
        ),
        body: Padding(
          padding: EdgeInsets.all(16),
          child: Form(
            key: formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Şifresini yenilemek istediğiniz emailinizi giriniz',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 24,
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                TextFormField(
                  controller: emailController,
                  cursorColor: Colors.white,
                  textInputAction: TextInputAction.next,
                  decoration: InputDecoration(labelText: 'Email'),
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  validator: (email) =>
                      email != null && !EmailValidator.validate(email)
                          ? 'Geçerli email giriniz'
                          : null,
                ),
                SizedBox(
                  height: 20,
                ),
                ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                      minimumSize: Size.fromHeight(50), primary: Colors.green),
                  icon: Icon(
                    Icons.email_outlined,
                  ),
                  label: Text(
                    'Yenile',
                    style: TextStyle(fontSize: 24),
                  ),
                  onPressed: resetSifre,
                )
              ],
            ),
          ),
        ),
      );
  Future resetSifre() async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => Center(
        child: CircularProgressIndicator(),
      ),
    );

    try {
      await FirebaseAuth.instance
          .sendPasswordResetEmail(email: emailController.text.trim());

      Utils.showSnackBar('Email Gönderildi');
      Navigator.of(context).popUntil((route) => route.isFirst);
    } on FirebaseAuthException catch (e) {
      print(e);
      Utils.showSnackBar(e.message);
      Navigator.of(context).pop();
    }
  }
}

class VerifyEmailPage extends StatefulWidget {
  const VerifyEmailPage({ Key? key }) : super(key: key);

  @override
  State<VerifyEmailPage> createState() => _VerifyEmailPageState();
}

class _VerifyEmailPageState extends State<VerifyEmailPage> {
  bool isEmailVerified = false;
  bool canResendEmail = false;
  Timer? timer;
  @override
  void initState(){
    super.initState();

    isEmailVerified = FirebaseAuth.instance.currentUser!.emailVerified;
    if(!isEmailVerified){
      sendVerificationEmail();
      
      timer = Timer.periodic(
        Duration(seconds: 3),
        (_)=>checkEmailVerified(),
      );
    }
  }
  @override
  void dispose(){
    timer?.cancel();
    super.dispose();
  }

  Future checkEmailVerified()async{
    await FirebaseAuth.instance.currentUser!.reload();
    setState(() {
      isEmailVerified = FirebaseAuth.instance.currentUser!.emailVerified;
    });

    if(isEmailVerified) timer?.cancel();
  }
  Future sendVerificationEmail()async{
   try{ final user = FirebaseAuth.instance.currentUser!;
    await user.sendEmailVerification();

    setState(() => canResendEmail = false);
    await Future.delayed(Duration(seconds: 5));
    setState(()=> canResendEmail = true);
   } catch (e){
    Utils.showSnackBar(e.toString());
   }
  }
  Widget build(BuildContext context) =>
  isEmailVerified ? HomePage() : Scaffold(
    appBar: AppBar(title: Text('Email Doğrulama'),),
    body: Padding(padding: EdgeInsets.all(16),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text('Doğrulama maili gönderildi',
        style: TextStyle(fontSize: 20),
        textAlign: TextAlign.center,),
        SizedBox(height: 24,),
        ElevatedButton.icon(
          style: ElevatedButton.styleFrom(
            minimumSize: Size.fromHeight(50),
          ),
          icon: Icon(Icons.email,size: 32,),
          label: Text('Tekrar gönder',style: TextStyle(fontSize: 24),
          ),
          onPressed: canResendEmail ? sendVerificationEmail : null,
        ),
        SizedBox(height: 8,),
        TextButton(style: ElevatedButton.styleFrom(
          minimumSize: Size.fromHeight(50),
        ),
        child: Text('İptal',style: TextStyle(fontSize: 24),),
        onPressed: () => FirebaseAuth.instance.signOut(),
        )
      ],
    ),),
  );
}