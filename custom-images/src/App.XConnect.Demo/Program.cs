using System;
using DockerExamples.XConnect.Model;
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
                var contact = new Contact(new ContactIdentifier("domain", "docker.examples", ContactIdentifierType.Known));

                var personalInfo = new PersonalInformation
                {
                    FirstName = "Docker",
                    LastName = "Examples"
                };
                client.SetFacet(contact, PersonalInformation.DefaultFacetKey, personalInfo);

                var emailFacet = new EmailAddressList(new EmailAddress("docker.examples@sitecore.com", true), "domain");
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
