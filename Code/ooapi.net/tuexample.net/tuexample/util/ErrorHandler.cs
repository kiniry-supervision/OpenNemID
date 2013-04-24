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

using System.Collections.Generic;
using org.openoces.ooapi.certificate;
using org.openoces.securitypackage;

namespace dk.certifikat.tuexample.util
{
    public class ErrorHandler
    {
        private static readonly Dictionary<string, string> ErrorCodes =
            new Dictionary<string, string>
                {
                    {"APP001.description", "The applet calculated the digest of its parameters, and it did not match the digest that was submitted in the parameter paramsdigest."},
                    {"APP001.text", "Der er opstået en teknisk fejl. Forsøg igen. Kontakt [TU], hvis problemet fortsætter."},
                    {"APP002.description", "The sign text was illegal, e.g. the HTML document contained illegal tags."},
                    {"APP002.text", "Der er opstået en teknisk fejl. Forsøg igen. Kontakt [TU], hvis problemet fortsætter."},
                    {"APP003.description", "An unrecoverable, internal error occurred in the applet."},
                    {"APP003.text", "Der er opstået en teknisk fejl. Kontakt NemID-support på tlf: 80 30 70 50."},
                    {"APP004.description", "Returned by the applet if it is unable to resume an existing user session and the No_Fallback parameter is specified."},
                    {"APP004.text", "Der er sket en teknisk fejl. Kontakt indehaveren af websitet"},
                    {"APP005.description", "The user chose not to trust the certificate that can verify the signature on the applet."},
                    {"APP005.text", "Du har ikke givet tilladelse til at NemID login kan køre på din computer. Du skal give tilladelse for at kunne logge på. Har du brug for hjælp, kan du kontakte NemID-support på tlf: 80 30 70 50"},
                    {"SRV001.description", "The signature on the applet parameters could not be verified by DanID."},
                    {"SRV001.text", "Der er opstået en teknisk fejl. Forsøg igen. Kontakt [TU], hvis problemet fortsætter."},
                    {"SRV002.description", "The authentication request could not be parsed by DanID."},
                    {"SRV002.text", "Der er opstået en teknisk fejl. Forsøg igen. Kontakt [TU], hvis problemet fortsætter."},
                    {"SRV003.description", "The time stamp of the authentication request was not within the allowed time span."},
                    {"SRV003.text", "Der er opstået en teknisk fejl. Forsøg igen. Kontakt [TU], hvis problemet fortsætter."},
                    {"SRV004.description", "An unrecoverable error occurred at DanID."},
                    {"SRV004.text", "Der er opstået en teknisk fejl. Kontakt NemID-support på tlf: 80 30 70 50."},
                    {"SRV005.description", "An unrecoverable error occurred at DanID."},
                    {"SRV005.text", "Der er opstået en teknisk fejl. Kontakt NemID-support på tlf: 80 30 70 50."},
                    {"SRV006.description", "The server lost the session it had established with the applet."},
                    {"SRV006.text", "Der er opstået en teknisk fejl. Forsøg igen."},
                    {"CAN001.description", "The user chose to cancel an activation flow by pressing the 'Afbryd' (Cancel) button."},
                    {"CAN001.text", "Du har afbrudt aktiveringen."},
                    {"CAN002.description", "The user chose to cancel by pressing the 'Afbryd' (Cancel) button."},
                    {"CAN002.text", "Du har afbrudt login."},
                    {"AUTH001.description", "The user exceeded the allowed number password attempts."},
                    {"AUTH001.text", "Din NemID er spærret. Kontakt venligst NemID-support på tlf: 80 30 70 50."},
                    {"AUTH003.description", "The user does not have an established agreement with the service provider."},
                    {"AUTH003.text", "Login er gennemført korrekt, men du har ikke adgang til tjenesten."},
                    {"AUTH004.description","OTP device is quarantined due to too many failed authentication attempts."},
                    {"AUTH004.text", "Din NemID er midlertidigt låst og du kan endnu ikke logge på."},
                    {"AUTH005.description", "NemID is locked due to too many failed attempts to enter a password."},
                    {"AUTH005.text", "Din NemID er spærret. Kontakt venligst NemID-support på tlf: 80 30 70 50."},
                    {"AUTH006.description", "The user has run out of OTP codes, and does not have a pending one."},
                    {"AUTH006.text", "Du har ikke flere koder på nøglekortet. Kontakt venligst NemID-support på tlf: 80 30 70 50."},
                    {"AUTH007.description", "NemID password is revoked due to too many failed entry attempts."},
                    {"AUTH007.text", "Din NemID-adgangskode er spærret pga. for mange fejlede forsøg. Kontakt NemID-support på tlf: 80 30 70 50."},
                    {"AUTH008.description", "NemID is not activated and does not have an active Activation Password."},
                    {"AUTH008.text", "Din NemID er ikke aktiveret og har ikke en aktiveringskode. Kontakt NemID-support på tlf: 80 30 70 50."},
                    {"AUTH009.description", "The user has not authenticated with 2-factor, sso is not possible."},
                    {"AUTH009.text", "AUTH009"},
                    {"LOCK001.description", "The user entered an incorrect password too many times. The OTP device is now quarantined."},
                    {"LOCK001.text", "Du har angivet forkert bruger-id eller adgangskode 5 gange i træk. NemID er nu spærret i 8 timer. Kontakt evt. NemID-support på tlf: 80 30 70 50."},
                    {"LOCK002.description", "The user entered an incorrect password too many times. The OTP device is now locked permanently."},
                    {"LOCK002.text", "Du har angivet forkert adgangskode for mange gange. Din NemID er spærret. Kontakt evt. NemID-support på tlf: 80 30 70 50."},
                    {"LOCK003.description", "Number of allowed otp code attempts exceeded. The OTP device is revoked."},
                    {"LOCK003.text", "Du har angivet forkert nøgle for mange gange. Din NemID er spærret. Kontakt evt. NemID-support på tlf: 80 30 70 50."},
                    {"OCES001.description", "The user does not have an OCES, so he cannot authenticate with an OCES service provider."},
                    {"OCES001.text", "Du har kun sagt ja til at bruge NemID til netbank. Ønsker du at bruge NemID til andre hjemmesider klik her www.nemid.nu [https://www.nemid.nu/privat/bestil_nemid/nemid_i_netbank/]"},
                    {"OCES002.description", "The user was not declared OCES-qualified."},
                    {"OCES002.text", "Ønsker du at bruge NemID til andet end netbank klik her www.nemid.nu [https://www.nemid.nu/privat/bestil_nemid/]"},
                    {"OCES003.description", "The user does not have OCES on this OTP device, but another of the user's devices has OCES."},
                    {"OCES003.text", "Der er ikke knyttet et certifikat til det NemID du har forsøgt at logge på med."},
                    {"OCES004.description", "The user is OCES-unqualified, eg. due to age or lack of a Danish CPR-number, and is not able to obtain an OCES certificate at all."},
                    {"OCES004.text", "Du kan ikke bruge NemID til andet end netbank. Det kan skyldes at du er under 15 år eller at du ikke har et dansk CPRnummer. "},
                    {"OCES005.description", "An error occurred when the CA tried to issue a certificate."},
                    {"OCES005.text", "Der er opstået en teknisk fejl. Forsøg igen. Kontakt [TU], hvis problemet fortsætter."},
                    {"OCES006.description", "The user has only inaccessible or inactive keys on any of his devices."},
                    {"OCES006.text", "Du har ikke knyttet et aktivt OCES-certifikat til NemID. Klik her for at bestille et nyt OCES-certifikat http://www.nemid.nu."},
                    {"cancel.description", "User chose to cancel the operation."},
                    {"cancel.text", "Du har afbrudt login."},
                    {"cancelsign.description", "User chose to cancel the operation."},
                    {"cancelsign.text", "Du har afbrudt signering."},

                    {"certificate.Valid", "Gyldig"},
                    {"certificate.Invalid", "Ugyldigt"},
                    {"certificate.NotYetValid", "Ikke gyldigt endnu"},
                    {"certificate.Expired", "Udløbet"},
                    {"certificate.Revoked", "Spærret"},

                    {"certificateTypes.poces", "personligt certifikat"},
                    {"certificateTypes.moces", "medarbejdercertifikat"},
                    {"certificateTypes.voces", "virksomhedscertifikat"},
                    {"certificateTypes.foces", "funktionscertifikat"},
                    {"certificateTypes.unknown", "ukendt"}
                };

        /// <summary>
        /// Translates the supplied error code to a descriptive message to be shown to the end-user.
        /// </summary>
        /// <param name="result">Error code from the applet.</param>
        /// <returns>Descriptive message.</returns>
        public static string GetErrorText(string result)
        {
            return ErrorCodes[result + ".text"];
        }

        /// <summary>
        /// Translates the supplied error code to a descriptive message to be logged.
        /// </summary>
        /// <param name="result">result Error code from the applet.</param>
        /// <returns>Descriptive message.</returns>
        public static string GetTechnicalDescription(string result)
        {
            return ErrorCodes[result + ".description"];
        }

        /// <summary>
        /// Translates the certificate status
        /// </summary>
        /// <param name="status">The CertificateStatus</param>
        /// <returns>Descriptive message.</returns>
        public static string GetCertificateStatusText(CertificateStatus status)
        {
            return ErrorCodes["certificate." + status];
        }

        public static string CertificateType(SignatureValidationStatus status)
        {
            var cert = status.Certificate;
            if (cert is PocesCertificate)
            {
                return ErrorCodes["certificateTypes.poces"];
            }
            if (cert is MocesCertificate)
            {
                return ErrorCodes["certificateTypes.moces"];
            }
            if (cert is VocesCertificate)
            {
                return ErrorCodes["certificateTypes.voces"];
            }
            if (cert is FocesCertificate)
            {
                return ErrorCodes["certificateTypes.foces"];
            }
            return ErrorCodes["certificateTypes.unknown"];
        }
    }
}
