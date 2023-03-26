import 'package:flutter/material.dart';
import 'package:klub/data/models/klub_file.model.dart';

class KlubFileComponent extends StatelessWidget {
  final KlubFile file;

  const KlubFileComponent({super.key, required this.file});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Icon(
          Icons.file_present,
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
              file.filename,
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
              file.fileType,
              textAlign: TextAlign.left,
            )
          ],
        )),
        const SizedBox(height: 20,),
        Divider(height: 5,)
      ],
    );
  }
}
