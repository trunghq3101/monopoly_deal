import 'package:flutter/material.dart';
import 'package:lucky_deal_shared/lucky_deal_shared.dart';
import 'package:monopoly_deal/app/app.dart';
import 'package:monopoly_deal/app/main_app.dart';

class JoinRoom extends StatefulWidget {
  const JoinRoom({super.key});

  @override
  State<JoinRoom> createState() => _JoinRoomState();
}

class _JoinRoomState extends State<JoinRoom> with RouteAware {
  static const roomIdLength = 6;
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
                leading: IconButton(
                  onPressed: () {
                    wsGateway.close();
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
                          focusNode: _focusNode,
                          onChanged: (value) {
                            setState(() => _enteredRoomId = value);
                          },
                          style: theme.textTheme.headline3?.copyWith(
                              color: theme.colorScheme.onTertiaryContainer),
                          textAlign: TextAlign.center,
                          maxLength: roomIdLength,
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
                        enabled: _enteredRoomId.length == roomIdLength,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class JoinRoomButton extends StatefulWidget {
  const JoinRoomButton({
    Key? key,
    required this.enabled,
    required this.enteredRoomId,
  }) : super(key: key);

  final String enteredRoomId;
  final bool enabled;

  @override
  State<JoinRoomButton> createState() => _JoinRoomButtonState();
}

class _JoinRoomButtonState extends State<JoinRoomButton> {
  @override
  void initState() {
    super.initState();
    wsGateway.addListener(_wsGatewayListener);
  }

  @override
  void dispose() {
    wsGateway.removeListener(_wsGatewayListener);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    if (GameRoomModel.of(context).loading) {
      return const ElevatedButton(
        onPressed: null,
        child: Padding(
          padding: EdgeInsets.all(8.0),
          child: SizedBox(
            width: 16,
            height: 16,
            child: RepaintBoundary(child: CircularProgressIndicator()),
          ),
        ),
      );
    }
    return ElevatedButton.icon(
      onPressed: widget.enabled
          ? () {
              wsGateway
                ..connect()
                ..send((sid) =>
                    JoinRoomPacket(sid: sid, roomId: widget.enteredRoomId));
            }
          : null,
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

  void _wsGatewayListener() {
    if (wsGateway.serverPacket is RoomInfoPacket) {
      Navigator.of(context).pushNamed('/waitingRoom');
    }
  }
}
