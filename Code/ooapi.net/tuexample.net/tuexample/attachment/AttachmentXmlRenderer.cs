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

using System.Text;

namespace dk.certifikat.tuexample.attachment
{
    public class AttachmentXmlRenderer
    {
        public string ToXml(Attachment attachments)
        {
            return ToXml(new[] {attachments});
        }

        public string ToXml(Attachment[] attachments)
        {
            var builder = new StringBuilder();
            builder.Append("<?xml version=\"1.0\" encoding=\"UTF-8\" ?>\n");
            builder.Append("<attachments>\n");
            foreach (var attachment in attachments)
            {
                builder.Append(ToAttachmentXml(attachment));
            }
            builder.Append("</attachments>\n");
            return builder.ToString();
        }

        private static string ToAttachmentXml(Attachment attachment)
        {
            var builder = new StringBuilder();
            builder.Append("<attachment>\n");
            builder.Append("<title>").Append(attachment.Title).Append("</title>\n");
            builder.Append("<path>").Append(attachment.Path).Append("</path>\n");
            builder.Append("<mimeType>").Append(attachment.MimeType).Append("</mimeType>\n");
            builder.Append("<size>").Append(attachment.Size).Append("</size>\n");
            builder.Append("<hashValue>").Append(attachment.HashValue).Append("</hashValue>\n");
            if (attachment.Optional)
            {
                builder.Append("<optional/>\n");
            }
            builder.Append("</attachment>\n");
            return builder.ToString();
        }
    }
}
