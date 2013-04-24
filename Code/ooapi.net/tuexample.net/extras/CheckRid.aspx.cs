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
using System.Configuration;
using org.openoces.ooapi.environment;
using org.openoces.ooapi.pidservice;
using org.openoces.ooapi.utils;
using org.openoces.ooapi.ridservice;
using dk.certifikat.tuexample.util;
using System.Web;

namespace dk.certifikat.extras
{
    public partial class CheckRid : System.Web.UI.Page
    {
        private static readonly string SpidPid = ConfigurationManager.AppSettings["spidPid"];
        private readonly Enum _spidEnv = (OcesEnvironment)
                Enum.Parse(typeof(OcesEnvironment), ConfigurationManager.AppSettings["pidEnvironment"], true);

        protected void validateRid(object sender, EventArgs e)
        {
            Session.Remove("cpr");
            Session.Remove("errorText");

            try
            {
                
                var rid = RequestValidator.getValidatedParam("rid", ridTxt.Text, 30);


                var wsUrl = Properties.Get("rid.service.url." + _spidEnv);
                RidService ridService = new RidService(wsUrl);
                var cpr = ridService.getCPR(rid);
                if (cpr != null && !"".Equals(cpr.Trim()))
                {
                    Session.Add("cpr", cpr);
                    Session.Add("Text", "Det lykkedes at hente CPR på PID.");
                }
                else
                {
                    Session.Add("errorText", "Rid " + rid + " matcher ikke et cpr");
                }

                ridTxt.Text = HttpUtility.HtmlEncode(rid);
                cprLabel.Text = HttpUtility.HtmlEncode(cpr);
                ridLabel.Text = HttpUtility.HtmlEncode(rid);
            }
            catch (RidServiceException ex)
            {
                Session.Add("errorText", ex);
            }
            catch (ArgumentException ae)
            {
                Session.Add("errorText", ae.Message);
            }
        }
    }
}
