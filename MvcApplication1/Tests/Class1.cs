using System;
using System.Collections.Generic;
using System.Diagnostics;
using System.Linq;
using System.Reflection;
using System.Text;
using NUnit.Framework;

namespace Tests
{
    [TestFixture]
    public class Class1
    {
        [Test]
        public void DoIt()
        {
            Assert.That(1, Is.EqualTo(1));
        }

        [Test]
        public void FailIt()
        {
            Assert.That(1, Is.EqualTo(2), "One is not equal to two, you idiot!");
        }
    }

    
}
