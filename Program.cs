

namespace djs.serialcomms
{
    class Program
    {
        static void Main(string[] args)
        {
            if (args.Length != 2)
            {
                System.Console.Write("Use: progloader comport filename\n\tExample:  progloader COM4 instructions.txt\n");
                return;
            }

            string commport = args[0];
            string filename = args[1];
            
            CSerialProgramLoader pl = new CSerialProgramLoader(commport);

            do
            {
                if (pl.run(filename) == false)
                {
                    System.Console.Write("Try Again? <y/n>:");
                    if (System.Console.ReadKey().Key != System.ConsoleKey.Y)
                    {
                        System.Console.Write("\n");
                        break;
                    }
                    else
                    {
                        System.Console.Write("\n");
                    }
                }
                else
                {
                    break;
                }
            } while (true);
        }
    }
}
