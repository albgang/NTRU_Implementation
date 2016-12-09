#TODO:
# __modcoeffs__ (should function the same as the one on github)
# __cylic_conv__ (section 1.2 on page 3 of grenoble.pdf)
# __randpoly__ (don't need to do till end cuz we're testing with deterministic polynomials first)

R.<x> = ZZ['x']

class NTRUEncrypt(object):

	def __init__(self,N_in,q_in):
		self.N = N_in
		self.q = q_in
		self.p = 3
		f = -1 + x + x^2 - x^4 + x^6 + x^9 - x^(10)
		g = -1 + x^2 + x^3 + x^5 -x^8 - x^(10)
		# self.fq = polyinv2n(self.f,self.q)
		# self.fp = self.__polyinv3__(self.f)
		# self.h = self.__modcoeffs__(p * self.__cylic_conv__(self.fq,self.g),self.q)

	# todo: 
	def __randpoly__(self,d):
		pass

	# todo: 
	def __modcoeffs__(self,f,m):
		pass

	def __polyinv3__(self,a):
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
				return (x^(N-k) * b).mod(x^self.N - 1) 
			if f == -1:
				return (-1)*(x^(N-k) * b).mod(x^self.N - 1) 

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
				return (x^(N-k) * b).mod(x^self.N - 1)

			if f.degree() < g.degree():
				f,g = g,f
				b,c = c,b

			f = self.__modcoeffs__(f + g,2)
			b + self.__modcoeffs__(b + c,2)


	def __polyinv2n__(self,a,pow2):
		b = __polyinv2__(a)
		cur2 = 2
		while cur2<pow2:
			cur2 = cur2^2
			b = self.__modcoeffs__(b * (2 - a*b),cur2)

	# todo:
	def __cylic_conv__(self,f,g):
		pass

	def encrypt(self,m):
		r = -1+x^2+x^3+x^4-x^5-x^7
		# r = self.__randpoly__(dr)
		return self.__modcoeffs__(self.__cylic_conv__(r,self.h) + m,self.q)

	def public_key(self):
		return self.h

	def decrypt(self,c):
		a = self.__modcoeffs__(self.__cylic_conv__(self.f,c),self.q)
		b = self.__modcoeffs__(a,self.p)
		return self.__modcoeffs__(self.__cylic_conv__(self.fp,b),self.p)

testntru = NTRUEncrypt(11,5)