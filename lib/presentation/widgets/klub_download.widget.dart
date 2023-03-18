import 'package:flutter/material.dart';
import 'package:klub/data/models/klub_download.model.dart';
import 'package:klub/data/models/klub_file.model.dart';

class KlubDownloadComponent extends StatelessWidget {
  final KlubDownload task;

  const KlubDownloadComponent({super.key, required this.task});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Icon(
          Icons.download,
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
              task.blocGroupRef,
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
              task.hasData ? "Processed" : "Pending",
              textAlign: TextAlign.left,
            )
          ],
        ))
      ],
    );
  }
}
