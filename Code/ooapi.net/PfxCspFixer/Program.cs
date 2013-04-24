/**
 * Copyright (c) 2010, DanID A/S
 * All rights reserved.
 *
 * Redistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met:
 *
 *  - Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.
 *  - Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the documentation and/or other materials provided with the distribution.
 *  - Neither the name of the DanID A/S nor the names of its contributors may be used to endorse or promote products derived from this software without specific prior written permission.
 *
 * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES,
 * INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
 * DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
 * SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
 * SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY,
 * WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE
 * USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 */
using System;
using System.IO;
using System.Security.Cryptography;
using System.Security.Cryptography.X509Certificates;

namespace PfxCspFixer
{
    class Program
    {
        static void Main(string[] args)
        {
            try
            {
                /*
                 * This program is used to change the csp name in a pfx file.
                 */
                PrintLine("Set correct CSP name in pfx file.");
                PrintLine("\n\nEnter path to PFX file.");
                var pfxPath = Prompt().Trim();
                PrintLine("\n\nEnter password to the PFX file.");
                var pfxPasswords = Prompt();

                var file = new FileInfo(pfxPath);
                if (!file.Exists || file.Directory == null)
                {
                    PrintLine("\nCould not find pfx file.");
                    return;
                }

                var newPfxPath = file.Directory.FullName + "\\correctCsp" + file.Name;
                PrintLine("New pfx file will be: " + newPfxPath);
                var newFile = new FileInfo(newPfxPath);
                if (newFile.Exists)
                {
                    PrintLine("\nFile already exists.");
                    return;
                }

                var oldPfx = new X509Certificate2(pfxPath, pfxPasswords, X509KeyStorageFlags.Exportable);
                var newPfx = new X509Certificate2(oldPfx);
                
                var csp = (RSACryptoServiceProvider)oldPfx.PrivateKey;
                
                var cspParams = new CspParameters();
                cspParams.KeyContainerName = "somealias";
                cspParams.ProviderType = 24; //Microsoft Enhanced RSA and AES Cryptographic Provider
                var rsaAlg = new RSACryptoServiceProvider(oldPfx.PrivateKey.KeySize, cspParams);

                rsaAlg.ImportParameters(csp.ExportParameters(true));
                newPfx.PrivateKey = rsaAlg;
                using (var fileStream = new FileStream(newPfxPath, FileMode.CreateNew))
                {
                    using (var writer = new BinaryWriter(fileStream))
                    {
                        writer.Write(newPfx.Export(X509ContentType.Pfx, pfxPasswords));
                    }
                }
            }
            catch (Exception e)
            {
                PrintLine(e.StackTrace);
                Prompt();
            }

        }
        static void Print(string s)
        {
            Console.Write(s);
        }

        static void PrintLine(string line)
        {
            Console.WriteLine(line);
        }

        static string Prompt()
        {
            Print("> ");
            return Console.ReadLine();
        }
    }
}
