

using System;
using System.IO;
using System.IO.Ports;
using System.Threading;

namespace djs.serialcomms
{
    class CSerialProgramLoader
    {
        // variables
        private const byte START_CODE = 0xF0;
        private const byte START_ACK_CODE = 0xF1;
        private const byte COMPLETION_CODE = 0xF2;
        private const byte COMPLETION_ACK_CODE = 0xF3;
        private const byte ERROR_CODE = 0xFF;

        private string m_portname;
        private SerialPort m_serial_port;
        private byte[] m_send_buffer;
        private byte[] m_receive_buffer;

        // properties


        // functions
        public CSerialProgramLoader(string portname)
        {
            this.m_portname = portname;
            this.m_send_buffer = null;
            this.m_receive_buffer = null;
        }

        public bool run(string filename)
        {
            // open the instruction file
            System.Console.Write("Opening instruction file " + filename + "\n");
            StreamReader sr;
            try
            {
                sr = new StreamReader(filename);
            }
            catch (Exception)
            {
                System.Console.Write("***ERROR*** Unable to open file.  Aborting\n");
                return false;
            }

            // create the buffers
            System.Console.Write("Creating send and receive buffers\n");
            this.m_send_buffer = new byte[4];
            this.m_receive_buffer = new byte[4];

            // create the serial port
            System.Console.Write("Creating serial port\n");
            this.m_serial_port = new SerialPort(this.m_portname, 9600, Parity.None, 8, StopBits.One);
            this.m_serial_port.DiscardNull = false;
            this.m_serial_port.Handshake = Handshake.None;
            this.m_serial_port.RtsEnable = true;
            

            // open the serial port
            System.Console.Write("Opening serial port\n");
            try
            {
                this.m_serial_port.Open();
            }
            catch (Exception)
            {
                System.Console.Write("***ERROR*** Unable to open comport " + this.m_portname + "\n");
                this.m_serial_port.Close();
                return false;
            }

            // set read timeout
            System.Console.Write("Setting serial port read timeout to 3 seconds\n");
            // set the read timeout to 3 seconds
            this.m_serial_port.ReadTimeout = 3000;

            // press any key to start
            System.Console.Write("Ensure the Hardware is enabled to receive program.\nPress any key to start transfer\n");
            System.Console.ReadKey();
            System.Console.Write("\n");

            // now do actual serial transfers
            try
            {
                // first thing we do is send a start code
                System.Console.Write("Sending START_CODE\n");
                this.m_send_buffer[0] = START_CODE;
                this.m_serial_port.Write(this.m_send_buffer, 0, 1);
                Thread.Sleep(1);

                // wait for the ack
                System.Console.Write("Waiting for START_ACK_CODE\n");
                int val = this.m_serial_port.Read(this.m_receive_buffer, 0, 1);
                if (val != 1)
                {
                    System.Console.Write("Unable to read bytes from serial port.  Aborting.\n");
                    this.m_serial_port.Close();
                    return false;
                }
                if (this.m_receive_buffer[0] == START_ACK_CODE)
                {
                    System.Console.Write("START_ACK_CODE received.\n");
                }
                else
                {
                    System.Console.Write("Received invalid response [0x" + this.m_receive_buffer[0].ToString("X2") + "].  Aborting.\n");
                    this.m_serial_port.Close();
                    return false;
                }

                // can now send the data from the file
                string line = "";
                while ((line = sr.ReadLine()) != null)
                {
                    System.Console.Write("Sending " + line + "\n");
                    this.convert_hex_string_to_byte_array(line, this.m_send_buffer);
                    this.m_serial_port.Write(this.m_send_buffer, 0, 4);
                    Thread.Sleep(1);
                }

                // send the completion byte
                System.Console.Write("Sending COMPLETION_CODE\n");
                this.m_send_buffer[0] = COMPLETION_CODE;
                this.m_serial_port.Write(this.m_send_buffer, 0, 1);

                // wait for the ack
                System.Console.Write("Waiting for COMPLETION_ACK_CODE\n");
                val = this.m_serial_port.Read(this.m_receive_buffer, 0, 1);
                if (val != 1)
                {
                    System.Console.Write("Unable to read bytes from serial port.  Aborting.\n");
                    this.m_serial_port.Close();
                    return false;
                }
                if (this.m_receive_buffer[0] == COMPLETION_ACK_CODE)
                {
                    System.Console.Write("COMPLETION_ACK_CODE received.\n");
                }
                else
                {
                    System.Console.Write("Received invalid response [0x" + this.m_receive_buffer[0].ToString("X2") + "].  Aborting.\n");
                    this.m_serial_port.Close();
                    return false;
                }
            }
            catch (Exception)
            {
                System.Console.Write("***ERROR*** Unable to send/receive data.  Aborting\n");
                this.m_serial_port.Close();
                return false;
            }


            System.Console.Write("Transfer complete\n");
            this.m_serial_port.Close();
            return true;
        }

        private void convert_hex_string_to_byte_array(string hex_string, byte[] array)
        {
            // converts a hex string into a byte array representing the string
            int NumberChars = hex_string.Length;
            for (int i = 0; i < NumberChars; i += 2)
            {
                array[i / 2] = Convert.ToByte(hex_string.Substring(i, 2), 16);
            }
        }
    }
}
