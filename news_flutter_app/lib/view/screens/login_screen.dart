import 'package:flutter/material.dart';
import 'package:news_flutter_app/view/widgets/common_ui.dart';

class AuthenForm extends StatefulWidget {
  final String buttonText;
  final Function onSubmit;
  const AuthenForm({Key? key, required this.buttonText, required this.onSubmit})
      : super(key: key);

  @override
  _AuthenFormState createState() => _AuthenFormState();
}

class _AuthenFormState extends State<AuthenForm> {
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).requestFocus(new FocusNode()),
      child: Column(
        children: [
          TextFormField(
            controller: usernameController,
            decoration: InputDecoration(
                hintText: 'bluez, nguyenphuong, ...', labelText: 'Username *'),
          ),
          SizedBox(height: 20),
          TextFormField(
            obscureText: true,
            controller: passwordController,
            decoration: InputDecoration(labelText: 'Password *'),
          ),
          // TextInputView(
          //   label: 'Username',
          //   placeHolder: 'Username',
          //   textController: usernameController,
          //   maxLines: 1,
          //   autoFocus: true,
          // ),
          // SizedBox(height: 20),
          // TextInputView(
          //   label: 'Password',
          //   placeHolder: 'Password',
          //   maxLines: 1,
          //   textController: passwordController,
          // ),
          MaterialButton(
            child: AppText.body(widget.buttonText),
            onPressed: () {
              widget.onSubmit(usernameController.text, passwordController.text);
            },
          )
        ],
      ),
    );
  }
}
