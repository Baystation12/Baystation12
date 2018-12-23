/obj/structure/ship_munition/bsa_charge
	name = "unknown bsa charge"
	desc = "A charge to power the BSA with. It looks impossibly round and shiny. This charge does not have a defined purpose."
	icon_state = "slug"
	var/chargetype
	var/chargedesc

/obj/structure/ship_munition/bsa_charge/proc/fire(turf/target, strength, range)
	CRASH("BSA charge firing logic not set!")

/obj/structure/ship_munition/bsa_charge/fire
	name = "\improper BSA-FR1-ENFER charge"
	color = "#b95a00"
	desc = "A charge to power the BSA with. It looks impossibly round and shiny. This charge is designed to release a localised fire on impact."
	chargetype = BSA_FIRE
	chargedesc = "ENFER"

/obj/structure/ship_munition/bsa_charge/fire/fire(turf/target, strength, range)
	for(var/turf/T in range(range, target))
		var/obj/effect/fake_fire/bluespace/bsaf = new(T)
		bsaf.lifetime = strength * 20

/obj/effect/fake_fire/bluespace
	name = "bluespace fire"
	color = COLOR_BLUE
	pressure = 1500

/obj/structure/ship_munition/bsa_charge/emp
	name = "\improper BSA-EM2-QUASAR charge"
	color = "#6a97b0"
	desc = "A charge to power the BSA with. It looks impossibly round and shiny. This charge is designed to release a blast of electromagnetic pulse on impact."
	chargetype = BSA_EMP
	chargedesc = "QUASAR"

/obj/structure/ship_munition/bsa_charge/emp/fire(turf/target, strength, range)
	empulse(target, strength * range / 3, strength * range)

/obj/structure/ship_munition/bsa_charge/mining
	name = "\improper BSA-MN3-BERGBAU charge"
	color = "#cfcf55"
	desc = "A charge to power the BSA with. It looks impossibly round and shiny. This charge is designed to mine ores on impact."
	chargetype = BSA_MINING
	chargedesc = "BERGBAU"

/obj/structure/ship_munition/bsa_charge/mining/fire(turf/target, strength, range)
	var/list/victims = range(range * 3, target)
	for(var/turf/simulated/mineral/M in victims)
		if(prob(strength * 100 / 6)) //6 instead of 5 so there are always leftovers
			M.GetDrilled(TRUE) //no artifacts survive this
	for(var/mob/living/L in victims)
		to_chat(L, "<span class='alert'>You feel an incredible power trying to pry you apart... But it decides to spare you.</span>")
		L.ex_act(3) //no artif- I mean idiot/unfortunate bystanders survive this... much

/obj/structure/ship_munition/bsa_charge/explosive
	name = "\improper BSA-XP4-INDARRA charge"
	color = "#aa5f61"
	desc = "A charge to power the BSA with. It looks impossibly round and shiny. This charge is designed to explode on impact."
	chargetype = BSA_EXPLOSIVE
	chargedesc = "INDARRA"

/obj/structure/ship_munition/bsa_charge/explosive/fire(turf/target, strength, range)
	explosion(target,max(1,strength * range / 10),strength * range / 7.5,strength * range / 5)