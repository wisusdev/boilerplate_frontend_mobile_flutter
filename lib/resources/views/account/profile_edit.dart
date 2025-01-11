import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:boilerplate_frontend_mobile_flutter/app/helpers/location.dart';
import 'package:boilerplate_frontend_mobile_flutter/app/helpers/text.dart';
import 'package:boilerplate_frontend_mobile_flutter/app/services/account_service.dart';
import 'package:boilerplate_frontend_mobile_flutter/resources/widgets/input_decoration.dart';
import 'package:boilerplate_frontend_mobile_flutter/resources/widgets/snack_bar.dart';

class ProfileEdit extends StatefulWidget {
    const ProfileEdit({super.key});

    @override
    State<ProfileEdit> createState() => _ProfileEditState();
}

class _ProfileEditState extends State<ProfileEdit> {
    final _formKey = GlobalKey<FormState>();

    final TextEditingController _firstnameController = TextEditingController();
	final TextEditingController _lastnameController = TextEditingController();
	final TextEditingController _emailController = TextEditingController();
    final TextEditingController _avatarController = TextEditingController();
    final TextEditingController _languageController = TextEditingController();
    final ImagePicker _picker = ImagePicker();
    String _userKey = '';

    Map<String, dynamic> errorMessage = {
        'first_name': null,
        'last_name': null,
        'email': null,
        'avatar': null,
        'language': null,
    };

    XFile? _imageFile;

    @override
    void initState() {
        super.initState();

        SharedPreferences.getInstance().then((prefs) {
            var userJson = prefs.getString('user');
            var userKey = prefs.getString('user_key');

            if (userJson != null) {
                var user = json.decode(userJson);
                setState(() {
                    _firstnameController.text = user['first_name'] ?? '';
                    _lastnameController.text = user['last_name'] ?? '';
                    _emailController.text = user['email'] ?? '';
                    _avatarController.text = user['avatar'] ?? '';
                    _languageController.text = user['language'] ?? '';
                    _userKey = userKey ?? '';
                });
            }
        });
    }

    Future<void> _pickImage() async {
        final XFile? pickedFile = await _picker.pickImage(source: ImageSource.gallery);

        setState(() {
            _imageFile = pickedFile;
        });
    }

    @override
    Widget build(BuildContext context) {
        String userLanguageDropdownValue = _languageController.text.isEmpty ? 'es' : _languageController.text;

        return Scaffold(
            appBar: AppBar(
                leading: BackButton(
                    color: Theme.of(context).colorScheme.onPrimary,
                    onPressed: () {
                        Navigator.pop(context, 'update');
                    },
                ),
                title: Text(
                    capitalizeText('${Location.of(context)!.trans('edit')} ${Location.of(context)!.trans('profile')}'),
                    style: TextStyle(
                        color: Theme.of(context).colorScheme.onPrimary
                    )
                ),
                backgroundColor: Theme.of(context).colorScheme.primary,
            ),
            body: SingleChildScrollView(
                child: Container(
                    margin: const EdgeInsets.only(left: 20, right: 20, top: 30),
                    child: Form(
                        key: _formKey,
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                                Row(
                                    children: [
                                        Expanded(
                                            child: TextFormField(
                                                controller: _firstnameController,
                                                decoration: inputDecoration(labelText: Location.of(context)!.trans('firstName')),
                                                validator: (value) {
                                                    if (value!.isEmpty) {
                                                        return Location.of(context)!.trans('validation.thisFieldIsRequired');
                                                    }
                
                                                    if(errorMessage['first_name'] != null){
                                                        return errorMessage['first_name'];
                                                    }
                                                    
                                                    return null;
                                                },
                                            ),
                                        ),
                                        const SizedBox(width: 10),
                                        Expanded(
                                            child: TextFormField(
                                                controller: _lastnameController,
                                                decoration: inputDecoration(labelText: Location.of(context)!.trans('lastName')),
                                                validator: (value) {
                                                    if (value!.isEmpty) {
                                                        return Location.of(context)!.trans('validation.thisFieldIsRequired');
                                                    }
                
                                                    if(errorMessage['last_name'] != null){
                                                        return errorMessage['last_name'];
                                                    }
                
                                                    return null;
                                                },
                                            ),
                                        )
                                    ],
                                ),
                
                                const SizedBox(height: 20),
                
                                TextFormField(
                                    controller: _emailController,
                                    keyboardType: TextInputType.emailAddress,
                                    decoration: inputDecoration(labelText: Location.of(context)!.trans('email')),
                                    validator: (value) {
                                        if (value!.isEmpty) {
                                            return Location.of(context)!.trans('validation.thisFieldIsRequired');
                                        }
                
                                        if(errorMessage['email'] != null){
                                            return errorMessage['email'];
                                        }
                
                                        return null;
                                    },
                                ),
                
                                const SizedBox(height: 20),
                
                                InputDecorator(
                                    decoration: inputDecoration(labelText: Location.of(context)!.trans('language')),
                                    child: DropdownButtonHideUnderline(
                                        child: DropdownButton<String>(
                                        value: userLanguageDropdownValue,
                                        isDense: true,
                                        onChanged: (String? value) {
                                            setState(() {
                                            userLanguageDropdownValue = value!;
                                            _languageController.text = value;
                                            });
                                        },
                                        items: <String>['es', 'en']
                                            .map<DropdownMenuItem<String>>((String value) {
                                            return DropdownMenuItem<String>(
                                                value: value,
                                                child: Text(Location.of(context)!.trans(value)),
                                            );
                                            })
                                            .toList(),
                                        ),
                                    ),
                                ),
                
                                const SizedBox(height: 20),
                                
                                ElevatedButton(
                                    onPressed: _pickImage,
                                    child: Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                            const Icon(Icons.camera_alt),
                                            const SizedBox(width: 10),
                                            Text(Location.of(context)!.trans('selectAPicture')),
                                        ],
                                    ),
                                ),

                                _imageFile != null ? const SizedBox(height: 20) : Container(),

                                Center(
                                    child: _imageFile != null ? Container(
                                        height: 200,
                                        width: 200,
                                        padding: const EdgeInsets.all(4),
                                        decoration: BoxDecoration(border: Border.all(color: Theme.of(context).colorScheme.primary, width: 3), borderRadius: BorderRadius.circular(10)),
                                        child: Image.file(File(_imageFile!.path)),
                                    ) : Container(),
                                ),

                                const SizedBox(height: 40),
                
                                ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                        backgroundColor: Theme.of(context).colorScheme.primary,
                                        padding: const EdgeInsets.all(13),
                                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                                    ),
                                    child: Center(
                                        child: Text(Location.of(context)!.trans('save'), style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontFamily: "Sofia",
                                            color: Theme.of(context).colorScheme.onPrimary,
                                            fontSize: 18.0
                                        ))
                                    ),
                                    onPressed: () {
                                        resetErrorMessages();
                                        if (_formKey.currentState!.validate()) {
                                            updateProfile(context);
                                        }
                                    },
                                )
                            ],
                        )
                    ),
                ),
            ),
        );
    }

    void updateProfile(context) async {

        Map<String, String> data = {
            'type': 'profile',
            'id': _userKey,
            'first_name': _firstnameController.text,
            'last_name': _lastnameController.text,
            'email': _emailController.text,
            'language': _languageController.text,
        };

        if(_imageFile != null){
            final File file = File(_imageFile!.path);
            final List<int> imageBytes = await file.readAsBytes();
            final String base64Image = base64Encode(imageBytes);
            data['avatar'] = base64Image;
        }

        Map<String, dynamic> profileEditResponse = await AccountService().updateProfile(data: data);

        if(profileEditResponse.containsKey('data')) {
            toastSuccess(context, Location.of(context)!.trans('recordUpdated'));
        }

        if(profileEditResponse.containsKey('errors')){
            var errors = profileEditResponse['errors'];
            
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
                'first_name': null,
                'last_name': null,
                'email': null,
                'avatar': null,
                'language': null,
            };
        });
    }
}