import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:saasaki_assignment_2/riverpod/auth.dart';

class LoginPage extends ConsumerStatefulWidget {
  const LoginPage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _LoginPageState();
}

class _LoginPageState extends ConsumerState<LoginPage> {
  // Controllers for login/register textfields
  final TextEditingController emailC = TextEditingController();
  final TextEditingController passwordC = TextEditingController();
  final TextEditingController rePasswordC = TextEditingController();

  final ValueNotifier<bool> showPassword = ValueNotifier<bool>(false);
  final isNewUserProvider = StateNotifierProvider<IsNewUserNotifier, bool>(
      (_) => IsNewUserNotifier());

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final size = MediaQuery.of(context).size;

    final auth = ref.watch(authProvider);
    final isNewUser = ref.watch(isNewUserProvider);

    Widget textFieldContainer({required Widget child}) => Padding(
          padding: const EdgeInsets.all(4.0),
          child: Container(
            decoration: BoxDecoration(
                color: theme.colorScheme.surface,
                borderRadius: BorderRadius.circular(18.0)),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: child,
            ),
          ),
        );

    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Center(
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: size.height / 8),
                child: Text(
                  'Tasks'.toUpperCase(),
                  style: theme.textTheme.displayLarge!
                      .copyWith(color: theme.colorScheme.primary),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                decoration: BoxDecoration(
                    color: theme.colorScheme.primaryContainer.withAlpha(100),
                    borderRadius: BorderRadius.circular(18.0)),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Text(isNewUser ? 'Register' : 'Login',
                              style: theme.textTheme.titleLarge),
                        ),
                        textFieldContainer(
                          child: TextFormField(
                            //using textformfield to support form validation
                            controller: emailC,
                            enabled: auth.authStatus != AuthStatus.loading,
                            keyboardType: TextInputType.emailAddress,
                            textInputAction: TextInputAction.next,
                            validator: (value) =>
                                EmailValidator.validate(value ?? '')
                                    ? null
                                    : ' Please enter a valid email',
                            decoration: const InputDecoration(
                              border: InputBorder.none,
                              prefixIcon: Icon(Icons.person),
                              labelText: 'Email',
                              hintText: 'Enter your mail address',
                            ),
                          ),
                        ),
                        textFieldContainer(
                          child: ValueListenableBuilder(
                            valueListenable: showPassword,
                            builder: (context, isVisible, child) =>
                                TextFormField(
                              controller: passwordC,
                              obscureText: !isVisible,
                              textInputAction: isNewUser
                                  ? TextInputAction.next
                                  : TextInputAction.done,
                              validator: (value) {
                                if (value!.isEmpty || value.length < 6) {
                                  return 'Minimum 6 charaters';
                                } else {
                                  return null;
                                }
                              },
                              decoration: InputDecoration(
                                enabled: auth.authStatus != AuthStatus.loading,
                                border: InputBorder.none,
                                prefixIcon: const Icon(Icons.password),
                                labelText: 'Password',
                                hintText: 'Enter your password',
                                suffixIcon: IconButton(
                                  onPressed: () =>
                                      showPassword.value = !isVisible,
                                  icon: Icon(isVisible
                                      ? Icons.visibility
                                      : Icons.visibility_off),
                                ),
                              ),
                            ),
                          ),
                        ),
                        if (isNewUser)
                          textFieldContainer(
                            child: TextFormField(
                              controller: rePasswordC,
                              obscureText: true,
                              validator: (value) {
                                if (value!.isEmpty || value.length < 6) {
                                  return 'Minimum 6 charaters';
                                } else if (value != passwordC.text) {
                                  return 'Password mismatch';
                                } else {
                                  return null;
                                }
                              },
                              decoration: InputDecoration(
                                enabled: auth.authStatus != AuthStatus.loading,
                                border: InputBorder.none,
                                prefixIcon: const Icon(Icons.password),
                                labelText: 'Re-enter Password',
                                hintText: 'Enter the same password again',
                              ),
                            ),
                          ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: auth.authStatus != AuthStatus.loading
                              ? ElevatedButton(
                                  onPressed: () {
                                    if (_formKey.currentState!.validate()) {
                                      isNewUser
                                          ? auth.registerWithEmail(
                                              email: emailC.text,
                                              password: passwordC.text)
                                          : auth.loginInWithEmail(
                                              email: emailC.text,
                                              password: passwordC.text);
                                    }
                                  },
                                  child: const Text('Submit'),
                                )
                              : const CircularProgressIndicator(),
                        ),
                        if (!isNewUser)
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Text('Are you a new user?'),
                              TextButton(
                                onPressed: () => ref
                                    .read(isNewUserProvider.notifier)
                                    .toggle(),
                                child: const Text('REGISTER'),
                              ),
                            ],
                          ),
                        if (isNewUser)
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Text('Are you an existing user?'),
                              TextButton(
                                onPressed: () => ref
                                    .read(isNewUserProvider.notifier)
                                    .toggle(),
                                child: const Text('LOGIN'),
                              ),
                            ],
                          ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class IsNewUserNotifier extends StateNotifier<bool> {
  IsNewUserNotifier() : super(false); // Initialize with the default value

  toggle() => state = !state;
}
