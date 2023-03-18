import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:klub/application/cubit/klub_cubit.dart';
import 'package:klub/presentation/widgets/klub_file.widget.dart';

class FilesScreen extends StatefulWidget {
  const FilesScreen({super.key});

  @override
  State<StatefulWidget> createState() {
    return _FilesScreenState();
  }
}

class _FilesScreenState extends State<FilesScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: BlocBuilder<KlubCubit, KlubState>(
          builder: (context, state) {
            if (state.files.isEmpty) {
              return Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [CircularProgressIndicator()]);
            }
            return Column(children: [
              ...state.files.map((f) => GestureDetector(
                behavior: HitTestBehavior.translucent,
                    onTap: () {
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                        content: Text('Download started...'),
                      ));
                      BlocProvider.of<KlubCubit>(context).startDownload(f);
                    },
                    child: KlubFileComponent(file: f),
                  ))
            ]);
          },
        ),
      ),
    );
  }
}
