/datum/nations
	var/name
	var/flagpath


/datum/nations/atmosia
	name = "Atmosia"
	flagpath = /obj/item/flag/nation/atmos

/datum/nations/brigston
	name = "Brigston"
	flagpath = /obj/item/flag/nation/sec

/datum/nations/cargonia
	name = "Cargonia"
	flagpath = /obj/item/flag/nation/cargo

/datum/nations/command
	name = "Command"
	flagpath = /obj/item/flag/nation/command

/datum/nations/medistan
	name = "Medistan"
	flagpath = /obj/item/flag/nation/med

/datum/nations/scientopia
	name = "Scientopia"
	flagpath = /obj/item/flag/nation/rnd









//Nations/Department flags --Nations Gamemode Specific
/obj/item/flag/nation
	density = 1
	anchored = 1
	var/turf/startloc = null

/obj/item/flag/nation/New()
	..()
	flag_list += src

/obj/item/flag/nation/fire_act()
	return

/obj/item/flag/nation/Ignite()
	return

/obj/item/flag/nation/light()
	return



/obj/item/flag/nation/attackby(var/obj/item/weapon/W, var/mob/user)




/obj/item/flag/nation/cargo
	name = "Cargonia flag"
	desc = "The flag of the independant, sovereign nation of Cargonia."
	icon_state = "cargoflag"

/obj/item/flag/nation/med
	name = "Medistan flag"
	desc = "The flag of the independant, sovereign nation of Medistan."
	icon_state = "medflag"

/obj/item/flag/nation/sec
	name = "Brigston flag"
	desc = "The flag of the independant, sovereign nation of Brigston."
	icon_state = "secflag"

/obj/item/flag/nation/rnd
	name = "Scientopia flag"
	desc = "The flag of the independant, sovereign nation of Scientopia."
	icon_state = "rndflag"

/obj/item/flag/nation/atmos
	name = "Atmosia flag"
	desc = "The flag of the independant, sovereign nation of Atmosia."
	icon_state = "atmosflag"

/obj/item/flag/nation/command
	name = "Command flag"
	desc = "The flag of the independant, sovereign nation of Command."
	icon_state = "ntflag"