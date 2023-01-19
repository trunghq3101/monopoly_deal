import 'package:flutter/material.dart';
import 'package:monopoly_deal/app/app.dart';
import 'package:monopoly_deal/app/main_app.dart';
import 'package:monopoly_deal/app/ui/constrained_content_box.dart';

class JoiningRoom extends StatefulWidget {
  const JoiningRoom({super.key});

  @override
  State<JoiningRoom> createState() => _JoiningRoomState();
}

class _JoiningRoomState extends State<JoiningRoom> with RouteAware {
  String _enteredRoomId = '';
  late FocusNode _focusNode;

  @override
  void initState() {
    super.initState();
    _focusNode = FocusNode();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _focusNode.requestFocus();
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    routeObserver.subscribe(this, ModalRoute.of(context)!);
  }

  @override
  void dispose() {
    routeObserver.unsubscribe(this);
    super.dispose();
  }

  @override
  void didPop() {
    RoomModel.of(context).disconnect();
    super.didPop();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return ConstrainedContentBox(
      child: Scaffold(
        backgroundColor: theme.colorScheme.surfaceTint.withOpacity(0.05),
        appBar: AppBar(
          backgroundColor: theme.colorScheme.surfaceTint.withOpacity(0.08),
          leading: IconButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            icon: Icon(Icons.adaptive.arrow_back),
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(Insets.large),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: Insets.medium),
              Card(
                elevation: 0,
                color: theme.colorScheme.tertiaryContainer,
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: Insets.medium,
                    horizontal: Insets.extraLarge,
                  ),
                  child: TextField(
                    key: const Key('enterCode'),
                    focusNode: _focusNode,
                    onChanged: (value) {
                      setState(() => _enteredRoomId = value);
                    },
                    style: theme.textTheme.headline3?.copyWith(
                        color: theme.colorScheme.onTertiaryContainer),
                    textAlign: TextAlign.center,
                    decoration: const InputDecoration(
                      hintText: 'Enter code',
                      counterText: '',
                    ),
                  ),
                ),
              ),
              const Spacer(),
              Align(
                alignment: Alignment.centerRight,
                child: JoinRoomButton(
                  enteredRoomId: _enteredRoomId,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class JoinRoomButton extends StatefulWidget {
  const JoinRoomButton({
    Key? key,
    required this.enteredRoomId,
  }) : super(key: key);

  final String enteredRoomId;

  @override
  State<JoinRoomButton> createState() => _JoinRoomButtonState();
}

class _JoinRoomButtonState extends State<JoinRoomButton> {
  @override
  void initState() {
    super.initState();
    // wsGateway.addListener(_wsGatewayListener);
  }

  @override
  void dispose() {
    // wsGateway.removeListener(_wsGatewayListener);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    // if (GameRoomModel.of(context).loading) {
    //   return const ElevatedButton(
    //     onPressed: null,
    //     child: Padding(
    //       padding: EdgeInsets.all(8.0),
    //       child: SizedBox(
    //         width: 16,
    //         height: 16,
    //         child: RepaintBoundary(child: CircularProgressIndicator()),
    //       ),
    //     ),
    //   );
    // }
    return ElevatedButton.icon(
      onPressed: () {
        RoomModel.of(context).joinRoom(widget.enteredRoomId);
        Navigator.of(context).pushNamed('/waitingRoom');
      },
      style: ElevatedButton.styleFrom(
        foregroundColor: theme.colorScheme.onPrimary,
        backgroundColor: theme.colorScheme.primary,
      ).copyWith(
        elevation: ButtonStyleButton.allOrNull(0.0),
      ),
      icon: const Icon(Icons.navigate_next_rounded),
      label: const Text('Join'),
    );
  }
}
