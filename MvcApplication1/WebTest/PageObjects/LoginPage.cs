using WatiN.Core;

namespace WebTest.PageObjects
{
    [Page(UrlRegex = ".*/Account/Register")]
    public class LoginPage : Page
    {
        public TextField UserNameField
        {
            get { return Document.TextField(Find.ById("UserName")); }
        }

        public TextField EmailField
        {
            get { return Document.TextField(Find.ById("Email")); }
        }

        public TextField PasswordField
        {
            get { return Document.TextField(Find.ById("Password")); }
        }

        public TextField PasswordConfirmationField
        {
            get { return Document.TextField(Find.ById("ConfirmPassword")); }
        }

        public Button RegisterButton
        {
            get { return Document.Button(Find.ByValue("Register")); }
        }

        public void Show()
        {
            StepDefinitions.Browser.NavigateToRelativeUrl("/Account/Register");
        }
    }
}
