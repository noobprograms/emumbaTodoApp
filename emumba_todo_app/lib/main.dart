import 'package:emumba_todo_app/utils/routes/routeNames.dart';
import 'package:emumba_todo_app/utils/routes/routes.dart';
import 'package:emumba_todo_app/view_models/auth_view_model.dart';
import 'package:emumba_todo_app/view_models/task_view_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    Color kColorScheme = Color.fromRGBO(29,52,97,1);
    return MultiProvider(
      providers: [ChangeNotifierProvider(create: (_) => AuthViewModel()),ChangeNotifierProvider(create: (_) => TaskViewModel()),
      ],
      child: MaterialApp(
        theme: ThemeData(colorSchemeSeed: kColorScheme),
        title: 'Easy Todo',
        debugShowCheckedModeBanner: false,
        initialRoute: RouteName.splashScreen,
        onGenerateRoute: Routes.generateRoute,
      ),
    );
  }
}
