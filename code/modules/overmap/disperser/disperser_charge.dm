/obj/structure/ship_munition/disperser_charge
	name = "unknown disperser charge"
	desc = "A charge to power the obstruction field disperser with. It looks impossibly round and shiny. This charge does not have a defined purpose."
	icon_state = "slug"
	atom_flags =  ATOM_FLAG_NO_TEMP_CHANGE | ATOM_FLAG_CLIMBABLE
	var/chargetype
	var/chargedesc

/obj/structure/ship_munition/disperser_charge/proc/fire(turf/target, strength, range)
	CRASH("OFD charge firing logic not set!")

/obj/structure/ship_munition/disperser_charge/fire
	name = "FR1-ENFER charge"
	color = "#b95a00"
	desc = "A charge to power the obstruction field disperser with. It looks impossibly round and shiny. This charge is designed to release a localised fire on impact."
	chargetype = OVERMAP_WEAKNESS_FIRE
	chargedesc = "ENFER"

/obj/structure/ship_munition/disperser_charge/fire/fire(turf/target, strength, range)
	for(var/turf/T in range(range, target))
		var/obj/effect/fake_fire/bluespace/disperserf = new(T)
		disperserf.lifetime = strength * 20

/obj/effect/fake_fire/bluespace
	name = "bluespace fire"
	color = COLOR_BLUE
	pressure = 1500


/obj/structure/ship_munition/disperser_charge/emp
	name = "EM2-QUASAR charge"
	color = "#6a97b0"
	desc = "A charge to power the obstruction field disperser with. It looks impossibly round and shiny. This charge is designed to release a blast of electromagnetic pulse on impact."
	chargetype = OVERMAP_WEAKNESS_EMP
	chargedesc = "QUASAR"

/obj/structure/ship_munition/disperser_charge/emp/fire(turf/target, strength, range)
	empulse(target, strength * range / 3, strength * range)

/obj/structure/ship_munition/disperser_charge/mining
	name = "MN3-BERGBAU charge"
	color = "#cfcf55"
	desc = "A charge to power the obstruction field disperser with. It looks impossibly round and shiny. This charge is designed to mine ores on impact."
	chargetype = OVERMAP_WEAKNESS_MINING
	chargedesc = "BERGBAU"

/obj/structure/ship_munition/disperser_charge/mining/fire(turf/target, strength, range)
	var/list/victims = range(range * 3, target)
	for(var/turf/simulated/mineral/M in victims)
		if(prob(strength * 100 / 6)) //6 instead of 5 so there are always leftovers
			M.GetDrilled(TRUE) //no artifacts survive this
	for(var/mob/living/L in victims)
		to_chat(L, SPAN_DANGER("You feel an incredible force ripping and tearing at you."))
		L.ex_act(EX_ACT_LIGHT) //no artif- I mean idiot/unfortunate bystanders survive this... much

/obj/structure/ship_munition/disperser_charge/explosive
	name = "XP4-INDARRA charge"
	color = "#aa5f61"
	desc = "A charge to power the obstruction field disperser with. It looks impossibly round and shiny. This charge is designed to explode on impact."
	chargetype = OVERMAP_WEAKNESS_EXPLOSIVE
	chargedesc = "INDARRA"

/obj/structure/ship_munition/disperser_charge/explosive/fire(turf/target, strength, range)
	explosion(target,max(1,strength * range / 10),strength * range / 7.5,strength * range / 5)
