using FluentAssertions;
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

        [Then(@"I should be able to enter my user name")]
        public void ThenIShouldBeAbleToEnterMyUserName()
        {
            Browser.Instance.Page<LoginPage>().UserNameField.Exists.Should().BeTrue();
        }

        [Then(@"I should be able to enter my email address")]
        public void ThenIShouldBeAbleToEnterMyEmailAddress()
        {
            Browser.Instance.Page<LoginPage>().EmailField.Exists.Should().BeTrue();
        }

        [Then(@"I should be able to enter my password")]
        public void ThenIShouldBeAbleToEnterMyPassword()
        {
            Browser.Instance.Page<LoginPage>().PasswordField.Exists.Should().BeTrue();
        }

        [Then(@"I should be able to confirm my passowrd")]
        public void ThenIShouldBeAbleToConfirmMyPassowrd()
        {
            Browser.Instance.Page<LoginPage>().PasswordConfirmationField.Exists.Should().BeTrue();
        }

        [Then(@"i should be able to click the register button")]
        public void ThenIShouldBeAbleToClickTheRegisterButton()
        {
            Browser.Instance.Page<LoginPage>().RegisterButton.Exists.Should().BeTrue();
        }

    }
}
