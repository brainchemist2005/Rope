	.data
hello:  .ascii "hello"
worldz:	.ascii " world\0"

	.text
        # Construit une corde unaire
        la a0, hello    # contenu
        li a1, 5        # taille
        call newRope
        mv s0, a0       # Sauvegarde pour exemples ultérieurs

	la a0, worldz	# contenu
	call str2Rope
	mv s2, a0	# corde unaire " world"
	
	mv a0, s0	# corde unaire "hello"
	
	mv a1, s2	# corde unaire " world"
	call concatRope
	mv s3, a0       # Sauvegarde pour exemples ultérieurs
	# s3 contient une corde binaire de taille 11 ("hello world"),
	# sa sous-corde de gauche est s0 ("hello")
	# et sa sous-corde de droite est s2 (" world")

	ld a0, 0(s3)
	call printInt	# -11

	li a0, ' '
	call printChar

	ebreak

	ld a0, 8(s3)
	call printString
	sub a0, a0, s0
	call printInt	# 0

	li a0, ' '
	call printChar

	ld a0, 16(s3)
	call printString
	sub a0, a0, s2
	call printInt	# 0

	li a0, 0
	call exit

#stdout:-11 0 0
