using System;
using System.Web.Security;

namespace dk.certifikat.variant1
{
    public partial class Logout : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            var user = (string)Session[Global.CurrentUser];
            //this page can be called without being logged in
            if (user == null)
            {
                Response.Redirect("/Default.aspx");
                return;
            }
            if (Roles.IsUserInRole(user, "poces"))
            {
                Roles.RemoveUserFromRole(user, "poces");
            }
            Session.Remove(variant1.Validate.KeyPid);

            FormSignoutIfUserIsNotInAnyRole(user);
            Response.Redirect("/Default.aspx");
        }

        private static void FormSignoutIfUserIsNotInAnyRole(string user)
        {
            if(user == null || Roles.GetRolesForUser(user).Length == 0 )
            {
                FormsAuthentication.SignOut();  
            }
        }
    }
}
