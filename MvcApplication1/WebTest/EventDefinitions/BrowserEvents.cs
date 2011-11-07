using TechTalk.SpecFlow;
using WebTest.StepDefinitions;

namespace WebTest.EventDefinitions
{
    [Binding]
    public class BrowserEvents
    {
        [AfterTestRun]
        public static void CloseBrowser()
        {
            if (Browser.IsRunning())
            {
                Browser.Close();
            }
        }
    }
}
