using System;

using CitizenFX.Core;
using static CitizenFX.Core.Native.API;

using SharpConfig;

#pragma warning disable 1998
namespace RealifevTemplate.Shared
{
    public class Config : BaseScript
    {
        public static Configuration Configuration { get; private set; }
        public static string ResourceName { get; private set; }

        private static NotImplementedException NotImplementedConfiguration = new NotImplementedException("Configuration is not implemented");

        public static void HandleConfiguration(Action<Section, Configuration> callback)
        {
            if (Configuration == null) throw NotImplementedConfiguration;
            callback.Invoke(Configuration[ResourceName], Configuration);
        }

        public Config()
        {
            if (ResourceName == null) ResourceName = GetCurrentResourceName();

            if (Configuration == null)
            {
                var loaded = Configuration.LoadFromString(LoadResourceFile(ResourceName, "config.ini"));
                if (loaded.Contains(ResourceName)) Configuration = loaded;
            }
        }
    }
}
