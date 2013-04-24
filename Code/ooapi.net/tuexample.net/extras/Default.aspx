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
<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Default.aspx.cs" Inherits="dk.certifikat.extras.Default" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="da" lang="da">
    <head>
        <title>TU-interaktionsdesign - Ekstra funktioner</title>
        <!--#include virtual="/include/common-head.inc" -->        
    </head>
    <body id="demosite">

        <div id="skipToContent" class="accessibility">
            <dl>
                <dt>Genveje:</dt>
                <dd><a href="#content" title="Gå direkte til hovedindhold" accesskey="2">Hovedindhold</a></dd>
            </dl>
        </div>

        <!-- container for header section -->
        <div id="headerWrapper">
            <div id="header">
                <div id="logo">
                    <img src="/resources/images/logo.png" alt="Demologo" title="Kun til demobrug" />
                </div>
                <ul id="menu">
                    <li><a href="#.#" title="Simuleret menu kun til demobrug">Menu 01</a></li>
                    <li><a href="#.#" title="Simuleret menu kun til demobrug">Menu 02</a></li>
                    <li><a href="#.#" title="Simuleret menu kun til demobrug">Menu 03</a></li>
                    
                </ul>
                <div class="button-wrapper">
                        <a href="/" title="Klik her for at komme tilbage til forsiden">Til forsiden</a>
                        <a href="CheckPid.aspx" title="Klik her for at komme til PID-opslag">PID-opslag</a>
                        <a href="CheckRid.aspx" title="Klik her for at komme til RID-opslag">RID-opslag</a>
                        <a href="Signer-bilag-med-engangsnoegle.aspx" title="Klik her for at komme til signér med bilag">Signér med bilag</a>
                        
                    </div>
            </div>
        </div>

        <div id="contentWrapper">
            <div id="content">
                <div class="content-block">
                
                    <h1>Ekstra funktioner</h1>
                    <p>Her kan du standardindstillingerne til login og signering.</p>
                                   
                    <h2>Valg af spærrelistecheck</h2>
                    <p>Du kan vælge hvilken form for spærreliste du ønsker at benytte.</p>
                    
                    <form method="post" action="Default.aspx" id="changeRevocation" name="changeRevocation" runat="server">
                    <%
                        var revocationCheckType = Session["revocationCheckType"];
                        if (revocationCheckType == null)
                        {
                            revocationCheckType = "partitioned";
                        }
                     %>
                       <p><label for="revocationCheckType">Spærrelistetype:</label> <select id="revocationCheckType" name="revocationCheckType" style="width: 150px;">
							<option value="full" <%="full".Equals(revocationCheckType) ? "selected=selected" : "" %>>Full CRL</option>
							<option value="partitioned" <%="partitioned".Equals(revocationCheckType) ? "selected=selected" : "" %>>Partitioned CRL</option>
							<option value="ocsp" <%="ocsp".Equals(revocationCheckType) ? "selected=selected" : "" %>>OCSP</option>
						</select>
						</p>						
						<asp:Button id="Button1" text="Ændr type" OnClick="changeRevocationList" runat="server"  />
                   
                
                    <h2>Valg af signeringstekst-type</h2>
                    <p>Du kan vælge hvilken form for signeringstekst du ønsker at benytte.</p>
                     
                    <%
                        var signTextType = Session["signTextFormat"];
                        if (signTextType == null)
                        {
                            signTextType = "html";
                        }
                     %>

                        <p><label for="SignTextType">Signeringstekst-type:</label> <select id="SignTextType" name="SignTextType" style="width: 150px;">
							<option value="html" <%="html".Equals(signTextType) ? "selected=selected" : "" %>>HTML</option>
							<option value="txt" <%="txt".Equals(signTextType) ? "selected=selected" : "" %>>Tekst</option>
							<option value="xml" <%="xml".Equals(signTextType) ? "selected=selected" : "" %>>XML</option>
                            <option value="pdf" <%="pdf".Equals(signTextType) ? "selected=selected" : "" %>>PDF</option>
                            <option value="pdf_w_attachment" <%="pdf_w_attachment".Equals(signTextType) ? "selected=selected" : "" %>>PDF W Attachment</option>
						</select>
						</p>
						<asp:Button id="id" text="Ændr type" OnClick="changeSignText" runat="server" />
                    </form>

                    
                    
                    <p>Hvis du klikker på "PID-opslag", kommer du til en side hvor du kan afprøve PID-opslag.</p>
                    <p>Hvis du klikker på "Signér med bilag", kommer du til en side hvor du kan afprøve signéring med bilag.</p>
                    <p>Hvis du klikker på "Til forsiden", kommer du tilbage til indeks-siden og kan afprøve en af de forskellige varianter af interaktionsdesignet.</p>
                    
                </div>
                <div class="image-block">
                    <img src="/resources/images/01.jpg" alt="Demobillede" />
                    <img src="/resources/images/02.jpg" alt="Demobillede" />
                </div>
                 
            </div>
        </div>
    </body>
</html>