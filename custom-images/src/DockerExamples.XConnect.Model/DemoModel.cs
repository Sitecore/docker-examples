using Sitecore.XConnect;
using Sitecore.XConnect.Schema;

namespace DockerExamples.XConnect.Model
{
    public class DemoModel
    {
        public static XdbModel Model { get; } = BuildModel();

        private static XdbModel BuildModel()
        {
            var builder = new XdbModelBuilder(typeof(DemoModel).FullName, new XdbModelVersion(1, 0));

            builder.ReferenceModel(Sitecore.XConnect.Collection.Model.CollectionModel.Model);
            builder.DefineFacet<Contact, DemoFacet>(DemoFacet.DefaultFacetKey);

            return builder.BuildModel();
        }
    }
}
