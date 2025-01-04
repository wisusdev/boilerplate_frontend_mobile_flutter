import 'package:flutter/material.dart';
import 'package:boilerplate_frontend_mobile_flutter/app/helpers/location.dart';
import 'package:boilerplate_frontend_mobile_flutter/app/services/auth_service.dart';
import 'package:boilerplate_frontend_mobile_flutter/config/app.dart';
import 'package:boilerplate_frontend_mobile_flutter/resources/views/auth/login.dart';
import 'package:boilerplate_frontend_mobile_flutter/resources/widgets/snack_bar.dart';

class AuthForgotPassword extends StatefulWidget {
  	const AuthForgotPassword({super.key});

  	@override
  	State<AuthForgotPassword> createState() => _AuthForgotPasswordState();
}

class _AuthForgotPasswordState extends State<AuthForgotPassword> {
	final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

    final TextEditingController _emailController = TextEditingController();

    Map<String, dynamic> errorMessage = {
        'email': null,
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
                                                    return Location.of(context)!.trans('validation.emailRequired');
                                                }

                                                if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
                                                    return Location.of(context)!.trans('validation.emailEmail');
                                                }

                                                if(errorMessage['email'] != null){
                                                    return errorMessage['email'];
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
                                                resetErrorMessages();

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
                                                        Navigator.pushAndRemoveUntil(
                                                            context, 
                                                            MaterialPageRoute(builder: (context) => const AuthLogin()), 
                                                            (route) => false
                                                        );
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

        Map<String, dynamic> responseForgotPassword = await AuthService().forgotPassword(data: data);
        
        if(responseForgotPassword.containsKey('data')){
            toastSuccess(context, Location.of(context)!.trans('message.emailVerificationSent'));
            Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const AuthLogin()));
        }

        if(responseForgotPassword.containsKey('errors')){
            var errors = responseForgotPassword['errors'];
            if(errors is List){
                for(var error in errors){
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
            };
        });
    }
}
