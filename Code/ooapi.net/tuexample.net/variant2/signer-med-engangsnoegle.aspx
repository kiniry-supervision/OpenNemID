<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="signer-med-engangsnoegle.aspx.cs" Inherits="dk.certifikat.variant2.signer_med_engangsnoegle" %>
<%@ Import Namespace="dk.certifikat.tuexample"%>
<%@ Import Namespace="org.openoces.ooapi.web"%>

<%--

    Copyright (c) 2010, DanID A/S
    All rights reserved.

    Redistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met:

     - Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.
     - Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the documentation and/or other materials provided with the distribution.
     - Neither the name of the DanID A/S nor the names of its contributors may be used to endorse or promote products derived from this software without specific prior written permission.

    THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES,
    INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
    DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
    SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
    SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY,
    WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE
    USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

--%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">

<%
	String htmlToBeSigned =
		"<html>"+
			"<head>"+
				"<title>Lorem ipsum dolor sit amet</title>"+
			"</head>"+
			"<body>"+
				"<h2>Lorem ipsum dolor sit amet</h2>"+
				"<p>Lorem ipsum dolor sit amet, consectetuer <b>adipiscing</b> elit. Fusce <i>ultricies</i>, tellus sit amet semper accumsan, enim dui tincidunt nisl, at bibendum massa erat in nisl.</p>"+
				"<ol>"+
					"<li>Duis quis sem</li>"+
					"<li>Ut luctus consequat lacus</li>"+
				"</ol>"+
				"<p><font size=\"2\">Sed consequat, mi a tempus scelerisque, velit risus pulvinar velit, et sollicitudin lectus dui a orci</font></p>"+
			"</body>"+
		"</html>";

	String txtToBeSigned = "Lørem æpsum dolor sit Åmet, consectetuer.";

	String xmlToBeSigned = "<root><header>Lorem ipsum dolor sit amet</header><body>Lørem æpsum dolor sit Åmet, consectetuer.</body></root>";
	String xsltForXmlToBeSigned = "PHhzbDpzdHlsZXNoZWV0IHZlcnNpb249IjEuMCIgeG1sbnM6eHNsPSJodHRwOi8vd3d3LnczLm9y"+
								  "Zy8xOTk5L1hTTC9UcmFuc2Zvcm0iPg0KDQo8eHNsOnRlbXBsYXRlIG1hdGNoPSIvIj4NCiAgPGh0"+
								  "bWw+DQogIDxib2R5Pg0KICA8aDI+PHhzbDp2YWx1ZS1vZiBzZWxlY3Q9InJvb3QvaGVhZGVyIi8+"+
								  "PC9oMj4NCiAgPHA+PHhzbDp2YWx1ZS1vZiBzZWxlY3Q9InJvb3QvYm9keSIvPjwvcD4NCiAgPC9i" +
								  "b2R5Pg0KICA8L2h0bWw+DQo8L3hzbDp0ZW1wbGF0ZT4NCjwveHNsOnN0eWxlc2hlZXQ+DQo="; // Base64 encoded XSLT

    var signer = new Signer(ConfigurationManager.AppSettings["pfxFile"], ConfigurationManager.AppSettings["pfxPassword"]);

    var generator = new OcesAppletElementGenerator(signer);
    generator.AddServerUrlPrefix(ConfigurationManager.AppSettings["nemIDAppletPrefix"]);
    var challenge = ChallengeGenerator.GenerateChallenge(Session);
    generator.SetChallenge(challenge);
    generator.SetLogLevel("debug"); // INFO/DEBUG/ERROR
    generator.AddSignedParameter("always_embedded", "true");

    string format = "" + Session["signTextFormat"];
    if (format.ToLower().Equals("txt"))
    {
        generator.SetSignText(txtToBeSigned, "plain");
        Session.Add("signText", txtToBeSigned);
        Session.Remove("signTransformation");
    }
    else if (format.ToLower().Equals("xml"))
    {
        generator.SetSignText(xmlToBeSigned, "xml");
        generator.AddSignedParameter("signTransformation", xsltForXmlToBeSigned);
        Session.Add("signText", xmlToBeSigned);
        Session.Add("signTransformation", xsltForXmlToBeSigned);
    }
    else
    {
        generator.SetSignText(htmlToBeSigned, "html");
        Session.Add("signText", htmlToBeSigned);
        Session.Remove("signTransformation");
    }    
%>
<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="da" lang="da">
    <head>
        <title>TU-interaktionsdesign</title>
        <!--#include virtual="/include/common-head.inc" -->
        <script type="text/javascript">
        $().ready(function() {
            // Read cookie
            var preferredLogin = $.cookie('preferredLogin');

            // Set 'remember' checkbox according to preferredLogin cookie
            if( preferredLogin == 'Otp') {
                $('#rememberOtp').attr('checked', true);
            }

            // Set preferredLogin cookie
            $('#rememberOtp').click(function(){
                if($('#rememberOtp').is(':checked')) {
                    $.cookie('preferredLogin', 'Otp', { expires: 365, path: '/' });
                } else {
                    $.cookie('preferredLogin', '', { expires: 365, path: '/' });
                }
            });
        });
        </script>
    </head>
    <body>

        <div id="skipToContent" class="accessibility">
            <dl>
                <dt>Genveje:</dt>
                <dd><a href="#tabs" title="Gå direkte til signeringsvalg" accesskey="1">Signeringsvalg</a></dd>
                <dd><a href="#content" title="Gå direkte til hovedindhold" accesskey="2">Hovedindhold</a></dd>
            </dl>
        </div>
        <!-- container for header section -->
        <div id="headerWrapper">
            <div id="header">
                <ul id="tabs">
                    <li class="selected">
                        <a href="signer-med-engangsnoegle.aspx" accesskey="3"><span class="nemidLogo"><!-- nemidLogo--></span><span>Signer med nøglekort</span></a>
                    </li>
                    <li>
                        <a href="signer-uden-engangsnoegle.aspx" accesskey="4"><span class="nemidLogo"><!-- nemidLogo--></span><span>Signer med nøglefil</span></a>
                    </li>
                    <li>
                        <a href="signer-med-digital-signatur.aspx" accesskey="5"><span class="digitalSignaturLogo"><!-- digitalSignaturLogo--></span><span>Signer med Digital Signatur</span></a>
                    </li>
                </ul>
            </div>
        </div>

        <div id="contentWrapper">
            <div id="content">
                <div class="tools">
                    <ul>
                        <li id="speaker"><a href="http://adgangforalle.dk" rel="external" title="Få teksten læst op - link til Adgangforalle.dk (åbner i nyt vindue)"><span class="accessibility">Oplæsning af tekst</span></a></li>
                    </ul>
                </div>
                <div id="signerWrapper">
                    <div id="appPlaceholder">
                        <fieldset>
                            <legend>Signer med engangsnøgle</legend>
        					<%= generator.GenerateSignAppletElement("sign.aspx") %>
                            <p class="remember">
                                <input type="checkbox" name="rememberOtp" id="rememberOtp" />
                                <label for="rememberOtp">Husk jeg vil signere med nøglekort</label>
                            </p>
                        </fieldset>
                    </div>
                    <div id="right-col">
                        <ul class="thumbs">
                            <li><span><img src="/resources/images/icons/Noglekort_lille.png" alt="Nøglekort" title="Nøglekort" /></span></li>
                        </ul>

                        <h2>Genveje</h2>
                        <ul class="linkList">
                            <li><a href="/" title="Klik her for at få hjælp nu">Få hjælp nu</a></li>
                            <li><a href="/" title="Klik her for at bestille NemID">Bestil NemID</a></li>
                            <li><a href="/" title="Klik her hvis du har glemt din adgangskode">Glemt adgangskode</a></li>
                        </ul>
                    </div>
                </div>
            </div>
        </div>
    </body>
</html>