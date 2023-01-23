#r "Newtonsoft.Json"

using System.Net;
using System.Net.Http;
using System.Net.Http.Headers;
using System.Linq;
using System.Text;
using Microsoft.AspNetCore.Mvc;
using Microsoft.Extensions.Primitives;
using Newtonsoft.Json;

private static const string discordWebhook = "your_webhook_here";

public static async Task<IActionResult> Run(HttpRequest req, ILogger log)
{
    string name = req.Query["name"];
    string brand = req.Query["brand"];
    const uint MAX_CHARS = 100;


    string requestBody = await new StreamReader(req.Body).ReadToEndAsync();
    dynamic data = JsonConvert.DeserializeObject(requestBody);
    name = name ?? data?.name;
    brand = brand ?? data?.brand;

    bool nameInvalid = name?.Length > MAX_CHARS || (name?.Any(c => !(char.IsLetterOrDigit(c) || c == 32)) ?? false);
    bool brandInvalid = brand?.Length > MAX_CHARS || (brand?.Any(c => !(char.IsLetterOrDigit(c) || c == 32)) ?? false);


    if(string.IsNullOrEmpty(name) && string.IsNullOrEmpty(brand) || nameInvalid || brandInvalid){
        return new BadRequestObjectResult($"Bad input, at least name or brand has to be passed. Additionally each input can consist of only up to {MAX_CHARS} alphanumeric characters.");
    }
    if(string.IsNullOrEmpty(name)) name = "Anonym";

    string publishMessage = string.IsNullOrEmpty(brand)
        ? $"{name} hat ein Bier getrunken."
                : $"{name} hat ein Bier der Marke: {brand} getrunken.";

    string body = $"{{ \"content\":\"{publishMessage}\"}}";

    var client = new HttpClient();

    var content = new StringContent(body, Encoding.UTF8, "application/json");

    var reply = await client.PostAsync(discordWebhook ,content);

    if(reply.IsSuccessStatusCode)
        return new OkObjectResult(publishMessage);
    return new BadRequestObjectResult("Something went wrong"); 
}