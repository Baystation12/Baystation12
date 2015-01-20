//This file was auto-corrected by findeclaration.exe on 25.5.2012 20:42:33

// reserving some numbers for later special antigens
var/global/const/ANTIGEN_A  = 1
var/global/const/ANTIGEN_B  = 2
var/global/const/ANTIGEN_C  = 4
var/global/const/ANTIGEN_D  = 8
var/global/const/ANTIGEN_E  = 16
var/global/const/ANTIGEN_M  = 32
var/global/const/ANTIGEN_N  = 64
var/global/const/ANTIGEN_O  = 128
var/global/const/ANTIGEN_P  = 256
var/global/const/ANTIGEN_Q  = 512
var/global/const/ANTIGEN_U  = 1024
var/global/const/ANTIGEN_V  = 2048
var/global/const/ANTIGEN_W  = 4096
var/global/const/ANTIGEN_X  = 8192
var/global/const/ANTIGEN_Y  = 16384
var/global/const/ANTIGEN_Z  = 32768

var/global/list/ANTIGENS = list(
"[ANTIGEN_A]" = "A",
"[ANTIGEN_B]" = "B",
"[ANTIGEN_C]" = "C",
"[ANTIGEN_E]" = "E",
"[ANTIGEN_D]" = "D",
"[ANTIGEN_M]" = "M",
"[ANTIGEN_N]" = "N",
"[ANTIGEN_O]" = "O",
"[ANTIGEN_P]" = "P",
"[ANTIGEN_Q]" = "Q",
"[ANTIGEN_U]" = "U",
"[ANTIGEN_V]" = "V",
"[ANTIGEN_W]" = "W",
"[ANTIGEN_X]" = "X",
"[ANTIGEN_Y]" = "Y",
"[ANTIGEN_Z]" = "Z"
)

// pure concentrated antibodies
datum/reagent/antibodies
	data = list("antibodies"=0)
	name = "Antibodies"
	id = "antibodies"
	reagent_state = LIQUID
	color = "#0050F0"

	reaction_mob(var/mob/M, var/method=TOUCH, var/volume)
		if(istype(M,/mob/living/carbon))
			if(src.data && method == INGEST)
				if(M:virus2) if(src.data["antibodies"] & M:virus2.antigen)
					M:virus2.dead = 1
				M:antibodies |= src.data["antibodies"]
		return

// iterate over the list of antigens and see what matches
/proc/antigens2string(var/antigens)
	var/code = ""
	for(var/V in ANTIGENS) if(text2num(V) & antigens) code += ANTIGENS[V]
	return code