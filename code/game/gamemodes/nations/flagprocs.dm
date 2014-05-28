/obj/item/flag/nation
	density = 1
	anchored = 1
	var/turf/startloc = null
	var/captured = 0
	var/list/vassals = list()
	var/datum/nations/liege = null
	var/datum/nations/nation = null

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
			if(user.mind.nation.type == nation) //Same team as flag
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
				if(liege && liege == F.liege)
					user << "<span class='warning'>You can't steal your liege's flags!</span>"
					return
				else if(..())
					captured = 0
					anchored = 0
					var/obj/item/flag/nation/N = locate(liege.flagpath)
					for(var/mob/living/carbon/human/H in player_list)
						if(H.mind && H.mind.nation)
							if(H.mind.nation == liege)
								H << "<span class='warning'>You are no longer the liege of [nation.name]!</span>"
							if(H.mind.nation == nation)
								H << "<span class='warning'>You are no longer vassals of [liege.name]!</span>"

					N.vassals -= nation
					liege = null
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
			liege = F.nation
			F.vassals += nation
			//Announce capture/vassalage here.
			for(var/mob/living/carbon/human/H in player_list)
				if(H.mind && H.mind.nation)
					if(H.mind.nation.type == F.nation)
						H << "<span class='warning'>You have just vassalized [nation.name]! They must now obey any memebrs of your nation!</span>"
						continue
					else if(H.mind.nation.type == nation)
						H << "<span class='warning'>You are now vassals of [liege.name]! You must now obey the orders of any of their members!</span>"
						continue
			//Check for Victory
			for(var/obj/item/flag/nation/N in flag_list)
				if(N == F)
					continue
				if(N.captured && (N.liege == F.nation) && N.Adjacent(F))
					continue
				else
					return
			ticker.mode.declare_completion(F.nation)



//Nations/Department flags --Nations Gamemode Specific
/obj/item/flag/nation/cargo
	name = "Cargonia flag"
	desc = "The flag of the independant, sovereign nation of Cargonia."
	icon_state = "cargoflag"
	nation = /datum/nations/cargonia

/obj/item/flag/nation/med
	name = "Medistan flag"
	desc = "The flag of the independant, sovereign nation of Medistan."
	icon_state = "medflag"
	nation = /datum/nations/medistan

/obj/item/flag/nation/sec
	name = "Brigston flag"
	desc = "The flag of the independant, sovereign nation of Brigston."
	icon_state = "secflag"
	nation = /datum/nations/brigston

/obj/item/flag/nation/rnd
	name = "Scientopia flag"
	desc = "The flag of the independant, sovereign nation of Scientopia."
	icon_state = "rndflag"
	nation = /datum/nations/scientopia

/obj/item/flag/nation/atmos
	name = "Atmosia flag"
	desc = "The flag of the independant, sovereign nation of Atmosia."
	icon_state = "atmosflag"
	nation = /datum/nations/atmosia

/obj/item/flag/nation/command
	name = "Command flag"
	desc = "The flag of the independant, sovereign nation of Command."
	icon_state = "ntflag"
	nation = /datum/nations/command