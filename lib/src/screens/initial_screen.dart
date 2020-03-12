import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:games.fair.wallet/core/core.dart';
import 'package:games.fair.wallet/src/app_keys.dart';
import 'package:games.fair.wallet/src/blocs/mnemonic/bloc.dart';
import 'package:games.fair.wallet/src/blocs/tab/bloc.dart';
import 'package:games.fair.wallet/src/blocs/wallet/bloc.dart';
import 'package:games.fair.wallet/src/providers/providers.dart';
import 'package:games.fair.wallet/src/repositories/crypto_repository.dart';
import 'package:games.fair.wallet/src/screens/screens.dart';
import 'package:games.fair.wallet/src/widgets/widgets.dart';
import 'package:http/http.dart' as http;
import 'package:multi_currency/multi_currency.dart';

class InitialScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return LinkProvider(
      child: BlocBuilder<MnemonicBloc, MnemonicState>(
        builder: (context, state) {
          if (state is MnemonicLoading) {
            return LoadingIndicator(key: AppKeys.statsLoadingIndicator);
          } else if (state is MnemonicNotLoaded || state is MnemonicRemoved) {
            return BlocProvider<TabBloc>(
                create: (context) => TabBloc(),
                child: GeneralScreen(linkProvider: LinkProvider.of(context)));
          } else if (state is MnemonicLoaded) {
            return ExistingScreen(
                linkProvider: LinkProvider.of(context),
                base64Mnemonic: state.mnemonic);
          } else if (state is MnemonicGeneration) {
            return GenerationScreen();
          } else if (state is MnemonicVerifyOrRecover) {
            return VerificationOrRecoverScreen(state.mnemonic);
          } else if (state is MnemonicAccepted) {
            return MultiBlocProvider(
              providers: [
                BlocProvider<TabBloc>(create: (context) => TabBloc()),
                BlocProvider<WalletBloc>(
                    create: (context) => WalletBloc(
                        multiCurrency: MultiCurrency(state.mnemonic),
                        repository: CryptoRepository(
                            db: DB.init(state.dbPath),
                            webClient: WebClient(httpClient: http.Client())))
                      ..add(LoadWallet())),
              ],
              child: RenderWalletScreen(),
            );
          } else {
            return Container(key: AppKeys.emptyStatsContainer);
          }
        },
      ),
    );
  }
}
