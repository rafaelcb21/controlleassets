A
SELECT * FROM lancamento WHERE idconta = ?
SELECT * FROM lancamento WHERE idconta > 0

B
SELECT * FROM lancamento WHERE tipo = ? AND idcartao = 0
SELECT * FROM lancamento WHERE tipo = ? AND pago = 1 AND idcartao = 0
SELECT * FROM lancamento WHERE tipo = ? AND pago = 0 AND idcartao = 0

C
SELECT * FROM lancamento WHERE tiporepeticao = Fixa AND idcartao = 0
SELECT * FROM lancamento WHERE tiporepeticao = Parcelada AND idcartao = 0
SELECT * FROM lancamento WHERE NOT tiporepeticao = Fixa AND idcartao = 0
SELECT * FROM lancamento WHERE NOT tiporepeticao = Parcelada AND idcartao = 0
SELECT * FROM lancamento WHERE NOT tiporepeticao = Fixa AND NOT tiporepeticao = Parcelada AND idcartao = 0
SELECT * FROM lancamento WHERE tiporepeticao = Fixa AND tiporepeticao = Parcelada AND idcartao = 0

D
SELECT * FROM lancamento WHERE idcategoria = ?

E
SELECT * FROM lancamento WHERE idtag = ?

A,B
SELECT * FROM lancamento WHERE idconta = ? AND tipo = ?
SELECT * FROM lancamento WHERE idconta = ? AND tipo = ? AND pago = 1
SELECT * FROM lancamento WHERE idconta = ? AND tipo = ? AND pago = 0

SELECT * FROM lancamento WHERE idconta > 0 AND tipo = ?
SELECT * FROM lancamento WHERE idconta > 0 AND tipo = ? AND pago = 1
SELECT * FROM lancamento WHERE idconta > 0 AND tipo = ? AND pago = 0

A,C
SELECT * FROM lancamento WHERE idconta = ? AND tiporepeticao = Fixa
SELECT * FROM lancamento WHERE idconta = ? AND tiporepeticao = Parcelada
SELECT * FROM lancamento WHERE idconta = ? AND NOT tiporepeticao = Fixa
SELECT * FROM lancamento WHERE idconta = ? AND NOT tiporepeticao = Parcelada
SELECT * FROM lancamento WHERE idconta = ? AND NOT tiporepeticao = Fixa AND NOT tiporepeticao = Parcelada
SELECT * FROM lancamento WHERE idconta = ? AND tiporepeticao = Fixa AND tiporepeticao = Parcelada

SELECT * FROM lancamento WHERE idconta > 0 AND tiporepeticao = Fixa
SELECT * FROM lancamento WHERE idconta > 0 AND tiporepeticao = Parcelada
SELECT * FROM lancamento WHERE idconta > 0 AND NOT tiporepeticao = Fixa
SELECT * FROM lancamento WHERE idconta > 0 AND NOT tiporepeticao = Parcelada
SELECT * FROM lancamento WHERE idconta > 0 AND NOT tiporepeticao = Fixa AND NOT tiporepeticao = Parcelada
SELECT * FROM lancamento WHERE idconta > 0 AND tiporepeticao = Fixa AND tiporepeticao = Parcelada

A,D
SELECT * FROM lancamento WHERE idconta = ? AND idcategoria = ?

SELECT * FROM lancamento WHERE idconta > 0 AND idcategoria = ?

A,E
SELECT * FROM lancamento WHERE idconta = ? AND idtag = ?

SELECT * FROM lancamento WHERE idconta > 0 AND idtag = ?

B,C
SELECT * FROM lancamento WHERE tipo = ? AND idcartao = 0 AND tiporepeticao = Fixa
SELECT * FROM lancamento WHERE tipo = ? AND idcartao = 0 AND tiporepeticao = Parcelada
SELECT * FROM lancamento WHERE tipo = ? AND idcartao = 0 AND NOT tiporepeticao = Fixa
SELECT * FROM lancamento WHERE tipo = ? AND idcartao = 0 AND NOT tiporepeticao = Parcelada
SELECT * FROM lancamento WHERE tipo = ? AND idcartao = 0 AND NOT tiporepeticao = Fixa AND NOT tiporepeticao = Parcelada
SELECT * FROM lancamento WHERE tipo = ? AND idcartao = 0 AND tiporepeticao = Fixa AND tiporepeticao = Parcelada

SELECT * FROM lancamento WHERE tipo = ? AND pago = 1 AND idcartao = 0 AND tiporepeticao = Fixa
SELECT * FROM lancamento WHERE tipo = ? AND pago = 1 AND idcartao = 0 AND tiporepeticao = Parcelada
SELECT * FROM lancamento WHERE tipo = ? AND pago = 1 AND idcartao = 0 AND NOT tiporepeticao = Fixa
SELECT * FROM lancamento WHERE tipo = ? AND pago = 1 AND idcartao = 0 AND NOT tiporepeticao = Parcelada
SELECT * FROM lancamento WHERE tipo = ? AND pago = 1 AND idcartao = 0 AND NOT tiporepeticao = Fixa AND NOT tiporepeticao = Parcelada
SELECT * FROM lancamento WHERE tipo = ? AND pago = 1 AND idcartao = 0 AND tiporepeticao = Fixa AND tiporepeticao = Parcelada

SELECT * FROM lancamento WHERE tipo = ? AND pago = 0 AND idcartao = 0 AND tiporepeticao = Fixa
SELECT * FROM lancamento WHERE tipo = ? AND pago = 0 AND idcartao = 0 AND tiporepeticao = Parcelada
SELECT * FROM lancamento WHERE tipo = ? AND pago = 0 AND idcartao = 0 AND NOT tiporepeticao = Fixa
SELECT * FROM lancamento WHERE tipo = ? AND pago = 0 AND idcartao = 0 AND NOT tiporepeticao = Parcelada
SELECT * FROM lancamento WHERE tipo = ? AND pago = 0 AND idcartao = 0 AND NOT tiporepeticao = Fixa AND NOT tiporepeticao = Parcelada
SELECT * FROM lancamento WHERE tipo = ? AND pago = 0 AND idcartao = 0 AND tiporepeticao = Fixa AND tiporepeticao = Parcelada

B,D
SELECT * FROM lancamento WHERE tipo = ? AND idcartao = 0 AND idcategoria = ?
SELECT * FROM lancamento WHERE tipo = ? AND pago = 1 AND idcartao = 0 AND idcategoria = ?
SELECT * FROM lancamento WHERE tipo = ? AND pago = 0 AND idcartao = 0 AND idcategoria = ?

B,E
SELECT * FROM lancamento WHERE tipo = ? AND idcartao = 0 AND idtag = ?
SELECT * FROM lancamento WHERE tipo = ? AND pago = 1 AND idcartao = 0 AND idtag = ?
SELECT * FROM lancamento WHERE tipo = ? AND pago = 0 AND idcartao = 0 AND idtag = ?

C,D
SELECT * FROM lancamento WHERE tiporepeticao = Fixa AND idcartao = 0 AND idcategoria = ?
SELECT * FROM lancamento WHERE tiporepeticao = Parcelada AND idcartao = 0 AND idcategoria = ?
SELECT * FROM lancamento WHERE NOT tiporepeticao = Fixa AND idcartao = 0 AND idcategoria = ?
SELECT * FROM lancamento WHERE NOT tiporepeticao = Parcelada AND idcartao = 0 AND idcategoria = ?
SELECT * FROM lancamento WHERE NOT tiporepeticao = Fixa AND NOT tiporepeticao = Parcelada AND idcartao = 0 AND idcategoria = ?
SELECT * FROM lancamento WHERE tiporepeticao = Fixa AND tiporepeticao = Parcelada AND idcartao = 0 AND idcategoria = ?

C,E
SELECT * FROM lancamento WHERE tiporepeticao = Fixa AND idcartao = 0 AND idtag = ?
SELECT * FROM lancamento WHERE tiporepeticao = Parcelada AND idcartao = 0 AND idtag = ?
SELECT * FROM lancamento WHERE NOT tiporepeticao = Fixa AND idcartao = 0 AND idtag = ?
SELECT * FROM lancamento WHERE NOT tiporepeticao = Parcelada AND idcartao = 0 AND idtag = ?
SELECT * FROM lancamento WHERE NOT tiporepeticao = Fixa AND NOT tiporepeticao = Parcelada AND idcartao = 0 AND idtag = ?
SELECT * FROM lancamento WHERE tiporepeticao = Fixa AND tiporepeticao = Parcelada AND idcartao = 0 AND idtag = ?

D,E
SELECT * FROM lancamento WHERE idcategoria = ? AND idtag = ?

A,B,C
SELECT * FROM lancamento WHERE idconta = ? AND tipo = ? AND tiporepeticao = Fixa
SELECT * FROM lancamento WHERE idconta = ? AND tipo = ? AND tiporepeticao = Parcelada
SELECT * FROM lancamento WHERE idconta = ? AND tipo = ? AND NOT tiporepeticao = Fixa
SELECT * FROM lancamento WHERE idconta = ? AND tipo = ? AND NOT tiporepeticao = Parcelada
SELECT * FROM lancamento WHERE idconta = ? AND tipo = ? AND NOT tiporepeticao = Fixa AND NOT tiporepeticao = Parcelada
SELECT * FROM lancamento WHERE idconta = ? AND tipo = ? AND tiporepeticao = Fixa AND tiporepeticao = Parcelada
SELECT * FROM lancamento WHERE idconta = ? AND tipo = ? AND pago = 1 AND tiporepeticao = Fixa
SELECT * FROM lancamento WHERE idconta = ? AND tipo = ? AND pago = 1 AND tiporepeticao = Parcelada
SELECT * FROM lancamento WHERE idconta = ? AND tipo = ? AND pago = 1 AND NOT tiporepeticao = Fixa
SELECT * FROM lancamento WHERE idconta = ? AND tipo = ? AND pago = 1 AND NOT tiporepeticao = Parcelada
SELECT * FROM lancamento WHERE idconta = ? AND tipo = ? AND pago = 1 AND NOT tiporepeticao = Fixa AND NOT tiporepeticao = Parcelada
SELECT * FROM lancamento WHERE idconta = ? AND tipo = ? AND pago = 1 AND tiporepeticao = Fixa AND tiporepeticao = Parcelada
SELECT * FROM lancamento WHERE idconta = ? AND tipo = ? AND pago = 0 AND tiporepeticao = Fixa
SELECT * FROM lancamento WHERE idconta = ? AND tipo = ? AND pago = 0 AND tiporepeticao = Parcelada
SELECT * FROM lancamento WHERE idconta = ? AND tipo = ? AND pago = 0 AND NOT tiporepeticao = Fixa
SELECT * FROM lancamento WHERE idconta = ? AND tipo = ? AND pago = 0 AND NOT tiporepeticao = Parcelada
SELECT * FROM lancamento WHERE idconta = ? AND tipo = ? AND pago = 0 AND NOT tiporepeticao = Fixa AND NOT tiporepeticao = Parcelada
SELECT * FROM lancamento WHERE idconta = ? AND tipo = ? AND pago = 0 AND tiporepeticao = Fixa AND tiporepeticao = Parcelada

SELECT * FROM lancamento WHERE idconta > 0 AND tipo = ? AND tiporepeticao = Fixa
SELECT * FROM lancamento WHERE idconta > 0 AND tipo = ? AND tiporepeticao = Parcelada
SELECT * FROM lancamento WHERE idconta > 0 AND tipo = ? AND NOT tiporepeticao = Fixa
SELECT * FROM lancamento WHERE idconta > 0 AND tipo = ? AND NOT tiporepeticao = Parcelada
SELECT * FROM lancamento WHERE idconta > 0 AND tipo = ? AND NOT tiporepeticao = Fixa AND NOT tiporepeticao = Parcelada
SELECT * FROM lancamento WHERE idconta > 0 AND tipo = ? AND tiporepeticao = Fixa AND tiporepeticao = Parcelada
SELECT * FROM lancamento WHERE idconta > 0 AND tipo = ? AND pago = 1 AND tiporepeticao = Fixa
SELECT * FROM lancamento WHERE idconta > 0 AND tipo = ? AND pago = 1 AND tiporepeticao = Parcelada
SELECT * FROM lancamento WHERE idconta > 0 AND tipo = ? AND pago = 1 AND NOT tiporepeticao = Fixa
SELECT * FROM lancamento WHERE idconta > 0 AND tipo = ? AND pago = 1 AND NOT tiporepeticao = Parcelada
SELECT * FROM lancamento WHERE idconta > 0 AND tipo = ? AND pago = 1 AND NOT tiporepeticao = Fixa AND NOT tiporepeticao = Parcelada
SELECT * FROM lancamento WHERE idconta > 0 AND tipo = ? AND pago = 1 AND tiporepeticao = Fixa AND tiporepeticao = Parcelada
SELECT * FROM lancamento WHERE idconta > 0 AND tipo = ? AND pago = 0 AND tiporepeticao = Fixa
SELECT * FROM lancamento WHERE idconta > 0 AND tipo = ? AND pago = 0 AND tiporepeticao = Parcelada
SELECT * FROM lancamento WHERE idconta > 0 AND tipo = ? AND pago = 0 AND NOT tiporepeticao = Fixa
SELECT * FROM lancamento WHERE idconta > 0 AND tipo = ? AND pago = 0 AND NOT tiporepeticao = Parcelada
SELECT * FROM lancamento WHERE idconta > 0 AND tipo = ? AND pago = 0 AND NOT tiporepeticao = Fixa AND NOT tiporepeticao = Parcelada
SELECT * FROM lancamento WHERE idconta > 0 AND tipo = ? AND pago = 0 AND tiporepeticao = Fixa AND tiporepeticao = Parcelada

A,B,D
SELECT * FROM lancamento WHERE idconta = ? AND tipo = ? AND idcategoria = ?
SELECT * FROM lancamento WHERE idconta = ? AND tipo = ? AND pago = 1 AND idcategoria = ?
SELECT * FROM lancamento WHERE idconta = ? AND tipo = ? AND pago = 0 AND idcategoria = ?

SELECT * FROM lancamento WHERE idconta > 0 AND tipo = ? AND idcategoria = ?
SELECT * FROM lancamento WHERE idconta > 0 AND tipo = ? AND pago = 1 AND idcategoria = ?
SELECT * FROM lancamento WHERE idconta > 0 AND tipo = ? AND pago = 0 AND idcategoria = ?

A,B,E
SELECT * FROM lancamento WHERE idconta = ? AND tipo = ? AND idtag = ?
SELECT * FROM lancamento WHERE idconta = ? AND tipo = ? AND pago = 1 AND idtag = ?
SELECT * FROM lancamento WHERE idconta = ? AND tipo = ? AND pago = 0 AND idtag = ?

SELECT * FROM lancamento WHERE idconta > 0 AND tipo = ? AND idtag = ?
SELECT * FROM lancamento WHERE idconta > 0 AND tipo = ? AND pago = 1 AND idtag = ?
SELECT * FROM lancamento WHERE idconta > 0 AND tipo = ? AND pago = 0 AND idtag = ?

A,C,D
SELECT * FROM lancamento WHERE idconta = ? AND tiporepeticao = Fixa AND idcategoria = ?
SELECT * FROM lancamento WHERE idconta = ? AND tiporepeticao = Parcelada AND idcategoria = ?
SELECT * FROM lancamento WHERE idconta = ? AND NOT tiporepeticao = Fixa AND idcategoria = ?
SELECT * FROM lancamento WHERE idconta = ? AND NOT tiporepeticao = Parcelada AND idcategoria = ?
SELECT * FROM lancamento WHERE idconta = ? AND NOT tiporepeticao = Fixa AND NOT tiporepeticao = Parcelada AND idcategoria = ?
SELECT * FROM lancamento WHERE idconta = ? AND tiporepeticao = Fixa AND tiporepeticao = Parcelada AND idcategoria = ?

SELECT * FROM lancamento WHERE idconta > 0 AND tiporepeticao = Fixa AND idcategoria = ?
SELECT * FROM lancamento WHERE idconta > 0 AND tiporepeticao = Parcelada AND idcategoria = ?
SELECT * FROM lancamento WHERE idconta > 0 AND NOT tiporepeticao = Fixa AND idcategoria = ?
SELECT * FROM lancamento WHERE idconta > 0 AND NOT tiporepeticao = Parcelada AND idcategoria = ?
SELECT * FROM lancamento WHERE idconta > 0 AND NOT tiporepeticao = Fixa AND NOT tiporepeticao = Parcelada AND idcategoria = ?
SELECT * FROM lancamento WHERE idconta > 0 AND tiporepeticao = Fixa AND tiporepeticao = Parcelada AND idcategoria = ?

A,C,E
SELECT * FROM lancamento WHERE idconta = ? AND tiporepeticao = Fixa AND idtag = ?
SELECT * FROM lancamento WHERE idconta = ? AND tiporepeticao = Parcelada AND idtag = ?
SELECT * FROM lancamento WHERE idconta = ? AND NOT tiporepeticao = Fixa AND idtag = ?
SELECT * FROM lancamento WHERE idconta = ? AND NOT tiporepeticao = Parcelada AND idtag = ?
SELECT * FROM lancamento WHERE idconta = ? AND NOT tiporepeticao = Fixa AND NOT tiporepeticao = Parcelada AND idtag = ?
SELECT * FROM lancamento WHERE idconta = ? AND tiporepeticao = Fixa AND tiporepeticao = Parcelada AND idtag = ?

SELECT * FROM lancamento WHERE idconta > 0 AND tiporepeticao = Fixa AND idtag = ?
SELECT * FROM lancamento WHERE idconta > 0 AND tiporepeticao = Parcelada AND idtag = ?
SELECT * FROM lancamento WHERE idconta > 0 AND NOT tiporepeticao = Fixa AND idtag = ?
SELECT * FROM lancamento WHERE idconta > 0 AND NOT tiporepeticao = Parcelada AND idtag = ?
SELECT * FROM lancamento WHERE idconta > 0 AND NOT tiporepeticao = Fixa AND NOT tiporepeticao = Parcelada AND idtag = ?
SELECT * FROM lancamento WHERE idconta > 0 AND tiporepeticao = Fixa AND tiporepeticao = Parcelada AND idtag = ?

A,D,E
SELECT * FROM lancamento WHERE idconta = ? AND idcategoria = ? AND idtag = ?

SELECT * FROM lancamento WHERE idconta > 0 AND idcategoria = ? AND idtag = ?

B,C,D
SELECT * FROM lancamento WHERE tipo = ? AND idcartao = 0 AND tiporepeticao = Fixa AND idcategoria = ?
SELECT * FROM lancamento WHERE tipo = ? AND idcartao = 0 AND tiporepeticao = Parcelada AND idcategoria = ?
SELECT * FROM lancamento WHERE tipo = ? AND idcartao = 0 AND NOT tiporepeticao = Fixa AND idcategoria = ?
SELECT * FROM lancamento WHERE tipo = ? AND idcartao = 0 AND NOT tiporepeticao = Parcelada AND idcategoria = ?
SELECT * FROM lancamento WHERE tipo = ? AND idcartao = 0 AND NOT tiporepeticao = Fixa AND NOT tiporepeticao = Parcelada AND idcategoria = ?
SELECT * FROM lancamento WHERE tipo = ? AND idcartao = 0 AND tiporepeticao = Fixa AND tiporepeticao = Parcelada AND idcategoria = ?

SELECT * FROM lancamento WHERE tipo = ? AND pago = 1 AND idcartao = 0 AND tiporepeticao = Fixa AND idcategoria = ?
SELECT * FROM lancamento WHERE tipo = ? AND pago = 1 AND idcartao = 0 AND tiporepeticao = Parcelada AND idcategoria = ?
SELECT * FROM lancamento WHERE tipo = ? AND pago = 1 AND idcartao = 0 AND NOT tiporepeticao = Fixa AND idcategoria = ?
SELECT * FROM lancamento WHERE tipo = ? AND pago = 1 AND idcartao = 0 AND NOT tiporepeticao = Parcelada AND idcategoria = ?
SELECT * FROM lancamento WHERE tipo = ? AND pago = 1 AND idcartao = 0 AND NOT tiporepeticao = Fixa AND NOT tiporepeticao = Parcelada AND idcategoria = ?
SELECT * FROM lancamento WHERE tipo = ? AND pago = 1 AND idcartao = 0 AND tiporepeticao = Fixa AND tiporepeticao = Parcelada AND idcategoria = ?

SELECT * FROM lancamento WHERE tipo = ? AND pago = 0 AND idcartao = 0 AND tiporepeticao = Fixa AND idcategoria = ?
SELECT * FROM lancamento WHERE tipo = ? AND pago = 0 AND idcartao = 0 AND tiporepeticao = Parcelada AND idcategoria = ?
SELECT * FROM lancamento WHERE tipo = ? AND pago = 0 AND idcartao = 0 AND NOT tiporepeticao = Fixa AND idcategoria = ?
SELECT * FROM lancamento WHERE tipo = ? AND pago = 0 AND idcartao = 0 AND NOT tiporepeticao = Parcelada AND idcategoria = ?
SELECT * FROM lancamento WHERE tipo = ? AND pago = 0 AND idcartao = 0 AND NOT tiporepeticao = Fixa AND NOT tiporepeticao = Parcelada AND idcategoria = ?
SELECT * FROM lancamento WHERE tipo = ? AND pago = 0 AND idcartao = 0 AND tiporepeticao = Fixa AND tiporepeticao = Parcelada AND idcategoria = ?

B,C,E
SELECT * FROM lancamento WHERE tipo = ? AND idcartao = 0 AND tiporepeticao = Fixa AND idtag = ?
SELECT * FROM lancamento WHERE tipo = ? AND idcartao = 0 AND tiporepeticao = Parcelada AND idtag = ?
SELECT * FROM lancamento WHERE tipo = ? AND idcartao = 0 AND NOT tiporepeticao = Fixa AND idtag = ?
SELECT * FROM lancamento WHERE tipo = ? AND idcartao = 0 AND NOT tiporepeticao = Parcelada AND idtag = ?
SELECT * FROM lancamento WHERE tipo = ? AND idcartao = 0 AND NOT tiporepeticao = Fixa AND NOT tiporepeticao = Parcelada AND idtag = ?
SELECT * FROM lancamento WHERE tipo = ? AND idcartao = 0 AND tiporepeticao = Fixa AND tiporepeticao = Parcelada AND idtag = ?

SELECT * FROM lancamento WHERE tipo = ? AND pago = 1 AND idcartao = 0 AND tiporepeticao = Fixa AND idtag = ?
SELECT * FROM lancamento WHERE tipo = ? AND pago = 1 AND idcartao = 0 AND tiporepeticao = Parcelada AND idtag = ?
SELECT * FROM lancamento WHERE tipo = ? AND pago = 1 AND idcartao = 0 AND NOT tiporepeticao = Fixa AND idtag = ?
SELECT * FROM lancamento WHERE tipo = ? AND pago = 1 AND idcartao = 0 AND NOT tiporepeticao = Parcelada AND idtag = ?
SELECT * FROM lancamento WHERE tipo = ? AND pago = 1 AND idcartao = 0 AND NOT tiporepeticao = Fixa AND NOT tiporepeticao = Parcelada AND idtag = ?
SELECT * FROM lancamento WHERE tipo = ? AND pago = 1 AND idcartao = 0 AND tiporepeticao = Fixa AND tiporepeticao = Parcelada AND idtag = ?

SELECT * FROM lancamento WHERE tipo = ? AND pago = 0 AND idcartao = 0 AND tiporepeticao = Fixa AND idtag = ?
SELECT * FROM lancamento WHERE tipo = ? AND pago = 0 AND idcartao = 0 AND tiporepeticao = Parcelada AND idtag = ?
SELECT * FROM lancamento WHERE tipo = ? AND pago = 0 AND idcartao = 0 AND NOT tiporepeticao = Fixa AND idtag = ?
SELECT * FROM lancamento WHERE tipo = ? AND pago = 0 AND idcartao = 0 AND NOT tiporepeticao = Parcelada AND idtag = ?
SELECT * FROM lancamento WHERE tipo = ? AND pago = 0 AND idcartao = 0 AND NOT tiporepeticao = Fixa AND NOT tiporepeticao = Parcelada AND idtag = ?
SELECT * FROM lancamento WHERE tipo = ? AND pago = 0 AND idcartao = 0 AND tiporepeticao = Fixa AND tiporepeticao = Parcelada AND idtag = ?

B,D,E
SELECT * FROM lancamento WHERE tipo = ? AND idcartao = 0 AND idcategoria = ? AND idtag = ?
SELECT * FROM lancamento WHERE tipo = ? AND pago = 1 AND idcartao = 0 AND idcategoria = ? AND idtag = ?
SELECT * FROM lancamento WHERE tipo = ? AND pago = 0 AND idcartao = 0 AND idcategoria = ? AND idtag = ?

C,D,E
SELECT * FROM lancamento WHERE tiporepeticao = Fixa AND idcartao = 0 AND idcategoria = ? AND idtag = ?
SELECT * FROM lancamento WHERE tiporepeticao = Parcelada AND idcartao = 0 AND idcategoria = ? AND idtag = ?
SELECT * FROM lancamento WHERE NOT tiporepeticao = Fixa AND idcartao = 0 AND idcategoria = ? AND idtag = ?
SELECT * FROM lancamento WHERE NOT tiporepeticao = Parcelada AND idcartao = 0 AND idcategoria = ? AND idtag = ?
SELECT * FROM lancamento WHERE NOT tiporepeticao = Fixa AND NOT tiporepeticao = Parcelada AND idcartao = 0 AND idcategoria = ? AND idtag = ?
SELECT * FROM lancamento WHERE tiporepeticao = Fixa AND tiporepeticao = Parcelada AND idcartao = 0 AND idcategoria = ? AND idtag = ?

A,B,C,D
SELECT * FROM lancamento WHERE idconta = ? AND tipo = ? AND tiporepeticao = Fixa AND idcategoria = ?
SELECT * FROM lancamento WHERE idconta = ? AND tipo = ? AND tiporepeticao = Parcelada AND idcategoria = ?
SELECT * FROM lancamento WHERE idconta = ? AND tipo = ? AND NOT tiporepeticao = Fixa AND idcategoria = ?
SELECT * FROM lancamento WHERE idconta = ? AND tipo = ? AND NOT tiporepeticao = Parcelada AND idcategoria = ?
SELECT * FROM lancamento WHERE idconta = ? AND tipo = ? AND NOT tiporepeticao = Fixa AND NOT tiporepeticao = Parcelada AND idcategoria = ?
SELECT * FROM lancamento WHERE idconta = ? AND tipo = ? AND tiporepeticao = Fixa AND tiporepeticao = Parcelada AND idcategoria = ?
SELECT * FROM lancamento WHERE idconta = ? AND tipo = ? AND pago = 1 AND tiporepeticao = Fixa AND idcategoria = ?
SELECT * FROM lancamento WHERE idconta = ? AND tipo = ? AND pago = 1 AND tiporepeticao = Parcelada AND idcategoria = ?
SELECT * FROM lancamento WHERE idconta = ? AND tipo = ? AND pago = 1 AND NOT tiporepeticao = Fixa AND idcategoria = ?
SELECT * FROM lancamento WHERE idconta = ? AND tipo = ? AND pago = 1 AND NOT tiporepeticao = Parcelada AND idcategoria = ?
SELECT * FROM lancamento WHERE idconta = ? AND tipo = ? AND pago = 1 AND NOT tiporepeticao = Fixa AND NOT tiporepeticao = Parcelada AND idcategoria = ?
SELECT * FROM lancamento WHERE idconta = ? AND tipo = ? AND pago = 1 AND tiporepeticao = Fixa AND tiporepeticao = Parcelada AND idcategoria = ?
SELECT * FROM lancamento WHERE idconta = ? AND tipo = ? AND pago = 0 AND tiporepeticao = Fixa AND idcategoria = ?
SELECT * FROM lancamento WHERE idconta = ? AND tipo = ? AND pago = 0 AND tiporepeticao = Parcelada AND idcategoria = ?
SELECT * FROM lancamento WHERE idconta = ? AND tipo = ? AND pago = 0 AND NOT tiporepeticao = Fixa AND idcategoria = ?
SELECT * FROM lancamento WHERE idconta = ? AND tipo = ? AND pago = 0 AND NOT tiporepeticao = Parcelada AND idcategoria = ?
SELECT * FROM lancamento WHERE idconta = ? AND tipo = ? AND pago = 0 AND NOT tiporepeticao = Fixa AND NOT tiporepeticao = Parcelada AND idcategoria = ?
SELECT * FROM lancamento WHERE idconta = ? AND tipo = ? AND pago = 0 AND tiporepeticao = Fixa AND tiporepeticao = Parcelada AND idcategoria = ?

SELECT * FROM lancamento WHERE idconta > 0 AND tipo = ? AND tiporepeticao = Fixa AND idcategoria = ?
SELECT * FROM lancamento WHERE idconta > 0 AND tipo = ? AND tiporepeticao = Parcelada AND idcategoria = ?
SELECT * FROM lancamento WHERE idconta > 0 AND tipo = ? AND NOT tiporepeticao = Fixa AND idcategoria = ?
SELECT * FROM lancamento WHERE idconta > 0 AND tipo = ? AND NOT tiporepeticao = Parcelada AND idcategoria = ?
SELECT * FROM lancamento WHERE idconta > 0 AND tipo = ? AND NOT tiporepeticao = Fixa AND NOT tiporepeticao = Parcelada AND idcategoria = ?
SELECT * FROM lancamento WHERE idconta > 0 AND tipo = ? AND tiporepeticao = Fixa AND tiporepeticao = Parcelada AND idcategoria = ?
SELECT * FROM lancamento WHERE idconta > 0 AND tipo = ? AND pago = 1 AND tiporepeticao = Fixa AND idcategoria = ?
SELECT * FROM lancamento WHERE idconta > 0 AND tipo = ? AND pago = 1 AND tiporepeticao = Parcelada AND idcategoria = ?
SELECT * FROM lancamento WHERE idconta > 0 AND tipo = ? AND pago = 1 AND NOT tiporepeticao = Fixa AND idcategoria = ?
SELECT * FROM lancamento WHERE idconta > 0 AND tipo = ? AND pago = 1 AND NOT tiporepeticao = Parcelada AND idcategoria = ?
SELECT * FROM lancamento WHERE idconta > 0 AND tipo = ? AND pago = 1 AND NOT tiporepeticao = Fixa AND NOT tiporepeticao = Parcelada AND idcategoria = ?
SELECT * FROM lancamento WHERE idconta > 0 AND tipo = ? AND pago = 1 AND tiporepeticao = Fixa AND tiporepeticao = Parcelada AND idcategoria = ?
SELECT * FROM lancamento WHERE idconta > 0 AND tipo = ? AND pago = 0 AND tiporepeticao = Fixa AND idcategoria = ?
SELECT * FROM lancamento WHERE idconta > 0 AND tipo = ? AND pago = 0 AND tiporepeticao = Parcelada AND idcategoria = ?
SELECT * FROM lancamento WHERE idconta > 0 AND tipo = ? AND pago = 0 AND NOT tiporepeticao = Fixa AND idcategoria = ?
SELECT * FROM lancamento WHERE idconta > 0 AND tipo = ? AND pago = 0 AND NOT tiporepeticao = Parcelada AND idcategoria = ?
SELECT * FROM lancamento WHERE idconta > 0 AND tipo = ? AND pago = 0 AND NOT tiporepeticao = Fixa AND NOT tiporepeticao = Parcelada AND idcategoria = ?
SELECT * FROM lancamento WHERE idconta > 0 AND tipo = ? AND pago = 0 AND tiporepeticao = Fixa AND tiporepeticao = Parcelada AND idcategoria = ?

A,B,C,E
SELECT * FROM lancamento WHERE idconta = ? AND tipo = ? AND tiporepeticao = Fixa AND idtag = ?
SELECT * FROM lancamento WHERE idconta = ? AND tipo = ? AND tiporepeticao = Parcelada AND idtag = ?
SELECT * FROM lancamento WHERE idconta = ? AND tipo = ? AND NOT tiporepeticao = Fixa AND idtag = ?
SELECT * FROM lancamento WHERE idconta = ? AND tipo = ? AND NOT tiporepeticao = Parcelada AND idtag = ?
SELECT * FROM lancamento WHERE idconta = ? AND tipo = ? AND NOT tiporepeticao = Fixa AND NOT tiporepeticao = Parcelada AND idtag = ?
SELECT * FROM lancamento WHERE idconta = ? AND tipo = ? AND tiporepeticao = Fixa AND tiporepeticao = Parcelada AND idtag = ?
SELECT * FROM lancamento WHERE idconta = ? AND tipo = ? AND pago = 1 AND tiporepeticao = Fixa AND idtag = ?
SELECT * FROM lancamento WHERE idconta = ? AND tipo = ? AND pago = 1 AND tiporepeticao = Parcelada AND idtag = ?
SELECT * FROM lancamento WHERE idconta = ? AND tipo = ? AND pago = 1 AND NOT tiporepeticao = Fixa AND idtag = ?
SELECT * FROM lancamento WHERE idconta = ? AND tipo = ? AND pago = 1 AND NOT tiporepeticao = Parcelada AND idtag = ?
SELECT * FROM lancamento WHERE idconta = ? AND tipo = ? AND pago = 1 AND NOT tiporepeticao = Fixa AND NOT tiporepeticao = Parcelada AND idtag = ?
SELECT * FROM lancamento WHERE idconta = ? AND tipo = ? AND pago = 1 AND tiporepeticao = Fixa AND tiporepeticao = Parcelada AND idtag = ?
SELECT * FROM lancamento WHERE idconta = ? AND tipo = ? AND pago = 0 AND tiporepeticao = Fixa AND idtag = ?
SELECT * FROM lancamento WHERE idconta = ? AND tipo = ? AND pago = 0 AND tiporepeticao = Parcelada AND idtag = ?
SELECT * FROM lancamento WHERE idconta = ? AND tipo = ? AND pago = 0 AND NOT tiporepeticao = Fixa AND idtag = ?
SELECT * FROM lancamento WHERE idconta = ? AND tipo = ? AND pago = 0 AND NOT tiporepeticao = Parcelada AND idtag = ?
SELECT * FROM lancamento WHERE idconta = ? AND tipo = ? AND pago = 0 AND NOT tiporepeticao = Fixa AND NOT tiporepeticao = Parcelada AND idtag = ?
SELECT * FROM lancamento WHERE idconta = ? AND tipo = ? AND pago = 0 AND tiporepeticao = Fixa AND tiporepeticao = Parcelada AND idtag = ?

SELECT * FROM lancamento WHERE idconta > 0 AND tipo = ? AND tiporepeticao = Fixa AND idtag = ?
SELECT * FROM lancamento WHERE idconta > 0 AND tipo = ? AND tiporepeticao = Parcelada AND idtag = ?
SELECT * FROM lancamento WHERE idconta > 0 AND tipo = ? AND NOT tiporepeticao = Fixa AND idtag = ?
SELECT * FROM lancamento WHERE idconta > 0 AND tipo = ? AND NOT tiporepeticao = Parcelada AND idtag = ?
SELECT * FROM lancamento WHERE idconta > 0 AND tipo = ? AND NOT tiporepeticao = Fixa AND NOT tiporepeticao = Parcelada AND idtag = ?
SELECT * FROM lancamento WHERE idconta > 0 AND tipo = ? AND tiporepeticao = Fixa AND tiporepeticao = Parcelada AND idtag = ?
SELECT * FROM lancamento WHERE idconta > 0 AND tipo = ? AND pago = 1 AND tiporepeticao = Fixa AND idtag = ?
SELECT * FROM lancamento WHERE idconta > 0 AND tipo = ? AND pago = 1 AND tiporepeticao = Parcelada AND idtag = ?
SELECT * FROM lancamento WHERE idconta > 0 AND tipo = ? AND pago = 1 AND NOT tiporepeticao = Fixa AND idtag = ?
SELECT * FROM lancamento WHERE idconta > 0 AND tipo = ? AND pago = 1 AND NOT tiporepeticao = Parcelada AND idtag = ?
SELECT * FROM lancamento WHERE idconta > 0 AND tipo = ? AND pago = 1 AND NOT tiporepeticao = Fixa AND NOT tiporepeticao = Parcelada AND idtag = ?
SELECT * FROM lancamento WHERE idconta > 0 AND tipo = ? AND pago = 1 AND tiporepeticao = Fixa AND tiporepeticao = Parcelada AND idtag = ?
SELECT * FROM lancamento WHERE idconta > 0 AND tipo = ? AND pago = 0 AND tiporepeticao = Fixa AND idtag = ?
SELECT * FROM lancamento WHERE idconta > 0 AND tipo = ? AND pago = 0 AND tiporepeticao = Parcelada AND idtag = ?
SELECT * FROM lancamento WHERE idconta > 0 AND tipo = ? AND pago = 0 AND NOT tiporepeticao = Fixa AND idtag = ?
SELECT * FROM lancamento WHERE idconta > 0 AND tipo = ? AND pago = 0 AND NOT tiporepeticao = Parcelada AND idtag = ?
SELECT * FROM lancamento WHERE idconta > 0 AND tipo = ? AND pago = 0 AND NOT tiporepeticao = Fixa AND NOT tiporepeticao = Parcelada AND idtag = ?
SELECT * FROM lancamento WHERE idconta > 0 AND tipo = ? AND pago = 0 AND tiporepeticao = Fixa AND tiporepeticao = Parcelada AND idtag = ?

A,B,D,E
SELECT * FROM lancamento WHERE idconta = ? AND tipo = ? AND idcategoria = ? AND idtag = ?
SELECT * FROM lancamento WHERE idconta = ? AND tipo = ? AND pago = 1 AND idcategoria = ? AND idtag = ?
SELECT * FROM lancamento WHERE idconta = ? AND tipo = ? AND pago = 0 AND idcategoria = ? AND idtag = ?

SELECT * FROM lancamento WHERE idconta > 0 AND tipo = ? AND idcategoria = ? AND idtag = ?
SELECT * FROM lancamento WHERE idconta > 0 AND tipo = ? AND pago = 1 AND idcategoria = ? AND idtag = ?
SELECT * FROM lancamento WHERE idconta > 0 AND tipo = ? AND pago = 0 AND idcategoria = ? AND idtag = ?

A,C,D,E
SELECT * FROM lancamento WHERE idconta = ? AND tiporepeticao = Fixa AND idcategoria = ? AND idtag = ?
SELECT * FROM lancamento WHERE idconta = ? AND tiporepeticao = Parcelada AND idcategoria = ? AND idtag = ?
SELECT * FROM lancamento WHERE idconta = ? AND NOT tiporepeticao = Fixa AND idcategoria = ? AND idtag = ?
SELECT * FROM lancamento WHERE idconta = ? AND NOT tiporepeticao = Parcelada AND idcategoria = ? AND idtag = ?
SELECT * FROM lancamento WHERE idconta = ? AND NOT tiporepeticao = Fixa AND NOT tiporepeticao = Parcelada AND idcategoria = ? AND idtag = ?
SELECT * FROM lancamento WHERE idconta = ? AND tiporepeticao = Fixa AND tiporepeticao = Parcelada AND idcategoria = ? AND idtag = ?

SELECT * FROM lancamento WHERE idconta > 0 AND tiporepeticao = Fixa AND idcategoria = ? AND idtag = ?
SELECT * FROM lancamento WHERE idconta > 0 AND tiporepeticao = Parcelada AND idcategoria = ? AND idtag = ?
SELECT * FROM lancamento WHERE idconta > 0 AND NOT tiporepeticao = Fixa AND idcategoria = ? AND idtag = ?
SELECT * FROM lancamento WHERE idconta > 0 AND NOT tiporepeticao = Parcelada AND idcategoria = ? AND idtag = ?
SELECT * FROM lancamento WHERE idconta > 0 AND NOT tiporepeticao = Fixa AND NOT tiporepeticao = Parcelada AND idcategoria = ? AND idtag = ?
SELECT * FROM lancamento WHERE idconta > 0 AND tiporepeticao = Fixa AND tiporepeticao = Parcelada AND idcategoria = ? AND idtag = ?

B,C,D,E
SELECT * FROM lancamento WHERE tipo = ? AND idcartao = 0 AND tiporepeticao = Fixa AND idcategoria = ? AND idtag = ?
SELECT * FROM lancamento WHERE tipo = ? AND idcartao = 0 AND tiporepeticao = Parcelada AND idcategoria = ? AND idtag = ?
SELECT * FROM lancamento WHERE tipo = ? AND idcartao = 0 AND NOT tiporepeticao = Fixa AND idcategoria = ? AND idtag = ?
SELECT * FROM lancamento WHERE tipo = ? AND idcartao = 0 AND NOT tiporepeticao = Parcelada AND idcategoria = ? AND idtag = ?
SELECT * FROM lancamento WHERE tipo = ? AND idcartao = 0 AND NOT tiporepeticao = Fixa AND NOT tiporepeticao = Parcelada AND idcategoria = ? AND idtag = ?
SELECT * FROM lancamento WHERE tipo = ? AND idcartao = 0 AND tiporepeticao = Fixa AND tiporepeticao = Parcelada AND idcategoria = ? AND idtag = ?

SELECT * FROM lancamento WHERE tipo = ? AND pago = 1 AND idcartao = 0 AND tiporepeticao = Fixa AND idcategoria = ? AND idtag = ?
SELECT * FROM lancamento WHERE tipo = ? AND pago = 1 AND idcartao = 0 AND tiporepeticao = Parcelada AND idcategoria = ? AND idtag = ?
SELECT * FROM lancamento WHERE tipo = ? AND pago = 1 AND idcartao = 0 AND NOT tiporepeticao = Fixa AND idcategoria = ? AND idtag = ?
SELECT * FROM lancamento WHERE tipo = ? AND pago = 1 AND idcartao = 0 AND NOT tiporepeticao = Parcelada AND idcategoria = ? AND idtag = ?
SELECT * FROM lancamento WHERE tipo = ? AND pago = 1 AND idcartao = 0 AND NOT tiporepeticao = Fixa AND NOT tiporepeticao = Parcelada AND idcategoria = ? AND idtag = ?
SELECT * FROM lancamento WHERE tipo = ? AND pago = 1 AND idcartao = 0 AND tiporepeticao = Fixa AND tiporepeticao = Parcelada AND idcategoria = ? AND idtag = ?

SELECT * FROM lancamento WHERE tipo = ? AND pago = 0 AND idcartao = 0 AND tiporepeticao = Fixa AND idcategoria = ? AND idtag = ?
SELECT * FROM lancamento WHERE tipo = ? AND pago = 0 AND idcartao = 0 AND tiporepeticao = Parcelada AND idcategoria = ? AND idtag = ?
SELECT * FROM lancamento WHERE tipo = ? AND pago = 0 AND idcartao = 0 AND NOT tiporepeticao = Fixa AND idcategoria = ? AND idtag = ?
SELECT * FROM lancamento WHERE tipo = ? AND pago = 0 AND idcartao = 0 AND NOT tiporepeticao = Parcelada AND idcategoria = ? AND idtag = ?
SELECT * FROM lancamento WHERE tipo = ? AND pago = 0 AND idcartao = 0 AND NOT tiporepeticao = Fixa AND NOT tiporepeticao = Parcelada AND idcategoria = ? AND idtag = ?
SELECT * FROM lancamento WHERE tipo = ? AND pago = 0 AND idcartao = 0 AND tiporepeticao = Fixa AND tiporepeticao = Parcelada AND idcategoria = ? AND idtag = ?

A,B,C,D,E
SELECT * FROM lancamento WHERE idconta = ? AND tipo = ? AND tiporepeticao = Fixa AND idcategoria = ? AND idtag = ?
SELECT * FROM lancamento WHERE idconta = ? AND tipo = ? AND tiporepeticao = Parcelada AND idcategoria = ? AND idtag = ?
SELECT * FROM lancamento WHERE idconta = ? AND tipo = ? AND NOT tiporepeticao = Fixa AND idcategoria = ? AND idtag = ?
SELECT * FROM lancamento WHERE idconta = ? AND tipo = ? AND NOT tiporepeticao = Parcelada AND idcategoria = ? AND idtag = ?
SELECT * FROM lancamento WHERE idconta = ? AND tipo = ? AND NOT tiporepeticao = Fixa AND NOT tiporepeticao = Parcelada AND idcategoria = ? AND idtag = ?
SELECT * FROM lancamento WHERE idconta = ? AND tipo = ? AND tiporepeticao = Fixa AND tiporepeticao = Parcelada AND idcategoria = ? AND idtag = ?
SELECT * FROM lancamento WHERE idconta = ? AND tipo = ? AND pago = 1 AND tiporepeticao = Fixa AND idcategoria = ? AND idtag = ?
SELECT * FROM lancamento WHERE idconta = ? AND tipo = ? AND pago = 1 AND tiporepeticao = Parcelada AND idcategoria = ? AND idtag = ?
SELECT * FROM lancamento WHERE idconta = ? AND tipo = ? AND pago = 1 AND NOT tiporepeticao = Fixa AND idcategoria = ? AND idtag = ?
SELECT * FROM lancamento WHERE idconta = ? AND tipo = ? AND pago = 1 AND NOT tiporepeticao = Parcelada AND idcategoria = ? AND idtag = ?
SELECT * FROM lancamento WHERE idconta = ? AND tipo = ? AND pago = 1 AND NOT tiporepeticao = Fixa AND NOT tiporepeticao = Parcelada AND idcategoria = ? AND idtag = ?
SELECT * FROM lancamento WHERE idconta = ? AND tipo = ? AND pago = 1 AND tiporepeticao = Fixa AND tiporepeticao = Parcelada AND idcategoria = ? AND idtag = ?
SELECT * FROM lancamento WHERE idconta = ? AND tipo = ? AND pago = 0 AND tiporepeticao = Fixa AND idcategoria = ? AND idtag = ?
SELECT * FROM lancamento WHERE idconta = ? AND tipo = ? AND pago = 0 AND tiporepeticao = Parcelada AND idcategoria = ? AND idtag = ?
SELECT * FROM lancamento WHERE idconta = ? AND tipo = ? AND pago = 0 AND NOT tiporepeticao = Fixa AND idcategoria = ? AND idtag = ?
SELECT * FROM lancamento WHERE idconta = ? AND tipo = ? AND pago = 0 AND NOT tiporepeticao = Parcelada AND idcategoria = ? AND idtag = ?
SELECT * FROM lancamento WHERE idconta = ? AND tipo = ? AND pago = 0 AND NOT tiporepeticao = Fixa AND NOT tiporepeticao = Parcelada AND idcategoria = ? AND idtag = ?
SELECT * FROM lancamento WHERE idconta = ? AND tipo = ? AND pago = 0 AND tiporepeticao = Fixa AND tiporepeticao = Parcelada AND idcategoria = ? AND idtag = ?

SELECT * FROM lancamento WHERE idconta > 0 AND tipo = ? AND tiporepeticao = Fixa AND idcategoria = ? AND idtag = ?
SELECT * FROM lancamento WHERE idconta > 0 AND tipo = ? AND tiporepeticao = Parcelada AND idcategoria = ? AND idtag = ?
SELECT * FROM lancamento WHERE idconta > 0 AND tipo = ? AND NOT tiporepeticao = Fixa AND idcategoria = ? AND idtag = ?
SELECT * FROM lancamento WHERE idconta > 0 AND tipo = ? AND NOT tiporepeticao = Parcelada AND idcategoria = ? AND idtag = ?
SELECT * FROM lancamento WHERE idconta > 0 AND tipo = ? AND NOT tiporepeticao = Fixa AND NOT tiporepeticao = Parcelada AND idcategoria = ? AND idtag = ?
SELECT * FROM lancamento WHERE idconta > 0 AND tipo = ? AND tiporepeticao = Fixa AND tiporepeticao = Parcelada AND idcategoria = ? AND idtag = ?
SELECT * FROM lancamento WHERE idconta > 0 AND tipo = ? AND pago = 1 AND tiporepeticao = Fixa AND idcategoria = ? AND idtag = ?
SELECT * FROM lancamento WHERE idconta > 0 AND tipo = ? AND pago = 1 AND tiporepeticao = Parcelada AND idcategoria = ? AND idtag = ?
SELECT * FROM lancamento WHERE idconta > 0 AND tipo = ? AND pago = 1 AND NOT tiporepeticao = Fixa AND idcategoria = ? AND idtag = ?
SELECT * FROM lancamento WHERE idconta > 0 AND tipo = ? AND pago = 1 AND NOT tiporepeticao = Parcelada AND idcategoria = ? AND idtag = ?
SELECT * FROM lancamento WHERE idconta > 0 AND tipo = ? AND pago = 1 AND NOT tiporepeticao = Fixa AND NOT tiporepeticao = Parcelada AND idcategoria = ? AND idtag = ?
SELECT * FROM lancamento WHERE idconta > 0 AND tipo = ? AND pago = 1 AND tiporepeticao = Fixa AND tiporepeticao = Parcelada AND idcategoria = ? AND idtag = ?
SELECT * FROM lancamento WHERE idconta > 0 AND tipo = ? AND pago = 0 AND tiporepeticao = Fixa AND idcategoria = ? AND idtag = ?
SELECT * FROM lancamento WHERE idconta > 0 AND tipo = ? AND pago = 0 AND tiporepeticao = Parcelada AND idcategoria = ? AND idtag = ?
SELECT * FROM lancamento WHERE idconta > 0 AND tipo = ? AND pago = 0 AND NOT tiporepeticao = Fixa AND idcategoria = ? AND idtag = ?
SELECT * FROM lancamento WHERE idconta > 0 AND tipo = ? AND pago = 0 AND NOT tiporepeticao = Parcelada AND idcategoria = ? AND idtag = ?
SELECT * FROM lancamento WHERE idconta > 0 AND tipo = ? AND pago = 0 AND NOT tiporepeticao = Fixa AND NOT tiporepeticao = Parcelada AND idcategoria = ? AND idtag = ?
SELECT * FROM lancamento WHERE idconta > 0 AND tipo = ? AND pago = 0 AND tiporepeticao = Fixa AND tiporepeticao = Parcelada AND idcategoria = ? AND idtag = ?

-- 335 QUERYS
