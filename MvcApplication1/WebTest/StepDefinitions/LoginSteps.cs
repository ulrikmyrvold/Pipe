using TechTalk.SpecFlow;
using WebTest.PageObjects;

namespace WebTest.StepDefinitions
{
    [Binding]
    public class LoginSteps
    {
        [Given(@"I have navigated to the account registration page")]
        public void GivenIHaveNavigatedToTheAccountRegistrationPage()
        {
            Browser.Instance.Page<LoginPage>().Show();
        }

        [Given(@"I have entered as user name: (.*)")]
        public void GivenIHaveEnteredAsUserNameUser(string userName)
        {
            Browser.Instance.Page<LoginPage>().UserNameField.Value = userName;
        }

        [Given(@"I have entered as email address: (.*)")]
        public void GivenIHaveEnteredAsEmailAddress(string emailAddress)
        {
            Browser.Instance.Page<LoginPage>().EmailField.Value = emailAddress;
        }

        [Given(@"I have entered as password: (.*)")]
        public void GivenIHaveEnteredAsPassword(string passowrd)
        {
            Browser.Instance.Page<LoginPage>().PasswordField.Value = passowrd;
            Browser.Instance.Page<LoginPage>().PasswordConfirmationField.Value = passowrd;
        }

        [When(@"I press register")]
        public void WhenIPressRegister()
        {
            Browser.Instance.Page<LoginPage>().RegisterButton.Click();
        }
    }
}
