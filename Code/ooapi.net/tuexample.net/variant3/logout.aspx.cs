using System;
using System.Web.Security;

namespace dk.certifikat.variant3
{
    public partial class Logout : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            var user = (string)Session[Global.CurrentUser];
            if (Roles.IsUserInRole(user, "nemid"))
            {
                Roles.RemoveUserFromRole(user, "nemid");
            }

            Session.Remove(variant3.Validate.KeyCvr);
            Session.Remove(variant3.Validate.KeyPid);
            Session.Remove(variant3.Validate.KeyRid);
            Session.Remove(variant3.Validate.KeyType);

            FormSignoutIfUserIsNotInAnyRole(user);
            Response.Redirect("/Default.aspx");
        }

        private static void FormSignoutIfUserIsNotInAnyRole(string user)
        {
            if (user == null || Roles.GetRolesForUser(user).Length == 0)
            {
                FormsAuthentication.SignOut();
            }
        }
    }
}
