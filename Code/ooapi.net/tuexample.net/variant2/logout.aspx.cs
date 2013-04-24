using System;
using System.Web.Security;

namespace dk.certifikat.variant2
{
    public partial class Logout : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            var user = (string)Session[Global.CurrentUser];
            //if not logged in.
            if (user == null)
            {
                Response.Redirect("/Default.aspx");
                return;
            }
            if (Roles.IsUserInRole(user, "moces"))
            {
                Roles.RemoveUserFromRole(user, "moces");
            }
            Session.Remove(variant2.Validate.KeyRid);
            Session.Remove(variant2.Validate.KeyCvr);

            FormSignoutIfUserIsNotInAnyRole(user);
            Session.Clear();
            Session.Abandon();
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
