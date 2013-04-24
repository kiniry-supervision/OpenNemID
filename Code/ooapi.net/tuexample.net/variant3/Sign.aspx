﻿<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Sign.aspx.cs" Inherits="dk.certifikat.variant3.Sign" %>

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
<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="da" lang="da">
    <head>
        <title>TU-interaktionsdesign</title>
        <!--#include virtual="/include/common-head.inc" -->
        <script type="text/javascript">
        $().ready(function() {
            rememberedLogin = 'signer-med-engangsnoegle.aspx'
            var preferredLogin = $.cookie('preferredLogin');
            if (preferredLogin == 'DigitalSignatur') {
                rememberedLogin = 'signer-med-digital-signatur.aspx';
            } else if (preferredLogin == 'Software') {
                rememberedLogin = "signer-uden-engangsnoegle.aspx";
            }
            $('#sign').attr('href', rememberedLogin);
        });
        </script>
    </head>
    <body>

        <div id="skipToContent" class="accessibility">
            <dl>
                <dt>Genveje:</dt>
                <dd><a href="#content" title="Gå direkte til hovedindhold" accesskey="2">Hovedindhold</a></dd>
            </dl>
        </div>

        <!-- container for header section -->
        <div id="headerWrapper">
            <div id="header">

            </div>
        </div>

        <div id="contentWrapper">
            <div id="content">
                <div id="loginWrapper">
                    <div id="appPlaceholder" class="wide">
                        <h1>Der er sket en signeringsfejl i TU-variant 03 med NemID</h1>
                        <p>Det lykkedes <b>ikke</b> at underskrive teksten.</p>
			            <p>Årsag: <%= Session["errorText"] %></p>
                        <p><a href="signer-uden-engangsnoegle.aspx" id="sign" title="Klik her for at prøve signering igen">Prøv igen.</a></p>
                    </div>
                </div>
            </div>
        </div>
    </body>
</html>