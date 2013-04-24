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

using System;
using System.Collections.Generic;
using System.Configuration;
using System.Web.Security;
using org.openoces.ooapi.environment;
using org.openoces.serviceprovider;

namespace dk.certifikat
{
    public class Global : System.Web.HttpApplication
    {
        public readonly static string CurrentUser = "current.user";
        readonly Char[] _splitChar = new[] {','};
        protected void Application_Start(object sender, EventArgs e)
        {
            Environments.OcesEnvironments = GetTrustedEnviroments();
            CreateRoleIfNotExists("moces");
            CreateRoleIfNotExists("poces");
            CreateRoleIfNotExists("nemid");
        }

        private List<OcesEnvironment> GetTrustedEnviroments()
        {
            var trustedEnvs = ConfigurationManager.AppSettings["trustedEnvironments"];
            var envs = trustedEnvs.Split(_splitChar);
            var trustedEnviroments = new List<OcesEnvironment>();
            foreach (var env in envs)
            {
                trustedEnviroments.Add((OcesEnvironment) Enum.Parse(typeof(OcesEnvironment), env, true));
            }
            return trustedEnviroments;
        }

        private static void CreateRoleIfNotExists(string role)
        {
            if (!Roles.RoleExists(role))
            {
                Roles.CreateRole(role);
            }  
        }

        protected void Session_Start(object sender, EventArgs e)
        {

        }

        protected void Application_BeginRequest(object sender, EventArgs e)
        {

        }

        protected void Application_AuthenticateRequest(object sender, EventArgs e)
        {

        }

        protected void Application_Error(object sender, EventArgs e)
        {

        }

        protected void Session_End(object sender, EventArgs e)
        {

        }

        protected void Application_End(object sender, EventArgs e)
        {

        }
    }
}