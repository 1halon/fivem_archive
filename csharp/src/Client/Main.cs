using System;

using CitizenFX.Core;
using static CitizenFX.Core.Native.API;

using SharpConfig;

namespace RealifevTemplate.Client
{
    using static Shared.Config;
    public class Main : BaseScript
    {
        public Main()
        {
            HandleConfiguration(new Action<Section, Configuration>((section, config) =>
            {

            }));
        }
    }
}
