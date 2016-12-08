R.<x> = ZZ['x']

class NTRUEncrypt(object):

	def __init__(self,N_in,log2q):
		self.N = N_in
		self.q = pow(2,log2q)
		self.p = 3
		f = -1 + x + x^2 - x^4 + x^6 + x^9 - x^(10)
		g = -1 + x^2 + x^3 + x^5 -x^8 - x^(10)
		# self.fg = polyinv2n(f,log2q)
		# self.fp = self.__polyinv3__(f)

		# todo: calc self.h

	# todo: absolutely last
	def __randpoly__(self,d):
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
				foo = f
				f = g
				g = foo
				bar = b
				b = c
				c = bar

			if f.coefficients(sparse=False)[0] == g.coefficients(sparse=False)[0]:
				f = f - g # todo: mod coeffs by 3 (other impl had a separate function for this)
				b + b - c # todo: mod coeffs by 3 (other impl had a separate function for this)
			else:
				f = f + g # todo: mod coeffs by 3 (other impl had a separate function for this)
				b = b + c # todo: mod coeffs by 3 (other impl had a separate function for this)

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
				foo = f
				f = g
				g = foo
				bar = b
				b = c
				c = bar

			f = f + g # todo: mod coeffs by 2 (other impl had a separate function for this)
			b + b + c # todo: mod coeffs by 2 (other impl had a separate function for this)


	def __polyinv2n__(self,a,n):
		b = __polyinv2__(a)
		q=1
		while q<n:
			q+=1
			b = b * (2 - a*b) #todo: mod coeffs by q (other impl had a separate function for this)


	# todo: this can be found on section 1.2 on page 3 of grenoble.pdf
	def __cylic_conv__():
		pass

	# todo
	def encrypt(self,m):
		pass

	def public_key(self):
		return self.h

	# todo
	def decrypt(self,c):
		pass


testntru = NTRUEncrypt(11,5)