import 'package:flutter/material.dart';
import 'package:frontend/service/auth/auth_service.dart';
import 'package:frontend/views/lobby.dart';
import 'package:frontend/views/signin.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {

  final _auth = AuthService();
  final _emailCtrl = TextEditingController();
  final _passCtrl = TextEditingController();

  FocusNode email_fs = FocusNode();
  FocusNode password_fs = FocusNode();

  bool isEmailFocused = false;
  bool isPasswordFocused = false;
  bool hiding_pass = true;

  String? _emailError;
  String? _passError;

// Colores personalizados
  Color _colorWarning = Colors.orangeAccent;
  Color _colorError = Colors.redAccent;


  @override
  void initState(){
    super.initState();

    email_fs.addListener(() {
      setState(() {
        isEmailFocused = email_fs.hasFocus;
      });
    });

    password_fs.addListener(() {
      setState(() {
        isPasswordFocused = password_fs.hasFocus;
      });
    });

  }

  @override
  void dispose(){
    super.dispose();
    email_fs.dispose();
    password_fs.dispose();
  }

  void_goToRegister(BuildContext context) {
    Navigator.of(context).push(_createRouteToRegister());
  }

  Route _createRouteToRegister(){
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) =>
        SigninPage(),
      transitionsBuilder: (context, animation, secondaryAnimation, child){
        const begin = Offset(1.0, 0.0);
        const end = Offset.zero;
        const curve = Curves.easeInOut;
        
        var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
        return SlideTransition(position: animation.drive(tween), child: child);

      }
    );
  }




  Future<void> _submit() async {
    setState(() {
      _emailError = null;
      _passError = null;
    });
    final email = _emailCtrl.text.trim();
    final password = _passCtrl.text.trim();

    if (email.isEmpty || password.isEmpty){
      setState(() {
        if (email.isEmpty) _emailError = "Falta rellenar este campo";
        if (password.isEmpty) _passError = "Falta rellenar este campo";        
      });
      return;
    }

    try {
      final success = await _auth.signIn(email, password);

      if(success){
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const HomePage())
        );
      }

    }on AuthException catch (e){
      print(e);
      setState(() {
        _emailError = "Este usuario no existe";
        _passError = "Esta contraseña no existe";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox.expand(
        child: Stack(
          children: [
          Positioned.fill(
            child: Image.asset(
              "assets/images/Diseño_inicial_pantalla_login_singup.png",
              fit: BoxFit.cover,
            ),
          ),
          Positioned.fill(
            child: Container(
              color: const Color.fromARGB(255, 0, 49, 96).withValues(alpha: 0.5), 
            ),
          ),
            Align(
              alignment: Alignment.centerRight,
              child: Container(
                width: MediaQuery.of(context).size.width * 0.5,
                height: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30),
                    bottomLeft: Radius.circular(30)
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.2),
                      blurRadius: 30,
                      offset: const Offset(-10, 0), 
                    ),
                  ],
                ),
                
                child: Center(
                  child: SingleChildScrollView(
                    padding: EdgeInsets.symmetric(horizontal: 60),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Bienvenido de nuevo!",
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 30,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 100),
                        SizedBox(
                          width: 350,
                          child: TextFormField(
                            cursorColor: Colors.black,
                            controller: _emailCtrl,
                            focusNode: email_fs,
                            onChanged: (value) {
                              if (_emailError != null) setState(() => _emailError = null);
                            },
                            decoration: InputDecoration(
                              errorText: _emailError,
                              errorStyle: TextStyle(
                                color: _emailError == "Falta rellenar este campo" ? _colorWarning : _colorError,
                                fontWeight: FontWeight.bold,
                              ),
                              label: isEmailFocused ? Icon(
                                Icons.email_rounded,
                                color: Colors.black) : null,
                              labelText: isEmailFocused ? null : "Email",
                              labelStyle: TextStyle(
                                color: (isEmailFocused || _emailCtrl.text.isNotEmpty) ? Colors.black : Colors.grey,
                          
                              ),
                              suffixIcon: isEmailFocused ? null : Icon(Icons.email_rounded, color: _emailCtrl.text.isEmpty ? Colors.grey : Colors.black),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(30),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(30),
                                borderSide: BorderSide(
                                  color: _emailCtrl.text.isEmpty ? Colors.grey : Colors.black,
                                  width: 2.0,
                                )
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(30),
                                borderSide: BorderSide(
                                  color: Colors.black,
                                  width: 2.0,
                                )
                              ),
                              errorBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(30),
                                borderSide: BorderSide(
                                  color: _emailError == "Falta rellenar este campo" ? _colorWarning : _colorError,
                                  width: 2.0,
                                ),
                              ),
                              focusedErrorBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(30),
                                borderSide: BorderSide(
                                  color: _emailError == "Falta rellenar este campo" ? _colorWarning : _colorError,
                                  width: 2.0,
                                ),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: 50),
                        SizedBox(
                          width: 350,
                          child: TextFormField(
                            controller: _passCtrl,
                            focusNode: password_fs,
                            obscureText: hiding_pass,
                            onChanged: (value) {
                              if (_passError != null) setState(() => _passError = null);
                            },
                            decoration: InputDecoration(
                              errorText: _passError,
                              errorStyle: TextStyle(
                                color: _passError == "Falta rellenar este campo" ? _colorWarning : _colorError,
                                fontWeight: FontWeight.bold,
                              ),
                              label: isPasswordFocused ? Icon(
                                Icons.password_rounded,
                                color: Colors.black) : null,
                              labelText: isPasswordFocused ? null : "Contraseña",
                              labelStyle: TextStyle(
                                color: (isPasswordFocused || _passCtrl.text.isNotEmpty) ? Colors.black : Colors.grey,
                              ),
                              suffixIcon: isPasswordFocused ? (hiding_pass ? IconButton(
                              onPressed: () {
                                setState(() {
                                  hiding_pass = !hiding_pass;    
                                });
                              }, 
                              icon: Icon(Icons.visibility_rounded, color: Colors.black)) : IconButton(
                                onPressed: () {
                                  setState(() {
                                    hiding_pass = !hiding_pass;
                                  });
                                }, 
                              icon: Icon(Icons.visibility_off_rounded, color: Colors.black))) : Icon(Icons.password_rounded, color: _passCtrl.text.isEmpty ? Colors.grey : Colors.black),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(30),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(30),
                                borderSide: BorderSide(
                                  color: _passCtrl.text.isEmpty ? Colors.grey : Colors.black,
                                  width: 2.0,
                                )
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(30),
                                borderSide: BorderSide(
                                  color: Colors.black,
                                  width: 2.0,
                                )
                              ),
                              errorBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(30),
                                borderSide: BorderSide(
                                  color: _passError == "Falta rellenar este campo" ? _colorWarning : _colorError,
                                  width: 2.0,
                                ),  
                              ),
                              focusedErrorBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(30),
                                borderSide: BorderSide(
                                  color: _passError == "Falta rellenar este campo" ? _colorWarning : _colorError,
                                  width: 2.0,
                                ),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: 50),
                        SizedBox(
                          width: 100,
                          child: ElevatedButton(
                            onPressed: _submit, 
                            style: ButtonStyle(
                              backgroundColor: WidgetStateProperty.all(Color.fromARGB(255, 0, 49, 96)),
                              shape: WidgetStateProperty.all<RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20),
                                )
                              )
                            ),
                            child: Center(
                              child: Text(
                                "Login",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold
                                ),
                                ),
                            )
                          ),
                        ),
                        SizedBox(height: 70),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [              
                            Text(
                              "No tienes una cuenta?",
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 16,
                                fontWeight: FontWeight.w600
                              ),
                            ),
                            SizedBox(width: 10),
                            ElevatedButton(
                              onPressed: () => void_goToRegister(context), 
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Color.fromARGB(255, 0, 49, 96)
                              ),
                              child: Text(
                                "Regístrate",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold
                                ),
                              )
                            )
                          ],
                        )        
                      ],
                    ),
                  ),
                )
              ),
            ),          
          ],
        ),
      )
    );
  }

}
