using System;
using DockerDemo.XConnect.Model;
using Sitecore.XConnect;
using Sitecore.XConnect.Client;
using Sitecore.XConnect.Collection.Model;
using Sitecore.XConnect.Schema;

namespace App.XConnect.Demo
{
    class Program
    {
        static void Main(string[] args)
        {
            AddContact();
        }

        private static void AddContact()
        {
            using (var client = GetClient())
            {
                var contact = new Contact(new ContactIdentifier("twitter", "dockerdemositecore", ContactIdentifierType.Known));

                var emailFacet = new EmailAddressList(new EmailAddress("docker.demo@sitecore.com", true), "domain");
                client.SetFacet(contact, EmailAddressList.DefaultFacetKey, emailFacet);

                // Add our custom facet
                var demoFacet = new DemoFacet
                {
                    FavoriteAnimal = "Whale"
                };
                client.SetFacet(contact, DemoFacet.DefaultFacetKey, demoFacet);

                client.AddContact(contact);
                client.Submit();

                Console.WriteLine("Added contact!");
            }
        }

        private static XConnectClient GetClient()
        {
            var config = new XConnectClientConfiguration(
                new XdbRuntimeModel(DemoModel.Model), // Use our custom model
                new Uri("http://localhost:8081/"),
                new Uri("http://localhost:8081/"));

            try
            {
                config.Initialize();
            }
            catch (XdbModelConflictException ex)
            {
                Console.WriteLine(ex.Message);
                throw;
            }

            return new XConnectClient(config);
        }
    }
}
