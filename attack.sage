# doesn't work...

from sage.modules.free_module_integer import IntegerLattice
import numpy

load("NTRUEncrypt.sage")

# parameters
testntru = NTRUEncrypt(1)
N = testntru.N
h = testntru.public_key()
print(h)
q = testntru.q
p = testntru.p
df = testntru.df
dg = testntru.dg
dr = testntru.dr

# construct LNT matrix
alpha = 5# max(ceil(sqrt(2*dg)/sqrt(2*df-1)),1)
hvec = h.list()
hmat = []
for i in range(N):
	hmat.append(numpy.roll(hvec,-1*i).tolist())

A = alpha*matrix.identity(N)
print(type(A))
B = matrix(hmat)
print(type(B))
C = matrix(N)
print(type(C))
D = q*matrix.identity(N)
print(type(D))

LNT = A.augment(B)
LNT = LNT.stack(C.augment(D))
print(type(LNT))

# LLL reduction and finding row with norm closesest to norm(alpha*f,g)
LNTrb = LNT.LLL()

vecnorm = sqrt(alpha*(2*df-1)+2*dg-1)
dists2vec = []

for i in range(2*N):
	dists2vec.append(abs(LNTrb[i].norm()-vecnorm))

indexmin = numpy.argmin(dists2vec)
print(LNTrb[indexmin])