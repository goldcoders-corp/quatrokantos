import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:path/path.dart' as p;
import 'package:quatrokantos/command_controller.dart';
import 'package:quatrokantos/exceptions/command_failed_exception.dart';
import 'package:quatrokantos/helpers/file_editor_helper.dart';

Future<void> main() async {
  await dotenv.load();

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;
  final CommandController ctrl = Get.put(CommandController());

  Future<void> _incrementCounter() async {
    setState(() {
      _counter++;
    });
    // final String curlPath = p.join('/usr', 'bin');
    // final String bashPath = p.join('/bin');
    // const String command1 = 'curl';
    // const String command2 = 'bash';

    // final String path1 =
    //     await PathHelper.resolve(paths: <String>[], fallback: curlPath);
    // final String path2 =
    //     await PathHelper.resolve(paths: <String>[], fallback: bashPath);
    // await Cmd.pipeTo(
    //   command1: command1,
    //   args1: <String>['-sS', 'https://webinstall.dev/webi'],
    //   path1: path1,
    //   command2: command2,
    //   args2: <String>[],
    //   path2: path2,
    // );

    try {
      final String filepath =
          p.join('/Users/uriah/code/Flutter/thriftlabs/.env');
      final FileEditor launcher = FileEditor(filePath: filepath);
      launcher.open();
    } catch (e, stacktrace) {
      print(e.toString());
      print(stacktrace.toString());
      CommandFailedException.log(e.toString(), stacktrace.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Obx(() {
        if (ctrl.isLoading == false) {
          return Center(
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  const Text(
                    'You have pushed the button this many times:',
                  ),
                  Text(
                    '$_counter',
                    style: Theme.of(context).textTheme.headline4,
                  ),
                  Text('Command Output:\n ${ctrl.results}'),
                ],
              ),
            ),
          );
        } else {
          return const Center(child: CircularProgressIndicator());
        }
      }),
      floatingActionButton: Obx(
        () => FloatingActionButton(
          onPressed: ctrl.isLoading ? null : _incrementCounter,
          tooltip: 'Increment',
          child: const Icon(Icons.add),
        ),
      ),
    );
  }
}
