import 'package:flutter/material.dart';
import 'package:news_flutter_app/view/shared/app_styles.dart';
import 'package:news_flutter_app/view/widgets/common_ui.dart';

class LoginView extends StatelessWidget {
  final Function login;
  final Function? signUp;
  final BuildContext? parentCtx;
  const LoginView({
    Key? key, required this.login, this.signUp, this.parentCtx}) :
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        children: [
          AppText.h2Bitter('Bạn chưa đăng nhập'),
          SizedBox(height: 12,),
          AppText.bodyBitter('Vui lòng đăng nhập để tiếp tục'),
          SizedBox(height: 12,),
          AuthenForm(
            buttonText: 'Login',
            onSubmit: login,
          ),
          SizedBox(height: signUp != null && parentCtx != null ? 20 : 0),
          signUp != null && parentCtx != null ? GestureDetector(
              onTap: () {
                showModalBottomSheet(
                    isScrollControlled: true,
                    context: parentCtx!,
                    builder: (context) {
                      return SignUpView(signUp: signUp!);
                    });
              },
              child: AppText.captionBitter('Create a new account'),
          ) : SizedBox()
        ],
      ),
    );
  }
}


class SignUpView extends StatelessWidget {
  final Function signUp;
  const SignUpView({
    Key? key, required this.signUp})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            AppText.h2Bitter('Đăng ký'),
            SizedBox(height: 12,),
            AppText.captionBitter('Vui lòng điền thông tin bên dưới'),
            SizedBox(height: 12,),
            AuthenForm(
              buttonText: 'SignUp',
              onSubmit: signUp,
            ),
          ],
        ),
      ),
    );
  }
}



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
          CustomTextFormField(
            controller: usernameController,
            hint: 'bluez, nguyenphuong, ...',
            label: 'Username *',
          ),
          SizedBox(height: 20),
          CustomTextFormField(
            obscure: true,
            controller: passwordController,
            hint: '',
            label: 'Password *',
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
          SizedBox(height: 40),
          MaterialButton(
            minWidth: 200,
            height: 50,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(18.0),
                side: BorderSide(color: Colors.black)
            ),
            child: AppText.bodyBitter(widget.buttonText),
            onPressed: () {
              widget.onSubmit(usernameController.text, passwordController.text);
            },
            color: Colors.black,
          )
        ],
      ),
    );
  }
}

class CustomTextFormField extends StatelessWidget {
  final TextEditingController controller;
  final String hint;
  final String label;
  final bool? obscure;
  const CustomTextFormField({
    Key? key, required this.controller, required this.hint, required this.label, this.obscure = false})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      obscureText: obscure!,
      controller: controller,
      decoration: InputDecoration(
          hintText: hint,
          labelText: label,
          labelStyle: TextStyle(color: Colors.black).merge(headlineStyleBitter),
          focusColor: Colors.black,
          focusedBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.black),
            //  when the TextFormField in focused
          ),
          border: new UnderlineInputBorder(
              borderSide: new BorderSide(
                  color: Colors.black
              )
          )
      ),
      cursorColor: Colors.black,
      style: bodyStyleBitter,
    );
  }
}
