import 'package:flutter/material.dart';
import 'package:klub/data/models/klub_bloc.model.dart';
import 'package:klub/data/models/klub_file.model.dart';

class KlubBlocComponent extends StatelessWidget {
  final KlubBloc bloc;

  const KlubBlocComponent({super.key, required this.bloc});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Icon(
          Icons.cloud,
          color: Colors.indigo,
        ),
        const SizedBox(
          width: 20,
        ),
        Expanded(
            child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              bloc.identifier,
              textAlign: TextAlign.left,
              style: const TextStyle(
                  fontWeight: FontWeight.bold, color: Colors.indigo),
              softWrap: true,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(
              height: 10,
            ),
            Text(
              "${bloc.size} Bytes",
              textAlign: TextAlign.left,
            )
          ],
        ))
      ],
    );
  }
}
