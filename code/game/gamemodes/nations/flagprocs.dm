/obj/item/flag/nation
	density = 1
	anchored = 1
	var/turf/startloc = null
	var/captured = 0

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
	return

/obj/item/flag/nation/attack_paw()
	return

/obj/item/flag/nation/ex_act()
	return

/obj/item/flag/nation/blob_act()
	return

/obj/item/flag/nation/attack_hand(mob/user as mob)
	if(user.mind)
		if(user.mind.nation)
			if(user.mind.nation.flagpath == type) //Same team as flag
				if(loc != startloc)
					loc = startloc
					user.visible_message("[user] sends [src] back to base!", "You return [src] to your base!")
					return
				else
					user << "<span class='warning'>You can't move your flag from it's home location!</span>"
					return
			else
				var/obj/item/flag/nation/F = locate(user.mind.nation.flagpath)
				if(captured && Adjacent(F.startloc))
					user << "<span class='warning'>This flag has already been captured by your team!</span>"
					return
				else
					captured = 0
					anchored = 0
					..()
		else
			user << "<span class='warning'>You are not part of a nation and therefore cannot pick up any flags!</span>"
			return
	return

/obj/item/flag/nation/dropped(mob/user as mob)
	..()
	spawn(20)
		anchored = 1
		var/obj/item/flag/nation/F = locate(user.mind.nation.flagpath)
		if(F.loc == F.startloc && Adjacent(F.startloc))
			captured = 1
			//Announce capture/vassalage here.
			//
			//Check for Victory
			for(var/obj/item/flag/nation/N in flag_list)
				if(N == F)
					continue
				if(N.captured && N.Adjacent(F))
					continue
				else
					break
				//announceVictory()




//Nations/Department flags --Nations Gamemode Specific
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