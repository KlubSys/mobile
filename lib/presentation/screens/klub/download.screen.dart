import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:klub/application/cubit/klub_cubit.dart';
import 'package:klub/data/models/klub_file.model.dart';
import 'package:klub/presentation/widgets/klub_download.widget.dart';
import 'package:klub/presentation/widgets/klub_file_download.widget.dart';

class DownloadsScreen extends StatefulWidget {
  const DownloadsScreen({super.key});

  @override
  State<StatefulWidget> createState() {
    return _DownloadsScreenState();
  }
}

class _DownloadsScreenState extends State<DownloadsScreen> {
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
            if (state.filesDownloads.isEmpty) {
              return Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [CircularProgressIndicator()]);
            }
            return Column(children: [
              ...state.filesDownloads.map((f) => KlubFileDownloadComponent(
                    process: f,
                    onSuccess: (String path, KlubFile file, int position) {
                      BlocProvider.of<KlubCubit>(context)
                          .updateCurrentDownloadSuccess(file, position, path);
                    },
                  ))
            ]);
          },
        ),
      ),
    );
  }
}
