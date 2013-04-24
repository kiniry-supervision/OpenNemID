<%-- 
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
--%>
<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="logon.aspx.cs" Inherits="dk.certifikat.variant2.Validate" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">

<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="da" lang="da">
    <head>
    	<title>NemID - Loginfejl</title>
        <!--#include virtual="/include/common-head.inc" -->
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
		        <div class="loginWrapper">
		            <h1>Fejl under login</h1>
			        <%if (Session["notMoces"] != null && (bool)Session["notMoces"])
                    { %>
			            <p>Du har ikke valgt et medarbejdercertifikat.</p>
			            <p>Det er kun muligt at logge ind med et gyldigt medarbejdercertifikat.</p>
			        <% } else
                    { %>
			            <p>Årsag: <%= Session["errorText"] %></p>
			        <% } %>
                    <p><a href="restricted" title="Klik her for at prøve igen">Prøv igen.</a></p>
		        </div>
	        </div>
        </div>
    </body>
</html>
