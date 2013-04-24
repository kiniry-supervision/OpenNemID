<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="signer-med-digital-signatur.aspx.cs" Inherits="dk.certifikat.variant3.signer_med_digital_signatur" %>
<%@ Import Namespace="dk.certifikat.tuexample"%>
<%@ Import Namespace="org.openoces.securitypackage"%>

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
	string textToBeSigned = "Lørem æpsum dolor sit Åmet, consectetuer.";
	Session.Add("signText", textToBeSigned);
    string openOcesLocation = ConfigurationManager.AppSettings["openOcesLocation"];
    string openOcesJar = ConfigurationManager.AppSettings["openOcesJar"];

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
            if( preferredLogin == 'DigitalSignatur') {
                $('#rememberDigitalSignatur').attr('checked', true);
            }

            // Set preferredLogin cookie
            $('#rememberDigitalSignatur').click(function(){
                if($('#rememberDigitalSignatur').is(':checked')) {
                    $.cookie('preferredLogin', 'DigitalSignatur', { expires: 365, path: '/' });
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
                    <li>
                        <a href="signer-med-engangsnoegle.aspx" accesskey="3"><span class="nemidLogo"><!-- nemidLogo--></span><span>Signer med nøglekort</span></a>
                    </li>
                    <li>
                        <a href="signer-uden-engangsnoegle.aspx" accesskey="4"><span class="nemidLogo"><!-- nemidLogo--></span><span>Signer med nøglefil</span></a>
                    </li>
                    <li class="selected">
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
                    <div id="appPlaceholder" class="wide">
                        <h1>Signer med Digital Signatur</h1>
                        <form method="post" action="Sign.aspx" id="signedForm" name="signedForm">
                            <input type="hidden" name="signature" id="signature" />
                            <input type="hidden" name="result" id="result" />
                            <fieldset>
                                <legend>Signer med Digital Signatur</legend>
                                <dl>
                                    <dt>
                                        <img src="/resources/images/logoDigitalSignatur.png" alt="Digital Signatur (logo)" />
                                    </dt>
                                    <dd class="selectUser">
                                        <script type="text/javascript">
                                            function onSignOK(signature) {
                                              document.signedForm.signature.value=signature;
                                              document.signedForm.result.value='<%=SignHandler.Base64Encode("ok")%>';
                                              document.signedForm.submit();
                                            }
                                            function onSignCancel() {
                                              document.signedForm.submit();
                                            }
                                            function onSignError(msg) {
                                              document.signedForm.result.value=msg;
                                              document.signedForm.submit();
                                            }
                                        </script>

                                        <applet id="signing_applet" name="signing_applet" code="org.openoces.opensign.client.applet.bootstrap.BootApplet" width="600" height="400" codebase="<%= openOcesLocation %>" archive="<%= openOcesJar %>" mayscript="true">
                                            <param name="signtext" value="<%=SignHandler.Base64Encode(textToBeSigned)%>"/>
                                            <param name="ZIP_FILE_ALIAS" value="OpenSign" />
                                            <param name="ZIP_BASE_URL" value="<%= openOcesLocation %>plugins" />
                                            <param name="MS_SUPPORT" value="bcjce" />
                                            <param name="SUN_SUPPORT" value="jsse" />
                                            <param name="STRIP_ZIP" value="yes" />
                                            <param name="EXTRA_ZIP_FILE_NAMES" value="capi,pkcs12,cdcard,oces" />
                                            <param name="LOG_LEVEL" value="INFO" />

                                            <param name="locale" value="da,DK" />

                                            <param name="cabbase" value="<%= openOcesLocation %>OpenSign-bootstrapped.cab" />

                                            <param name="key.store.directory" value="null" />

                                            <param name="loglevel" value="debug" />

                                            <param name="background" value="255,255,255" />
                                            <param name="socialsecuritynumber" value="no" />

                                            <param name="optionalid" value="no" />

                                            <param name="opensign.doappletrequest" value="false" />
                                            <param name="opensign.doappletrequestonmac" value="false" />
                                            <param name="logonto" value="DanID Test TU" />
                                            <param name="cdkortservice" value="demo" />

                                            <param name="signproperties" value="challenge=<%=ChallengeGenerator.GenerateChallenge(Session)%>" />
                                            <param name="subjectdnfilter" value=""/>
                                            <param name="issuerdnfilter" value="<%=SignHandler.Base64Encode("TDC")%>" />
                                            <param name="opensign.message.name" value="signature" />
                                            <param name="opensign.result.name" value="result" />
                                            <param name="gui" value="modern" />
                                        </applet>
                                    </dd>
                                </dl>
                                <p class="remember">
                                    <input type="checkbox" name="rememberDigitalSignatur" id="rememberDigitalSignatur" />
                                    <label for="rememberDigitalSignatur">Husk jeg vil signere med Digital Signatur</label>
                                </p>
                            </fieldset>
                        </form>
                    </div>
                    <div id="right-col">
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