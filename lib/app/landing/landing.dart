import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:reown_appkit/reown_appkit.dart';
import 'package:timetracker/app/settings/bloc/settings_bloc.dart';
import 'package:timetracker/l10n/l10n.dart';
import 'package:timetracker_api/timetracker_api.dart';

class LandingPage extends StatelessWidget {
  const LandingPage({super.key});

  static String route = '/welcome';

  List<Map<String, dynamic>> get thumbnails => [
        {
          'image': 'assets/images/landing/landing_1.png',
          'token': 'assets/images/tokens/btc.png',
          'angle': -0.2,
        },
        {
          'image': 'assets/images/landing/landing_2.png',
          'token': 'assets/images/tokens/bnb.png',
          'angle': 0.3,
        },
        {
          'image': 'assets/images/landing/landing_3.png',
          'token': 'assets/images/tokens/eth.png',
          'angle': 0.1,
        },
      ];

  Widget _thumbnail(Map<String, dynamic> data) => Transform.rotate(
        angle: data['angle']! as double,
        child: SizedBox(
          width: 200,
          height: 300,
          child: Stack(
            alignment: AlignmentDirectional.bottomCenter,
            children: [
              Padding(
                padding: const EdgeInsets.only(bottom: 24),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(32),
                  child: Image.asset(
                    data['image']! as String,
                    fit: BoxFit.cover,
                    width: double.infinity,
                    height: double.infinity,
                  ),
                ),
              ),
              Positioned(
                bottom: 0,
                child: Container(
                  width: 48,
                  height: 48,
                  alignment: Alignment.center,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white54,
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(6),
                    child: Image.asset(
                      data['token']! as String,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      );

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final theme = Theme.of(context);

    final viewSize = MediaQuery.of(context).size;
    final setting = context.read<SettingsBloc>();
    final modelFuture = setting.model(context);

    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          clipBehavior: Clip.none,
          child: Container(
            width: 500,
            constraints: BoxConstraints(
              maxWidth: 500,
              minHeight: viewSize.height,
            ),
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(
                  height: 500,
                  child: Stack(
                    children: [
                      Align(
                        alignment: Alignment.topRight,
                        child: _thumbnail(thumbnails[1]),
                      ),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: _thumbnail(thumbnails[0]),
                      ),
                      Align(
                        alignment: Alignment.bottomRight,
                        child: _thumbnail(thumbnails[2]),
                      ),
                    ],
                  ),
                ),
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      l10n.landing,
                      textAlign: TextAlign.center,
                      style: theme.textTheme.headlineMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      l10n.slogan,
                      textAlign: TextAlign.center,
                      style: theme.textTheme.bodyMedium,
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  child: FutureBuilder(
                    future: modelFuture,
                    builder: (context, snapshot) => ElevatedButton(
                      onPressed: snapshot.data != null
                          ? () => onStartButtonPressed(context, setting)
                          : null,
                      style: ElevatedButton.styleFrom(
                        padding: EdgeInsets.zero,
                        fixedSize: const Size.square(94),
                        shape: const OvalBorder(),
                        backgroundColor: Colors.orange,
                      ),
                      child: snapshot.data != null
                          ? const Icon(
                              Icons.arrow_forward_ios_rounded,
                              color: Colors.white,
                            )
                          : const CupertinoActivityIndicator(),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> onStartButtonPressed(
    BuildContext context,
    SettingsBloc setting,
  ) async {
    final model = await setting.model(context);
    await model?.openModalView(const ReownAppKitModalQRCodePage());
    model?.closeModal();
    if ((model?.isConnected ?? false) && context.mounted) {
      setting.add(
        SettingsEvent.login(
          TransactionActor(
            type: 'ethereumAddress',
            value: model!.session!.getAddress(
              SettingsBloc.namespace,
            )!,
          ),
        ),
      );
    }
  }
}
