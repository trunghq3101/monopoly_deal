import 'package:flutter/material.dart';
import 'package:monopoly_deal/app/app.dart';
import 'package:monopoly_deal/app/ui/constrained_content_box.dart';

class ConfigRoom extends StatefulWidget {
  const ConfigRoom({super.key});

  @override
  State<ConfigRoom> createState() => _ConfigRoomState();
}

class _ConfigRoomState extends State<ConfigRoom> {
  int _noPlayers = 2;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return ConstrainedContentBox(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: theme.colorScheme.surfaceTint.withOpacity(0.08),
          title: const Text('Configure'),
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
                    horizontal: Insets.large,
                  ),
                  child: Wrap(
                    alignment: WrapAlignment.center,
                    crossAxisAlignment: WrapCrossAlignment.center,
                    children: [
                      Text(
                        'No. of players:',
                        style: theme.textTheme.headline5?.copyWith(
                            color: theme.colorScheme.onTertiaryContainer),
                      ),
                      SizedBox(
                        width: 200,
                        height: 200,
                        child: ListWheelScrollView.useDelegate(
                          onSelectedItemChanged: (value) {
                            _noPlayers = value + 2;
                          },
                          itemExtent:
                              theme.textTheme.headline3!.fontSize! * 1.2,
                          overAndUnderCenterOpacity: 0.5,
                          diameterRatio: 0.9,
                          childDelegate: ListWheelChildLoopingListDelegate(
                            children: List.generate(
                              4,
                              (index) => Text(
                                '${index + 2}',
                                style: theme.textTheme.headline3?.copyWith(
                                    color:
                                        theme.colorScheme.onTertiaryContainer),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const Spacer(),
              Align(
                alignment: Alignment.centerRight,
                child: ElevatedButton.icon(
                  onPressed: () {
                    RoomModel.of(context).createRoom(_noPlayers);
                    Navigator.of(context).pushNamed('/waitingRoom');
                  },
                  style: ElevatedButton.styleFrom(
                    foregroundColor: theme.colorScheme.onPrimary,
                    backgroundColor: theme.colorScheme.primary,
                  ).copyWith(elevation: ButtonStyleButton.allOrNull(0.0)),
                  icon: const Icon(Icons.navigate_next_rounded),
                  label: const Text('Create'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
