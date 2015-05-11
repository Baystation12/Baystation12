/datum/reagent/toxin
	name = "Toxin"
	id = "toxin"
	description = "A toxic chemical."
	reagent_state = LIQUID
	color = "#CF3600" // rgb: 207, 54, 0
	var/toxpwr = 0.7 // Toxins are really weak, but without being treated, last very long.
	custom_metabolism = 0.1

/datum/reagent/toxin/on_mob_life(var/mob/living/M as mob,var/alien)
	if(!M) M = holder.my_atom
	if(toxpwr)
		M.adjustToxLoss(toxpwr*REM)
	if(alien) ..() // Kind of a catch-all for aliens without the liver. Because this does not metabolize 'naturally', only removed by the liver.
	return

/datum/reagent/plasticide
	name = "Plasticide"
	id = "plasticide"
	description = "Liquid plastic, do not eat."
	reagent_state = LIQUID
	color = "#CF3600" // rgb: 207, 54, 0
	custom_metabolism = 0.01

/datum/reagent/plasticide/on_mob_life(var/mob/living/M as mob)
	if(!M) M = holder.my_atom
	// Toxins are really weak, but without being treated, last very long.
	M.adjustToxLoss(0.2)
	..()
	return

/datum/reagent/toxin/amatoxin
	name = "Amatoxin"
	id = "amatoxin"
	description = "A powerful poison derived from certain species of mushroom."
	reagent_state = LIQUID
	color = "#792300" // rgb: 121, 35, 0
	toxpwr = 1

/datum/reagent/toxin/carpotoxin
	name = "Carpotoxin"
	id = "carpotoxin"
	description = "A deadly neurotoxin produced by the dreaded space carp."
	reagent_state = LIQUID
	color = "#003333" // rgb: 0, 51, 51
	toxpwr = 2

/datum/reagent/toxin/phoron
	name = "Phoron"
	id = "phoron"
	description = "Phoron in its liquid form."
	reagent_state = LIQUID
	color = "#9D14DB"
	toxpwr = 3

/datum/reagent/toxin/phoron/on_mob_life(var/mob/living/M as mob)
	if(!M) M = holder.my_atom
	holder.remove_reagent("inaprovaline", 2*REM)
	..()
	return

/datum/reagent/toxin/phoron/reaction_obj(var/obj/O, var/volume)
	src = null
	/*if(istype(O,/obj/item/weapon/reagent_containers/food/snacks/egg/slime))
		var/obj/item/weapon/reagent_containers/food/snacks/egg/slime/egg = O
		if (egg.grown)
			egg.Hatch()*/
	if((!O) || (!volume))	return 0
	var/turf/the_turf = get_turf(O)
	the_turf.assume_gas("volatile_fuel", volume, T20C)

/datum/reagent/toxin/phoron/reaction_turf(var/turf/T, var/volume)
	src = null
	T.assume_gas("volatile_fuel", volume, T20C)
	return

/datum/reagent/toxin/phoron/reaction_mob(var/mob/living/M, var/method=TOUCH, var/volume)//Splashing people with plasma is stronger than fuel!
	if(!istype(M, /mob/living))
		return
	if(method == TOUCH)
		M.adjust_fire_stacks(volume / 5)
		return

/datum/reagent/toxin/cyanide //Fast and Lethal
	name = "Cyanide"
	id = "cyanide"
	description = "A highly toxic chemical."
	reagent_state = LIQUID
	color = "#CF3600" // rgb: 207, 54, 0
	toxpwr = 4
	custom_metabolism = 0.4

/datum/reagent/toxin/cyanide/on_mob_life(var/mob/living/M as mob)
	if(!M) M = holder.my_atom
	M.adjustOxyLoss(4*REM)
	M.sleeping += 1
	..()
	return

/datum/reagent/toxin/potassium_chloride
	name = "Potassium Chloride"
	id = "potassium_chloride"
	description = "A delicious salt that stops the heart when injected into cardiac muscle."
	reagent_state = SOLID
	color = "#FFFFFF" // rgb: 255,255,255
	toxpwr = 0
	overdose = 30

/datum/reagent/toxin/potassium_chloride/on_mob_life(var/mob/living/carbon/M as mob)
	var/mob/living/carbon/human/H = M
	if(H.stat != 1)
		if (volume >= overdose)
			if(H.losebreath >= 10)
				H.losebreath = max(10, H.losebreath-10)
			H.adjustOxyLoss(2)
			H.Weaken(10)
	..()
	return

/datum/reagent/toxin/potassium_chlorophoride
	name = "Potassium Chlorophoride"
	id = "potassium_chlorophoride"
	description = "A specific chemical based on Potassium Chloride to stop the heart for surgery. Not safe to eat!"
	reagent_state = SOLID
	color = "#FFFFFF" // rgb: 255,255,255
	toxpwr = 2
	overdose = 20

/datum/reagent/toxin/potassium_chlorophoride/on_mob_life(var/mob/living/carbon/M as mob)
	if(ishuman(M))
		var/mob/living/carbon/human/H = M
		if(H.stat != 1)
			if(H.losebreath >= 10)
				H.losebreath = max(10, M.losebreath-10)
			H.adjustOxyLoss(2)
			H.Weaken(10)
	..()
	return

/datum/reagent/toxin/zombiepowder
	name = "Zombie Powder"
	id = "zombiepowder"
	description = "A strong neurotoxin that puts the subject into a death-like state."
	reagent_state = SOLID
	color = "#669900" // rgb: 102, 153, 0
	toxpwr = 0.5

/datum/reagent/toxin/zombiepowder/on_mob_life(var/mob/living/carbon/M as mob)
	if(!M) M = holder.my_atom
	M.status_flags |= FAKEDEATH
	M.adjustOxyLoss(0.5*REM)
	M.Weaken(10)
	M.silent = max(M.silent, 10)
	M.tod = worldtime2text()
	..()
	return

/datum/reagent/toxin/zombiepowder/Destroy()
	if(holder && ismob(holder.my_atom))
		var/mob/M = holder.my_atom
		M.status_flags &= ~FAKEDEATH
	..()

//Reagents used for plant fertilizers.
/datum/reagent/toxin/fertilizer
	name = "fertilizer"
	id = "fertilizer"
	description = "A chemical mix good for growing plants with."
	reagent_state = LIQUID
	toxpwr = 0.2 //It's not THAT poisonous.
	color = "#664330" // rgb: 102, 67, 48

/datum/reagent/toxin/fertilizer/eznutrient
	name = "EZ Nutrient"
	id = "eznutrient"

/datum/reagent/toxin/fertilizer/left4zed
	name = "Left-4-Zed"
	id = "left4zed"

/datum/reagent/toxin/fertilizer/robustharvest
	name = "Robust Harvest"
	id = "robustharvest"

/datum/reagent/toxin/plantbgone
	name = "Plant-B-Gone"
	id = "plantbgone"
	description = "A harmful toxic mixture to kill plantlife. Do not ingest!"
	reagent_state = LIQUID
	color = "#49002E" // rgb: 73, 0, 46
	toxpwr = 1

	// Clear off wallrot fungi
/datum/reagent/toxin/plantbgone/reaction_turf(var/turf/T, var/volume)
	if(istype(T, /turf/simulated/wall))
		var/turf/simulated/wall/W = T
		if(W.rotting)
			W.rotting = 0
			for(var/obj/effect/E in W) if(E.name == "Wallrot") qdel(E)

			for(var/mob/O in viewers(W, null))
				O.show_message(text("\blue The fungi are completely dissolved by the solution!"), 1)

/datum/reagent/toxin/plantbgone/reaction_obj(var/obj/O, var/volume)
	if(istype(O,/obj/effect/alien/weeds/))
		var/obj/effect/alien/weeds/alien_weeds = O
		alien_weeds.health -= rand(15,35) // Kills alien weeds pretty fast
		alien_weeds.healthcheck()
	else if(istype(O,/obj/effect/plant))
		var/obj/effect/plant/plant = O
		plant.die_off()
	else if(istype(O,/obj/machinery/portable_atmospherics/hydroponics))
		var/obj/machinery/portable_atmospherics/hydroponics/tray = O

		if(tray.seed)
			tray.health -= rand(30,50)
			if(tray.pestlevel > 0)
				tray.pestlevel -= 2
			if(tray.weedlevel > 0)
				tray.weedlevel -= 3
			tray.toxins += 4
			tray.check_level_sanity()
			tray.update_icon()

/datum/reagent/toxin/plantbgone/reaction_mob(var/mob/living/M, var/method=TOUCH, var/volume)
	src = null
	if(iscarbon(M))
		var/mob/living/carbon/C = M
		if(!C.wear_mask) // If not wearing a mask
			C.adjustToxLoss(2) // 4 toxic damage per application, doubled for some reason
		if(ishuman(M))
			var/mob/living/carbon/human/H = M
			if(H.dna)
				if(H.species.flags & IS_PLANT) //plantmen take a LOT of damage
					H.adjustToxLoss(50)

/datum/reagent/toxin/acid/polyacid
	name = "Polytrinic acid"
	id = "pacid"
	description = "Polytrinic acid is a an extremely corrosive chemical substance."
	reagent_state = LIQUID
	color = "#8E18A9" // rgb: 142, 24, 169
	toxpwr = 2
	meltprob = 30

/datum/reagent/toxin/lexorin
	name = "Lexorin"
	id = "lexorin"
	description = "Lexorin temporarily stops respiration. Causes tissue damage."
	reagent_state = LIQUID
	color = "#C8A5DC" // rgb: 200, 165, 220
	toxpwr = 0
	overdose = REAGENTS_OVERDOSE

/datum/reagent/toxin/lexorin/on_mob_life(var/mob/living/M as mob)
	if(M.stat == 2.0)
		return
	if(!M) M = holder.my_atom
	if(prob(33))
		M.take_organ_damage(1*REM, 0)
	if(M.losebreath < 15)
		M.losebreath++
	..()
	return

/datum/reagent/toxin/mutagen
	name = "Unstable mutagen"
	id = "mutagen"
	description = "Might cause unpredictable mutations. Keep away from children."
	reagent_state = LIQUID
	color = "#13BC5E" // rgb: 19, 188, 94
	toxpwr = 0

/datum/reagent/toxin/mutagen/reaction_mob(var/mob/living/carbon/M, var/method=TOUCH, var/volume)
	if(!..())	return
	if(!istype(M) || !M.dna)	return  //No robots, AIs, aliens, Ians or other mobs should be affected by this.
	src = null
	if((method==TOUCH && prob(33)) || method==INGEST)
		randmuti(M)
		if(prob(98))	randmutb(M)
		else			randmutg(M)
		domutcheck(M, null)
		M.UpdateAppearance()
	return

/datum/reagent/toxin/mutagen/on_mob_life(var/mob/living/carbon/M)
	if(!istype(M))	return
	if(!M) M = holder.my_atom
	M.apply_effect(10,IRRADIATE,0)
	..()
	return

/datum/reagent/toxin/slimejelly
	name = "Slime Jelly"
	id = "slimejelly"
	description = "A gooey semi-liquid produced from one of the deadliest lifeforms in existence. SO REAL."
	reagent_state = LIQUID
	color = "#801E28" // rgb: 128, 30, 40
	toxpwr = 0

/datum/reagent/toxin/slimejelly/on_mob_life(var/mob/living/M as mob)
	if(prob(10))
		M << "\red Your insides are burning!"
		M.adjustToxLoss(rand(20,60)*REM)
	else if(prob(40))
		M.heal_organ_damage(5*REM,0)
	..()
	return

/datum/reagent/toxin/stoxin
	name = "Soporific"
	id = "stoxin"
	description = "An effective hypnotic used to treat insomnia."
	reagent_state = LIQUID
	color = "#009CA8" // rgb: 232, 149, 204
	toxpwr = 0
	custom_metabolism = 0.1
	overdose = REAGENTS_OVERDOSE

/datum/reagent/toxin/stoxin/on_mob_life(var/mob/living/M as mob)
	if(!M) M = holder.my_atom
	if(!data) data = 1
	switch(data)
		if(1 to 12)
			if(prob(5))	M.emote("yawn")
		if(12 to 15)
			M.eye_blurry = max(M.eye_blurry, 10)
		if(15 to 49)
			if(prob(50))
				M.Weaken(2)
			M.drowsyness = max(M.drowsyness, 20)
		if(50 to INFINITY)
			M.sleeping = max(M.sleeping, 20)
			M.drowsyness = max(M.drowsyness, 60)
	data++
	..()
	return

/datum/reagent/toxin/chloralhydrate
	name = "Chloral Hydrate"
	id = "chloralhydrate"
	description = "A powerful sedative."
	reagent_state = SOLID
	color = "#000067" // rgb: 0, 0, 103
	toxpwr = 1
	custom_metabolism = 0.1 //Default 0.2
	overdose = 15
	overdose_dam = 5

/datum/reagent/toxin/chloralhydrate/on_mob_life(var/mob/living/M as mob)
	if(!M) M = holder.my_atom
	if(!data) data = 1
	data++
	switch(data)
		if(1)
			M.confused += 2
			M.drowsyness += 2
		if(2 to 20)
			M.Weaken(30)
			M.eye_blurry = max(M.eye_blurry, 10)
		if(20 to INFINITY)
			M.sleeping = max(M.sleeping, 30)
	..()
	return

/datum/reagent/toxin/beer2	//disguised as normal beer for use by emagged brobots
	name = "Beer"
	id = "beer2"
	description = "An alcoholic beverage made from malted grains, hops, yeast, and water. The fermentation appears to be incomplete." //If the players manage to analyze this, they deserve to know something is wrong.
	reagent_state = LIQUID
	color = "#664300" // rgb: 102, 67, 0
	custom_metabolism = 0.15 // Sleep toxins should always be consumed pretty fast
	overdose = REAGENTS_OVERDOSE/2

	glass_icon_state = "beerglass"
	glass_name = "glass of beer"
	glass_desc = "A freezing pint of beer"
	glass_center_of_mass = list("x"=16, "y"=8)

/datum/reagent/toxin/beer2/on_mob_life(var/mob/living/M as mob)
	if(!M) M = holder.my_atom
	if(!data) data = 1
	switch(data)
		if(1)
			M.confused += 2
			M.drowsyness += 2
		if(2 to 50)
			M.sleeping += 1
		if(51 to INFINITY)
			M.sleeping += 1
			M.adjustToxLoss((data - 50)*REM)
	data++
	..()
	return

/datum/reagent/space_drugs
	name = "Space drugs"
	id = "space_drugs"
	description = "An illegal chemical compound used as drug."
	reagent_state = LIQUID
	color = "#60A584" // rgb: 96, 165, 132
	overdose = REAGENTS_OVERDOSE

/datum/reagent/space_drugs/on_mob_life(var/mob/living/M as mob)
	if(!M) M = holder.my_atom
	M.druggy = max(M.druggy, 15)
	if(isturf(M.loc) && !istype(M.loc, /turf/space))
		if(M.canmove && !M.restrained())
			if(prob(10)) step(M, pick(cardinal))
	if(prob(7)) M.emote(pick("twitch","drool","moan","giggle"))
	holder.remove_reagent(src.id, 0.5 * REAGENTS_METABOLISM)
	return

/datum/reagent/serotrotium
	name = "Serotrotium"
	id = "serotrotium"
	description = "A chemical compound that promotes concentrated production of the serotonin neurotransmitter in humans."
	reagent_state = LIQUID
	color = "#202040" // rgb: 20, 20, 40
	overdose = REAGENTS_OVERDOSE

/datum/reagent/serotrotium/on_mob_life(var/mob/living/M as mob)
	if(ishuman(M))
		if(prob(7)) M.emote(pick("twitch","drool","moan","gasp"))
		holder.remove_reagent(src.id, 0.25 * REAGENTS_METABOLISM)
	return

/datum/reagent/cryptobiolin
	name = "Cryptobiolin"
	id = "cryptobiolin"
	description = "Cryptobiolin causes confusion and dizzyness."
	reagent_state = LIQUID
	color = "#000055" // rgb: 200, 165, 220
	overdose = REAGENTS_OVERDOSE

/datum/reagent/cryptobiolin/on_mob_life(var/mob/living/M as mob)
	if(!M) M = holder.my_atom
	M.make_dizzy(1)
	if(!M.confused) M.confused = 1
	M.confused = max(M.confused, 20)
	holder.remove_reagent(src.id, 0.5 * REAGENTS_METABOLISM)
	..()
	return

/datum/reagent/impedrezene
	name = "Impedrezene"
	id = "impedrezene"
	description = "Impedrezene is a narcotic that impedes one's ability by slowing down the higher brain cell functions."
	reagent_state = LIQUID
	color = "#C8A5DC" // rgb: 200, 165, 220
	overdose = REAGENTS_OVERDOSE

/datum/reagent/impedrezene/on_mob_life(var/mob/living/M as mob)
	if(!M) M = holder.my_atom
	M.jitteriness = max(M.jitteriness-5,0)
	if(prob(80)) M.adjustBrainLoss(1*REM)
	if(prob(50)) M.drowsyness = max(M.drowsyness, 3)
	if(prob(10)) M.emote("drool")
	..()
	return

/datum/reagent/toxin/mindbreaker
	name = "Mindbreaker Toxin"
	id = "mindbreaker"
	description = "A powerful hallucinogen, it can cause fatal effects in users."
	reagent_state = LIQUID
	color = "#B31008" // rgb: 139, 166, 233
	toxpwr = 0
	custom_metabolism = 0.05
	overdose = REAGENTS_OVERDOSE

/datum/reagent/toxin/mindbreaker/on_mob_life(var/mob/living/M)
	if(!M) M = holder.my_atom
	M.hallucination += 10
	..()
	return

/datum/reagent/psilocybin
	name = "Psilocybin"
	id = "psilocybin"
	description = "A strong psycotropic derived from certain species of mushroom."
	color = "#E700E7" // rgb: 231, 0, 231
	overdose = REAGENTS_OVERDOSE

/datum/reagent/psilocybin/on_mob_life(var/mob/living/M as mob)
	if(!M) M = holder.my_atom
	M.druggy = max(M.druggy, 30)
	if(!data) data = 1
	switch(data)
		if(1 to 5)
			if (!M.stuttering) M.stuttering = 1
			M.make_dizzy(5)
			if(prob(10)) M.emote(pick("twitch","giggle"))
		if(5 to 10)
			if (!M.stuttering) M.stuttering = 1
			M.make_jittery(10)
			M.make_dizzy(10)
			M.druggy = max(M.druggy, 35)
			if(prob(20)) M.emote(pick("twitch","giggle"))
		if (10 to INFINITY)
			if (!M.stuttering) M.stuttering = 1
			M.make_jittery(20)
			M.make_dizzy(20)
			M.druggy = max(M.druggy, 40)
			if(prob(30)) M.emote(pick("twitch","giggle"))
	holder.remove_reagent(src.id, 0.2)
	data++
	..()
	return

/datum/reagent/nicotine
	name = "Nicotine"
	id = "nicotine"
	description = "A highly addictive stimulant extracted from the tobacco plant."
	reagent_state = LIQUID
	color = "#181818" // rgb: 24, 24, 24

/datum/reagent/slimetoxin
	name = "Mutation Toxin"
	id = "mutationtoxin"
	description = "A corruptive toxin produced by slimes."
	reagent_state = LIQUID
	color = "#13BC5E" // rgb: 19, 188, 94
	overdose = REAGENTS_OVERDOSE

/datum/reagent/slimetoxin/on_mob_life(var/mob/living/M as mob)
	if(!M) M = holder.my_atom
	if(ishuman(M))
		var/mob/living/carbon/human/human = M
		if(human.species.name != "Slime")
			M << "<span class='danger'>Your flesh rapidly mutates!</span>"
			human.set_species("Slime")
	..()
	return

/datum/reagent/aslimetoxin
	name = "Advanced Mutation Toxin"
	id = "amutationtoxin"
	description = "An advanced corruptive toxin produced by slimes."
	reagent_state = LIQUID
	color = "#13BC5E" // rgb: 19, 188, 94
	overdose = REAGENTS_OVERDOSE

/datum/reagent/aslimetoxin/on_mob_life(var/mob/living/M as mob)
	if(!M) M = holder.my_atom
	if(istype(M, /mob/living/carbon) && M.stat != DEAD)
		M << "\red Your flesh rapidly mutates!"
		if(M.monkeyizing)	return
		M.monkeyizing = 1
		M.canmove = 0
		M.icon = null
		M.overlays.Cut()
		M.invisibility = 101
		for(var/obj/item/W in M)
			if(istype(W, /obj/item/weapon/implant))	//TODO: Carn. give implants a dropped() or something
				qdel(W)
				continue
			W.layer = initial(W.layer)
			W.loc = M.loc
			W.dropped(M)
		var/mob/living/carbon/slime/new_mob = new /mob/living/carbon/slime(M.loc)
		new_mob.a_intent = I_HURT
		new_mob.universal_speak = 1
		if(M.mind)
			M.mind.transfer_to(new_mob)
		else
			new_mob.key = M.key
		qdel(M)
	..()
	return

/datum/reagent/nanites
	name = "Nanomachines"
	id = "nanites"
	description = "Microscopic construction robots."
	reagent_state = LIQUID
	color = "#535E66" // rgb: 83, 94, 102

/datum/reagent/nanites/reaction_mob(var/mob/M, var/method=TOUCH, var/volume)
	src = null
	if( (prob(10) && method==TOUCH) || method==INGEST)
		M.contract_disease(new /datum/disease/robotic_transformation(0),1)

/datum/reagent/xenomicrobes
	name = "Xenomicrobes"
	id = "xenomicrobes"
	description = "Microbes with an entirely alien cellular structure."
	reagent_state = LIQUID
	color = "#535E66" // rgb: 83, 94, 102

/datum/reagent/xenomicrobes/reaction_mob(var/mob/M, var/method=TOUCH, var/volume)
	src = null
	if( (prob(10) && method==TOUCH) || method==INGEST)
		M.contract_disease(new /datum/disease/xeno_transformation(0),1)
