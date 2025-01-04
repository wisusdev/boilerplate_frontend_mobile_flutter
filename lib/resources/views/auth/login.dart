import 'package:flutter/material.dart';
import 'package:boilerplate_frontend_mobile_flutter/app/helpers/location.dart';
import 'package:boilerplate_frontend_mobile_flutter/app/services/auth_service.dart';
import 'package:boilerplate_frontend_mobile_flutter/resources/views/home.dart';
import 'package:boilerplate_frontend_mobile_flutter/resources/widgets/input_decoration.dart';
import 'package:boilerplate_frontend_mobile_flutter/resources/widgets/snack_bar.dart';
import 'package:boilerplate_frontend_mobile_flutter/config/app.dart';

class AuthLogin extends StatefulWidget {
	const AuthLogin({super.key});
	
	@override
  	State<AuthLogin> createState() => _AuthLoginState();
}

class _AuthLoginState extends State<AuthLogin> {
  	final _formKey = GlobalKey<FormState>();

    final TextEditingController _emailController = TextEditingController();
	final TextEditingController _passwordController = TextEditingController();

    Map<String, dynamic> errorMessage = {
        'email': null,
        'password': null,
    };

  	@override
  	Widget build(BuildContext context) {
        final size = MediaQuery.of(context).size;

		return GestureDetector(
            onTap: () => FocusScope.of(context).unfocus(),
            child: Scaffold(
                body: SingleChildScrollView(
                    reverse: true,
                    padding: EdgeInsets.only(left: 20, right: 20, top: size.height * 0.08, bottom: size.height * 0.06),
                    child: Form(
                        key: _formKey,
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                                Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                        const Row(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: [
                                                Image(image: AssetImage(logoApp), width: 80, height: 80,),
                                            ],
                                        ),
                                        
                                        const SizedBox(height: 40),
                                        
                                        Text(Location.of(context)!.trans('welcomeBack'), style: const TextStyle(fontSize: 31, fontWeight: FontWeight.w100)),
                                        
                                        const SizedBox(height: 10),
                                        
                                        TextFormField(
                                            controller: _emailController,
                                            keyboardType: TextInputType.emailAddress,
                                            decoration: inputDecoration(labelText: Location.of(context)!.trans('email')),
                                            validator: (value) {
                                                if (value!.isEmpty) {
                                                    return Location.of(context)!.trans('validation.emailRequired');
                                                }

                                                if (!RegExp(r'^[\w-.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
                                                    return Location.of(context)!.trans('validation.emailEmail');
                                                }

                                                if(errorMessage['email'] != null){
                                                    return errorMessage['email'];
                                                }
                                                
                                                return null;
                                            },
                                        ),

                                        const SizedBox(height: 10),

                                        TextFormField(
                                            controller: _passwordController,
                                            keyboardType: TextInputType.visiblePassword,
                                            obscureText: true,
                                            decoration: inputDecoration(labelText: Location.of(context)!.trans('password')),
                                            validator: (value) {
                                                if (value!.isEmpty) {
                                                    return 'Por favor ingresa tu contraseña';
                                                }

                                                if (value.length < 8) {
                                                    return 'La contraseña debe tener al menos 8 caracteres';
                                                }

                                                if(errorMessage['password'] != null){
                                                    return errorMessage['password'];
                                                }

                                                return null;
                                            }
                                        ),

                                        const SizedBox(height: 20),
                                        
                                        Row(
                                            mainAxisAlignment: MainAxisAlignment.end,
                                            children: [
                                                InkWell(
                                                    onTap: () {
                                                        Navigator.pushNamed(context, 'forgot_password');
                                                    },
                                                    child: Text(Location.of(context)!.trans('forgotPassword'), style: const TextStyle(fontWeight: FontWeight.w500, fontFamily: 'Sofia')),
                                                ),
                                            ],
                                        ),
                                        
                                        const SizedBox(height: 40),

                                        ElevatedButton(
                                            style: ElevatedButton.styleFrom(
                                                backgroundColor: Color(Theme.of(context).colorScheme.primary.value),
                                                padding: const EdgeInsets.all(13),
                                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                                            ),
                                            child: Center(
                                                child: Text(Location.of(context)!.trans('login'), style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontFamily: "Sofia",
                                                    color: Color(Theme.of(context).colorScheme.onPrimary.value),
                                                    fontSize: 18.0
                                                ))
                                            ),
                                            onPressed: () {
                                                resetErrorMessages();

                                                if (_formKey.currentState!.validate()) {
                                                    _formKey.currentState!.save();

                                                    login(context);
                                                }
                                            },
                                        ),
                                    ],
                                ),

                                const SizedBox(height: 40),

                                Column(
                                    children: [
                                        Row(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: [
                                                InkWell(
                                                    onTap: () {
                                                        Navigator.pushNamed(context, 'register');
                                                    },
                                                    child: Text(Location.of(context)!.trans('registerHere'), style: const TextStyle(fontFamily: 'Sofia'))
                                                ),
                                            ],
                                        ),
                                    ],
                                )
                            ],
                        ),
                    ),
                )
            ),
        );
    }

    void login(context) async {

        Map<String, String> data = {
            'type': 'users',
            'email': _emailController.text,
            'password': _passwordController.text,
        };

        Map<String, dynamic> loginResponse = await AuthService().login(data: data);

        if(loginResponse.containsKey('data')){
            Navigator.pushAndRemoveUntil(
                context, 
                MaterialPageRoute(builder: (context) => const HomeView()), 
                (route) => false
            );
        } 
        
        if(loginResponse.containsKey('errors')){
            var errors = loginResponse['errors'];

            if(errors is List){
                for (var error in errors) {
                    String title = error['title'];
                    List<String> titleList = title.split('.');

                    errorMessage[titleList.last] = Location.of(context)!.trans(error['detail']);
                }
            }
            
            toastDanger(context, Location.of(context)!.trans('errorAsOccurred'));

            _formKey.currentState!.validate();
        }
    }

    resetErrorMessages(){
        setState(() {
            errorMessage = {
                'email': null,
                'password': null,
            };
        });
    }
}