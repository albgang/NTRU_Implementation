R.<x> = ZZ['x']

class NTRUEncrypt(object):
	def __init__(self,sec_lvl):
		self.p = 3
		if sec_lvl == 1: #weak
			self.N = 11
			self.q = 32
			self.df = 4
			self.dg = 3
			self.dr = 3
		elif sec_lvl == 2: #moderate
			self.N = 167
			self.q = 128
			self.df = 61
			self.dg = 20
			self.dr = 18
		elif sec_lvl == 3: #standard
			self.N = 263
			self.q = 128
			self.df = 50
			self.dg = 24
			self.dr = 16
		elif sec_lvl == 4: #strongest
			self.N = 503
			self.q = 256
			self.df = 216
			self.dg = 72
			self.dr = 55
		else:
			print("Invalid Security Level. Valid Security Levels are 1 (weak), 2(moderate), 3(standard), and 4(strongest)")
			exit(1)

		invq,invp = false,false
		while not invq and not invp:
			# self.__f = self.__randpoly(self.df,self.df-1)
			self.__f = -1 + x + x^2 - x^4 + x^6 + x^9 - x^(10)
			invq, self.fq = self.__polyinv2n(self.__f,self.q)
			invp, self.__fp = self.__polyinv3(self.__f)
		
		self.g = -1 + x^2 + x^3 + x^5 -x^8 - x^(10)
		# self.g = self.__randpoly(self.dg,self.dg)

		self.h = self.__modcoeffs(self.p*self.__cylic_conv(self.fq,self.g),self.q)

	def __randpoly(self,num1s,numneg1s):
		randlist = [1] * num1s + [-1] * numneg1s + [0] * (self.N-num1s-numneg1s)
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

	def __polyinv3(self,a):
		k=0
		b=1
		c=0
		f = a
		g = x^self.N - 1

		while(1):
			while(f(0) == 0 and f != 0):
				f = f.shift(-1)
				c = c * x
				k += 1
			
			if f == 1:
				return (True, self.__modcoeffs(self.__cylic_conv(x^((-k)%self.N),b),3)) 
			elif f == -1:
				return (True, self.__modcoeffs(self.__cylic_conv(-x^((-k)%self.N),b),3))
			elif f.degree() == -1 or f.is_zero():
				return (False,0)

			if f.degree() < g.degree():
				f,g = g,f
				b,c = c,b

			if f(0) == g(0):
				f = self.__modcoeffs(f-g,3)
				b = b-c
				c = self.__modcoeffs(c,3)

			else:
				f = self.__modcoeffs(f+g,3)
				b = b+c
				c = self.__modcoeffs(c,3)

	def __polyinv2(self,a):
		k=0
		b=1
		c=0
		f = a
		g = x^self.N - 1

		while(1):
			while(f(0) == 0 and f != 0):
				f = f.shift(-1)
				c = c * x
				k += 1

			if f == 1:
				return (True, self.__modcoeffs(self.__cylic_conv(x^((-k)%self.N),b),2)) 
			elif f.degree() == -1 or f == 0:
				return (False,0)

			if f.degree() < g.degree():
				f,g = g,f
				b,c = c,b

			f = self.__modcoeffs(f + g,2)
			b = b+c
			c = self.__modcoeffs(c,2)


	def __polyinv2n(self,a,pow2):
		inv2, b = self.__polyinv2(a)
		if (inv2):
			curpow2 = 2
			while curpow2<pow2:
				curpow2 = curpow2^2
				ab = self.__cylic_conv(a,b)
				b = self.__cylic_conv(b,2-ab)
				b = self.__modcoeffs(b,curpow2)
			return (True, self.__modcoeffs(b,pow2))
		else: 
			return (False,0)

	def __cylic_conv(self,f,g):
		fg = (f*g).list()
		lower_fg = fg[0:self.N]
		upper_fg = fg[self.N:len(fg)]
		h = lower_fg
		for i in range(len(upper_fg)):
			h[i] += upper_fg[i]
		return R(h)

	def encrypt(self,m):
		r = -1+x^2+x^3+x^4-x^5-x^7
		# r = self.__randpoly(self.dr,self.dr)
		return self.__modcoeffs(self.__cylic_conv(r,self.h) + m,self.q)

	def public_key(self):
		return self.h

	def check_f(self,potential_f):
		return potential_f == self.f

	def check_fp(self,potential_fp):
		return potential_fp == self.fp

	def check_g(self,potential_g):
		return potential_g == self.g

	def decrypt(self,c):
		a = self.__modcoeffs(self.__cylic_conv(self.__f,c),self.q)
		b = self.__modcoeffs(a,self.p)
		return self.__modcoeffs(self.__cylic_conv(self.__fp,b),self.p)

# print("private key attempt:", testntru.__f,testntru.__fp) # we want this to give error [it does]
# print("private functions attempt:",testntru.__cylic_conv(x,x)) # we want this to give error [it does]
