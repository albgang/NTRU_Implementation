**Synopsis**
==========================
NTRUEncrypt.sage contains our groups implementation of NTRUEncrypt for EECS475 (Introduction to Cryptography). We implemented NTRU in order to shed some light on a lattice based cryptosystem.

**Code Example**
==========================

    def __init__(self,N_in,q_in):
        self.N = N_in
        self.q = q_in
        self.p = 3
        self.df = randint(1,ceil(self.N/2))
        self.dg = randint(1,ceil(self.N/2))
        self.dr = randint(1,ceil(self.N/2))
        self.g = self.__randpoly(self.dg)
        #self.g = -1 + x^2 + x^3 + x^5 -x^8 - x^(10) #replace once we finish randpoly

        invq,invp = false,false
        while not invq and not invp:
          self.__f = self.__randpoly(self.df)
          #self.__f = -1 + x + x^2 - x^4 + x^6 + x^9 - x^(10) #replace once we finish randpoly
          invq, self.fq = self.__polyinv2n(self.__f,self.q)
          invp, self.__fp = self.__polyinv3(self.__f)

        self.h = self.__modcoeffs(self.p*self.__cylic_conv(self.fq,self.g),self.q)

      def __randpoly(self,d):
        randlist = [1] * d + [-1] * (d-1) + [0] * (self.N - 2 * d + 1)
        shuffle(randlist)
        return R(randlist)

      def __modcoeffs(self,f,m):
        c = f.list()
        m2 = m/2
        for i in range(len(c)):
          c[i] = c[i]%m
          if c[i] > m2:
            c[i] -= m
        return R(c) 
**Usage**
==========================
Run sage and type this command in the sage terminal:
```
  sage NTRUEncrypt.sage
```

**Contributors**
==========================
- *Albert Gang*
- *Jacob Winick*
- *Michael Lu*
- *Steven La Feir*
