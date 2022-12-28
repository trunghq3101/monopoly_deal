import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('when calling service, then text changed', (tester) async {
    final boxBKey = GlobalKey<_BoxBState>();
    final tree = MaterialApp(
      home: UiModel(
        notifier: UiModelNotifier(),
        child: Column(
          children: [
            const BoxA(),
            BoxB(key: boxBKey),
          ],
        ),
      ),
    );
    await tester.pumpWidget(tree);
    expect(find.text('initial'), findsOneWidget);

    await tester.tap(find.text('button'));
    await tester.pump();
    expect(boxBKey.currentState!.rebuildTimes, 1);
    expect(find.text('updated'), findsOneWidget);
  });

  testWidgets('when calling service failed, then show error dialog',
      (tester) async {
    final tree = MaterialApp(
      home: UiModel(
        notifier: UiModelNotifier(),
        child: Column(
          children: const [BoxC(), ErrorDisplay()],
        ),
      ),
    );
    await tester.pumpWidget(tree);
    await tester.tap(find.text('buttonC'));
    await tester.pumpAndSettle();

    expect(find.textContaining('error'), findsOneWidget);
  });
}

class ClientSideServiceA extends ChangeNotifier {
  final serviceA = ServiceA();
  int? data;
  final StreamController<String> _errorController = StreamController();
  Stream<String> get error => _errorController.stream;

  ClientSideServiceA() {
    serviceA.data.listen((event) {
      data = event;
      notifyListeners();
    });
  }

  void change() {
    serviceA.change();
  }

  void changeError() {
    try {
      serviceA.changeError();
    } catch (e) {
      _errorController.add(e.toString());
    }
  }
}

class ErrorDisplay extends StatefulWidget {
  const ErrorDisplay({super.key});

  @override
  State<ErrorDisplay> createState() => _ErrorDisplayState();
}

class _ErrorDisplayState extends State<ErrorDisplay> {
  @override
  void initState() {
    super.initState();
    serviceLocator.get().error.listen((event) {
      showDialog(
        context: context,
        builder: (_) => AlertDialog(title: Text(event)),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}

class UiModel extends InheritedNotifier<UiModelNotifier> {
  const UiModel({super.key, required super.child, super.notifier});

  static UiModelNotifier of(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<UiModel>()!.notifier!;
}

class UiModelNotifier extends ChangeNotifier {
  final clientServiceA = serviceLocator.get();
  String boxAText = 'initial';

  UiModelNotifier() {
    clientServiceA.addListener(() {
      boxAText = clientServiceA.data != null ? 'updated' : 'initial';
      notifyListeners();
    });
  }
}

class BoxA extends StatelessWidget {
  const BoxA({super.key});

  @override
  Widget build(BuildContext context) {
    return Text(UiModel.of(context).boxAText);
  }
}

class BoxB extends StatefulWidget {
  const BoxB({super.key});

  @override
  State<BoxB> createState() => _BoxBState();
}

class _BoxBState extends State<BoxB> {
  var rebuildTimes = 0;

  @override
  Widget build(BuildContext context) {
    rebuildTimes++;
    return TextButton(
      onPressed: () {
        serviceLocator.get().change();
      },
      child: const Text('button'),
    );
  }
}

class BoxC extends StatelessWidget {
  const BoxC({super.key});

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () {
        serviceLocator.get().changeError();
      },
      child: const Text('buttonC'),
    );
  }
}

class ServiceLocator {
  final clientServiceA = ClientSideServiceA();
  ClientSideServiceA get() => clientServiceA;
}

final serviceLocator = ServiceLocator();

/*
* External service
**/
class ServiceA {
  final StreamController<int> _controller = StreamController();
  int _counter = 0;
  Stream<int> get data => _controller.stream;

  void change() {
    _controller.add(_counter++);
  }

  void changeError() {
    throw Exception('error');
  }
}
