**Synopsis**
==========================
NTRUEncrypt.sage contains our groups implementation of NTRUEncrypt for EECS475 (Introduction to Cryptography). We implemented NTRU in order to shed some light on a lattice based cryptosystem.

**Usage**
==========================
Run sage and type this command in the sage terminal:
```
  load("NTRUEncrypt.sage")
```

**Example**
==========================

	load("NTRUEncrypt.sage")

	testntru = NTRUEncrypt(1)
	h = testntru.public_key()
	m = -1 + x^3 - x^4 - x^8 + x^9 + x^(10)
	print("message: ",m)
	c = testntru.encrypt(m)
	print("ciphertext: ", c)
	d = testntru.decrypt(c)
	print("decryption: ", d)

**Contributors**
==========================
- *Albert Gang*
- *Jacob Winick*
- *Michael Lu*
- *Steven La Feir*
