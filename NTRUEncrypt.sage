#TODO:
# __modcoeffs__ (should function the same as the one on github)
# __cylic_conv__ (section 1.2 on page 3 of grenoble.pdf)
# __randpoly__ (don't need to do till end cuz we're testing with deterministic polynomials first)

R.<x> = ZZ['x']

class NTRUEncrypt(object):
    def __init__(self,N_in,q_in):
        print("__init__")
        self.N = N_in
        self.q = q_in
        self.p = 3
        f = -1 + x + x^2 - x^4 + x^6 + x^9 - x^(10)
        g = -1 + x^2 + x^3 + x^5 -x^8 - x^(10)
        invq, self.fq = self.__polyinv2n__(f,self.q)
        invp, self.fp = self.__polyinv3__(f)
        self.h = self.__modcoeffs__(p * self.__cylic_conv__(self.fq,g),self.q)
        print("fq: ")
        print(self.fq)
        print("fp: ")
        print(self.fp)
        print("h: ")
        print(self.h)
# todo: 
    def __randpoly__(self,d):
        print("__randpoly__")
        
        pass

    # todo: 
    def __modcoeffs__(self,f,m):
        print("__modcoeffs__")
        c = f.list()
        m2 = m/2
        for i in range(len(c)):
            c[i] = c[i]%m
            if c[i] > m2:
                c[i] -= m
        return R(c)        

    def __polyinv3__(self,a):
        print("__polyinv3__")
        k=0
        b=1
        c=0
        f = a
        g = x^self.N - 1

        while(1):
            while(f.coefficients(sparse=False)[0] == 0 and not f.is_zero()):
                f = f/x
                c = c*x
                k += 1

            if f == 1:
                return (True, (x^(N-k) * b).mod(x^self.N - 1)) 
            elif -f == 1:
                return (True, (-1)*(x^(N-k) * b).mod(x^self.N - 1))
            elif f.degree() == -1 or f == 0:
                return (False,0)
            if f.degree() < g.degree():
                f,g = g,f
                b,c = c,b

            if f.coefficients(sparse=False)[0] == g.coefficients(sparse=False)[0]:
                f = self.__modcoeffs__(f - g,3)
                b + self.__modcoeffs__(b - c,3)
            else:
                f = self.__modcoeffs__(f + g,3)
                b = self.__modcoeffs__(b + c,3)

    def __polyinv2__(self,a):
        print("__polyinv2__")
        k=0
        b=1
        c=0
        f = a
        g = x^self.N - 1

        while(1):
            while(f.coefficients(sparse=False)[0] == 0 and not f.is_zero()):
                f = f/x
                c = c*x
                k += 1

            if f == 1:
                return (True, (x^(N-k) * b).mod(x^self.N - 1))
            elif f.degree() == -1 or f == 0:
                return (False,0)
            if f.degree() < g.degree():
                f,g = g,f
                b,c = c,b

            f = self.__modcoeffs__(f + g,2)
            b + self.__modcoeffs__(b + c,2)


    def __polyinv2n__(self,a,pow2):
        print("__polyinv2n__")
        inv2, b = self.__polyinv2__(a)
        if (inv2):
            cur2 = 2
            while cur2<pow2:
                cur2 = cur2^2
                b = self.__modcoeffs__(b * (2 - a*b),cur2)
            return (True, b)
        else: 
            return (False,0)

    # todo:
    def __cylic_conv__(self,f,g):
        print("__cylic_conv__")
        fg = (f*g).list()
        lower_fg = fg[0:self.N]
        upper_fg = fg[self.N:len(fg)]
        h = lower_fg
        for i in range(len(upper_fg)):
            h[i] += upper_fg[i]
        return R(h)      
        

    def encrypt(self,m):
        print("encrypt")
        r = -1+x^2+x^3+x^4-x^5-x^7
        # r = self.__randpoly__(dr)
        return self.__modcoeffs__(self.__cylic_conv__(r,self.h) + m,self.q)

    def public_key(self):
        return self.h

    def decrypt(self,c):
        print("decrypt")
        a = self.__modcoeffs__(self.__cylic_conv__(self.f,c),self.q)
        b = self.__modcoeffs__(a,self.p)
        return self.__modcoeffs__(self.__cylic_conv__(self.fp,b),self.p)
testntru = NTRUEncrypt(11,5)