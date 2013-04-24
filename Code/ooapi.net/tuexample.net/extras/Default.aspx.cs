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
using org.openoces.serviceprovider;
using dk.certifikat.tuexample.attachment;

namespace dk.certifikat.extras
{
    public partial class Default : System.Web.UI.Page
    {

        protected void changeSignText(object sender, EventArgs e)
        {
            Session.Remove("signTextFormat");
            Session.Remove("attachment");
            var signTextType = Request["signTextType"];

            if ("xml".Equals(signTextType))
            {
                Session.Add("signTextFormat", "xml");
                
            }
            else if ("txt".Equals(signTextType))
            {
                Session.Add("signTextFormat", "txt");
                
            }
            else if ("pdf".Equals(signTextType))
            {
                Session.Add("signTextFormat", "pdf");
                Session.Add("signTextUri", "/extras/attachment/sample.pdf?jsessionid=" + Session.SessionID);
                
            }
            else if("pdf_w_attachment".Equals(signTextType)) 
            {
                Session.Add("signTextFormat", "pdf_w_attachment");
                Session.Add("signTextUri", "/extras/attachment/sample.pdf?jsessionid=" + Session.SessionID);
                Attachment attachment = new AttachmentFactory("SHA256").Create("GIF-dokument-til-bilag.gif", "/extras/attachment/GIF-dokument-til-bilag.gif", "extras.attachment.GIF-dokument-til-bilag.gif", "image/gif", true);
                Session.Add("attachment", attachment);
            }
            else
            {
                Session.Add("signTextFormat", "html");
            }
            Response.Redirect("/extras/");
        }

                protected void changeRevocationList(object sender, EventArgs e)
                {
                    Session.Remove("revocationCheckType");
                    var revocationCheckType = Request["revocationCheckType"];

                    if ("full".Equals(revocationCheckType))
                    {
                        ServiceProviderSetup.SetFullCrlRevocationChecker();
                        Session.Add("revocationCheckType", "full");
                    }
                    else if ("ocsp".Equals(revocationCheckType))
                    {
                        ServiceProviderSetup.SetOcspRevocationChecker();
                        Session.Add("revocationCheckType", "ocsp");
                    }
                    else
                    {
                        ServiceProviderSetup.SetPartitionedCrlRevocationChecker();
                        Session.Add("revocationCheckType", "partitioned");
                    }
                    Response.Redirect("/extras/");
                }


        

    }
}