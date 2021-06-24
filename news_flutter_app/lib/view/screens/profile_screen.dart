import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:news_flutter_app/model/user_entity.dart';
import 'package:news_flutter_app/view/widgets/authentication_view.dart';
import 'package:news_flutter_app/view/widgets/common_ui.dart';
import 'package:news_flutter_app/viewmodel/profile_viewmodel.dart';
import 'package:news_flutter_app/viewmodel/sign_up_viewmodel.dart';
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
        title: AppText.h2Bitter('Profile'),
      ),
      body: SingleChildScrollView(
        child: Column(
            children: [
              vm.getUserInfo != null
                  ? _buildProfile(vm.getUserInfo!, vm.logout)
                  : vm.doHaveAccount != null && vm.doHaveAccount == true
                  ? Column(
                    children: [
                      LoginView(
                          login: vm.login,
                          errorText: vm.getErrorMessage,
                      ),
                      GestureDetector(
                        onTap: () {
                          _openSignUpBottomPopup(context, vm);
                        },
                        child: AppText.captionBitter('Create a new account'),
                      )
                    ],
                  )
                  : SignUpView(signUp: vm.createNewAccount, errorText: vm.getErrorMessage),
            ],
          ),
        )
    );
  }

  void _openSignUpBottomPopup(BuildContext parentContext, ProfileViewModel vm) {
    showModalBottomSheet(
        isScrollControlled: true,
        context: parentContext,
        builder: (context) {
          return ChangeNotifierProvider<SignUpViewModel>(
              create: (context) => SignUpViewModel(),
              child: Consumer<SignUpViewModel>(
                builder: (context, model, child) {
                  if (model.getErrorMessage == null && model.getCreatedUser != null) {
                    Navigator.of(context).pop();
                    WidgetsBinding.instance!.addPostFrameCallback((_){
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: AppText.captionBitter('Create user success'),
                        ),
                      );
                    });
                  }
                  return SignUpView(
                    signUp: model.signup,
                    errorText: model.getErrorMessage,
                  );
                },
              ),
          );
          // return SignUpView(signUp: func, errorText: vm.getErrorMessage);
        },
    );
  }

  Widget _buildProfile(UserEntity user, Function logout) {
    return Center(
      child: Column(
        children: [
          SizedBox(height: 200),
          AppText.bodyBitter('Welcome, ${user.username}'),
          SizedBox(height: 40),
          MaterialButton(
            minWidth: 200,
            height: 50,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(18.0),
                side: BorderSide(color: Colors.black)
            ),
            child: AppText.bodyBitter('Logout'),
            onPressed: () {logout();},
            color: Colors.black,
          )
        ],
      ),
    );
  }
}