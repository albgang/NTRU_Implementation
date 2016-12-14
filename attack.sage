from sage.modules.free_module_integer import IntegerLattice
import numpy, sys

R.<x> = ZZ['x']

## --- Inverting Functions (Modified from NTRUEncrypt) --- ##
def ComputePublicKey(f, g, dg, df, p, q, N):
	invq, fq = polyinv2n(f,q,N)
	if not invq:
		return R()
	return modcoeffs(p*cylic_conv(fq,g,N),q)

def modcoeffs(f,m):
	c = f.list()
	m2 = m/2
	for i in range(len(c)):
		c[i] = c[i]%m
		if c[i] > m2:
			c[i] -= m
	return R(c)        

def polyinv3(a, N):
	k=0
	b=1
	c=0
	f = a
	g = x^N - 1

	while(1):
		while(f(0) == 0 and f != 0):
			f = f.shift(-1)
			c = c * x
			k += 1
		
		if f == 1:
			return (True, modcoeffs(cylic_conv(x^((-k)%N),b,N),3)) 
		elif f == -1:
			return (True, modcoeffs(cylic_conv(-x^((-k)%N),b,N),3))
		elif f.degree() == -1 or f.is_zero():
			return (False,0)

		if f.degree() < g.degree():
			f,g = g,f
			b,c = c,b

		if f(0) == g(0):
			f = modcoeffs(f-g,3)
			b = b-c
			c = modcoeffs(c,3)

		else:
			f = modcoeffs(f+g,3)
			b = b+c
			c = modcoeffs(c,3)

def polyinv2(a,N):
	k=0
	b=1
	c=0
	f = a
	g = x^N - 1

	while(1):
		while(f(0) == 0 and f != 0):
			f = f.shift(-1)
			c = c * x
			k += 1

		if f == 1:
			return (True, modcoeffs(cylic_conv(x^((-k)%N),b,N),2)) 
		elif f.degree() == -1 or f == 0:
			return (False,0)

		if f.degree() < g.degree():
			f,g = g,f
			b,c = c,b

		f = modcoeffs(f + g,2)
		b = b+c
		c = modcoeffs(c,2)

def polyinv2n(a,pow2,N):
	inv2, b = polyinv2(a,N)
	if (inv2):
		curpow2 = 2
		while curpow2<pow2:
			curpow2 = curpow2^2
			ab = cylic_conv(a,b,N)
			b = cylic_conv(b,2-ab,N)
			b = modcoeffs(b,curpow2)
		return (True, modcoeffs(b,pow2))
	else: 
		return (False,0)

def cylic_conv(f,g,N):
	fg = (f*g).list()
	lower_fg = fg[0:N]
	upper_fg = fg[N:len(fg)]
	h = lower_fg
	for i in range(len(upper_fg)):
		h[i] += upper_fg[i]
	return R(h)

## --- Initialize NTRU --- ##
load("NTRUEncrypt.sage")
NTRU = NTRUEncrypt(1)
N = NTRU.N
p = NTRU.p
q = NTRU.q
df = NTRU.df
dg = NTRU.dg
h = NTRU.public_key()

## --- Construct the Equivalent Lattice --- ##
#Alpha matrix
alpha = max(ceil(sqrt(2*dg)/sqrt(2*df-1)),1)
A = alpha*matrix.identity(N)

#H matrix
h_list = h.list()
h_matrix = []
for i in range(N):
	h_matrix.append(numpy.roll(h_list,-1*i).tolist())
B = matrix(h_matrix)

#0 matrix
C = matrix(N)

#Q matrix
D = q*matrix.identity(N)

#Combine matrices
LNT = A.augment(B)
LNT = LNT.stack(C.augment(D))
#print(LNT)


## --- Compute LLL Reduction --- ##
LNT_reduced = LNT.BKZ()

#print
if (0):
	for i in range(2*N):
		print(LNT_reduced[i])

## --- Find Closest Norm --- ##
target_length = sqrt(alpha*(2*df-1)+2*p^2*dg)
distance2target = []

#Calculate distance for each vector
for i in range(2*N):
	distance2target.append((LNT_reduced[i].norm()-target_length).n())

#Compute h_attack for all vectors w/ 0-distance
index = -1
for i in range(2*N):
	if distance2target[i] == 0:
		f_attack = LNT_reduced[i][0:N]/alpha
		g_attack = LNT_reduced[i][N:(2*N)]/p
		f_attack = f_attack.list()
		f_attack.reverse() #why?!?!
		g_attack = g_attack.list()
		g_attack = numpy.roll(g_attack,-1).tolist() #why?!?!?1
		#note that h_attack is invariant to roll
		
		h_attack = ComputePublicKey(R(f_attack), R(g_attack), dg, df, p, q, N)

		if h == h_attack:
			index = i


if index == -1:
	print("Private key lattice attack failed.")
	sys.exit()
else:
	print("Private key has been broken.")

## --- Test Found Norm --- ##

#Create and encrypt message

#Decrypt message using real encryption

#Decrypt message using the break

## --- Outputs --- ##
# print("The public key is: ", h.list())
# print("The value of df is: ", df)
# print("The value of dg is: ", dg)
# print("Key found [alpha*f p*g]: ")
# print("Initial message: ")
# print("Decrypted (real) message: ")
# print("Decrypted (attack) message: ")