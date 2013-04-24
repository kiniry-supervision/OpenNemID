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
using System.Web.Security;
using dk.certifikat.tuexample;
using dk.certifikat.tuexample.util;
using org.openoces.ooapi.certificate;
using org.openoces.ooapi.exceptions;
using org.openoces.securitypackage;
using org.openoces.serviceprovider;
using System.Configuration;

namespace dk.certifikat.variant3
{
    public partial class Validate : System.Web.UI.Page
    {
        public static string KeyPid = "variant3.pid";
        public static string KeyRid = "variant3.rid";
        public static string KeyCvr = "variant3.cvr";
        public static string KeyType = "variant3.type";

        protected void Page_Load(object sender, EventArgs e)
        {
            var result = Request["result"];
            if (result.Length % 4 == 0)
            {
                result = SignHandler.Base64Decode(result);
            }
            if ("ok" == result.ToLower())
            {
                try
                {
                    String logonto = ConfigurationManager.AppSettings["logonto"];
                    if (logonto == null || "".Equals(logonto.Trim()))
                    {
                        throw new ConfigurationErrorsException("Error - logonto parameter from configuration is missing or empty");
                    }
                    string signature = SignHandler.Base64Decode(Request["signature"]);
                    CertificateAndStatus certificateAndStatus = LogonHandler.ValidateAndExtractCertificateAndStatus(signature, Challenge(), logonto);
                    if (certificateAndStatus.Certificate is PocesCertificate || certificateAndStatus.Certificate is MocesCertificate)
                    {
                        CertificateStatus status = certificateAndStatus.CertificateStatus;
                        if (status == CertificateStatus.Valid)
                        {
                            SetAttributesForMocesOrPoces(certificateAndStatus.Certificate);

                            if (Session[Global.CurrentUser] == null)
                            {
                                var randomUserName = ChallengeGenerator.GenerateChallenge();
                                Session.Add(Global.CurrentUser, randomUserName);
                            }
                            if (!Roles.IsUserInRole((string)Session[Global.CurrentUser], "nemid"))
                            {
                                Roles.AddUserToRole((string)Session[Global.CurrentUser], "nemid");
                            }
                            FormsAuthentication.RedirectFromLoginPage((string)Session[Global.CurrentUser], false);
                        }
                        else
                        {
                            Session.Add("errorText", "Certifikatet er " + ErrorHandler.GetCertificateStatusText(status));
                        }
                    }
                    else
                    {
                        Session.Add("notPocesOrMoces", true);
                    }
                }
                catch (NonOcesCertificateException)
                {
                    Session.Add("errorText", "Ikke et OCES-certifikat");
                }
                catch (Exception)
                {
                    Session.Add("errorText", "Ukendt server-fejl");
                }
            }
            else
            {
                Session.Add("errorText", ErrorHandler.GetErrorText(result));
            }
        }

        private string Challenge()
        {
            var challenge = (string)Session[ChallengeGenerator.ChallengeSessionKey];
            Session.Remove(ChallengeGenerator.ChallengeSessionKey);
            return challenge;
        }

        private void SetAttributesForMocesOrPoces(OcesCertificate certificate)
        {
            if (certificate is PocesCertificate)
            {
                Session.Add(KeyType, "POCES");
                Session.Add(KeyPid, ((PocesCertificate)certificate).Pid);
            }
            else
            {
                Session.Add(KeyType, "MOCES");
                Session.Add(KeyRid, ((MocesCertificate)certificate).Rid);
                Session.Add(KeyCvr, ((MocesCertificate)certificate).Cvr);
            }
        }
    }
}       