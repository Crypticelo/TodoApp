import 'package:auto_route/annotations.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo/application/auth/authbloc/auth_bloc.dart';
import 'package:todo/application/todos/observer/observer_bloc.dart';
import 'package:todo/injection.dart';
import 'package:todo/presentation/home/widgets/home_body.dart';
import 'package:todo/presentation/routes/router.gr.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final observerBloc = sl<ObserverBloc>()..add(ObserverAllEvent());
    return MultiBlocProvider(
      providers: [
        BlocProvider<ObserverBloc>(
          create: (context) => observerBloc,
        ),
      ],
      child: MultiBlocListener(
        listeners: [
          BlocListener<AuthBloc, AuthState>(listener: ((context, state) {
            if (state is AuthStateUnauthenticated) {
              AutoRouter.of(context).push(const SignUpPageRoute());
            }
          }))
        ],
        child: Scaffold(
          appBar: AppBar(
            leading: IconButton(
                onPressed: () {
                  BlocProvider.of<AuthBloc>(context).add(SignOutPressdEvent());
                },
                icon: Icon(Icons.exit_to_app)),
            title: const Text('Todo'),
          ),
          body: const HomeBody(),
        ),
      ),
    );
  }
}
