import 'package:beer_tracker/models/beer_entry.dart';
import 'package:beer_tracker/models/settings.dart';
import 'package:beer_tracker/secrets.dart';
import 'package:http/http.dart';

Future<void> publishToDiscord(BeerEntry entry) async {
  var name = Settings.publishToDiscordName.value;
  var result = await post(Uri.parse(azurePublishFunction),
      headers: {"content-type": "application/json"}, body: "{\"name\":\"$name\", \"brand\": \"${entry.brand}\"}");
}
