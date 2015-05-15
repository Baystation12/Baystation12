//This file was auto-corrected by findeclaration.exe on 25.5.2012 20:42:33

/*
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
*/

var/global/list/ALL_ANTIGENS = list(
		"A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "K", "L", "M", "N", "O", "P", "Q", "R", "S", "T", "U", "V", "W", "X", "Y", "Z"
	)

/hook/startup/proc/randomise_antigens_order()
	ALL_ANTIGENS = shuffle(ALL_ANTIGENS)
	return 1

// pure concentrated antibodies
datum/reagent/antibodies
	data = list("antibodies"=list())
	name = "Antibodies"
	id = "antibodies"
	reagent_state = LIQUID
	color = "#0050F0"

	reaction_mob(var/mob/M, var/method=CHEM_TOUCH, var/volume)
		if(istype(M,/mob/living/carbon))
			var/mob/living/carbon/C = M
			if(src.data && method == CHEM_INGEST)
				//if(C.virus2) if(src.data["antibodies"] & C.virus2.antigen)
				//	C.virus2.dead = 1
				C.antibodies |= src.data["antibodies"]
		return

// iterate over the list of antigens and see what matches
/proc/antigens2string(list/antigens, none="None")
	if(!istype(antigens))
		CRASH("Illegal type!")
	if(!antigens.len)
		return none

	var/code = ""
	for(var/V in ALL_ANTIGENS)
		if(V in antigens)
			code += V

	if(!code)
		return none

	return code
