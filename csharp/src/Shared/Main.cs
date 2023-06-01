using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using CitizenFX.Core;
using static CitizenFX.Core.Native.API;
using SharpConfig;

namespace RealifevTemplate.Shared
{
    public class Main : BaseScript
    {
        public static Configuration Config { get; private set; }
        public static string ResourceName { get; private set; }


        public static void HandleConfig(Action<Section, Configuration> callback)
        {
            if (Config == null) throw new NotImplementedException("Config is not implemented");

            callback.Invoke(Config[ResourceName], Config);
        }

        public Main()
        {
            Debug.WriteLine("Hi from RealifevTemplate.Shared!");
            if (ResourceName == null) ResourceName = GetCurrentResourceName();
            if (Config == null) Config = ConfigReader();
        }

        private Configuration ConfigReader()
        {
            var loaded = Configuration.LoadFromString(LoadResourceFile(ResourceName, "config.ini"));
            if (!loaded.Contains(ResourceName)) return null;

            return loaded;
        }
    }
}
