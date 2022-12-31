import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:monopoly_deal/app/app.dart';
import 'package:monopoly_deal/app/main_app.dart';

class WaitingRoomArgs {
  final Function()? pendingAction;

  WaitingRoomArgs({this.pendingAction});
}

class WaitingRoom extends StatefulWidget {
  const WaitingRoom({super.key});

  @override
  State<WaitingRoom> createState() => _WaitingRoomState();
}

class _WaitingRoomState extends State<WaitingRoom> with RouteAware {
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    routeObserver.subscribe(this, ModalRoute.of(context)!);
    errorDisplayKey.currentState?.setActions([
      TextButton(
        onPressed: () {
          errorDisplayKey.currentState?.dismiss();
          Navigator.of(context).pop();
        },
        child: const Text('Go back'),
      ),
    ]);
    final args = ModalRoute.of(context)!.settings.arguments as WaitingRoomArgs?;
    args?.pendingAction?.call();
  }

  @override
  void dispose() {
    routeObserver.unsubscribe(this);
    errorDisplayKey.currentState?.unset();
    super.dispose();
  }

  @override
  void didPop() {
    wsGateway.close();
    super.didPop();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return ColoredBox(
      color: theme.colorScheme.surface,
      child: SafeArea(
        child: Align(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 600),
            child: Scaffold(
              backgroundColor: theme.colorScheme.surfaceTint.withOpacity(0.05),
              appBar: AppBar(
                backgroundColor:
                    theme.colorScheme.surfaceTint.withOpacity(0.08),
                leading: Align(
                  child: Builder(builder: (context) {
                    return TextButton.icon(
                      onPressed: () {
                        wsGateway.close();
                        ScaffoldMessenger.of(context).clearSnackBars();
                        Navigator.of(context)
                            .popUntil(ModalRoute.withName('/'));
                      },
                      icon: const Icon(Icons.close),
                      label: const Text("Leave"),
                    );
                  }),
                ),
                leadingWidth: 100,
              ),
              body: Builder(builder: (context) {
                return Padding(
                  padding: const EdgeInsets.all(Insets.large),
                  child: GameRoomModel.of(context).roomId != null
                      ? const WaitingRoomContent()
                      : const Center(child: CircularProgressIndicator()),
                );
              }),
            ),
          ),
        ),
      ),
    );
  }
}

class WaitingRoomContent extends StatelessWidget {
  const WaitingRoomContent({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const SizedBox(height: Insets.medium),
        Card(
          elevation: 0,
          color: theme.colorScheme.tertiaryContainer,
          clipBehavior: Clip.hardEdge,
          child: Builder(builder: (context) {
            return InkWell(
              onTap: () {
                Clipboard.setData(
                  ClipboardData(text: GameRoomModel.of(context).roomId!),
                ).then(
                  (_) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Copied!')),
                    );
                  },
                );
              },
              child: Padding(
                padding: const EdgeInsets.all(Insets.medium),
                child: Builder(builder: (context) {
                  return Text(
                    GameRoomModel.of(context).roomId!,
                    style: theme.textTheme.headline3?.copyWith(
                        color: theme.colorScheme.onTertiaryContainer),
                    textAlign: TextAlign.center,
                  );
                }),
              ),
            );
          }),
        ),
        Card(
          elevation: 0,
          color: theme.colorScheme.surfaceTint.withOpacity(0.08),
          child: Padding(
            padding: const EdgeInsets.all(Insets.medium),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Member(index: 0),
                    Member(index: 1),
                  ],
                ),
                const SizedBox(height: Insets.medium),
                const WaitingProgressIndicator(),
              ],
            ),
          ),
        ),
        const Spacer(),
        const StartButton(),
      ],
    );
  }
}

class WaitingProgressIndicator extends StatelessWidget {
  const WaitingProgressIndicator({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GameRoomModel.of(context).isFull
        ? Text(
            'Ready!',
            style: Theme.of(context).textTheme.headline5,
          )
        : const RepaintBoundary(child: LinearProgressIndicator());
  }
}

class StartButton extends StatelessWidget {
  const StartButton({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Align(
      alignment: Alignment.centerRight,
      child: ElevatedButton.icon(
        onPressed: GameRoomModel.of(context).isFull
            ? () {
                Navigator.of(context).pushReplacementNamed('/game');
              }
            : null,
        style: ElevatedButton.styleFrom(
          foregroundColor: theme.colorScheme.onPrimary,
          backgroundColor: theme.colorScheme.primary,
        ).copyWith(elevation: ButtonStyleButton.allOrNull(0.0)),
        icon: const Icon(Icons.navigate_next_rounded),
        label: const Text('Start game'),
      ),
    );
  }
}

class Member extends StatelessWidget {
  const Member({super.key, required this.index});

  final int index;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.all(Insets.small),
      child: Icon(
        Icons.person,
        size: 40,
        color: GameRoomModel.of(context).members.length - 1 < index
            ? theme.colorScheme.onSurface.withOpacity(0.11)
            : theme.primaryColor,
      ),
    );
  }
}
