using System;
using System.IO;
using DockerDemo.XConnect.Model;
using Sitecore.XConnect.Schema;

namespace Build.XConnect.ModelBuilder
{
    class Program
    {
        static void Main(string[] args)
        {
            var path = GetOutputPath(args);
            SerializeModel(path, DemoModel.Model);
        }

        private static string GetOutputPath(string[] args)
        {
            return args.Length > 0 ? Directory.CreateDirectory(args[0]).FullName : Directory.GetCurrentDirectory();
        }

        private static void SerializeModel(string path, XdbModel model)
        {
            var fileName = model + ".json";
            var filePath = Path.Combine(path, fileName);
            var json = Sitecore.XConnect.Serialization.XdbModelWriter.Serialize(model);
            File.WriteAllText(filePath, json);
            Console.WriteLine($"Serialized Xdb model {filePath}");
        }
    }
}
