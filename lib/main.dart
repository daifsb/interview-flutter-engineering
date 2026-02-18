import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:interview_flutter/features/cart/cubit/cart_screen_cubit.dart';

import 'core/constants/app_constants.dart';
import 'core/initializer/dependencies_initializer.dart';
import 'core/router/app_router.dart';
import 'core/theme/app_theme.dart';

void main() async {
  await initializeDependencies();
  runApp(const InterviewStarterApp());
}

class InterviewStarterApp extends StatelessWidget {
  const InterviewStarterApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => CartScreenCubit(),
        ),
      ],
      child: MaterialApp.router(
        title: AppConstants.appName,
        theme: AppTheme.lightTheme,
        routerConfig: AppRouter.router,
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}
