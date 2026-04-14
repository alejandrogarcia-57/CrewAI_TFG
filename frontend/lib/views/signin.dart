import 'package:flutter/material.dart';
import 'package:frontend/service/auth/auth_service.dart';
import 'package:frontend/views/login.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class SigninPage extends StatefulWidget {
  const SigninPage({super.key});

  @override
  State<SigninPage> createState() => _SigninPageState();
}

class _SigninPageState extends State<SigninPage> {

  final _auth = AuthService();
  final _userCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _passCtrl = TextEditingController();

  FocusNode user_fs = FocusNode();
  FocusNode email_fs = FocusNode();
  FocusNode password_fs = FocusNode();

  bool isUserFocused = false;
  bool isEmailFocused = false;
  bool isPasswordFocused = false;
  bool hiding_pass = true;

  // Variables para mensajes de error
  String? _userError;
  String? _emailError;
  String? _passError;


  // Colores personalizados
  Color _colorWarning = Colors.orangeAccent;
  Color _colorError = Colors.redAccent;

  @override
  void initState(){
    super.initState();

    user_fs.addListener(() {
      setState(() {
        isUserFocused = user_fs.hasFocus;
      });
    });

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
  void dispose() {
    super.dispose();
    _userCtrl.dispose();
    _emailCtrl.dispose();
    _passCtrl.dispose();
  }
  


  void _goToLogin(BuildContext context){
    Navigator.of(context).push(_createRouteToLogin());
  }

  Route _createRouteToLogin(){
    return PageRouteBuilder(
      pageBuilder:(context, animation, secondaryAnimation) => 
        LoginPage(),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        const begin = Offset(-1.0, 0.0);
        const end = Offset.zero;
        const curve = Curves.easeInOut;

        var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
        return SlideTransition(position: animation.drive(tween), child: child);
      },
    );
  }
  
  Future<void> _create() async {
  final supabase = Supabase.instance.client;
  
  final email = _emailCtrl.text.trim();
  final password = _passCtrl.text.trim();
  final username = _userCtrl.text.trim(); 

  if (username.isEmpty || email.isEmpty || password.isEmpty) {
    setState(() {
      if (username.isEmpty) _userError = "Falta rellenar este campo";
      if (email.isEmpty) _emailError = "Falta rellenar este campo";
      if (password.isEmpty) _passError = "Falta rellenar este campo";
    });
    return; 
  }

  try {

    final String? res = await _auth.signUp(
      email, 
      password);

      if (res != null) {

      await supabase.from('users').insert({
        'id': res,        
        'username': username,
        'email': email,
      });

      
      _emailCtrl.clear();
      _passCtrl.clear();
      _userCtrl.clear();
    }   

  } on AuthException catch (e) {
    print(e);
    setState(() {
      _userError = "Error, introduce de nuevo el usuario";
      _emailError = "Error, introduce de nuevo el email";
      _passError = "Error, introduce de nuevo la contraseña";
    });
  } catch (e) {
    print(e);
    setState(() {
      _userError = "Error, introduce de nuevo el usuario";
      _emailError = "Error, introduce de nuevo el email";
      _passError = "Error, introduce de nuevo la contraseña";
    });
  }
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
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
            alignment: Alignment.centerLeft,
            child: Container(
              width: MediaQuery.of(context).size.width * 0.5,
              height: double.infinity,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topRight: Radius.circular(30),
                  bottomRight: Radius.circular(30)
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
                        "Empieza a jugar ahora!",
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 26,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text(
                        "Registra tus datos",
                        style: TextStyle(
                          color: Colors.grey,
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      SizedBox(height: 75),
                      SizedBox(
                        width: 350,
                        child: TextFormField(
                            cursorColor: Colors.black,
                            controller: _userCtrl,
                            focusNode: user_fs,
                            onChanged: (value) {
                              if (_userError != null) setState(() => _userError = null);
                            },
                            decoration: InputDecoration(
                              errorText: _userError,
                              errorStyle: TextStyle(
                                color: _emailError == "Falta rellenar este campo" ? _colorWarning : _colorError,
                                fontWeight: FontWeight.bold,
                              ),
                              label: isUserFocused ? Icon(
                                Icons.person_rounded,
                                color: Colors.black) : null,
                              labelText: isUserFocused ? null : "Nombre",
                              labelStyle: TextStyle(
                                color: (isUserFocused || _userCtrl.text.isNotEmpty) ? Colors.black : Colors.grey,
                        
                              ),
                              suffixIcon: isUserFocused ? null : Icon(Icons.person_rounded, color: _userCtrl.text.isEmpty ? Colors.grey : Colors.black),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(30),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(30),
                                borderSide: BorderSide(
                                  color: _userCtrl.text.isEmpty ? Colors.grey : Colors.black,
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
                                  color: _userError == "Falta rellenar este campo" ? _colorWarning : _colorError, 
                                  width: 2.0
                                ),
                              ),
                              focusedErrorBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(30),
                                borderSide: BorderSide(
                                  color: _userError == "Falta rellenar este campo" ? _colorWarning : _colorError, 
                                  width: 2.5
                                ),
                              ),
                            ),
                          ),
                      ),
                      SizedBox(height: 50),
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
                                  width: 2.0
                                ),
                              ),
                              focusedErrorBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(30),
                                borderSide: BorderSide(
                                  color: _emailError == "Falta rellenar este campo" ? _colorWarning : _colorError, 
                                  width: 2.0
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
                                  width: 2.0
                                ),
                              ),
                              focusedErrorBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(30),
                                borderSide: BorderSide(
                                  color: _passError == "Falta rellenar este campo" ? _colorWarning : _colorError, 
                                  width: 2.0
                                ),
                              ),
                            ),
                          ),
                      ),
                      SizedBox(height: 50),
                      SizedBox(
                        width: 250,
                        child: ElevatedButton(
                          onPressed: _create, 
                          style: ButtonStyle(
                            backgroundColor: WidgetStateProperty.all<Color>(Color.fromARGB(255, 0, 49, 96)),
                            padding: WidgetStateProperty.all<EdgeInsets>(EdgeInsets.symmetric(vertical: 15)),
                            shape: WidgetStateProperty.all<RoundedRectangleBorder>(
                              RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30.0),
                              )
                            )
                          ),
                          child: Center(
                            child: Text(
                              "Create an account",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.bold
                              ),
                            ),
                          )
                        ),
                      ),
                      SizedBox(height: 50),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Ya estas registrado?",
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 16,
                              fontWeight: FontWeight.w600
                            ),
                          ),
                          SizedBox(width: 10),
                          ElevatedButton(
                            onPressed: () => _goToLogin(context), 
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Color.fromARGB(255, 0, 49, 96)
                            ),
                            child: Text(
                              "Inicia sesión",
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
                )
              ),
            )

          )
        ],
      )      
    );
  }
}

