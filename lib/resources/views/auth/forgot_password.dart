import 'package:flutter/material.dart';
import 'package:todolist_flutter/app/helpers/location.dart';
import 'package:todolist_flutter/app/services/auth_service.dart';
import 'package:todolist_flutter/config/app.dart';
import 'package:todolist_flutter/resources/widgets/snack_bar.dart';

class AuthForgotPassword extends StatefulWidget {
  	const AuthForgotPassword({super.key});

  	@override
  	State<AuthForgotPassword> createState() => _AuthForgotPasswordState();
}

class _AuthForgotPasswordState extends State<AuthForgotPassword> {
	final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

    final TextEditingController _emailController = TextEditingController();
  	
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
                                    children: [
                                        const Row(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: [
                                                Image(image: AssetImage(logoApp), width: 80, height: 80,),
                                            ],
                                        ),

                                        const SizedBox(height: 20),

                                        Text(Location.of(context)!.trans('resetPassword'), style: const TextStyle( fontSize: 31, fontWeight: FontWeight.w100)),

                                        const SizedBox(height: 20),

                                        TextFormField(
                                            controller: _emailController,
                                            keyboardType: TextInputType.emailAddress,
                                            decoration: InputDecoration(
                                                labelText: Location.of(context)!.trans('email'),
                                                border: OutlineInputBorder(
                                                    borderRadius: BorderRadius.circular(20),
                                                    borderSide: const BorderSide(color: Colors.transparent)
                                                ),
                                            ),
                                            validator: (value) {
                                                if (value!.isEmpty) {
                                                return 'Por favor ingresa tu correo electrónico';
                                            }

                                            if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
                                                return 'Por favor ingresa un correo electrónico válido';
                                            }

                                            return null;
                                            },
                                        ),

                                        const SizedBox(height: 40),

                                        ElevatedButton(
                                            style: ElevatedButton.styleFrom(
                                                backgroundColor: Color(Theme.of(context).colorScheme.primary.value),
                                                padding: const EdgeInsets.all(13),
                                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                                            ),
                                            child: Center(
                                                child: Text(Location.of(context)!.trans('sendPasswordResetLink'), style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontFamily: "Sofia",
                                                    color: Color(Theme.of(context).colorScheme.onPrimary.value),
                                                    fontSize: 18.0
                                                ))
                                            ),
                                            onPressed: (){
                                                if (_formKey.currentState!.validate()) {
                                                    _formKey.currentState!.save();

                                                    forgotPassword(context);
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
                                                        Navigator.pushNamed(context, 'login');
                                                    },
                                                    child: Text(Location.of(context)!.trans('login'), style: const TextStyle(fontFamily: 'Sofia'))
                                                )
                                            ],
                                        )
                                    ],
                                )
                            ],
                        ),
                    ),
                ),
            ),
        );
  	}

    void forgotPassword(context) async {

        Map<String, String> data = {
            'type': 'users',
            'email': _emailController.text,
        };

        var responseForgotPassword = await AuthService().forgotPassword(data: data);
        
        if(responseForgotPassword){
            Navigator.pushNamed(context, 'login');
        } else {
            getScafoldMessage(context, 'No se pudo enviar el correo de recuperación de contraseña');
        }
    }
}
