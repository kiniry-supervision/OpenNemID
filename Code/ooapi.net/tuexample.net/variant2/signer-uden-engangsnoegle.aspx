<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="signer-uden-engangsnoegle.aspx.cs" Inherits="dk.certifikat.variant2.signer_uden_engangsnoegle" %>
<%@ Import Namespace="dk.certifikat.tuexample"%>
<%@ Import Namespace="org.openoces.securitypackage"%>
<%@ Import Namespace="dk.certifikat.tuexample.util" %>

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
            if( preferredLogin == 'Software') {
                $('#rememberSoftware').attr('checked', true);
            }

            // Set preferredLogin cookie
            $('#rememberSoftware').click(function(){
                if($('#rememberSoftware').is(':checked')) {
                    $.cookie('preferredLogin', 'Software', { expires: 365, path: '/' });
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
                    <li class="selected">
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
                    <div id="appPlaceholder" class="wide">
                        <form method="post" action="sign.aspx" id="signedForm" name="signedForm">
                            <input type="hidden" name="signature" id="signature" />
                            <input type="hidden" name="result" id="result" />
                            <fieldset>
                                <legend>Signer uden engangsnøgle</legend>
                                <dl>
                                    <dt>
                                        <img src="/resources/images/logoNemID.png" alt="NemID (logo)" />
                                    </dt>
                                    <dd class="selectUser">
                                        <script type="text/javascript">
                                            var signatureChunk = "";
                                            function addChunk(chunk) {
                                                signatureChunk = signatureChunk + chunk;
                                            }

                                            function allChunk() {
                                                onSignOK(signatureChunk);
                                            }
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
                                            <%if(! "pdf".Equals(signTextFormat))
                                              { %>
                                              <param name="signtext" value="<%=signText%>"/>
                                            <%}
                                                if ("xml".Equals(signTextFormat))
                                                {%>
                                                <param name="signTransformation" value="<%=xsltForXmlToBeSigned%>" />
                                            <%} %>
                                            <param name="ZIP_FILE_ALIAS" value="OpenSign" />
                                            <param name="ZIP_BASE_URL" value="<%= openOcesLocation %>plugins" />
                                            <param name="MS_SUPPORT" value="bcjce" />
                                            <param name="SUN_SUPPORT" value="jsse" />
                                            <param name="STRIP_ZIP" value="yes" />
                                            <param name="EXTRA_ZIP_FILE_NAMES" value="capi,pkcs12,oces,pdf<%=Session["attachment"]!=null?",attachment":"" %>" />
                                            <param name="LOG_LEVEL" value="DEBUG" />

                                            <param name="locale" value="da,DK" />

                                            <param name="cabbase" value="<%= openOcesLocation %>OpenSign-bootstrapped.cab" />

                                            <param name="key.store.directory" value="null" />

                                            <param name="loglevel" value="debug" />

                                            <param name="background" value="255,255,255" />
                                            <param name="socialsecuritynumber" value="no" />

                                            <param name="optionalid" value="no" />

                                            <param name="opensign.doappletrequest" value="false" />
                                            <param name="opensign.doappletrequestonmac" value="false" />
                                            <param name="logonto" value="<%=ConfigurationManager.AppSettings["logonto"]%>" />
                                            <!--param name="cdkortservice" value="demo" /-->

                                            <param name="signproperties" value="challenge=<%=ChallengeGenerator.GenerateChallenge(Session)%>" />
                                            <param name="subjectdnfilter" value="<%=SignHandler.Base64Encode("RID:")%>"/>
                                            <param name="issuerdnfilter" value="<%=SignHandler.Base64Encode("TRUST2408")%>" />
                                            <param name="opensign.message.name" value="signature" />
                                            <param name="opensign.result.name" value="result" />
                                            <param name="gui" value="modern" />
                                            <param name="signTextFormat" value="<%="txt".Equals(signTextFormat)?"PLAIN":signTextFormat.ToUpper()%>" />
                                            <%
                                                if("pdf".Equals(signTextFormat))
                                                {%>
                                                    <param name="signtext.uri" value="<%=signTextUri%>"/>
	            								    <param name="signtext.uri.hash.value" value="<%=documentHash%>"/>
	            								    <param name="signtext.uri.hash.algorithm" value="sha-256"/>
	            								    
	        									    <param name="signText.chunk" value="true"/>     

                                                    <%
                                                    if (encodedAttachmentXml != null && ! "".Equals(encodedAttachmentXml))
                                                    {%>
                                                    <param name="attachments" value="<%=encodedAttachmentXml%>"/>
                                            <%      }
                                                }    
                                                
                                            %>
                                        </applet>
                                    </dd>
                                </dl>
                                <p class="remember">
                                    <input type="checkbox" name="rememberSoftware" id="rememberSoftware" />
                                    <label for="rememberSoftware">Husk jeg vil signere med nøglefil</label>
                                </p>
                            </fieldset>
                        </form>
                    </div>
                    <div id="right-col">
                        <ul class="thumbs">
                            <li><span><img style="margin-top: 4px;" src="/resources/images/icons/Noglefil_brudt_lille.png" alt="Signer med nøglefil" title="Signer med nøglefil" /></span></li>
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