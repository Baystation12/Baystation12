/obj/structure/ship_munition/bsa_charge
	name = "unknown bsa charge"
	desc = "A charge to power the BSA with. It looks impossibly round and shiny."
	icon_state = "slug"
	var/chargetype
	var/chargedesc

/obj/structure/ship_munition/bsa_charge/proc/fire(turf/target, strength, range)
	CRASH("BSA charge firing logic not set!")

/obj/structure/ship_munition/bsa_charge/fire
	name = "\improper BSA-FR1-ENFER charge"
	color = "#b95a00"
	chargetype = BSA_FIRE
	chargedesc = "ENFER"

/obj/structure/ship_munition/bsa_charge/fire/fire(turf/target, strength, range)
	for(var/turf/T in range(range, target))
		var/obj/fire/F = new(T)
		QDEL_IN(F, 40 * strength) //Not regular fire, does not respect atmos. Let's get rid of it manually.

/obj/structure/ship_munition/bsa_charge/emp
	name = "\improper BSA-EM2-QUASAR charge"
	color = "#6a97b0"
	chargetype = BSA_EMP
	chargedesc = "QUASAR"

/obj/structure/ship_munition/bsa_charge/emp/fire(turf/target, strength, range)
	empulse(target, strength * range / 3, strength * range)

/obj/structure/ship_munition/bsa_charge/mining
	name = "\improper BSA-MN3-BERGBAU charge"
	color = "#cfcf55"
	chargetype = BSA_MINING
	chargedesc = "BERGBAU"

/obj/structure/ship_munition/bsa_charge/mining/fire(turf/target, strength, range)
	var/list/victims = range(range * 3, target)
	for(var/turf/simulated/mineral/M in victims)
		if(prob(strength * 100 / 6)) //6 instead of 5 so there are always leftovers
			to_chat(M, "You feel an incredible power trying to pry you apart... But it decides to spare you.")
			M.GetDrilled(TRUE) //no artifacts survive this
	for(var/mob/living/L in victims)
		L.ex_act(3) //no artif- I mean idiot/unfortunate bystanders survive this... much

/obj/structure/ship_munition/bsa_charge/explosive
	name = "\improper BSA-XP4-INDARRA charge"
	color = "#aa5f61"
	chargetype = BSA_EXPLOSIVE
	chargedesc = "INDARRA"

/obj/structure/ship_munition/bsa_charge/explosive/fire(turf/target, strength, range)
	explosion(target,max(1,strength * range / 10),strength * range / 7.5,strength * range / 5)