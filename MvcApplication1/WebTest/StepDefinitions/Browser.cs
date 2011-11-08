using System.Configuration;
using System.Text;
using WatiN.Core;

namespace WebTest.StepDefinitions
{
    public class Browser
    {
        private static IE _browser;

        public static IE Instance
        {
            get
            {
                if (_browser == null)
                {
                    _browser = new IE {AutoClose = true};
                }
                return _browser;
            }
        }

        public static void NavigateToRelativeUrl(string url)
        {
            var stringBuilder = new StringBuilder(RootUrl);
            if (!RootUrl.EndsWith("/"))
                stringBuilder.Append("/");
            stringBuilder.Append(url);
            NavigateTo(stringBuilder.ToString());
        }

        public static void NavigateTo(string url)
        {
            Instance.GoTo(url);
            Update();
        }


        public static void Update()
        {
            Instance.Refresh();
        }

        public static string RootUrl
        {
            get { return ConfigurationManager.AppSettings["siteUrl"]; }
        }

        public static bool IsRunning()
        {
            return _browser != null;
        }

        public static void Close()
        {
            if (Instance == null) return;

            Instance.ForceClose();

            _browser = null;
        }
    }
}
