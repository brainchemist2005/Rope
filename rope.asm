.text 
.global newRope
newRope:
    # Alloue de la mémoire pour la corde
    li a7, 9            # syscall pour sbrk en RARS
    li a0, 16           # taille de la corde unaire
    ecall

    # Initialise rLen et rData
    mv t0, a0           # adresse de la corde allouée
    sw a1, 0(t0)        # rLen
    sw a0, 4(t0)        # rData (adresse du tableau de caractères)
    jr ra

.global str2Rope
str2Rope:
    # Calcule la longueur de la chaîne
    mv t0, a0
    li t1, 0
loop:
    lbu t2, 0(t0)
    beqz t2, endloop
    addi t0, t0, 1
    addi t1, t1, 1
    j loop
endloop:
    
    # Appelle newRope avec l'adresse et la taille
    mv a1, t1
    j newRope

.global lenRope
lenRope:
    lw a0, 0(a0)    # Charge rLen
    jr ra

.global printRope
printRope:
    # Récupère rData et rLen
    lw t1, 0(a0)    # rLen
    lw t2, 4(a0)    # rData

    # Appel système pour écrire
    li a7, 64       # syscall pour Write en RARS
    li a0, 1        # descripteur de fichier (stdout)
    mv a1, t2       # pointeur vers les données
    mv a2, t1       # nombre d'octets à écrire
    ecall
    jr ra


.global splitRope
splitRope:
    # Charge la longueur de la corde et l'adresse des données
    lw t1, 0(a0)    # rLen
    lw t2, 4(a0)    # rData

    # Vérifie si l'index est valide
    bltz a1, split_end
    bgt a1, t1, split_end

    # Crée la première corde jusqu'à l'index
    mv a0, t2       # adresse des données
    mv a1, a1       # longueur jusqu'à l'index
    jal newRope     # appelle newRope
    mv t3, a0       # sauvegarde l'adresse de la première nouvelle corde

    # Crée la seconde corde à partir de l'index
    add t0, t2, a1  # calcule la nouvelle adresse des données
    sub t4, t1, a1  # calcule la nouvelle longueur
    mv a0, t0
    mv a1, t4
    jal newRope

    # Retourne les deux nouvelles adresses de cordes
    mv a0, t3
    mv a1, a0
    jr ra
    
    split_end:
    # Si l'index est en dehors de la plage valide, retourne la corde originale et une corde vide

    # Retourne la corde originale en a0
    mv a0, t2   # Retourne l'adresse originale de la corde

    # Crée une corde vide pour a1
    li a1, 0
    jal newRope # Crée une corde vide
    mv a1, a0   # Met la corde vide en a1

    # Restaure a0 à la corde originale
    mv a0, t2
    jr ra

.global concatRope
concatRope:
    # Alloue de la mémoire pour la corde binaire
    li a7, 9        # syscall pour sbrk en RARS
    li a0, 24       # taille de la corde binaire
    ecall
    mv t5, a0       # Sauvegarde l'adresse de la corde binaire

    # Calcule la longueur totale des cordes originales
    lw t1, 0(a0)    # rLen de la première corde
    lw t2, 0(a1)    # rLen de la seconde corde
    sub t3, zero, t1
    sub t3, t3, t2  # rLen totale (négatif)

    # Initialise la corde binaire
    mv t0, t5       # Utilise l'adresse de la corde binaire sauvegardée
    sw t3, 0(t0)    # rLen (négatif)
    sw a0, 4(t0)    # rLeft (première corde)
    sw a1, 8(t0)    # rRight (seconde corde)
    jr ra
