using NUnit.Framework;

namespace Tests
{
    [TestFixture]
    public class TestClass
    {
        [Test]
        public void DoIt()
        {
            Assert.That(1, Is.EqualTo(1));
        }

        [Test]
        public void FailIt()
        {
            Assert.That(2, Is.EqualTo(2), "One is not equal to two, you idiot!");
        }
    }
}
