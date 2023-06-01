using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using CitizenFX.Core;
using SharpConfig;
using System.Threading;

namespace RealifevTemplate.Server
{
    using static Shared.Main;
    public class Main : BaseScript
    {
        public Main()
        {
            Debug.WriteLine("Hi from RealifevTemplate.Server!");

            HandleConfig(new Action<Section, Configuration>((section, config) =>
            {
                Debug.WriteLine("HandleConfig");
            }));
        }

        [Command("hello_server")]
        public void HelloServer()
        {
            Debug.WriteLine("Sure, hello.");
        }
        
        [EventHandler("onResourceStart")]
        public void TestEvent(string resourceName)
        {
            Debug.WriteLine($"{resourceName} start");
        }
    }
}
