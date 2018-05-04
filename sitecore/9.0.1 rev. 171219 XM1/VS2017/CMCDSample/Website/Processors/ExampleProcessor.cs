using System;
using Sitecore.Pipelines.HttpRequest;

namespace Website.Processors
{
    public class ExampleProcessor : HttpRequestProcessor
    {
        public override void Process(HttpRequestArgs args)
        {
            if (args.HttpContext.Request.Path == "/")
            {
                var sitecoreRole = System.Configuration.ConfigurationManager.AppSettings["role:define"];
                var text = string.Empty;

                text += $"<b>HOST: {Environment.MachineName}</b>";
                text += $"<br/>";
                text += $"<b>ROLE: {sitecoreRole}</b>";

                args.HttpContext.Response.Write(text);
            }
        }
    }
}