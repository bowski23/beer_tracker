import 'package:beer_tracker/models/beer_entry.dart';
import 'package:beer_tracker/models/settings.dart';
import 'package:beer_tracker/secrets.dart';
import 'package:http/http.dart';

Future<void> publishToDiscord(BeerEntry entry) async {
  var name = Settings.publishToDiscordName.value;
  await post(Uri.parse(discordHook),
      headers: {"content-type": "application/json"},
      body: "{\"content\":\"$name hat ein Bier der Marke: ${entry.brand} getrunken.\",\"tts\":\"true\"}");
}
