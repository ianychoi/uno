namespace Mono.test_188
{
    //
    // Test that the foreach statement generated by mcs invokes the Dispose()
    // method even if the enumerator class returned by GetEnumerator () does not
    // implement IDisposable.
    //
    
    using Uno;
    
    public class Enumerator {
    
        int counter;
    
        public Enumerator () {
            counter = 3;
        }
    
        public bool MoveNext () {
            return (counter -- > 0);
        }
    
        public char Current {
            get {
                return 'a';
            }
        }
    }
    
    class RealEnumerator : Enumerator, IDisposable {
    
        Coll c;
    
        public RealEnumerator (Coll c) {
            this.c = c;
        }
    
        public void Dispose () {
            c.disposed = true;
        }
    }
    
    public class Coll {
    
        public bool disposed;
    
        public Enumerator GetEnumerator () {
            return new RealEnumerator (this);
        }
    }
    
    class Test {
    
        [Uno.Testing.Ignore, Uno.Testing.Test] public static void test_188() { Uno.Testing.Assert.AreEqual(0, Main(new string[0])); }
        public static int Main(string[] args)
        {
            Coll coll = new Coll ();
            foreach (char c in coll) {
            }
            return (coll.disposed ? 0 : 1);
        }
    }
}