/datum/reagent/nutriment
	name = "Nutriment"
	description = "All the vitamins, minerals, and carbohydrates the body needs in pure form."
	taste_mult = 4
	reagent_state = SOLID
	metabolism = REM * 4
	var/nutriment_factor = 10 // Per unit
	var/hydration_factor = 0 // Per unit
	var/injectable = 0
	color = "#664330"
	value = 0.1

/datum/reagent/nutriment/mix_data(var/list/newdata, var/newamount)

	if(!islist(newdata) || !newdata.len)
		return

	//add the new taste data
	LAZYINITLIST(data)
	for(var/taste in newdata)
		if(taste in data)
			data[taste] += newdata[taste]
		else
			data[taste] = newdata[taste]

	//cull all tastes below 10% of total
	var/totalFlavor = 0
	for(var/taste in data)
		totalFlavor += data[taste]
	if(!totalFlavor)
		return
	for(var/taste in data)
		if(data[taste]/totalFlavor < 0.1)
			data -= taste

/datum/reagent/nutriment/affect_blood(var/mob/living/carbon/M, var/alien, var/removed)
	if(!injectable)
		M.adjustToxLoss(0.2 * removed)
		return
	affect_ingest(M, alien, removed)

/datum/reagent/nutriment/affect_ingest(var/mob/living/carbon/M, var/alien, var/removed)
	if (alien == IS_SKRELL && protein_amount > 0)
		var/datum/species/skrell/S = M.species
		S.handle_protein(M, src)
	M.heal_organ_damage(0.5 * removed, 0) //what

	adjust_nutrition(M, alien, removed)
	M.add_chemical_effect(CE_BLOODRESTORE, 4 * removed)

/datum/reagent/nutriment/proc/adjust_nutrition(var/mob/living/carbon/M, var/alien, var/removed)
	var/nut_removed = removed
	var/hyd_removed = removed
	if(alien == IS_UNATHI)
		removed *= 0.1 // Unathi get most of their nutrition from meat.
	if(nutriment_factor)
		M.adjust_nutrition(nutriment_factor * nut_removed) // For hunger and fatness
	if(hydration_factor)
		M.adjust_hydration(hydration_factor * hyd_removed) // For thirst

/datum/reagent/nutriment/glucose
	name = "Glucose"
	color = "#ffffff"
	scannable = 1

	injectable = 1

/datum/reagent/nutriment/protein // Bad for Skrell!
	name = "Animal Protein"
	taste_description = "some sort of protein"
	color = "#440000"
	protein_amount = 1

/datum/reagent/nutriment/protein/adjust_nutrition(var/mob/living/carbon/M, var/alien, var/removed)
	switch(alien)
		if(IS_UNATHI) removed *= 2.25
		if(IS_SKRELL) return
	M.adjust_nutrition(nutriment_factor * removed)

/datum/reagent/nutriment/protein/egg // Also bad for skrell.
	name = "egg yolk"
	taste_description = "egg"
	color = "#ffffaa"

//vegetamarian alternative that is safe for skrell to ingest//rewired it from its intended nutriment/protein/egg/softtofu because it would not actually work, going with plan B, more recipes.

/datum/reagent/nutriment/softtofu
	name = "plant protein"
	description = "A gooey pale bean paste."
	taste_description = "healthy sadness"
	color = "#ffffff"

/datum/reagent/nutriment/honey
	name = "Honey"
	description = "A golden yellow syrup, loaded with sugary sweetness."
	taste_description = "sweetness"
	nutriment_factor = 10
	color = "#ffff00"

/datum/reagent/nutriment/honey/affect_ingest(var/mob/living/carbon/human/M, var/alien, var/removed)
	..()

	if(alien == IS_UNATHI)
		var/datum/species/unathi/S = M.species
		S.handle_sugar(M,src)

/datum/reagent/nutriment/flour
	name = "flour"
	description = "This is what you rub all over yourself to pretend to be a ghost."
	taste_description = "chalky wheat"
	reagent_state = SOLID
	nutriment_factor = 1
	color = "#ffffff"

/datum/reagent/nutriment/flour/touch_turf(var/turf/simulated/T)
	if(istype(T))
		new /obj/effect/decal/cleanable/flour(T)
		if(T.wet > 1)
			T.wet = min(T.wet, 1)
		else
			T.wet = 0

/datum/reagent/nutriment/batter
	name = "Batter"
	description = "A gooey mixture of eggs and flour, a base for turning wheat into food."
	taste_description = "blandness"
	reagent_state = LIQUID
	nutriment_factor = 3
	color = "#ffd592"
	protein_amount = 0.4

/datum/reagent/nutriment/batter/touch_turf(var/turf/simulated/T)
	if(!istype(T, /turf/space))
		new /obj/effect/decal/cleanable/pie_smudge(T)
		if(T.wet > 1)
			T.wet = min(T.wet, 1)
		else
			T.wet = 0

/datum/reagent/nutriment/batter/cakebatter
	name = "Cake Batter"
	description = "A gooey mixture of eggs, flour and sugar, a important precursor to cake!"
	taste_description = "sweetness"
	color = "#ffe992"
	protein_amount = 0.3

/datum/reagent/nutriment/coffee
	name = "Coffee Powder"
	description = "A bitter powder made by grinding coffee beans."
	taste_description = "bitterness"
	taste_mult = 1.3
	nutriment_factor = 1
	color = "#482000"

/datum/reagent/nutriment/coffee/instant
	name = "Instant Coffee Powder"
	description = "A bitter powder made by processing coffee beans."

/datum/reagent/nutriment/tea
	name = "Tea Powder"
	description = "A dark, tart powder made from black tea leaves."
	taste_description = "tartness"
	taste_mult = 1.3
	nutriment_factor = 1
	color = "#101000"

/datum/reagent/nutriment/tea/instant
	name = "Instant Tea Powder"

/datum/reagent/nutriment/coco
	name = "Coco Powder"
	description = "A fatty, bitter paste made from coco beans."
	taste_description = "bitterness"
	taste_mult = 1.3
	reagent_state = SOLID
	nutriment_factor = 5
	color = "#302000"

/datum/reagent/nutriment/instantjuice
	name = "Juice Powder"
	description = "Dehydrated, powdered juice of some kind."
	taste_mult = 1.3
	nutriment_factor = 1

/datum/reagent/nutriment/instantjuice/grape
	name = "Grape Juice Powder"
	description = "Dehydrated, powdered grape juice."
	taste_description = "dry grapes"
	color = "#863333"

/datum/reagent/nutriment/instantjuice/orange
	name = "Orange Juice Powder"
	description = "Dehydrated, powdered orange juice."
	taste_description = "dry oranges"
	color = "#e78108"

/datum/reagent/nutriment/instantjuice/watermelon
	name = "Watermelon Juice Powder"
	description = "Dehydrated, powdered watermelon juice."
	taste_description = "dry sweet watermelon"
	color = "#b83333"

/datum/reagent/nutriment/instantjuice/apple
	name = "Apple Juice Powder"
	description = "Dehydrated, powdered apple juice."
	taste_description = "dry sweet apples"
	color = "#c07c40"

/datum/reagent/nutriment/soysauce
	name = "Soysauce"
	description = "A salty sauce made from the soy plant."
	taste_description = "umami"
	taste_mult = 1.1
	reagent_state = LIQUID
	nutriment_factor = 2
	color = "#792300"

/datum/reagent/nutriment/ketchup
	name = "Ketchup"
	description = "Ketchup, catsup, whatever. It's tomato paste."
	taste_description = "ketchup"
	reagent_state = LIQUID
	nutriment_factor = 5
	color = "#731008"

/datum/reagent/nutriment/barbecue
	name = "Barbecue Sauce"
	description = "Barbecue sauce for barbecues and long shifts."
	taste_description = "barbecue"
	reagent_state = LIQUID
	nutriment_factor = 5
	color = "#4f330f"

/datum/reagent/nutriment/garlicsauce
	name = "Garlic Sauce"
	description = "Garlic sauce, perfect for spicing up a plate of garlic."
	taste_description = "garlic"
	reagent_state = LIQUID
	nutriment_factor = 4
	color = "#d8c045"

/datum/reagent/nutriment/rice
	name = "Rice"
	description = "Enjoy the great taste of nothing."
	taste_description = "rice"
	taste_mult = 0.4
	reagent_state = SOLID
	nutriment_factor = 1
	color = "#ffffff"

/datum/reagent/nutriment/rice/chazuke
	name = "Chazuke"
	description = "Green tea over rice. How rustic!"
	taste_description = "green tea and rice"
	taste_mult = 0.4
	reagent_state = LIQUID
	nutriment_factor = 1
	color = "#f1ffdb"

/datum/reagent/nutriment/cherryjelly
	name = "Cherry Jelly"
	description = "Totally the best. Only to be spread on foods with excellent lateral symmetry."
	taste_description = "cherry"
	taste_mult = 1.3
	reagent_state = LIQUID
	nutriment_factor = 1
	color = "#801e28"

/datum/reagent/nutriment/cornoil
	name = "Corn Oil"
	description = "An oil derived from various types of corn."
	taste_description = "slime"
	taste_mult = 0.1
	reagent_state = LIQUID
	nutriment_factor = 20
	color = "#302000"

/datum/reagent/nutriment/cornoil/touch_turf(var/turf/simulated/T)
	if(!istype(T))
		return

	var/hotspot = (locate(/obj/hotspot) in T)
	if(hotspot && !istype(T, /turf/space))
		var/datum/gas_mixture/lowertemp = T.remove_air(T:air:total_moles)
		lowertemp.temperature = max(min(lowertemp.temperature-2000, lowertemp.temperature / 2), 0)
		lowertemp.react()
		T.assume_air(lowertemp)
		qdel(hotspot)

	if(volume >= 3)
		T.wet_floor()

/datum/reagent/nutriment/sprinkles
	name = "Sprinkles"
	description = "Multi-colored little bits of sugar, commonly found on donuts. Loved by cops."
	taste_description = "childhood whimsy"
	nutriment_factor = 1
	color = "#ff00ff"

/datum/reagent/nutriment/mint
	name = "Mint"
	description = "Also known as Mentha."
	taste_description = "sweet mint"
	reagent_state = LIQUID
	color = "#07aab2"

/datum/reagent/lipozine // The anti-nutriment.
	name = "Lipozine"
	description = "A chemical compound that causes a powerful fat-burning reaction."
	taste_description = "mothballs"
	reagent_state = LIQUID
	color = "#bbeda4"
	overdose = REAGENTS_OVERDOSE
	value = 0.11

/datum/reagent/lipozine/affect_blood(var/mob/living/carbon/M, var/alien, var/removed)
	M.adjust_nutrition(-10)

/* Non-food stuff like condiments */

/datum/reagent/sodiumchloride
	name = "Table Salt"
	description = "A salt made of sodium chloride. Commonly used to season food."
	taste_description = "salt"
	reagent_state = SOLID
	color = "#ffffff"
	overdose = REAGENTS_OVERDOSE
	value = 0.11

/datum/reagent/blackpepper
	name = "Black Pepper"
	description = "A powder ground from peppercorns. *AAAACHOOO*"
	taste_description = "pepper"
	reagent_state = SOLID
	color = "#000000"
	value = 0.1

/datum/reagent/enzyme
	name = "Universal Enzyme"
	description = "A universal enzyme used in the preperation of certain chemicals and foods."
	taste_description = "sweetness"
	taste_mult = 0.7
	reagent_state = LIQUID
	color = "#365e30"
	overdose = REAGENTS_OVERDOSE
	value = 0.2

/datum/reagent/frostoil
	name = "Chilly Oil"
	description = "An oil harvested from a mutant form of chili peppers, it has a chilling effect on the body."
	taste_description = "arctic mint"
	taste_mult = 1.5
	reagent_state = LIQUID
	color = "#07aab2"
	value = 0.2

/datum/reagent/frostoil/affect_blood(var/mob/living/carbon/M, var/alien, var/removed)
	if(alien == IS_DIONA)
		return
	M.bodytemperature = max(M.bodytemperature - 10 * TEMPERATURE_DAMAGE_COEFFICIENT, 0)
	if(prob(1))
		M.emote("shiver")
	if(istype(M, /mob/living/carbon/slime))
		M.bodytemperature = max(M.bodytemperature - rand(10,20), 0)
	holder.remove_reagent(/datum/reagent/capsaicin, 5)

/datum/reagent/capsaicin
	name = "Capsaicin Oil"
	description = "This is what makes chilis hot."
	taste_description = "hot peppers"
	taste_mult = 1.5
	reagent_state = LIQUID
	color = "#b31008"
	var/agony_dose = 5
	var/agony_amount = 2
	var/discomfort_message = "<span class='danger'>Your insides feel uncomfortably hot!</span>"
	var/slime_temp_adj = 10
	value = 0.2

/datum/reagent/capsaicin/affect_blood(var/mob/living/carbon/M, var/alien, var/removed)
	if(alien == IS_DIONA)
		return
	M.adjustToxLoss(0.5 * removed)

/datum/reagent/capsaicin/affect_ingest(var/mob/living/carbon/M, var/alien, var/removed)
	if(alien == IS_DIONA || alien == IS_UNATHI)
		return
	if(ishuman(M))
		var/mob/living/carbon/human/H = M
		if(!H.can_feel_pain())
			return
	if(M.chem_doses[type] < agony_dose)
		if(prob(5) || M.chem_doses[type] == metabolism) //dose == metabolism is a very hacky way of forcing the message the first time this procs
			to_chat(M, discomfort_message)
	else
		M.apply_effect(agony_amount, EFFECT_PAIN, 0)
		if(prob(5))
			M.custom_emote(2, "[pick("dry heaves!","coughs!","splutters!")]")
			to_chat(M, "<span class='danger'>You feel like your insides are burning!</span>")
	if(istype(M, /mob/living/carbon/slime))
		M.bodytemperature += rand(0, 15) + slime_temp_adj
	holder.remove_reagent(/datum/reagent/frostoil, 5)

/datum/reagent/capsaicin/condensed
	name = "Condensed Capsaicin"
	description = "A chemical agent used for self-defense and in police work."
	taste_description = "scorching agony"
	taste_mult = 10
	reagent_state = LIQUID
	touch_met = 5 // Get rid of it quickly
	color = "#b31008"
	agony_dose = 0.5
	agony_amount = 4
	discomfort_message = "<span class='danger'>You feel like your insides are burning!</span>"
	slime_temp_adj = 15

/datum/reagent/capsaicin/condensed/affect_touch(var/mob/living/carbon/M, var/alien, var/removed)
	var/eyes_covered = 0
	var/mouth_covered = 0
	var/partial_mouth_covered = 0
	var/stun_probability = 50
	var/no_pain = 0
	var/obj/item/eye_protection = null
	var/obj/item/face_protection = null
	var/obj/item/partial_face_protection = null

	var/effective_strength = 5

	if(alien == IS_SKRELL)	//Larger eyes means bigger targets.
		effective_strength = 8

	var/list/protection
	if(istype(M, /mob/living/carbon/human))
		var/mob/living/carbon/human/H = M
		protection = list(H.head, H.glasses, H.wear_mask)
		if(!H.can_feel_pain())
			no_pain = 1 //TODO: living-level can_feel_pain() proc
	else
		protection = list(M.wear_mask)

	for(var/obj/item/I in protection)
		if(I)
			if(I.body_parts_covered & EYES)
				eyes_covered = 1
				eye_protection = I.name
			if((I.body_parts_covered & FACE) && !(I.item_flags & ITEM_FLAG_FLEXIBLEMATERIAL))
				mouth_covered = 1
				face_protection = I.name
			else if(I.body_parts_covered & FACE)
				partial_mouth_covered = 1
				partial_face_protection = I.name

	if(eyes_covered)
		if(!mouth_covered)
			to_chat(M, "<span class='warning'>Your [eye_protection] protects your eyes from the pepperspray!</span>")
	else
		to_chat(M, "<span class='warning'>The pepperspray gets in your eyes!</span>")
		M.confused += 2
		if(mouth_covered)
			M.eye_blurry = max(M.eye_blurry, effective_strength * 3)
			M.eye_blind = max(M.eye_blind, effective_strength)
		else
			M.eye_blurry = max(M.eye_blurry, effective_strength * 5)
			M.eye_blind = max(M.eye_blind, effective_strength * 2)

	if(mouth_covered)
		to_chat(M, "<span class='warning'>Your [face_protection] protects you from the pepperspray!</span>")
	else if(!no_pain)
		if(partial_mouth_covered)
			to_chat(M, "<span class='warning'>Your [partial_face_protection] partially protects you from the pepperspray!</span>")
			stun_probability *= 0.5
		to_chat(M, "<span class='danger'>Your face and throat burn!</span>")
		if(M.stunned > 0  && !M.lying)
			M.Weaken(4)
		if(prob(stun_probability))
			M.custom_emote(2, "[pick("coughs!","coughs hysterically!","splutters!")]")
			M.Stun(3)

/datum/reagent/capsaicin/condensed/affect_ingest(var/mob/living/carbon/M, var/alien, var/removed)
	if(ishuman(M))
		var/mob/living/carbon/human/H = M
		if(!H.can_feel_pain())
			return
	if(M.chem_doses[type] == metabolism)
		to_chat(M, "<span class='danger'>You feel like your insides are burning!</span>")
	else
		M.apply_effect(6, EFFECT_PAIN, 0)
		if(prob(5))
			to_chat(M, "<span class='danger'>You feel like your insides are burning!</span>")
			M.custom_emote(2, "[pick("coughs.","gags.","retches.")]")
			M.Stun(2)
	if(istype(M, /mob/living/carbon/slime))
		M.bodytemperature += rand(15, 30)
	holder.remove_reagent(/datum/reagent/frostoil, 5)

/datum/reagent/nutriment/vinegar
	name = "Vinegar"
	description = "A weak solution of acetic acid. Usually used for seasoning food."
	taste_description = "vinegar"
	reagent_state = LIQUID
	color = "#e8dfd0"
	taste_mult = 3

/datum/reagent/nutriment/mayo
	name = "Mayonnaise"
	description = "A mixture of egg yolk with lemon juice or vinegar. Usually put on bland food to make it more edible."
	taste_description = "mayo"
	reagent_state = LIQUID
	color = "#efede8"
	taste_mult = 2
	protein_amount = 0.7
