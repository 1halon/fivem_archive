using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using CitizenFX.Core;

namespace RealifevTemplate.Server
{
    public class Main : BaseScript
    {
        public Main()
        {
            Debug.WriteLine("Hi from RealifevTemplate.Server!");

        }

        [Command("hello_server")]
        public void HelloServer()
        {
            Debug.WriteLine("Sure, hello.");
        }
    }
}
