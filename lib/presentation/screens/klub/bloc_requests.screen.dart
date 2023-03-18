import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:klub/application/cubit/klub_cubit.dart';
import 'package:klub/presentation/widgets/klub_download.widget.dart';

class BlocRequestsScreen extends StatefulWidget {
  const BlocRequestsScreen({super.key});

  @override
  State<StatefulWidget> createState() {
    return _BlocRequestsScreenState();
  }
}

class _BlocRequestsScreenState extends State<BlocRequestsScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: BlocBuilder<KlubCubit, KlubState>(
          builder: (context, state) {
            if (state.blocRequestsTasks.isEmpty) {
              return Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [CircularProgressIndicator()]);
            }
            return Column(children: [
              ...state.blocRequestsTasks
                  .map((t) => KlubDownloadComponent(task: t))
            ]);
          },
        ),
      ),
    );
  }
}
