import 'package:example/example_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:request_builder/request_builder.dart';

void main() {
  runApp(const MyApp());
}

GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    RequestBuilderInitializer.init(navigatorKey: navigatorKey);

    return MaterialApp(
      title: 'Flutter Demo',
      navigatorKey: navigatorKey,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      locale: const Locale('ar'),
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.amber),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Request Builder Demo'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => ExampleCubit(),
      child: Builder(builder: (context) {
        return Scaffold(
          appBar: AppBar(
            backgroundColor: Theme.of(context).colorScheme.inversePrimary,
            title: Text(widget.title),
          ),
          body: Center(
            child: Column(
              children: [
                Wrap(
                  spacing: 5,
                  children: [
                    ElevatedButton(
                      child: const Text("Initial"),
                      onPressed: () {
                        ExampleCubit.get(context)
                            .emitState(const InitialState());
                      },
                    ),
                    ElevatedButton(
                      child: const Text("Loading popup"),
                      onPressed: () {
                        ExampleCubit.get(context).emitState(const LoadingState(
                            type: LoadingRendererType.popup));
                      },
                    ),
                    ElevatedButton(
                      child: const Text("Loading full content"),
                      onPressed: () {
                        ExampleCubit.get(context).emitState(const LoadingState(
                            type: LoadingRendererType.content));
                      },
                    ),
                    ElevatedButton(
                      child: const Text("Content"),
                      onPressed: () {
                        ExampleCubit.get(context)
                            .emitState(const ContentState());
                      },
                    ),
                    ElevatedButton(
                      child: const Text("Success popup"),
                      onPressed: () {
                        ExampleCubit.get(context).emitState(const SuccessState(
                            type: SuccessRendererType.popup,
                            message: "Success with popup"));
                      },
                    ),
                    ElevatedButton(
                      child: const Text("Success content"),
                      onPressed: () {
                        ExampleCubit.get(context).emitState(const SuccessState(
                            type: SuccessRendererType.content,
                            message: "Success content"));
                      },
                    ),
                    ElevatedButton(
                      child: const Text("Success toast"),
                      onPressed: () {
                        ExampleCubit.get(context).emitState(const SuccessState(
                            type: SuccessRendererType.toast,
                            message: "Success toast"));
                      },
                    ),
                    ElevatedButton(
                      child: const Text("Error popup"),
                      onPressed: () {
                        ExampleCubit.get(context).emitState(const ErrorState(
                            type: ErrorRendererType.popup,
                            message: "Error with popup"));
                      },
                    ),
                    ElevatedButton(
                      child: const Text("Error content"),
                      onPressed: () {
                        ExampleCubit.get(context).emitState(const ErrorState(
                            type: ErrorRendererType.content,
                            message: "Error content"));
                      },
                    ),
                    ElevatedButton(
                      child: const Text("Error toast"),
                      onPressed: () {
                        ExampleCubit.get(context).emitState(const ErrorState(
                            type: ErrorRendererType.toast,
                            message: "Error toast"));
                      },
                    ),
                    ElevatedButton(
                      child: const Text("Empty"),
                      onPressed: () {
                        ExampleCubit.get(context).emitState(
                            const EmptyState(message: "Error toast"));
                      },
                    ),
                  ],
                ),
                Expanded(
                    child: RequestBuilder<ExampleCubit>(
                  contentBuilder: (context, cubit) => const Center(
                    child: Text('Content of request'),
                  ),
                  retry: (context, cubit) {},
                ))
              ],
            ),
          ),
        );
      }),
    );
  }
}
