import 'package:flutter/material.dart';
import 'package:lnkr_syafiq_afifuddin/model/link.dart';
import 'package:url_launcher/url_launcher.dart';

class LinkCard extends StatelessWidget {
  final Link link;

  const LinkCard(this.link, {super.key});

  void _launchURL(String url) async {
    Uri raw = Uri.parse(link.link);
    Uri uri = Uri(scheme: 'https', host: raw.host, path: raw.path);
    await _launchInBrowser(uri);
  }

  Future<void> _launchInBrowser(Uri url) async {
    if (!await launchUrl(
      url,
      mode: LaunchMode.externalApplication,
    )) {
      throw Exception('Could not launch $url');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        onTap: () {
          _launchURL(link.link);
        },
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(link.title, style: const TextStyle(fontSize: 19)),
              const SizedBox(height: 8),
              Text(link.shortLink),
              const SizedBox(height: 4),
              Text(
                link.link,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(color: Colors.grey.shade400),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
