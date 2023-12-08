.eqv PrintChar, 11


	 .data
hello:  .ascii "hello"

        .text
        # Construit une corde unaire
        la a0, hello    # contenu
        li a1, 5        # taille
        call newRope
        mv s0, a0       # Sauvegarde pour exemples ultérieurs
        
        li a0, -1
        li a7,PrintChar 
        ecall
