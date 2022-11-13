import 'package:flutter/material.dart';
import 'package:monopoly_deal/routes.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _content = "";
  final _buttonText = "Join";
  late Function()? _onMainBtnPressed;

  @override
  void initState() {
    super.initState();
    _onMainBtnPressed = () => Navigator.of(context).pushNamed(AppRoutes.game);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.amber,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Spacer(),
          Expanded(
              child: Text(
            _content,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.headline2,
          )),
          Row(
            children: [
              const Spacer(),
              Expanded(
                child: ElevatedButton(
                  onPressed: _onMainBtnPressed,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      _buttonText,
                      style: Theme.of(context)
                          .textTheme
                          .headline4!
                          .copyWith(color: Colors.white),
                    ),
                  ),
                ),
              ),
              const Spacer(),
            ],
          ),
          const Spacer(),
        ],
      ),
    );
  }
}
