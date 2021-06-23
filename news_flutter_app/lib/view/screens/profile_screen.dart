import 'package:flutter/material.dart';
import 'package:news_flutter_app/view/screens/login_screen.dart';
import 'package:news_flutter_app/view/widgets/common_ui.dart';
import 'package:news_flutter_app/viewmodel/profile_viewmodel.dart';
import 'package:provider/provider.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ProfileView();
  }
}

class ProfileView extends StatelessWidget {
  const ProfileView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final vm = Provider.of<ProfileViewModel>(context);
    vm.validateHaveAccount();
    return Scaffold(
      appBar: new AppBar(
        title: Text('ProfileView'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            vm.getUserInfo != null
                ? AppText.body(vm.getUserInfo!.username)
                : vm.doHaveAccount != null && vm.doHaveAccount == true
                    ? _buildLogin(vm.login, context, vm.createNewAccount)
                    : _buildSignUp(vm.createNewAccount),
          ],
        ),
      ),
    );
  }

  Widget _buildLogin(Function login, BuildContext context, Function signup) {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Column(
        children: [
          AppText.h2('Bạn chưa đăng nhập'),
          AppText.body('Vui lòng đăng nhập để tiếp tục'),
          AuthenForm(
            buttonText: 'Login',
            onSubmit: login,
          ),
          SizedBox(height: 20),
          GestureDetector(
              onTap: () {
                showModalBottomSheet(
                    isScrollControlled: true,
                    context: context,
                    builder: (context) {
                      return _buildSignUp(signup);
                    });
              },
              child: AppText.body('Create a new account'))
        ],
      ),
    );
  }

  Widget _buildSignUp(Function signup) {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Column(
        children: [
          AppText.h2('Đăng ký'),
          AppText.body('Vui lòng điền thông tin bên dưới'),
          AuthenForm(
            buttonText: 'SignUp',
            onSubmit: signup,
          )
        ],
      ),
    );
  }
}
