/obj/structure/ship_munition/bsa_charge
	name = "bsa charge"
	desc = "A charge to power the BSA with. It looks impossibly round and shiny."
	icon_state = "slug"
	var/chargetype
	var/chargedesc
	var/chargeeffect

/obj/structure/ship_munition/bsa_charge/examine(mob/user)
	. = ..(user)
	if(. && user.skill_check(SKILL_WEAPONS, SKILL_ADEPT))
		to_chat(user, "You recognize it as a [chargedesc]. [chargeeffect]")

/obj/structure/ship_munition/bsa_charge/proc/fire(turf/target, strength, range)
	CRASH("BSA charge firing logic not set!")

/obj/structure/ship_munition/bsa_charge/fire
	chargetype = BSA_FIRE
	chargedesc = "BSA-FR1-ENFER"
	chargeeffect = "It creates a localized fire on impact."

/obj/structure/ship_munition/bsa_charge/fire/fire(turf/target, strength, range)
	for(var/turf/T in range(range, target))
		var/obj/effect/fake_fire/bluespace/bsaf = new(T)
		bsaf.lifetime = strength * 20

/obj/effect/fake_fire/bluespace
	name = "bluespace fire"
	color = COLOR_BLUE
	pressure = 1500

/obj/structure/ship_munition/bsa_charge/emp
	chargetype = BSA_EMP
	chargedesc = "BSA-EM2-QUASAR"
	chargeeffect = "It creates an electromagnetic pulse on impact."

/obj/structure/ship_munition/bsa_charge/emp/fire(turf/target, strength, range)
	empulse(target, strength * range / 3, strength * range)

/obj/structure/ship_munition/bsa_charge/mining
	chargetype = BSA_MINING
	chargedesc = "BSA-MN3-BERGBAU"
	chargeeffect = "It extracts minerals from rock formations on impact."

/obj/structure/ship_munition/bsa_charge/mining/fire(turf/target, strength, range)
	var/list/victims = range(range * 3, target)
	for(var/turf/simulated/mineral/M in victims)
		if(prob(strength * 100 / 6)) //6 instead of 5 so there are always leftovers
			M.GetDrilled(TRUE) //no artifacts survive this
	for(var/mob/living/L in victims)
		to_chat(L, "<span class='alert'>You feel an incredible power trying to pry you apart... But it decides to spare you.</span>")
		L.ex_act(3) //no artif- I mean idiot/unfortunate bystanders survive this... much

/obj/structure/ship_munition/bsa_charge/explosive
	chargetype = BSA_EXPLOSIVE
	chargedesc = "BSA-XP4-INDARRA"
	chargeeffect = "It explodes on impact."

/obj/structure/ship_munition/bsa_charge/explosive/fire(turf/target, strength, range)
	explosion(target,max(1,strength * range / 10),strength * range / 7.5,strength * range / 5)