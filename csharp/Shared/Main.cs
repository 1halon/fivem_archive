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

        public Main()
        {
            Debug.WriteLine("Hi from RealifevTemplate.Shared!");
            if (Config == null) Config = ConfigReader();
        }

        private Configuration ConfigReader()
        {
            string resourceName = GetCurrentResourceName();
            string data = LoadResourceFile(resourceName, "config.ini");

            var loaded = Configuration.LoadFromString(data);
            if (!loaded.Contains(resourceName)) return null;

            return loaded;
        }
    }
}
