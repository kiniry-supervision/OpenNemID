using System;
using System.Collections;
using System.Configuration;
using System.Data;
using System.Linq;
using System.Web;
using System.Web.Security;
using System.Web.UI;
using System.Web.UI.HtmlControls;
using System.Web.UI.WebControls;
using System.Web.UI.WebControls.WebParts;
using System.Xml.Linq;
using dk.certifikat.tuexample.util;
using System.Text;
using dk.certifikat.tuexample.attachment;
using org.openoces.securitypackage;

namespace dk.certifikat.variant2
{
    public partial class signer_uden_engangsnoegle : System.Web.UI.Page
    {
        public String documentHash;
        public String encodedAttachmentXml;
        public String signTextUri;
        public String signTextFormat;
        public String signText;
        public String xsltForXmlToBeSigned = "PHhzbDpzdHlsZXNoZWV0IHZlcnNpb249IjEuMCIgeG1sbnM6eHNsPSJodHRwOi8vd3d3LnczLm9y" +
                                          "Zy8xOTk5L1hTTC9UcmFuc2Zvcm0iPg0KDQo8eHNsOnRlbXBsYXRlIG1hdGNoPSIvIj4NCiAgPGh0" +
                                          "bWw+DQogIDxib2R5Pg0KICA8aDI+PHhzbDp2YWx1ZS1vZiBzZWxlY3Q9InJvb3QvaGVhZGVyIi8+" +
                                          "PC9oMj4NCiAgPHA+PHhzbDp2YWx1ZS1vZiBzZWxlY3Q9InJvb3QvYm9keSIvPjwvcD4NCiAgPC9i" +
                                          "b2R5Pg0KICA8L2h0bWw+DQo8L3hzbDp0ZW1wbGF0ZT4NCjwveHNsOnN0eWxlc2hlZXQ+DQo="; // Base64 encoded XSLT

        protected void Page_Load(object sender, EventArgs e)
        {
            String htmlToBeSigned =
            "<html>" +
                "<head>" +
                    "<title>Lorem ipsum dolor sit amet</title>" +
                "</head>" +
                "<body>" +
                    "<h2>Lorem ipsum dolor sit amet</h2>" +
                    "<p>Lorem ipsum dolor sit amet, consectetuer <b>adipiscing</b> elit. Fusce <i>ultricies</i>, tellus sit amet semper accumsan, enim dui tincidunt nisl, at bibendum massa erat in nisl.</p>" +
                    "<ol>" +
                        "<li>Duis quis sem</li>" +
                        "<li>Ut luctus consequat lacus</li>" +
                    "</ol>" +
                    "<p><font size=\"2\">Sed consequat, mi a tempus scelerisque, velit risus pulvinar velit, et sollicitudin lectus dui a orci</font></p>" +
                "</body>" +
            "</html>";

            String txtToBeSigned = "Lørem æpsum dolor sit Åmet, consectetuer.";

            String xmlToBeSigned = "<root><header>Lorem ipsum dolor sit amet</header><body>Lørem æpsum dolor sit Åmet, consectetuer.</body></root>";
            
            signTextFormat = Session["signTextFormat"] as String;
            
            if (signTextFormat == null)
                signTextFormat = "html";

            if ("txt".Equals(signTextFormat))
            {
                
                Session.Add("signText", txtToBeSigned);
                signText = SignHandler.Base64Encode(txtToBeSigned);
            } 
            else if ("xml".Equals(signTextFormat))
            {
                
                Session.Add("signTransformation", xsltForXmlToBeSigned);
                Session.Add("signText", xmlToBeSigned);
                signText = SignHandler.Base64Encode(xmlToBeSigned);
                
            }
            else if ("html".Equals(signTextFormat))
            {
                signText = SignHandler.Base64Encode(htmlToBeSigned);
                Session.Add("signText", htmlToBeSigned);
            }
            else if (signTextFormat.StartsWith("pdf"))
            {
                signTextUri = Session["signTextUri"] as String;
                ResourceHelper helper = new ResourceHelper();
                String absPath = helper.ConvertRelativeUrlToAbsoluteUrl("/extras/attachment/sample.pdf", Request, Page);
                byte[] data = helper.readFileContentFromURL(absPath);
                Session.Add("signText", Encoding.ASCII.GetString(data));
                documentHash = helper.CreateHashValue(data);
                Attachment attachment = (Attachment)Session["attachment"];
                if (attachment != null)
                {
                    encodedAttachmentXml = helper.Base64Encode(new AttachmentXmlRenderer().ToXml(attachment));
                }
                signTextFormat = "pdf";
                
                Session.Add("signTextFormat", signTextFormat);
            }
            
        }
    }
}
