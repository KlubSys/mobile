import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:klub/application/cubit/klub_cubit.dart';
import 'package:klub/presentation/widgets/klub_bloc.widget.dart';

class BlocsScreen extends StatefulWidget {
  const BlocsScreen({super.key});

  @override
  State<StatefulWidget> createState() {
    return _BlocsScreenState();
  }
}

class _BlocsScreenState extends State<BlocsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: BlocBuilder<KlubCubit, KlubState>(
          builder: (context, state) {
            if (state.blocs.isEmpty) {
              return Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [CircularProgressIndicator()]);
            }
            return Column(children: [
              ...state.blocs.map((b) => KlubBlocComponent(bloc: b))
            ]);
          },
        ),
      ),
    );
  }
}
