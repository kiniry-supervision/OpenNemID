<%-- 
 * Copyright (c) 2011, DanID A/S
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
--%>
<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="log-ind-med-engangsnoegle.aspx.cs" Inherits="dk.certifikat.variant2.LogIndMedEngangsnoegle" %>
<%@ Import Namespace="org.openoces.ooapi.web"%>
<%@ Import Namespace="dk.certifikat.tuexample"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="da" lang="da">
    <head>
        <title>TU-interaktionsdesign</title>
    	<!--#include virtual="/include/common-head.inc" -->
    	
        <script type="text/javascript">
            $().ready(function() {
                // Read cookie
                var preferredLogin = $.cookie('preferredLogin');

                // Set 'remember' checkbox according to preferredLogin cookie
                if (preferredLogin == 'Otp') {
                    $('#rememberOtp').attr('checked', true);
                }

                // Set preferredLogin cookie
                $('#rememberOtp').click(function() {
                    if ($('#rememberOtp').is(':checked')) {
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
                <dd><a href="#tabs" title="Gå direkte til loginvalg" accesskey="1">Loginvalg</a></dd>
                <dd><a href="#content" title="Gå direkte til hovedindhold" accesskey="2">Hovedindhold</a></dd>
            </dl>
        </div>
        <!-- container for header section -->
        <div id="headerWrapper">
            <div id="header">
                <form runat="server">
                <ul id="tabs">
                    <li class="selected">
                        <asp:LinkButton ID="loginOtpLink" AccessKey="3" runat="server"><span class="nemidLogo"><!-- nemidLogo--></span><span>Log ind med nøglekort</span></asp:LinkButton>
                        
                    </li>
                    <li>
                        <asp:LinkButton ID="loginUdenOtpLink" AccessKey="4" runat="server"><span class="nemidLogo"><!-- nemidLogo--></span><span>Log ind med nøglefil</span></asp:LinkButton>
                        
                    </li>
                    <li>
                        <asp:LinkButton ID="loginDigSignLink" AccessKey="5" runat="server"><span class="digitalSignaturLogo"><!-- digitalSignaturLogo--></span><span>Log ind med Digital Signatur</span></asp:LinkButton>
                        
                    </li>
                </ul>
                </form>
            </div>
        </div>

        <div id="contentWrapper">
            <div id="content">
                <div class="tools">
                    <ul>
                        <li id="speaker"><a href="http://adgangforalle.dk" rel="external" title="Få teksten læst op - link til Adgangforalle.dk (åbner i nyt vindue)"><span class="accessibility">Oplæsning af tekst</span></a></li>
                    </ul>
                </div>
                <div id="loginWrapper">
                    <div id="appPlaceholder">
                        <fieldset>
                            <legend>Log ind med engangsnøgle</legend>
                            <span ID="generatorSpan" runat="server" />
                            
                            <p class="remember">
                                <input type="checkbox" name="rememberOtp" id="rememberOtp" />
                                <label for="rememberOtp">Husk jeg vil logge ind med nøglekort</label>
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