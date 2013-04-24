using System;
using dk.certifikat.tuexample;
using dk.certifikat.tuexample.util;
using org.openoces.ooapi.certificate;
using org.openoces.securitypackage;
using System.Configuration;

namespace dk.certifikat.variant2
{
    public partial class Sign : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            Session.Remove("errorText");
            string result = Request["result"];
            if (result != null && result.Length % 4 == 0)
            {
                result = SignHandler.Base64Decode(result);
            }
            if (result != null && "ok" == result.ToLower())
            {
                var loginData = Request["signature"];
                var textToBeSigned = (string)Session["signText"];
                var signTextTransformation = (string)Session["signTransformation"];
                var logonto = ConfigurationManager.AppSettings["logonto"];
                var signTextFormat = (String)Session["signTextFormat"];

                if (logonto == null || "".Equals(logonto.Trim()))
                {
                    throw new ConfigurationErrorsException("Fejl: Logonto / friendlyname mangler, eller er tom i konfigurationen");
                }



                SignatureValidationStatus status = null;
                if ("pdf".Equals(signTextFormat))
                {
                    status = SignHandler.validateSignatureAgainstAgreementPDF(loginData, textToBeSigned, Challenge(), logonto);
                }
                else
                {
                    status = SignHandler.ValidateSignatureAgainstAgreement(loginData, textToBeSigned, signTextTransformation, Challenge(), logonto);
                }

                if (!(status.Certificate is MocesCertificate))
                {
                    Session.Add("errorText", "Det benyttede certifikat er ikke af korrekt type. Forventede medarbejdercertifikat, fik " + ErrorHandler.CertificateType(status));
                }
                else if (status.CertificateStatus != CertificateStatus.Valid)
                {
                    Session.Add("errorText", "Certifikatet er " + ErrorHandler.GetCertificateStatusText(status.CertificateStatus));
                }
                else if (status.SignatureMatches)
                {
                    Response.Redirect("signeringskvittering.aspx");
                }
                else
                {
                    Session.Add("errorText", "Signaturen matcher ikke teksten '" + textToBeSigned + "'.");
                }
            }
            else
            {
                Session.Add("errorText", ErrorHandler.GetErrorText(String.IsNullOrEmpty(result) ? "cancelsign" : result));
            }
        }

        private string Challenge()
        {
            var challenge = (string)Session[ChallengeGenerator.ChallengeSessionKey];
            Session.Remove(ChallengeGenerator.ChallengeSessionKey);
            return challenge;
        }
    }
}