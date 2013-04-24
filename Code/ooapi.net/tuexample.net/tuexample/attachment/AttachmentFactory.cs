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
using System.Reflection;
using System.Security.Cryptography;

namespace dk.certifikat.tuexample.attachment
{
    public class AttachmentFactory
    {
        private readonly HashAlgorithm _hashAlgorithm;
        private const string Path = "dk.certifikat.";

        public AttachmentFactory(string hashAlgorithm)
        {
            if (hashAlgorithm.ToUpper() == "SHA256")
            {
                _hashAlgorithm = SHA256.Create();
            }
            else if (hashAlgorithm.ToUpper() == "SHA-1")
            {
                _hashAlgorithm = SHA1.Create();
            }
        }

        static Stream CreateStream(string filePath)
            {
            var assembly = Assembly.GetExecutingAssembly();
            var stream = assembly.GetManifestResourceStream(@filePath);
            
            if (stream == null)
            {
                throw new ArgumentException("File '" + filePath + "' cannot be read");
            }
            return stream;
        }

        public Attachment Create(string title, string attachmentPath, string attachmentFile, string mimeType, bool optional)
        {
            byte[] content = ReadAttachment(attachmentFile);
            int size = content.Length;
            string hashValue = CreateHashValue(content);
            return new Attachment(title, attachmentPath, mimeType, size, hashValue, optional);
        }

        

        private static byte[] ReadAttachment(string attachment)
        {
            using (Stream stream = CreateStream(Path + attachment))
            {
                using (var br = new BinaryReader(stream))
                {
                    return br.ReadBytes((int)stream.Length);
                }
            }
        }

        private string CreateHashValue(byte[] data)
        {
            return Base64Encode(_hashAlgorithm.ComputeHash(data));
        }

        private static string Base64Encode(byte[] bytes)
        {
            return Convert.ToBase64String(bytes);
        }
    }
}
