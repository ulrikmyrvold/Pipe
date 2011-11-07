using NUnit.Framework;
using TechTalk.SpecFlow;
using WebTest.PageObjects;

namespace WebTest.StepDefinitions
{
    [Binding]
    public class HomePageSteps
    {
        [Then(@"I should see on the home page the message: (.*)")]
        public void ThenIShouldSeeTheMessageWelcomeUser(string welcomeMessage)
        {
            Assert.That(Browser.Instance.Page<HomePage>().WelcomeUserDiv.Text.Replace("<b>", "").Replace("</b>", "").StartsWith(welcomeMessage));
        }
    }
}
