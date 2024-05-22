/* Toxins, poisons, venoms */

/datum/reagent/toxin
	name = "toxin"
	description = "A toxic chemical."
	taste_description = "bitterness"
	taste_mult = 1.2
	reagent_state = LIQUID
	color = "#cf3600"
	metabolism = REM * 0.25 // 0.05 by default. They last a while and slowly kill you.
	heating_products = list(/datum/reagent/toxin/denatured)
	heating_point = 100 CELSIUS
	heating_message = "goes clear."
	value = 2
	should_admin_log = TRUE

	var/target_organ
	var/strength = 4 // How much damage it deals per unit

/datum/reagent/toxin/affect_blood(mob/living/carbon/M, removed)
	if(strength && !IS_METABOLICALLY_INERT(M))
		M.add_chemical_effect(CE_TOXIN, strength)
		var/dam = (strength * removed)
		if(target_organ && ishuman(M))
			var/mob/living/carbon/human/H = M
			var/obj/item/organ/internal/I = H.internal_organs_by_name[target_organ]
			if(I)
				var/can_damage = I.max_damage - I.damage
				if(can_damage > 0)
					if(dam > can_damage)
						I.take_internal_damage(can_damage, silent=TRUE)
						dam -= can_damage
					else
						I.take_internal_damage(dam, silent=TRUE)
						dam = 0
		if(dam)
			M.adjustToxLoss(target_organ ? (dam * 0.75) : dam)

/datum/reagent/toxin/denatured
	name = "denatured toxin"
	description = "Once toxic, now harmless."
	taste_description = null
	taste_mult = null
	color = "#808080"
	metabolism = REM
	heating_products = null
	heating_point = null

	target_organ = null
	strength = 0

/datum/reagent/toxin/plasticide
	name = "Plasticide"
	description = "Liquid plastic, do not eat."
	taste_description = "plastic"
	reagent_state = LIQUID
	color = "#cf3600"
	strength = 5
	heating_point = null
	heating_products = null

/datum/reagent/toxin/amatoxin // Delayed action poison, very dangerous but takes a while before doing anything.
	name = "Amatoxin"
	description = "A powerful poison derived from certain species of mushroom."
	taste_description = "mushroom"
	reagent_state = LIQUID
	metabolism = REM * 0.5
	color = "#792300"
	strength = 10

/datum/reagent/toxin/amatoxin/affect_blood(mob/living/carbon/M, removed)
	if (IS_METABOLICALLY_INERT(M))
		return
	M.reagents.add_reagent(/datum/reagent/toxin/amaspores, 2 * removed)

/datum/reagent/toxin/amaspores
	name = "Amaspores"
	description = "The secondary component to amatoxin poisoning, remaining dormant for a time before causing the victim to rapidly vomit blood from the mouth, causing massive blood loss."
	taste_description = "dusty dirt"
	reagent_state = LIQUID
	var/next_symptom = 10
	metabolism = REM
	color = "#330e00"
	strength = 30

/datum/reagent/toxin/amaspores/affect_blood(mob/living/carbon/M, removed)
	var/mob/living/carbon/human/target = M
	if (IS_METABOLICALLY_INERT(M))
		return

	if(M.chem_doses[/datum/reagent/toxin/amatoxin] > 0)
		M.reagents.add_reagent(/datum/reagent/toxin/amaspores, metabolism) // The spores lay dormant for as long as any traces of amatoxin remain
		next_symptom -= 1
		//completely reworks symptoms to be much less obvious and in your face, and not happen every single second.
		if(next_symptom == 0)
			//mimics symptoms of high exertion.
			if(prob(25))
				M.add_chemical_effect(CE_PULSE, 3)
			//mimics random pains that can easily be brushed off.
			if(prob(20))
				var/obj/item/organ/external/pained_limb = target.get_organ(pick(BP_CHEST))
				pained_limb.add_pain(10)
			//mimics symptoms of smoking.
			if(prob(25))
				to_chat(M, SPAN_NOTICE("You feel faintly sore in the throat."))
			next_symptom = 10
		return
	//this is the stage that kicks in faster, victim starts to rapidly vomit blood and the spores tear their chest open from the inside.
	M.add_chemical_effect(CE_SLOWDOWN, 1)
	next_symptom -= 1
	if(next_symptom < 1)
		var/obj/item/organ/external/organ = target.get_organ(BP_CHEST)
		organ.take_external_damage(rand(5,10), 0, EMPTY_BITFIELD, "Amaspore Growth")
		if(target.get_blood_volume() == 0)
			return
		target.remove_blood(rand(20,30))
		to_chat(M, SPAN_DANGER("You can taste blood in your mouth."))
		M.Stun(1)
		M.visible_message(SPAN_DANGER("\The [M] violently vomits blood!"))
		playsound(M.loc, 'sound/effects/splat.ogg', 50, 1)
		if(istype(M.loc, /turf/simulated))
			var/obj/decal/cleanable/blood/blood_vomit = new /obj/decal/cleanable/blood(M.loc)
			blood_vomit.update_icon()
		next_symptom = 5
	if (prob(15))
		M.Weaken(5)
		M.add_chemical_effect(CE_VOICELOSS, 5)
	if (prob(30))
		M.eye_blurry = max(M.eye_blurry, 10)



/datum/reagent/toxin/carpotoxin
	name = "Carpotoxin"
	description = "A deadly neurotoxin produced by the dreaded space carp."
	taste_description = "fish"
	reagent_state = LIQUID
	color = "#003333"

	target_organ = BP_BRAIN
	strength = 10

/datum/reagent/toxin/carpotoxin/affect_blood(mob/living/carbon/M, removed)
	if (IS_METABOLICALLY_INERT(M))
		return

	var/effectiveness = 1
	var/effective_dose = 2

	if(M.chem_doses[type] < effective_dose)
		effectiveness = M.chem_doses[type]/effective_dose
	else if(volume < effective_dose)
		effectiveness = volume/effective_dose
	M.add_chemical_effect(CE_BLOCKAGE, (80 * effectiveness)/100)

/datum/reagent/toxin/venom
	name = "Spider Venom"
	description = "A deadly necrotic toxin produced by giant spiders to disable their prey."
	taste_description = "absolutely vile"
	color = "#91d895"
	target_organ = BP_LIVER
	strength = 5

/datum/reagent/toxin/venom/affect_blood(mob/living/carbon/M, removed)
	if(prob(volume*2))
		M.set_confused(3)
	..()

/datum/reagent/toxin/cryotoxin
	name = "Cryotoxin"
	description = "A biological agent that rapidly lowers a victims bodytemperature, and persists for quite some time."
	taste_description = "mint"
	taste_mult = 1.5
	reagent_state = LIQUID
	metabolism = REM * 0.5
	color = "#b31008"

/datum/reagent/toxin/cryotoxin/affect_blood(mob/living/carbon/M, removed)
	if (IS_METABOLICALLY_INERT(M))
		return
	M.bodytemperature = max(M.bodytemperature - 15 * TEMPERATURE_DAMAGE_COEFFICIENT, 215)
	if (prob(15))
		to_chat(M, SPAN_DANGER("Your insides feel freezing cold!"))
	if (prob(1))
		M.emote("shiver")
	holder.remove_reagent("capsaicin", 5)

/datum/reagent/toxin/irritanttoxin
	name = "Irritant toxin"
	description = "A biological agent that acts similarly to pepperspray. This compound seems to be particularly cruel, however, capable of permeating the barriers of blood vessels."
	taste_description = "fire"
	color = "#b31008"
	target_organ = BP_KIDNEYS

/datum/reagent/toxin/irritanttoxin/affect_blood(mob/living/carbon/M, removed)
	if (IS_METABOLICALLY_INERT(M))
		return
	if (prob(50))
		M.adjustToxLoss(0.5 * removed)
	if (prob(50))
		M.custom_pain("You are getting unbearably hot!", 30)
		if (prob(10))
			to_chat(M, SPAN_DANGER("You feel like your insides are burning!"))
		else if (prob(20))
			M.visible_message(SPAN_WARNING("[M] [pick("dry heaves!","coughs!","splutters!","rubs at their eyes!")]"))
	else
		M.eye_blurry = max(M.eye_blurry, 10)

/datum/reagent/toxin/pyrotoxin
	name = "Pyrotoxin"
	description = "A biologically produced compound capable of melting steel or other metals, similarly to thermite."
	taste_description = "sweet chalk"
	reagent_state = SOLID
	color = "#673910"
	touch_met = 50

/datum/reagent/toxin/pyrotoxin/affect_blood(mob/living/carbon/M, removed)
	M.adjustFireLoss(3 * removed)
	if (M.fire_stacks <= 1.5)
		M.adjust_fire_stacks(0.15)
	if (IS_METABOLICALLY_INERT(M))
		return
	if (prob(10))
		to_chat(M, SPAN_WARNING("Your veins feel like they're on fire!"))
		M.adjust_fire_stacks(0.1)
	else if (prob(5))
		M.IgniteMob()
		M.visible_message(
			SPAN_WARNING("Some of \the [M]'s veins rupture, the exposed blood igniting!"),
			SPAN_DANGER("Some of your veins rupture, the exposed blood igniting!")
		)

/datum/reagent/toxin/serotrotium
	name = "Serotropic venom"
	description = "A chemical compound that promotes concentrated production of the serotonin neurotransmitter in humans. This appears to be a biologically produced form, resulting in a specifically toxic nature."
	taste_description = "chalky bitterness"
	target_organ = BP_KIDNEYS

/datum/reagent/toxin/serotrotium/affect_blood(mob/living/carbon/M, removed)
	if (IS_METABOLICALLY_INERT(M))
		return
	if(prob(30))
		if(prob(25))
			M.emote(pick("shiver", "blink_r"))
		M.adjustBrainLoss(0.2 * removed)
	return ..()

/datum/reagent/toxin/stimm	//Homemade Hyperzine
	name = "Stimm"
	description = "A homemade stimulant with some serious side-effects."
	taste_description = "sweetness"
	taste_mult = 1.8
	color = "#d0583a"
	metabolism = REM * 3
	overdose = 8
	strength = 3

/datum/reagent/toxin/stimm/affect_blood(mob/living/carbon/M, removed)
	..()
	if (prob(15))
		M.emote(pick("twitch", "blink_r", "shiver"))
	if (prob(15))
		M.visible_message(
			SPAN_WARNING("\The [M] shudders violently."),
			SPAN_WARNING("You shudder uncontrollably, it hurts.")
		)
		M.take_organ_damage(6 * removed, 0)
	M.add_chemical_effect(CE_SPEEDBOOST, 1)

/datum/reagent/toxin/stimm/overdose(mob/living/carbon/M)
	..()
	if (prob(10)) // 1 in 10. This thing's made with welder fuel and fertilizer, what do you expect?
		var/mob/living/carbon/human/H = M
		var/obj/item/organ/internal/heart/O = H.internal_organs_by_name[BP_HEART]
		O.take_internal_damage(1)
		to_chat(M, SPAN_WARNING("You feel a stabbing pain in your heart as it beats out of control!"))

/datum/reagent/toxin/chlorine
	name = "Chlorine"
	description = "A highly poisonous liquid. Smells strongly of bleach."
	reagent_state = LIQUID
	taste_description = "bleach"
	color = "#707c13"
	strength = 15
	metabolism = REM
	heating_point = null
	heating_products = null

/datum/reagent/toxin/phoron
	name = "Phoron"
	description = "Phoron in its liquid form."
	taste_mult = 1.5
	reagent_state = LIQUID
	color = "#ff3300"
	strength = 30
	touch_met = 5
	var/fire_mult = 5
	heating_point = null
	heating_products = null

/datum/reagent/toxin/phoron/touch_mob(mob/living/L, amount)
	if(istype(L))
		L.adjust_fire_stacks(amount / fire_mult)

/datum/reagent/toxin/phoron/affect_blood(mob/living/carbon/M, removed)
	if (HAS_TRAIT(M, /singleton/trait/general/serpentid_adapted))
		return
	..()

/datum/reagent/toxin/phoron/affect_touch(mob/living/carbon/M, removed)
	M.take_organ_damage(0, removed * 0.1) //being splashed directly with phoron causes minor chemical burns
	if(prob(10 * fire_mult))
		M.pl_effects()

/datum/reagent/toxin/phoron/touch_turf(turf/simulated/T)
	if(!istype(T))
		return
	T.assume_gas(GAS_PHORON, volume, T20C)
	remove_self(volume)

// Produced during deuterium synthesis. Super poisonous, SUPER flammable (doesn't need oxygen to burn).
/datum/reagent/toxin/phoron/oxygen
	name = "Oxyphoron"
	description = "An exceptionally flammable molecule formed from deuterium synthesis."
	strength = 15
	fire_mult = 15

/datum/reagent/toxin/phoron/oxygen/touch_turf(turf/simulated/T)
	if(!istype(T))
		return
	T.assume_gas(GAS_OXYGEN, ceil(volume/2), T20C)
	T.assume_gas(GAS_PHORON, ceil(volume/2), T20C)
	remove_self(volume)

/datum/reagent/toxin/cyanide //Fast and Lethal
	name = "Cyanide"
	description = "A highly toxic chemical."
	taste_mult = 0.6
	reagent_state = LIQUID
	color = "#cf3600"
	strength = 20
	metabolism = REM * 2
	target_organ = BP_HEART
	heating_point = null
	heating_products = null

/datum/reagent/toxin/cyanide/affect_blood(mob/living/carbon/M, removed)
	..()
	M.sleeping += 1

/datum/reagent/toxin/taxine
	name = "Taxine"
	description = "A potent cardiotoxin found in nearly every part of the common yew."
	taste_description = "intense bitterness"
	color = "#6b833b"
	strength = 16
	overdose = REAGENTS_OVERDOSE / 3
	metabolism = REM * 2
	target_organ = BP_HEART
	heating_point = null
	heating_products = null

/datum/reagent/toxin/taxine/affect_blood(mob/living/carbon/M, removed)
	..()
	M.mod_confused(2)

/datum/reagent/toxin/taxine/overdose(mob/living/carbon/M)
	..()
	if(ishuman(M))
		var/mob/living/carbon/human/H = M
		if(H.stat != UNCONSCIOUS)
			H.Weaken(8)
		M.add_chemical_effect(CE_NOPULSE, 1)

/datum/reagent/toxin/potassium_chloride
	name = "Potassium Chloride"
	description = "A delicious salt that stops the heart when injected into cardiac muscle."
	taste_description = "salt"
	reagent_state = SOLID
	color = "#ffffff"
	strength = 0
	overdose = REAGENTS_OVERDOSE
	heating_point = null
	heating_products = null

/datum/reagent/toxin/potassium_chloride/overdose(mob/living/carbon/M)
	..()
	if(ishuman(M))
		var/mob/living/carbon/human/H = M
		if(H.stat != 1)
			if(H.losebreath >= 10)
				H.losebreath = max(10, H.losebreath - 10)
			H.adjustOxyLoss(2)
			H.Weaken(10)
		M.add_chemical_effect(CE_NOPULSE, 1)


/datum/reagent/toxin/potassium_chlorophoride
	name = "Potassium Chlorophoride"
	description = "A specific chemical based on Potassium Chloride to stop the heart for surgery. Not safe to eat!"
	taste_description = "salt"
	reagent_state = SOLID
	color = "#ffffff"
	strength = 10
	overdose = 20
	heating_point = null
	heating_products = null

/datum/reagent/toxin/potassium_chlorophoride/affect_blood(mob/living/carbon/M, removed)
	..()
	if(ishuman(M))
		var/mob/living/carbon/human/H = M
		if(H.stat != UNCONSCIOUS)
			if(H.losebreath >= 10)
				H.losebreath = max(10, M.losebreath-10)
			H.adjustOxyLoss(2)
			H.Weaken(10)
		M.add_chemical_effect(CE_NOPULSE, 1)

/datum/reagent/toxin/zombiepowder
	name = "Zombie Powder"
	description = "A strong neurotoxin that puts the subject into a death-like state."
	taste_description = "death"
	reagent_state = SOLID
	color = "#669900"
	metabolism = REM
	strength = 0.1
	target_organ = BP_BRAIN
	heating_message = "melts into a liquid slurry."
	heating_products = list(/datum/reagent/toxin/carpotoxin, /datum/reagent/soporific, /datum/reagent/copper)

/datum/reagent/toxin/zombiepowder/affect_blood(mob/living/carbon/M, removed)
	..()
	if (IS_METABOLICALLY_INERT(M))
		return
	M.status_flags |= FAKEDEATH
	M.adjustOxyLoss(-5 * removed)
	M.Weaken(10)
	M.silent = max(M.silent, 10)
	if(M.chem_doses[type] <= removed) //half-assed attempt to make timeofdeath update only at the onset
		M.timeofdeath = world.time
	M.add_chemical_effect(CE_NOPULSE, 1)

/datum/reagent/toxin/zombiepowder/Destroy()
	if(holder && holder.my_atom && ismob(holder.my_atom))
		var/mob/M = holder.my_atom
		M.status_flags &= ~FAKEDEATH
		M.reagents.add_reagent(/datum/reagent/adrenaline, 5)
	. = ..()

/datum/reagent/toxin/fertilizer //Reagents used for plant fertilizers.
	name = "Fertilizer"
	description = "A chemical mix good for growing plants with."
	taste_description = "plant food"
	taste_mult = 0.5
	reagent_state = LIQUID
	strength = 0.5 // It's not THAT poisonous.
	color = "#664330"
	heating_point = null
	heating_products = null

/datum/reagent/toxin/fertilizer/eznutrient
	name = "EZ Nutrient"

/datum/reagent/toxin/fertilizer/left4zed
	name = "Left-4-Zed"

/datum/reagent/toxin/fertilizer/robustharvest
	name = "Robust Harvest"

/datum/reagent/toxin/fertilizer/potash
	name = "Potassium Nitrate"
	description = "Also known as Saltpetre. Useful as a fertilizer."
	taste_description = "sharp salt"
	reagent_state = SOLID
	color = "#c7beb9"
	value = 0.9

/datum/reagent/toxin/plantbgone
	name = "Plant-B-Gone"
	description = "A harmful toxic mixture to kill plantlife. Do not ingest!"
	taste_mult = 1
	reagent_state = LIQUID
	color = "#49002e"
	strength = 4
	heating_products = list(/datum/reagent/toxin, /datum/reagent/water)

/datum/reagent/toxin/plantbgone/touch_turf(turf/T)
	if(istype(T, /turf/simulated/wall))
		var/turf/simulated/wall/W = T
		if(locate(/obj/overlay/wallrot) in W)
			for(var/obj/overlay/wallrot/E in W)
				qdel(E)
			W.visible_message(SPAN_NOTICE("The fungi are completely dissolved by the solution!"))

/datum/reagent/toxin/plantbgone/touch_obj(obj/O, volume)
	if(istype(O, /obj/vine))
		qdel(O)

/datum/reagent/toxin/plantbgone/affect_blood(mob/living/carbon/M, removed)
	..()
	if (M.species.species_flags & SPECIES_FLAG_IS_PLANT)
		M.adjustToxLoss(50 * removed)

/datum/reagent/toxin/plantbgone/affect_touch(mob/living/carbon/M, removed)
	..()
	if (HAS_TRAIT(M, /singleton/trait/general/permeable_skin))
		M.adjustToxLoss(50 * removed)

/datum/reagent/acid/polyacid
	name = "Polytrinic acid"
	description = "Polytrinic acid is a an extremely corrosive chemical substance."
	taste_description = "acid"
	reagent_state = LIQUID
	color = "#8e18a9"
	power = 10
	meltdose = 4
	max_damage = 60

/datum/reagent/acid/stomach
	name = "stomach acid"
	taste_description = "coppery foulness"
	power = 2
	color = "#d8ff00"

/datum/reagent/lexorin
	name = "Lexorin"
	description = "Lexorin temporarily stops respiration. Causes tissue damage."
	taste_description = "acid"
	reagent_state = LIQUID
	color = "#c8a5dc"
	metabolism = REM * 0.5
	overdose = REAGENTS_OVERDOSE
	value = 2.4

/datum/reagent/lexorin/affect_blood(mob/living/carbon/M, removed)
	if (M.species.breath_type != GAS_OXYGEN || IS_METABOLICALLY_INERT(M))
		return

	var/permeability = GET_TRAIT_LEVEL(carbon, /singleton/trait/general/permeable_skin)
	M.take_organ_damage((10 - (2 * permeability)) * removed, 0, ORGAN_DAMAGE_FLESH_ONLY)
	if (prob(10))
		M.visible_message(
			SPAN_WARNING("\The [M]'s skin fizzles and flakes away!"),
			SPAN_DANGER("Your skin fizzles and flakes away!")
		)
	if(M.losebreath < (30 + (15 * permeability)))
		M.losebreath++
	M.adjustOxyLoss(15 * removed)

/datum/reagent/lexorin/affect_touch(mob/living/carbon/M, removed)
	if (M.species.breath_type != GAS_OXYGEN || HAS_TRAIT(M, /singleton/trait/general/nonpermeable_skin))
		return

	touch_met = volume // immediately permiates the skin, also avoids bugs with chemical duplication.

	// The warning messages should only display once per splash, all of the chemicals upon the skin should be absorbed in one tick.
	M.visible_message(
		SPAN_WARNING("\The [M]'s skin fizzles and flakes on contact with the liquid!"),
		SPAN_DANGER("You feel a painful fizzling and your skin begins to flake!.")
	)

	var/permeability = GET_TRAIT_LEVEL(carbon, /singleton/trait/general/permeable_skin)
	M.reagents.add_reagent(/datum/reagent/lexorin, (0.5 + (2.5 * permeability)) * removed)

/datum/reagent/mutagen
	name = "Unstable mutagen"
	description = "Might cause unpredictable mutations. Keep away from children."
	taste_description = "slime"
	taste_mult = 0.9
	reagent_state = LIQUID
	color = "#13bc5e"
	value = 3.1

/datum/reagent/mutagen/affect_touch(mob/living/carbon/M, removed)
	if(prob(33))
		affect_blood(M, removed)

/datum/reagent/mutagen/affect_ingest(mob/living/carbon/M, removed)
	if(prob(67))
		affect_blood(M, removed)

/datum/reagent/mutagen/affect_blood(mob/living/carbon/M, removed)

	if(M.isSynthetic())
		return

	var/mob/living/carbon/human/H = M
	if(istype(H) && (H.species.species_flags & SPECIES_FLAG_NO_SCAN))
		return

	if(M.dna)
		if(prob(removed * 0.1)) // Approx. one mutation per 10 injected/20 ingested/30 touching units
			randmuti(M)
			if(prob(98))
				randmutb(M)
			else
				randmutg(M)
			domutcheck(M, null)
			M.UpdateAppearance()
	M.apply_damage(10 * removed, DAMAGE_RADIATION, armor_pen = 100)

/datum/reagent/slimejelly
	name = "Slime Jelly"
	description = "A gooey semi-liquid produced from one of the deadliest lifeforms in existence. SO REAL."
	taste_description = "slime"
	taste_mult = 1.3
	reagent_state = LIQUID
	color = "#801e28"
	value = 1.2
	should_admin_log = TRUE

/datum/reagent/slimejelly/affect_blood(mob/living/carbon/M, removed)
	if (IS_METABOLICALLY_INERT(M))
		return
	if(prob(10))
		to_chat(M, SPAN_DANGER("Your insides are burning!"))
		M.adjustToxLoss(rand(100, 300) * removed)
	else if(prob(40))
		M.heal_organ_damage(25 * removed, 0)

/datum/reagent/soporific
	name = "Soporific"
	description = "An effective hypnotic used to treat insomnia."
	taste_description = "bitterness"
	reagent_state = LIQUID
	color = "#009ca8"
	metabolism = REM * 0.5
	overdose = REAGENTS_OVERDOSE
	value = 2.5
	scannable = TRUE
	should_admin_log = TRUE

/datum/reagent/soporific/affect_blood(mob/living/carbon/M, removed)
	if (IS_METABOLICALLY_INERT(M))
		return

	var/threshold = 1 + (0.2 * GET_TRAIT_LEVEL(M, /singleton/trait/boon/clear_mind))

	if(M.chem_doses[type] < 1 * threshold)
		if(M.chem_doses[type] == metabolism * 2 || prob(5))
			M.emote("yawn")
	else if(M.chem_doses[type] < 1.5 * threshold)
		M.eye_blurry = max(M.eye_blurry, 10)
	else if(M.chem_doses[type] < 5 * threshold)
		if(prob(50))
			M.Weaken(2)
			M.add_chemical_effect(CE_SEDATE, 1)
		M.drowsyness = max(M.drowsyness, 20)
	else
		M.sleeping = max(M.sleeping, 20)
		M.drowsyness = max(M.drowsyness, 60)
		M.add_chemical_effect(CE_SEDATE, 1)
	M.add_chemical_effect(CE_PULSE, -1)

/datum/reagent/chloralhydrate
	name = "Chloral Hydrate"
	description = "A powerful sedative."
	taste_description = "bitterness"
	reagent_state = SOLID
	color = "#000067"
	metabolism = REM * 0.5
	overdose = REAGENTS_OVERDOSE * 0.5
	value = 2.6
	should_admin_log = TRUE

/datum/reagent/chloralhydrate/affect_blood(mob/living/carbon/M, removed)
	if (IS_METABOLICALLY_INERT(M))
		return

	var/threshold = 1 + (0.2 * GET_TRAIT_LEVEL(M, /singleton/trait/boon/clear_mind))
	M.add_chemical_effect(CE_SEDATE, 1)

	if(M.chem_doses[type] <= metabolism * threshold)
		M.mod_confused(2)
		M.drowsyness += 2

	if(M.chem_doses[type] < 2 * threshold)
		M.Weaken(30)
		M.eye_blurry = max(M.eye_blurry, 10)
	else
		M.sleeping = max(M.sleeping, 30)

	if(M.chem_doses[type] > 1 * threshold)
		M.adjustToxLoss(removed)

/datum/reagent/chloralhydrate/beer //disguised as normal beer for use by emagged brobots
	name = "Beer"
	description = "An alcoholic beverage made from malted grains, hops, yeast, and water. The fermentation appears to be incomplete." //If the players manage to analyze this, they deserve to know something is wrong.
	taste_description = "shitty piss water"
	reagent_state = LIQUID
	color = "#ffd300"

	glass_name = "beer"
	glass_desc = "A freezing pint of beer"

/datum/reagent/vecuronium_bromide
	name = "Vecuronium Bromide"
	description = "A powerful paralytic."
	taste_description = "metallic"
	reagent_state = SOLID
	color = "#ff337d"
	metabolism = REM * 0.5
	overdose = REAGENTS_OVERDOSE * 0.5
	value = 2.6
	should_admin_log = TRUE

/datum/reagent/vecuronium_bromide/affect_blood(mob/living/carbon/M, removed)
	if (IS_METABOLICALLY_INERT(M))
		return

	var/threshold = 2 + (0.4 * GET_TRAIT_LEVEL(M, /singleton/trait/boon/clear_mind))

	if(M.chem_doses[type] >= metabolism * threshold * 0.5)
		M.set_confused(2)
		M.add_chemical_effect(CE_VOICELOSS, 1)
	if(M.chem_doses[type] > threshold * 0.5)
		M.make_dizzy(3)
		M.Weaken(2)
	if(M.chem_doses[type] == round(threshold * 0.5, metabolism))
		to_chat(M, SPAN_WARNING("Your muscles slacken and cease to obey you."))
	if(M.chem_doses[type] >= threshold)
		M.add_chemical_effect(CE_SEDATE, 1)
		M.eye_blurry = max(M.eye_blurry, 10)

	if(M.chem_doses[type] > 1 * threshold)
		M.adjustToxLoss(removed)

/datum/reagent/impedrezene // Impairs mental function correctly, takes an overwhelming dose to kill.
	name = "Impedrezene"
	description = "Impedrezene is a narcotic that impedes one's ability by slowing down the higher brain cell functions."
	taste_description = "numbness"
	reagent_state = LIQUID
	color = "#c8a5dc"
	overdose = REAGENTS_OVERDOSE
	value = 1.8

/datum/reagent/impedrezene/affect_blood(mob/living/carbon/M, removed)
	if (IS_METABOLICALLY_INERT(M))
		return

	M.jitteriness = max(M.jitteriness - 5, 0)
	M.add_chemical_effect(M.add_chemical_effect(CE_SLOWDOWN, 1))

	if(prob(80))
		M.set_confused(10)
	if(prob(50))
		M.drowsyness = max(M.drowsyness, 3)
	if(prob(10))
		M.emote("drool")
		M.apply_effect(EFFECT_STUTTER, 3)

	if (M.getBrainLoss() < 60)
		M.adjustBrainLoss(14 * removed)
	else
		M.adjustBrainLoss(7 * removed)

/* Drugs */

/datum/reagent/drugs
	name = "Parent drug reagent"
	description = "The parent reagent for all illegal drugs."
	taste_description = "something you should report to coders"
	taste_mult = 1.2
	color = "#f2f2f2"
	var/high_messages = TRUE
	var/list/high_message_list = list("You feel great! For now...", "You feel a wave of happiness!")
	var/list/sober_message_list = list("You feel like garbage...", "Your head aches.")
	var/last_message_time

	var/prob_proc = FALSE

	reagent_state = LIQUID
	metabolism = REM * 0.5
	ingest_met = REM * 1.5
	overdose = REAGENTS_OVERDOSE

/datum/reagent/drugs/affect_blood(mob/living/carbon/M, removed)
	if (IS_METABOLICALLY_INERT(M))
		return

	if(high_messages == TRUE)
		if(world.time > last_message_time + 30 SECONDS && volume > 0.5) /// Spam prevention.
			last_message_time = world.time
			var/msg = pick(high_message_list)
			to_chat(M, SPAN_DANGER("[msg]"))
		else if(volume <= 0.2 && data != -1)
			data = -1
			var/msg = pick(sober_message_list)
			to_chat(M, SPAN_DANGER("[msg]"))
	if(prob(5) && prob_proc == FALSE) /// Enables procs to activate, remains true until THAT PROC sets it to false again.
		prob_proc = TRUE


/datum/reagent/drugs/hextro
	name = "Hextromycosalinate"
	description = "Coloquially known as 'Hector', or by the name of 'Hex', This concoction is a \
	dizzying mix of psychedelics, hallucinogens and other reagents of both synthetic and organic sources. \
	With such broad and hardly traceable origins, its a common saying that each dose is unique in nature. \
	Its hazardous and erratic origin usually entails a great deal of mixed adverse side effects, but  \
	its cheap cost and potent hallucinations make it enticing for anyone willing to escape the real world \
	briefly, at the cost of severe addiction."
	taste_description = "bittersweetness"
	taste_mult = 0.4
	reagent_state = LIQUID
	color = "#60a584"
	metabolism = REM * 0.5
	value = 2.8
	should_admin_log = TRUE
	high_message_list = list("You feel so much more relaxed.",
	"You can't quite focus on anything.",
	"Colors around you seem much more intense.",
	"You could snack on something right now...",
	"You feel lightheaded and giggly.",
	"Everything seems so hilarious.",
	"You really could go for some takeout right now.",
	"You momentarily forget where you are.",
	"You have a mild urge to look over your shoulder.")
	sober_message_list = list("You feel the urge to just sit there and do nothing.",
	"Reality seems like a real pain in the ass to deal with right now.",
	"Things feel really colourless to you all of a sudden.",
	"You feel the urge to lie down and nap.")

/datum/reagent/drugs/hextro/affect_blood(mob/living/carbon/M, removed)
	if (IS_METABOLICALLY_INERT(M))
		return

	if(prob(5) && prob_proc == TRUE)
		M.apply_effect(3, EFFECT_STUTTER)
		M.emote("giggle")
		prob_proc = FALSE
	if(prob(10) && prob_proc == TRUE)
		M.adjust_nutrition(-10)
		prob_proc = FALSE

	M.add_chemical_effect(CE_PULSE, -1)

	..()

/datum/reagent/drugs/serotrotium
	name = "Serotrotium"
	description = "A chemical compound that promotes concentrated production of the serotonin neurotransmitter in humans."
	taste_description = "bitterness"
	reagent_state = LIQUID
	color = "#202040"
	metabolism = REM * 0.25
	value = 2.5
	high_message_list = list("Everything feels good, stable.", "You feel grounded.")
	sober_message_list = list("The stability is gone...", "Everything is much less stable.")

/datum/reagent/drugs/serotrotium/affect_blood(mob/living/carbon/M, removed)
	if (IS_METABOLICALLY_INERT(M))
		return FALSE
	if(prob(7))
		M.emote(pick("giggle", "laugh", "smile"))
	return ..()

/datum/reagent/drugs/cryptobiolin
	name = "Cryptobiolin"
	description = "A narcotic known to cause confusion and dizzyness."
	taste_description = "sourness"
	reagent_state = LIQUID
	color = "#000055"
	metabolism = REM * 0.5
	heating_point = 61 CELSIUS
	heating_products = list(/datum/reagent/potassium, /datum/reagent/acetone, /datum/reagent/sugar)
	value = 2
	high_message_list = list("The world distorts around you...!",
	"The walls look like they're moving...",
	"Nothing really makes sense right now.",
	"It feels like you've melded with the world around you...")
	sober_message_list = list("Everything feels... flat.", "You feel almost TOO grounded in your surroundings.")

/datum/reagent/drugs/cryptobiolin/affect_blood(mob/living/carbon/M, removed)
	if (IS_METABOLICALLY_INERT(M))
		return FALSE
	var/drug_strength = 4 - (0.8 * GET_TRAIT_LEVEL(M, /singleton/trait/boon/clear_mind))

	M.make_dizzy(drug_strength)
	M.set_confused(drug_strength * 5)
	..()

/datum/reagent/drugs/mindbreaker
	name = "Mindbreaker Toxin"
	description = "A powerful hallucinogen, it can cause fatal effects in users."
	taste_description = "sourness"
	reagent_state = LIQUID
	color = "#b31008"
	metabolism = REM * 0.25
	value = 0.6
	should_admin_log = TRUE
	high_message_list = list("You don't quite know what up or down is anymore...",
	"Colors just seem much more amazing.",
	"You feel incredibly confident. No one can stop you.",
	"You clench your jaw involuntarily.",
	"You feel... unsteady.",
	"You really feel like talking about your feelings!")
	sober_message_list = list("Everything feels a little more grounded.",
	"Colors seem... flatter.",
	"Everything feels a little dull, now.")

/datum/reagent/drugs/mindbreaker/affect_blood(mob/living/carbon/M, removed)
	if (IS_METABOLICALLY_INERT(M))
		return
	M.add_chemical_effect(CE_MIND, -2)

	var/hallucination_duration = 50 - (25 * GET_TRAIT_LEVEL(M, /singleton/trait/boon/clear_mind))
	var/hallucination_power = 50 - (20 * GET_TRAIT_LEVEL(M, /singleton/trait/boon/clear_mind))

	if (hallucination_duration && hallucination_power)
		M.hallucination(hallucination_duration, hallucination_power)
	..()

/datum/reagent/drugs/psilocybin
	name = "Psilocybin"
	description = "A strong psycotropic derived from certain species of mushroom."
	taste_description = "mushroom"
	color = "#e700e7"
	metabolism = REM * 0.5
	value = 0.7
	high_message_list = list("The world distorts around you...!",
	"The walls look like they're moving...",
	"Nothing really makes sense right now.",
	"It feels like you've melded with the world around you..."
	)
	sober_message_list = list("Everything feels... flat.", "You feel almost TOO grounded in your surroundings.")

/datum/reagent/drugs/psilocybin/affect_blood(mob/living/carbon/M, removed)
	if (IS_METABOLICALLY_INERT(M))
		return

	var/threshold = 1 + (0.2 * GET_TRAIT_LEVEL(M, /singleton/trait/boon/clear_mind))
	M.druggy = max(M.druggy, 30)

	if(M.chem_doses[type] < 1 * threshold)
		M.make_dizzy(5)
	else if(M.chem_doses[type] < 2 * threshold)
		M.apply_effect(3, EFFECT_STUTTER)
		M.make_jittery(5)
		M.make_dizzy(5)
		M.druggy = max(M.druggy, 35)
		if(prob(10))
			M.emote("giggle")
	else
		M.add_chemical_effect(CE_MIND, -1)
		M.apply_effect(3, EFFECT_STUTTER)
		M.make_jittery(10)
		M.make_dizzy(10)
		M.druggy = max(M.druggy, 40)
		if(prob(15))
			M.emote(pick("twitch", "giggle"))
	..()


/datum/reagent/drugs/three_eye
	name = "Three Eye"
	description = "Out on the edge of human space, at the limits of scientific understanding and \
	cultural taboo, people develop and dose themselves with substances that would curl the hair on \
	a brinker's vatgrown second head. Three Eye is one of the most notorious narcotics to ever come \
	out of the independant habitats, and has about as much in common with recreational drugs as a \
	Stok does with an Unathi strike trooper. It is equally effective on humans, Skrell, dionaea and \
	probably the Captain's cat, and distributing it will get you guaranteed jail time in every \
	human territory."
	taste_description = "liquid starlight"
	reagent_state = LIQUID
	color = "#ccccff"
	metabolism = REM
	overdose = 25
	should_admin_log = TRUE
	high_message_list = list(
		"Your name is called. It is your time.",
		"You are dissolving. Your hands are wax...",
		"It all runs together. It all mixes.",
		"It is done. It is over. You are done. You are over.",
		"You won't forget. Don't forget. Don't forget.",
		"Light seeps across the edges of your vision...",
		"Something slides and twitches within your sinus cavity...",
		"Your bowels roil. It waits within.",
		"Your gut churns. You are heavy with potential.",
		"Your heart flutters. It is winged and caged in your chest.",
		"There is a precious thing, behind your eyes.",
		"Everything is ending. Everything is beginning.",
		"Nothing ends. Nothing begins.",
		"Wake up. Please wake up.",
		"Stop it! You're hurting them!",
		"It's too soon for this. Please go back.",
		"We miss you. Where are you?",
		"Come back from there. Please."
	)
	var/static/list/overdose_messages = list(
		"THE SIGNAL THE SIGNAL THE SIGNAL THE SIGNAL",
		"IT CRIES IT CRIES IT WAITS IT CRIES",
		"NOT YOURS NOT YOURS NOT YOURS NOT YOURS",
		"THAT IS NOT FOR YOU",
		"IT RUNS IT RUNS IT RUNS IT RUNS",
		"THE BLOOD THE BLOOD THE BLOOD THE BLOOD",
		"THE LIGHT THE DARK A STAR IN CHAINS"
	)

/datum/reagent/drugs/three_eye/affect_blood(mob/living/carbon/M, removed)
	M.add_client_color(/datum/client_color/thirdeye)
	M.add_chemical_effect(CE_THIRDEYE, 1)
	M.add_chemical_effect(CE_MIND, -2)
	M.hallucination(50, 50)
	M.make_jittery(3)
	M.make_dizzy(3)
	if(prob(0.1) && ishuman(M))
		var/mob/living/carbon/human/H = M
		H.seizure()
		H.adjustBrainLoss(rand(8, 12))
	..()

/datum/reagent/drugs/three_eye/on_leaving_metabolism(mob/parent, metabolism_class)
	parent.remove_client_color(/datum/client_color/thirdeye)

/datum/reagent/drugs/three_eye/overdose(mob/living/carbon/M)
	..()
	M.adjustBrainLoss(rand(1, 5))
	if(ishuman(M) && prob(10))
		var/mob/living/carbon/human/H = M
		H.seizure()
	if(prob(10))
		to_chat(M, SPAN_DANGER(SPAN_SIZE(rand(2,4), pick(overdose_messages))))
	if(M.psi)
		M.psi.check_latency_trigger(30, "a Three Eye overdose")

/* Transformations */
/datum/reagent/slimetoxin
	name = "Mutation Toxin"
	description = "A corruptive toxin produced by slimes."
	taste_description = "sludge"
	reagent_state = LIQUID
	color = "#13bc5e"
	metabolism = REM * 0.2
	value = 2
	should_admin_log = TRUE

/datum/reagent/slimetoxin/affect_blood(mob/living/carbon/human/H, removed)
	if(!istype(H))
		return
	if(H.species.name == SPECIES_PROMETHEAN)
		return
	H.adjustToxLoss(40 * removed)
	if(H.chem_doses[type] < 1 || prob(30))
		return
	H.chem_doses[type] = 0
	var/list/meatchunks = list()
	for(var/limb_tag in list(BP_R_ARM, BP_L_ARM, BP_R_LEG,BP_L_LEG))
		var/obj/item/organ/external/E = H.get_organ(limb_tag)
		if(E && !E.is_stump() && !BP_IS_ROBOTIC(E) && E.species.name != SPECIES_PROMETHEAN)
			meatchunks += E
	if(!length(meatchunks))
		if(prob(10))
			to_chat(H, SPAN_DANGER("Your flesh rapidly mutates!"))
			H.set_species(SPECIES_PROMETHEAN)
			H.shapeshifter_set_colour("#05ff9b")
			H.verbs -= /mob/living/carbon/human/proc/shapeshifter_select_colour
		return
	var/obj/item/organ/external/O = pick(meatchunks)
	to_chat(H, SPAN_DANGER("Your [O.name]'s flesh mutates rapidly!"))
	if(!wrapped_species_by_ref["\ref[H]"])
		wrapped_species_by_ref["\ref[H]"] = H.species.name
	meatchunks = list(O) | O.children
	for(var/obj/item/organ/external/E in meatchunks)
		E.species = all_species[SPECIES_PROMETHEAN]
		E.skin_tone = null
		E.s_col = ReadRGB("#05ff9b")
		E.s_col_blend = ICON_ADD
		E.status &= ~ORGAN_BROKEN
		E.status |= ORGAN_MUTATED
		E.limb_flags &= ~ORGAN_FLAG_CAN_BREAK
		E.dislocated = -1
		E.max_damage = 5
		E.update_icon(1)
	O.max_damage = 15
	if(prob(10))
		to_chat(H, SPAN_DANGER("Your slimy [O.name] plops off!"))
		O.droplimb()
	H.update_body()

/datum/reagent/aslimetoxin
	name = "Advanced Mutation Toxin"
	description = "An advanced corruptive toxin produced by slimes."
	taste_description = "sludge"
	reagent_state = LIQUID
	color = "#13bc5e"

/datum/reagent/aslimetoxin/affect_blood(mob/living/carbon/M, removed) // TODO: check if there's similar code anywhere else
	if(HAS_TRANSFORMATION_MOVEMENT_HANDLER(M))
		return
	to_chat(M, SPAN_DANGER("Your flesh rapidly mutates!"))
	ADD_TRANSFORMATION_MOVEMENT_HANDLER(M)
	M.icon = null
	M.ClearOverlays()
	M.set_invisibility(INVISIBILITY_ABSTRACT)
	for(var/obj/item/W in M)
		if(istype(W, /obj/item/implant)) //TODO: Carn. give implants a dropped() or something
			qdel(W)
			continue
		M.drop_from_inventory(W)
	var/mob/living/carbon/slime/new_mob = new /mob/living/carbon/slime(M.loc)
	new_mob.a_intent = "hurt"
	new_mob.universal_speak = TRUE
	if(M.mind)
		M.mind.transfer_to(new_mob)
	else
		new_mob.key = M.key
	qdel(M)

/datum/reagent/nanites
	name = "Nanomachines"
	description = "Microscopic construction robots."
	taste_description = "slimey metal"
	reagent_state = LIQUID
	color = "#535e66"
	hidden_from_codex = TRUE
	value = 9

/datum/reagent/xenomicrobes
	name = "Xenomicrobes"
	description = "Microbes with an entirely alien cellular structure."
	taste_description = "sludge"
	reagent_state = LIQUID
	color = "#535e66"
	hidden_from_codex = TRUE
	heating_point = 100 CELSIUS
	value = 5

/datum/reagent/toxin/hair_remover
	name = "Hair Remover"
	description = "An extremely effective chemical depilator. Do not ingest."
	taste_description = "acid"
	reagent_state = LIQUID
	color = "#d9ffb3"
	strength = 1
	overdose = REAGENTS_OVERDOSE
	heating_products = null
	heating_point = null

/datum/reagent/toxin/hair_remover/affect_touch(mob/living/carbon/human/M, removed)
	if (!(M.species.appearance_flags & SPECIES_APPEARANCE_HAS_STATIC_HAIR))
		return
	M.species.set_default_hair(M)
	to_chat(M, SPAN_WARNING("You feel a chill and your skin feels lighter.."))
	remove_self(volume)

/datum/reagent/toxin/bromide
	name = "Bromide"
	description = "A dark, nearly opaque, red-orange, toxic element."
	taste_description = "pestkiller"
	reagent_state = LIQUID
	color = "#4c3b34"
	strength = 3
	heating_products = null
	heating_point = null

/datum/reagent/toxin/methyl_bromide
	name = "Methyl Bromide"
	description = "A fumigant derived from bromide."
	taste_description = "pestkiller"
	reagent_state = LIQUID
	color = "#4c3b34"
	strength = 5
	heating_products = null
	heating_point = null

/datum/reagent/toxin/methyl_bromide/affect_touch(mob/living/carbon/M, removed)
	if (!HAS_TRAIT(M, /singleton/trait/general/serpentid_adapted))
		return ..()

/datum/reagent/toxin/methyl_bromide/affect_ingest(mob/living/carbon/M, removed)
	if (!HAS_TRAIT(M, /singleton/trait/general/serpentid_adapted))
		return ..()

/datum/reagent/toxin/methyl_bromide/touch_turf(turf/simulated/T)
	if(istype(T))
		T.assume_gas(GAS_METHYL_BROMIDE, volume, T20C)
		remove_self(volume)

/datum/reagent/toxin/methyl_bromide/affect_blood(mob/living/carbon/M, removed)
	if (!HAS_TRAIT(M, /singleton/trait/general/serpentid_adapted))
		. = ..()
	if(istype(M))
		for(var/obj/item/organ/external/E in M.organs)
			if(LAZYLEN(E.implants))
				for(var/obj/spider/spider in E.implants)
					if(prob(25))
						E.implants -= spider
						M.visible_message(SPAN_NOTICE("The dying form of \a [spider] emerges from inside \the [M]'s [E.name]."))
						qdel(spider)
						break

/datum/reagent/toxin/tar
	name = "Tar"
	description = "A dark, viscous liquid."
	taste_description = "petroleum"
	color = "#140b30"
	strength = 4
	heating_products = list(/datum/reagent/acetone, /datum/reagent/carbon, /datum/reagent/ethanol)
	heating_point = 145 CELSIUS
	heating_message = "separates."

/datum/reagent/toxin/boron
	name = "Boron"
	description = "A chemical that is highly valued for its potential in fusion energy."
	taste_description = "metal"
	reagent_state = SOLID
	color = "#837e79"
	value = 4
	strength = 7
