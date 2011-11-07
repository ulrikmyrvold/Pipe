using WatiN.Core;

namespace WebTest.PageObjects
{
    public class HomePage : Page
    {
        public Div WelcomeUserDiv
        {
            get { return Document.Div(Find.ById("logindisplay")); }
        }           
    }
}
