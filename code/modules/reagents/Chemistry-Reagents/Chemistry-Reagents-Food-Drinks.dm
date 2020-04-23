/* Food */

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

/datum/reagent/nutriment/protein/affect_ingest(var/mob/living/carbon/M, var/alien, var/removed)
	switch(alien)
		if(IS_SKRELL)
			M.adjustToxLoss(0.5 * removed)
			return
	..()

/datum/reagent/nutriment/protein/adjust_nutrition(var/mob/living/carbon/M, var/alien, var/removed)
	switch(alien)
		if(IS_UNATHI) removed *= 2.25
	M.adjust_nutrition(nutriment_factor * removed)

/datum/reagent/nutriment/protein/affect_blood(var/mob/living/carbon/M, var/alien, var/removed)
	if(alien && alien == IS_SKRELL)
		M.adjustToxLoss(2 * removed)
		return
	..()

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
	if(!istype(T, /turf/space))
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

	var/hotspot = (locate(/obj/fire) in T)
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
	if(alien == IS_DIONA)
		return
	if(ishuman(M))
		var/mob/living/carbon/human/H = M
		if(!H.can_feel_pain())
			return
	if(M.chem_doses[type] < agony_dose)
		if(prob(5) || M.chem_doses[type] == metabolism) //dose == metabolism is a very hacky way of forcing the message the first time this procs
			to_chat(M, discomfort_message)
	else
		M.apply_effect(agony_amount, PAIN, 0)
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
		M.apply_effect(6, PAIN, 0)
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

/* Drinks */

/datum/reagent/drink
	name = "Drink"
	description = "Uh, some kind of drink."
	reagent_state = LIQUID
	color = "#e78108"
	var/nutrition = 0 // Per unit
	var/hydration = 6 // Per unit
	var/adj_dizzy = 0 // Per tick
	var/adj_drowsy = 0
	var/adj_sleepy = 0
	var/adj_temp = 0
	value = 0.1

/datum/reagent/drink/affect_blood(var/mob/living/carbon/M, var/alien, var/removed)
	M.adjustToxLoss(removed) // Probably not a good idea; not very deadly though
	return

/datum/reagent/drink/affect_ingest(var/mob/living/carbon/M, var/alien, var/removed)
	if(nutrition)
		M.adjust_nutrition(nutrition * removed)
	if(hydration)
		M.adjust_hydration(hydration * removed)
	M.dizziness = max(0, M.dizziness + adj_dizzy)
	M.drowsyness = max(0, M.drowsyness + adj_drowsy)
	M.sleeping = max(0, M.sleeping + adj_sleepy)
	if(adj_temp > 0 && M.bodytemperature < 310) // 310 is the normal bodytemp. 310.055
		M.bodytemperature = min(310, M.bodytemperature + (adj_temp * TEMPERATURE_DAMAGE_COEFFICIENT))
	if(adj_temp < 0 && M.bodytemperature > 310)
		M.bodytemperature = min(310, M.bodytemperature - (adj_temp * TEMPERATURE_DAMAGE_COEFFICIENT))

// Juices
/datum/reagent/drink/juice/affect_ingest(var/mob/living/carbon/human/M, var/alien, var/removed)
	..()
	M.immunity = min(M.immunity + 0.25, M.immunity_norm*1.5)
	if(alien == IS_UNATHI)
		var/datum/species/unathi/S = M.species
		S.handle_sugar(M,src,0.5)

/datum/reagent/drink/juice/banana
	name = "Banana Juice"
	description = "The raw essence of a banana."
	taste_description = "banana"
	color = "#c3af00"

	glass_name = "banana juice"
	glass_desc = "The raw essence of a banana. HONK!"

/datum/reagent/drink/juice/berry
	name = "Berry Juice"
	description = "A delicious blend of several different kinds of berries."
	taste_description = "berries"
	color = "#990066"

	glass_name = "berry juice"
	glass_desc = "Berry juice. Or maybe it's jam. Who cares?"

/datum/reagent/drink/juice/carrot
	name = "Carrot juice"
	description = "It is just like a carrot but without crunching."
	taste_description = "carrots"
	color = "#ff8c00" // rgb: 255, 140, 0

	glass_name = "carrot juice"
	glass_desc = "It is just like a carrot but without crunching."

/datum/reagent/drink/juice/carrot/affect_ingest(var/mob/living/carbon/M, var/alien, var/removed)
	..()
	M.reagents.add_reagent(/datum/reagent/imidazoline, removed * 0.2)

/datum/reagent/drink/juice/grape
	name = "Grape Juice"
	description = "It's grrrrrape!"
	taste_description = "grapes"
	color = "#863333"

	glass_name = "grape juice"
	glass_desc = "It's grrrrrape!"

/datum/reagent/drink/juice/lemon
	name = "Lemon Juice"
	description = "This juice is VERY sour."
	taste_description = "sourness"
	taste_mult = 1.1
	color = "#afaf00"

	glass_name = "lemon juice"
	glass_desc = "Sour..."

/datum/reagent/drink/juice/lime
	name = "Lime Juice"
	description = "The sweet-sour juice of limes."
	taste_description = "unbearable sourness"
	taste_mult = 1.1
	color = "#365e30"

	glass_name = "lime juice"
	glass_desc = "A glass of sweet-sour lime juice"

/datum/reagent/drink/juice/lime/affect_ingest(var/mob/living/carbon/M, var/alien, var/removed)
	..()
	if(alien == IS_DIONA)
		return
	M.adjustToxLoss(-0.5 * removed)

/datum/reagent/drink/juice/orange
	name = "Orange juice"
	description = "Both delicious AND rich in Vitamin C, what more do you need?"
	taste_description = "oranges"
	color = "#e78108"

	glass_name = "orange juice"
	glass_desc = "Vitamins! Yay!"

/datum/reagent/drink/juice/orange/affect_ingest(var/mob/living/carbon/M, var/alien, var/removed)
	..()
	if(alien == IS_DIONA)
		return
	M.adjustOxyLoss(-2 * removed)

/datum/reagent/toxin/poisonberryjuice // It has more in common with toxins than drinks... but it's a juice
	name = "Poison Berry Juice"
	description = "A tasty juice blended from various kinds of very deadly and toxic berries."
	taste_description = "berries"
	color = "#863353"
	strength = 5

	glass_name = "poison berry juice"
	glass_desc = "A glass of deadly juice."

/datum/reagent/toxin/poisonberryjuice/affect_blood(var/mob/living/carbon/M, var/alien, var/removed)
	if(alien == IS_UNATHI)
		return //unathi are immune!
	return ..()

/datum/reagent/drink/juice/potato
	name = "Potato Juice"
	description = "Juice of the potato. Bleh."
	taste_description = "irish sadness and potatoes"
	nutrition = 2
	color = "#302000"

	glass_name = "potato juice"
	glass_desc = "Juice from a potato. Bleh."

/datum/reagent/drink/juice/garlic
	name = "Garlic Juice"
	description = "Who would even drink this?"
	taste_description = "bad breath"
	nutrition = 1
	color = "#eeddcc"

	glass_name = "garlic juice"
	glass_desc = "Who would even drink juice from garlic?"

/datum/reagent/drink/juice/onion
	name = "Onion Juice"
	description = "Juice from an onion, for when you need to cry."
	taste_description = "stinging tears"
	nutrition = 1
	color = "#ffeedd"

	glass_name = "onion juice"
	glass_desc = "Juice from an onion, for when you need to cry."

/datum/reagent/drink/juice/tomato
	name = "Tomato Juice"
	description = "Tomatoes made into juice. What a waste of big, juicy tomatoes, huh?"
	taste_description = "tomatoes"
	color = "#731008"

	glass_name = "tomato juice"
	glass_desc = "Are you sure this is tomato juice?"

/datum/reagent/drink/juice/tomato/affect_ingest(var/mob/living/carbon/M, var/alien, var/removed)
	..()
	if(alien == IS_DIONA)
		return
	M.heal_organ_damage(0, 0.5 * removed)

/datum/reagent/drink/juice/watermelon
	name = "Watermelon Juice"
	description = "Delicious juice made from watermelon."
	taste_description = "sweet watermelon"
	color = "#b83333"

	glass_name = "watermelon juice"
	glass_desc = "Delicious juice made from watermelon."

/datum/reagent/drink/juice/turnip
	name = "Turnip Juice"
	description = "Delicious (?) juice made from turnips."
	taste_description = "love of motherland and oppression"
	color = "#b1166e"

	glass_name = "turnip juice"
	glass_desc = "Delicious (?) juice made from turnips."


/datum/reagent/drink/juice/apple
	name = "Apple Juice"
	description = "Delicious sweet juice made from apples."
	taste_description = "sweet apples"
	color = "#c07c40"

	glass_name = "apple juice"
	glass_desc = "Delicious juice made from apples."

/datum/reagent/drink/juice/pear
	name = "Pear Juice"
	description = "Delicious sweet juice made from pears."
	taste_description = "sweet pears"
	color = "#ffff66"

	glass_name = "pear juice"
	glass_desc = "Delicious juice made from pears."

// Everything else

/datum/reagent/drink/milk
	name = "Milk"
	description = "An opaque white liquid produced by the mammary glands of mammals."
	taste_description = "milk"
	color = "#dfdfdf"

	glass_name = "milk"
	glass_desc = "White and nutritious goodness!"

/datum/reagent/drink/milk/chocolate
	name =  "Chocolate Milk"
	description = "A mixture of perfectly healthy milk and delicious chocolate."
	taste_description = "chocolate milk"
	color = "#74533b"

	glass_name = "chocolate milk"
	glass_desc = "Deliciously fattening!"

/datum/reagent/drink/milk/affect_ingest(var/mob/living/carbon/M, var/alien, var/removed)
	..()
	if(alien == IS_DIONA)
		return
	M.heal_organ_damage(0.5 * removed, 0)
	holder.remove_reagent(/datum/reagent/capsaicin, 10 * removed)

/datum/reagent/drink/milk/cream
	name = "Cream"
	description = "The fatty, still liquid part of milk. Why don't you mix this with sum scotch, eh?"
	taste_description = "creamy milk"
	color = "#dfd7af"

	glass_name = "cream"
	glass_desc = "Ewwww..."

/datum/reagent/drink/milk/soymilk
	name = "Soy Milk"
	description = "An opaque white liquid made from soybeans."
	taste_description = "soy milk"
	color = "#dfdfc7"

	glass_name = "soy milk"
	glass_desc = "White and nutritious soy goodness!"

/datum/reagent/drink/coffee
	name = "Coffee"
	description = "Coffee is a brewed drink prepared from roasted seeds, commonly called coffee beans, of the coffee plant."
	taste_description = "bitterness"
	taste_mult = 1.3
	color = "#482000"
	adj_dizzy = -5
	adj_drowsy = -3
	adj_sleepy = -2
	adj_temp = 25
	overdose = 60

	glass_name = "coffee"
	glass_desc = "Don't drop it, or you'll send scalding liquid and glass shards everywhere."

/datum/reagent/drink/coffee/affect_ingest(var/mob/living/carbon/M, var/alien, var/removed)
	if(alien == IS_DIONA)
		return
	..()

	if(adj_temp > 0)
		holder.remove_reagent(/datum/reagent/frostoil, 10 * removed)
	if(volume > 15)
		M.add_chemical_effect(CE_PULSE, 1)
	if(volume > 45)
		M.add_chemical_effect(CE_PULSE, 1)

/datum/reagent/nutriment/coffee/affect_blood(var/mob/living/carbon/M, var/alien, var/removed)
	..()
	M.add_chemical_effect(CE_PULSE, 2)

/datum/reagent/drink/coffee/overdose(var/mob/living/carbon/M, var/alien)
	if(alien == IS_DIONA)
		return
	M.make_jittery(5)
	M.add_chemical_effect(CE_PULSE, 1)

/datum/reagent/drink/coffee/icecoffee
	name = "Iced Coffee"
	description = "Coffee and ice, refreshing and cool."
	taste_description = "bitter coldness"
	color = "#102838"
	adj_temp = -5

	glass_name = "iced coffee"
	glass_desc = "A drink to perk you up and refresh you!"
	glass_special = list(DRINK_ICE)

/datum/reagent/drink/coffee/soy_latte
	name = "Soy Latte"
	description = "A nice and tasty beverage while you are reading your hippie books."
	taste_description = "bitter creamy coffee"
	color = "#c65905"
	adj_temp = 5

	glass_name = "soy latte"
	glass_desc = "A nice and refreshing beverage while you are reading your hippie books."

/datum/reagent/drink/coffee/soy_latte/affect_ingest(var/mob/living/carbon/M, var/alien, var/removed)
	..()
	M.heal_organ_damage(0.5 * removed, 0)

/datum/reagent/drink/coffee/icecoffee/soy_latte
	name = "Iced Soy Latte"
	description = "A nice and tasty beverage while you are reading your hippie books. This one's cold."
	taste_description = "cold bitter creamy coffee"
	color = "#c65905"

	glass_name = "iced soy latte"
	glass_desc = "A nice and refreshing beverage while you are reading your hippie books. This one's cold."

/datum/reagent/drink/coffee/icecoffee/soy_latte/affect_ingest(var/mob/living/carbon/M, var/alien, var/removed)
	..()
	M.heal_organ_damage(0.5 * removed, 0)

/datum/reagent/drink/coffee/cafe_latte
	name = "Cafe Latte"
	description = "A nice, strong and tasty beverage while you are reading."
	taste_description = "bitter creamy coffee"
	color = "#c65905"
	adj_temp = 5

	glass_name = "cafe latte"
	glass_desc = "A nice, strong and refreshing beverage while you are reading."

/datum/reagent/drink/coffee/cafe_latte/affect_ingest(var/mob/living/carbon/M, var/alien, var/removed)
	..()
	M.heal_organ_damage(0.5 * removed, 0)

/datum/reagent/drink/coffee/icecoffee/cafe_latte
	name = "Iced Cafe Latte"
	description = "A nice, strong and refreshing beverage while you are reading. This one's cold."
	taste_description = "cold bitter creamy coffee"
	color = "#c65905"

	glass_name = "iced cafe latte"
	glass_desc = "A nice, strong and refreshing beverage while you are reading. This one's cold."

/datum/reagent/drink/coffee/icecoffee/cafe_latte/affect_ingest(var/mob/living/carbon/M, var/alien, var/removed)
	..()
	M.heal_organ_damage(0.5 * removed, 0)

/datum/reagent/drink/coffee/cafe_latte/mocha
	name = "Mocha Latte"
	description = "Coffee and chocolate, smooth and creamy."
	taste_description = "bitter creamy chocolate"

	glass_name = "mocha latte"
	glass_desc = "Coffee and chocolate, smooth and creamy."

/datum/reagent/drink/coffee/soy_latte/mocha
	name = "Mocha Soy Latte"
	description = "Coffee, soy, and chocolate, smooth and creamy."
	taste_description = "bitter creamy chocolate"

	glass_name = "mocha soy latte"
	glass_desc = "Coffee, soy, and chocolate, smooth and creamy."

/datum/reagent/drink/coffee/icecoffee/cafe_latte/mocha
	name = "Iced Mocha Latte"
	description = "Coffee and chocolate, smooth and creamy. This one's cold."
	taste_description = "cold bitter creamy chocolate"

	glass_name = "iced mocha latte"
	glass_desc = "Coffee and chocolate, smooth and creamy. This one's cold."

/datum/reagent/drink/coffee/icecoffee/soy_latte/mocha
	name = "Iced Soy Mocha Latte"
	description = "Coffee, soy, and chocolate, smooth and creamy. This one's cold."
	taste_description = "cold bitter creamy chocolate"

	glass_name = "iced soy mocha latte"
	glass_desc = "Coffee, soy, and chocolate, smooth and creamy. This one's cold."

/datum/reagent/drink/coffee/cafe_latte/pumpkin
	name = "Pumpkin Spice Latte"
	description = "Smells and tastes like Autumn."
	taste_description = "bitter creamy pumpkin spice"

	glass_name = "pumpkin spice latte"
	glass_desc = "Smells and tastes like Autumn."

/datum/reagent/drink/coffee/soy_latte/pumpkin
	name = "Pumpkin Spice Soy Latte"
	description = "Smells and tastes like Autumn."
	taste_description = "bitter creamy pumpkin spice"

	glass_name = "pumpkin spice soy latte"
	glass_desc = "Smells and tastes like Autumn."

/datum/reagent/drink/coffee/icecoffee/cafe_latte/pumpkin
	name = "Iced Pumpkin Spice Latte"
	description = "Smells and tastes like Autumn. This one's cold"
	taste_description = "cold bitter creamy pumpkin spice"

	glass_name = "iced pumpkin spice latte"
	glass_desc = "Smells and tastes like Autumn. This one's cold."

/datum/reagent/drink/coffee/icecoffee/soy_latte/pumpkin
	name = "Iced Pumpkin Spice Soy Latte"
	description = "Smells and tastes like Autumn. This one's cold"
	taste_description = "cold bitter creamy pumpkin spice"

	glass_name = "iced pumpkin spice soy latte"
	glass_desc = "Smells and tastes like Autumn. This one's cold."

/datum/reagent/drink/hot_coco
	name = "Hot Chocolate"
	description = "Made with love! And cocoa beans."
	taste_description = "creamy chocolate"
	reagent_state = LIQUID
	color = "#403010"
	nutrition = 2
	adj_temp = 5

	glass_name = "hot chocolate"
	glass_desc = "Made with love! And cocoa beans."

/datum/reagent/drink/sodawater
	name = "Soda Water"
	description = "A can of club soda. Why not make a scotch and soda?"
	taste_description = "carbonated water"
	color = "#619494"
	adj_dizzy = -5
	adj_drowsy = -3
	adj_temp = -5

	glass_name = "soda water"
	glass_desc = "Soda water. Why not make a scotch and soda?"
	glass_special = list(DRINK_FIZZ)

/datum/reagent/drink/grapesoda
	name = "Grape Soda"
	description = "Grapes made into a fine drank."
	taste_description = "grape soda"
	color = "#421c52"
	adj_drowsy = -3

	glass_name = "grape soda"
	glass_desc = "Looks like a delicious drink!"
	glass_special = list(DRINK_FIZZ)

/datum/reagent/drink/tonic
	name = "Tonic Water"
	description = "It tastes strange but at least the quinine keeps the Space Malaria at bay."
	taste_description = "tart and fresh"
	color = "#619494"
	adj_dizzy = -5
	adj_drowsy = -3
	adj_sleepy = -2
	adj_temp = -5

	glass_name = "tonic water"
	glass_desc = "Quinine tastes funny, but at least it'll keep that Space Malaria away."

/datum/reagent/drink/lemonade
	name = "Lemonade"
	description = "Oh the nostalgia..."
	taste_description = "tartness"
	color = "#ffff00"
	adj_temp = -5

	glass_name = "lemonade"
	glass_desc = "Oh the nostalgia..."
	glass_special = list(DRINK_FIZZ)

/datum/reagent/drink/kiraspecial
	name = "Kira Special"
	description = "Long live the guy who everyone had mistaken for a girl. Baka!"
	taste_description = "fruity sweetness"
	color = "#cccc99"
	adj_temp = -5

	glass_name = "Kira Special"
	glass_desc = "Long live the guy who everyone had mistaken for a girl. Baka!"
	glass_special = list(DRINK_FIZZ)

/datum/reagent/drink/brownstar
	name = "Brown Star"
	description = "It's not what it sounds like..."
	taste_description = "orange and cola soda"
	color = "#9f3400"
	adj_temp = -2

	glass_name = "Brown Star"
	glass_desc = "It's not what it sounds like..."

/datum/reagent/drink/orange_cola
	name = "Fizzy Orange"
	description = "Artificial sugars and orange essence with fizz."
	taste_description = "orange"
	color = "#ffa500"
	adj_temp = -5

	glass_name = "Orange Soda"
	glass_desc = "A surprisingly tasty dye."
	glass_special = list(DRINK_FIZZ)

/datum/reagent/drink/rootbeer
	name = "Root WeiBeer"
	description = "Root beer, brewed from the rare beer root. And a lot of chemicals."
	taste_description = "faint toothpaste(?) and fizz"
	color = "#290e05"
	adj_temp = -5

	glass_name = "Root Beer"
	glass_desc = "Yep that sure is some rooty beer."
	glass_special = list(DRINK_FIZZ)

/datum/reagent/drink/apple_cola
	name = "Apple Soda"
	description = "Apple soda. Using only genuine genetically engineered apples. Engineered from bananas."
	taste_description = "fizzy apples!"
	color = "#ffe4a2"
	adj_temp = -5

	glass_name = "Apple Soda"
	glass_desc = "Disappointing cider."
	glass_special = list(DRINK_FIZZ)

/datum/reagent/drink/strawberry_soda
	name = "Strawberry Soda"
	description = "Soda using sweet berries."
	taste_description = "oddly bland"
	color = "#ff6a9b"
	adj_temp = -5

	glass_name = "Strawberry Soda"
	glass_desc = "Attractive and alliterative."
	glass_special = list(DRINK_FIZZ)

/datum/reagent/drink/porksoda
	name = "Pork Soda"
	description = "Soda made from straight up pork."
	taste_description = "pork"
	color = "#ff6a9b"
	adj_temp = -5

	glass_name = "Pork Soda"
	glass_desc = "I asked for a glass of PORT!"
	glass_special = list(DRINK_FIZZ)

/datum/reagent/drink/milkshake
	name = "Milkshake"
	description = "Glorious brainfreezing mixture."
	taste_description = "creamy vanilla"
	color = "#aee5e4"
	adj_temp = -9

	glass_name = "milkshake"
	glass_desc = "Glorious brainfreezing mixture."

/datum/reagent/milkshake/affect_ingest(var/mob/living/carbon/human/M, var/alien, var/removed)
	..()

	if(alien == IS_UNATHI)
		var/datum/species/unathi/S = M.species
		S.handle_sugar(M,src,0.5)

/datum/reagent/drink/rewriter
	name = "Rewriter"
	description = "The secret of the sanctuary of the Libarian..."
	taste_description = "a bad night out"
	color = "#485000"
	adj_temp = -5

	glass_name = "Rewriter"
	glass_desc = "The secret of the sanctuary of the Libarian..."

/datum/reagent/drink/rewriter/affect_ingest(var/mob/living/carbon/M, var/alien, var/removed)
	..()
	M.make_jittery(5)

/datum/reagent/drink/nuka_cola
	name = "Nuka Cola"
	description = "Cola, cola never changes."
	taste_description = "the future"
	color = "#100800"
	adj_temp = -5
	adj_sleepy = -2

	glass_name = "Nuka-Cola"
	glass_desc = "Don't cry, Don't raise your eye, It's only nuclear wasteland"
	glass_special = list(DRINK_FIZZ)

/datum/reagent/drink/nuka_cola/affect_ingest(var/mob/living/carbon/M, var/alien, var/removed)
	..()
	M.add_chemical_effect(CE_SPEEDBOOST, 1)
	M.make_jittery(20)
	M.druggy = max(M.druggy, 30)
	M.dizziness += 5
	M.drowsyness = 0

/datum/reagent/drink/grenadine
	name = "Grenadine Syrup"
	description = "Made in the modern day with proper pomegranate substitute. Who uses real fruit, anyways?"
	taste_description = "100% pure pomegranate"
	color = "#ff004f"

	glass_name = "grenadine syrup"
	glass_desc = "Sweet and tangy, a bar syrup used to add color or flavor to drinks."

/datum/reagent/drink/space_cola
	name = "Space Cola"
	description = "A refreshing beverage."
	taste_description = "cola"
	reagent_state = LIQUID
	color = "#100800"
	adj_drowsy = -3
	adj_temp = -5

	glass_name = "Space Cola"
	glass_desc = "A glass of refreshing Space Cola"
	glass_special = list(DRINK_FIZZ)

/datum/reagent/drink/spacemountainwind
	name = "Mountain Wind"
	description = "Blows right through you like a space wind."
	taste_description = "sweet citrus soda"
	color = "#102000"
	adj_drowsy = -7
	adj_sleepy = -1
	adj_temp = -5

	glass_name = "Space Mountain Wind"
	glass_desc = "Space Mountain Wind. As you know, there are no mountains in space, only wind."
	glass_special = list(DRINK_FIZZ)

/datum/reagent/drink/dr_gibb
	name = "Dr. Gibb"
	description = "A delicious blend of 42 different flavours"
	taste_description = "cherry soda"
	color = "#102000"
	adj_drowsy = -6
	adj_temp = -5

	glass_name = "Dr. Gibb"
	glass_desc = "Dr. Gibb. Not as dangerous as the name might imply."

/datum/reagent/drink/space_up
	name = "Space-Up"
	description = "Tastes like a hull breach in your mouth."
	taste_description = "a hull breach"
	color = "#202800"
	adj_temp = -8

	glass_name = "Space-up"
	glass_desc = "Space-up. It helps keep your cool."
	glass_special = list(DRINK_FIZZ)

/datum/reagent/drink/lemon_lime
	name = "Lemon Lime"
	description = "A tangy substance made of 0.5% natural citrus!"
	taste_description = "tangy lime and lemon soda"
	color = "#878f00"
	adj_temp = -8

	glass_name = "lemon lime soda"
	glass_desc = "A tangy substance made of 0.5% natural citrus!"
	glass_special = list(DRINK_FIZZ)

/datum/reagent/drink/doctor_delight
	name = "The Doctor's Delight"
	description = "A gulp a day keeps the MediBot away. That's probably for the best."
	taste_description = "homely fruit"
	reagent_state = LIQUID
	color = "#ff8cff"
	nutrition = 1

	glass_name = "The Doctor's Delight"
	glass_desc = "A healthy mixture of juices, guaranteed to keep you healthy until the next toolboxing takes place."

/datum/reagent/drink/doctor_delight/affect_ingest(var/mob/living/carbon/M, var/alien, var/removed)
	..()
	if(alien == IS_DIONA)
		return
	M.adjustOxyLoss(-4 * removed)
	M.heal_organ_damage(2 * removed, 2 * removed)
	M.adjustToxLoss(-2 * removed)
	if(M.dizziness)
		M.dizziness = max(0, M.dizziness - 15)
	if(M.confused)
		M.confused = max(0, M.confused - 5)

/datum/reagent/drink/dry_ramen
	name = "Dry Ramen"
	description = "Space age food, since August 25, 1958. Contains dried noodles, vegetables, and chemicals that boil in contact with water."
	taste_description = "dry and cheap noodles"
	reagent_state = SOLID
	nutrition = 1
	color = "#302000"

/datum/reagent/drink/hot_ramen
	name = "Hot Ramen"
	description = "The noodles are boiled, the flavors are artificial, just like being back in school."
	taste_description = "wet and cheap noodles"
	reagent_state = LIQUID
	color = "#302000"
	nutrition = 5
	adj_temp = 5

/datum/reagent/drink/hell_ramen
	name = "Hell Ramen"
	description = "The noodles are boiled, the flavors are artificial, just like being back in school."
	taste_description = "wet and cheap noodles on fire"
	reagent_state = LIQUID
	color = "#302000"
	nutrition = 5

/datum/reagent/drink/hell_ramen/affect_ingest(var/mob/living/carbon/M, var/alien, var/removed)
	..()
	if(alien == IS_DIONA)
		return
	M.bodytemperature += 10 * TEMPERATURE_DAMAGE_COEFFICIENT

/datum/reagent/drink/nothing
	name = "Nothing"
	description = "Absolutely nothing."
	taste_description = "nothing"

	glass_name = "nothing"
	glass_desc = "Absolutely nothing."

/* Alcohol */

// Basic

/datum/reagent/ethanol/absinthe
	name = "Absinthe"
	description = "Watch out that the Green Fairy doesn't come for you!"
	taste_description = "death and licorice"
	taste_mult = 1.5
	color = "#33ee00"
	strength = 12

	glass_name = "absinthe"
	glass_desc = "Wormwood, anise, oh my."

/datum/reagent/ethanol/ale
	name = "Ale"
	description = "A dark alchoholic beverage made by malted barley and yeast."
	taste_description = "hearty barley ale"
	color = "#4c3100"
	strength = 50

	glass_name = "ale"
	glass_desc = "A freezing container of delicious ale"

/datum/reagent/ethanol/beer
	name = "Beer"
	description = "An alcoholic beverage made from malted grains, hops, yeast, and water."
	taste_description = "piss water"
	color = "#ffd300"
	strength = 50
	nutriment_factor = 1

	glass_name = "beer"
	glass_desc = "A freezing container of beer"

/datum/reagent/ethanol/beer/good

	taste_description = "beer"

/datum/reagent/ethanol/beer/affect_ingest(var/mob/living/carbon/M, var/alien, var/removed)
	..()
	if(alien == IS_DIONA)
		return
	M.jitteriness = max(M.jitteriness - 3, 0)

/datum/reagent/ethanol/bluecuracao
	name = "Blue Curacao"
	description = "Exotically blue, fruity drink, distilled from oranges."
	taste_description = "oranges"
	taste_mult = 1.1
	color = "#0000cd"
	strength = 15

	glass_name = "blue curacao"
	glass_desc = "Exotically blue, fruity drink, distilled from oranges."

/datum/reagent/ethanol/cognac
	name = "Cognac"
	description = "A sweet and strongly alchoholic drink, made after numerous distillations and years of maturing. Classy as fornication."
	taste_description = "rich and smooth alcohol"
	taste_mult = 1.1
	color = "#ab3c05"
	strength = 15

	glass_name = "cognac"
	glass_desc = "Damn, you feel like some kind of French aristocrat just by holding this."

/datum/reagent/ethanol/deadrum
	name = "Deadrum"
	description = "Popular with the sailors. Not very popular with everyone else."
	taste_description = "salty sea water"
	color = "#ecb633"
	strength = 50

	glass_name = "rum"
	glass_desc = "Now you want to Pray for a pirate suit, don't you?"

/datum/reagent/ethanol/deadrum/affect_ingest(var/mob/living/carbon/M, var/alien, var/removed)
	..()
	if(alien == IS_DIONA)
		return
	M.dizziness +=5

/datum/reagent/ethanol/gin
	name = "Gin"
	description = "It's gin. In space. I say, good sir."
	taste_description = "an alcoholic christmas tree"
	color = "#bcf5ff"
	strength = 15
	alpha = 120

	glass_name = "gin"
	glass_desc = "A crystal clear glass of Griffeater gin."

//Base type for alchoholic drinks containing coffee
/datum/reagent/ethanol/coffee
	overdose = 45

/datum/reagent/ethanol/coffee/affect_ingest(var/mob/living/carbon/M, var/alien, var/removed)
	if(alien == IS_DIONA)
		return
	..()
	M.dizziness = max(0, M.dizziness - 5)
	M.drowsyness = max(0, M.drowsyness - 3)
	M.sleeping = max(0, M.sleeping - 2)
	if(M.bodytemperature > 310)
		M.bodytemperature = max(310, M.bodytemperature - (5 * TEMPERATURE_DAMAGE_COEFFICIENT))

/datum/reagent/ethanol/coffee/overdose(var/mob/living/carbon/M, var/alien)
	if(alien == IS_DIONA)
		return
	M.make_jittery(5)

/datum/reagent/ethanol/coffee/kahlua
	name = "Kahlua"
	description = "A widely known, Mexican coffee-flavoured liqueur. In production since 1936!"
	taste_description = "spiked latte"
	taste_mult = 1.1
	color = "#4c3100"
	strength = 15

	glass_name = "RR coffee liquor"
	glass_desc = "DAMN, THIS THING LOOKS ROBUST"

/datum/reagent/ethanol/melonliquor
	name = "Melon Liquor"
	description = "A relatively sweet and fruity 46 proof liquor."
	taste_description = "fruity alcohol"
	color = "#138808" // rgb: 19, 136, 8
	strength = 50

	glass_name = "melon liquor"
	glass_desc = "A relatively sweet and fruity 46 proof liquor."

/datum/reagent/ethanol/rum
	name = "Rum"
	description = "Yohoho and all that."
	taste_description = "spiked butterscotch"
	taste_mult = 1.1
	color = "#ecb633"
	strength = 15

	glass_name = "rum"
	glass_desc = "Now you want to Pray for a pirate suit, don't you?"

/datum/reagent/ethanol/sake
	name = "Sake"
	description = "Anime's favorite drink."
	taste_description = "dry alcohol"
	color = "#dddddd"
	strength = 25

	glass_name = "sake"
	glass_desc = "A glass of sake."

/datum/reagent/ethanol/tequilla
	name = "Tequila"
	description = "A strong and mildly flavoured, mexican produced spirit. Feeling thirsty hombre?"
	taste_description = "paint stripper"
	color = "#ffff91"
	strength = 25
	alpha = 120

	glass_name = "Tequilla"
	glass_desc = "Now all that's missing is the weird colored shades!"

/datum/reagent/ethanol/thirteenloko
	name = "Thirteen Loko"
	description = "A potent mixture of caffeine and alcohol."
	taste_description = "jitters and death"
	color = "#102000"
	strength = 25
	nutriment_factor = 1

	glass_name = "Thirteen Loko"
	glass_desc = "This is a glass of Thirteen Loko, it appears to be of the highest quality. The drink, not the glass."

/datum/reagent/ethanol/thirteenloko/affect_ingest(var/mob/living/carbon/M, var/alien, var/removed)
	..()
	if(alien == IS_DIONA)
		return
	M.drowsyness = max(0, M.drowsyness - 7)
	if (M.bodytemperature > 310)
		M.bodytemperature = max(310, M.bodytemperature - (5 * TEMPERATURE_DAMAGE_COEFFICIENT))
	M.make_jittery(5)
	M.add_chemical_effect(CE_PULSE, 2)

/datum/reagent/ethanol/vermouth
	name = "Vermouth"
	description = "You suddenly feel a craving for a martini..."
	taste_description = "dry alcohol"
	taste_mult = 1.3
	color = "#91ff91" // rgb: 145, 255, 145
	strength = 15

	glass_name = "vermouth"
	glass_desc = "You wonder why you're even drinking this straight."

/datum/reagent/ethanol/vodka
	name = "Vodka"
	description = "Number one drink AND fueling choice for Independents around the galaxy."
	taste_description = "grain alcohol"
	color = "#d5eaff" // rgb: 0, 100, 200
	strength = 15
	alpha = 120

	glass_name = "vodka"
	glass_desc = "The glass contain wodka. Xynta."

/datum/reagent/ethanol/vodka/premium
	name = "Premium Vodka"
	description = "Premium distilled vodka imported directly from the Gilgamesh Colonial Confederation."
	taste_description = "clear kvass"
	color = "#aaddff" // rgb: 170, 221, 255 - very light blue.
	strength = 10

/datum/reagent/ethanol/whiskey
	name = "Whiskey"
	description = "A superb and well-aged single-malt whiskey. Damn."
	taste_description = "molasses"
	color = "#4c3100"
	strength = 25

	glass_name = "whiskey"
	glass_desc = "The silky, smokey whiskey goodness inside the glass makes the drink look very classy."

/datum/reagent/ethanol/wine
	name = "Wine"
	description = "An premium alchoholic beverage made from distilled grape juice."
	taste_description = "bitter sweetness"
	color = "#7e4043" // rgb: 126, 64, 67
	strength = 15

	glass_name = "wine"
	glass_desc = "A very classy looking drink."

/datum/reagent/ethanol/wine/premium
	name = "White Wine"
	description = "An exceptionally expensive alchoholic beverage made from distilled white grapes."
	taste_description = "white velvet"
	color = "#ffddaa" // rgb: 255, 221, 170 - a light cream
	strength = 20

/datum/reagent/ethanol/herbal
	name = "Herbal Liquor"
	description = "A complex blend of herbs, spices and roots mingle in this old Earth classic."
	taste_description = "a sweet summer garden"
	color = "#dfff00"
	strength = 13

	glass_name = "herbal liquor"
	glass_desc = "It's definitely green. Or is it yellow?"

// Cocktails
/datum/reagent/ethanol/acid_spit
	name = "Acid Spit"
	description = "A drink for the daring, can be deadly if incorrectly prepared!"
	taste_description = "stomach acid"
	reagent_state = LIQUID
	color = "#365000"
	strength = 30

	glass_name = "Acid Spit"
	glass_desc = "A drink from the company archives. Made from live aliens."

/datum/reagent/ethanol/alliescocktail
	name = "Allies Cocktail"
	description = "A drink made from your allies, not as sweet as when made from your enemies."
	taste_description = "bitter yet free"
	color = "#d8ac45"
	strength = 25

	glass_name = "Allies cocktail"
	glass_desc = "A drink made from your allies."

/datum/reagent/ethanol/aloe
	name = "Aloe"
	description = "So very, very, very good."
	taste_description = "sweet 'n creamy"
	color = "#b7ea75"
	strength = 15

	glass_name = "Aloe"
	glass_desc = "Very, very, very good."

/datum/reagent/ethanol/amasec
	name = "Amasec"
	description = "Official drink of the Gun Club!"
	taste_description = "dark and metallic"
	reagent_state = LIQUID
	color = "#ff975d"
	strength = 25

	glass_name = "Amasec"
	glass_desc = "Always handy before COMBAT!!!"

/datum/reagent/ethanol/andalusia
	name = "Andalusia"
	description = "A nice, strangely named drink."
	taste_description = "lemons"
	color = "#f4ea4a"
	strength = 15

	glass_name = "Andalusia"
	glass_desc = "A nice, strange named drink."

/datum/reagent/ethanol/antifreeze
	name = "Anti-freeze"
	description = "Ultimate refreshment."
	taste_description = "Jack Frost's piss"
	color = "#56deea"
	strength = 12
	adj_temp = 20
	targ_temp = 330

	glass_name = "Anti-freeze"
	glass_desc = "The ultimate refreshment."

/datum/reagent/ethanol/atomicbomb
	name = "Atomic Bomb"
	description = "Nuclear proliferation never tasted so good."
	taste_description = "da bomb"
	reagent_state = LIQUID
	color = "#666300"
	strength = 10
	druggy = 50

	glass_name = "Atomic Bomb"
	glass_desc = "We cannot take legal responsibility for your actions after imbibing."

/datum/reagent/ethanol/coffee/b52
	name = "B-52"
	description = "Coffee, Irish Cream, and cognac. You will get bombed."
	taste_description = "angry and irish"
	taste_mult = 1.3
	color = "#997650"
	strength = 12

	glass_name = "B-52"
	glass_desc = "Kahlua, Irish cream, and congac. You will get bombed."

/datum/reagent/ethanol/bahama_mama
	name = "Bahama mama"
	description = "Tropical cocktail."
	taste_description = "lime and orange"
	color = "#ff7f3b"
	strength = 25

	glass_name = "Bahama Mama"
	glass_desc = "Tropical cocktail"

/datum/reagent/ethanol/bananahonk
	name = "Banana Mama"
	description = "A drink from Clown Heaven."
	taste_description = "a bad joke"
	nutriment_factor = 1
	color = "#ffff91"
	strength = 12

	glass_name = "Banana Honk"
	glass_desc = "A drink from Banana Heaven."

/datum/reagent/ethanol/barefoot
	name = "Barefoot"
	description = "Barefoot and pregnant"
	taste_description = "creamy berries"
	color = "#ffcdea"
	strength = 30

	glass_name = "Barefoot"
	glass_desc = "Barefoot and pregnant"

/datum/reagent/ethanol/beepsky_smash
	name = "Beepsky Smash"
	description = "Deny drinking this and prepare for THE LAW."
	taste_description = "JUSTICE"
	taste_mult = 2
	reagent_state = LIQUID
	color = "#404040"
	strength = 12

	glass_name = "Beepsky Smash"
	glass_desc = "Heavy, hot and strong. Just like the Iron fist of the LAW."

/datum/reagent/ethanol/beepsky_smash/affect_ingest(var/mob/living/carbon/M, var/alien, var/removed)
	..()
	M.Stun(2)

/datum/reagent/ethanol/bilk
	name = "Bilk"
	description = "This appears to be beer mixed with milk. Disgusting."
	taste_description = "desperation and lactate"
	color = "#895c4c"
	strength = 50
	nutriment_factor = 2

	glass_name = "bilk"
	glass_desc = "A brew of milk and beer. For those alcoholics who fear osteoporosis."

/datum/reagent/ethanol/black_russian
	name = "Black Russian"
	description = "For the lactose-intolerant. Still as classy as a White Russian."
	taste_description = "bitterness"
	color = "#360000"
	strength = 15

	glass_name = "Black Russian"
	glass_desc = "For the lactose-intolerant. Still as classy as a White Russian."

/datum/reagent/ethanol/bloody_mary
	name = "Bloody Mary"
	description = "A strange yet pleasurable mixture made of vodka, tomato and lime juice. Or at least you THINK the red stuff is tomato juice."
	taste_description = "tomatoes with a hint of lime"
	color = "#b40000"
	strength = 15

	glass_name = "Bloody Mary"
	glass_desc = "Tomato juice, mixed with Vodka and a lil' bit of lime. Tastes like liquid murder."

/datum/reagent/ethanol/booger
	name = "Booger"
	description = "Ewww..."
	taste_description = "sweet 'n creamy"
	color = "#8cff8c"
	strength = 30

	glass_name = "Booger"
	glass_desc = "Ewww..."

/datum/reagent/ethanol/coffee/brave_bull
	name = "Brave Bull"
	description = "It's just as effective as Dutch-Courage!"
	taste_description = "alcoholic bravery"
	taste_mult = 1.1
	color = "#4c3100"
	strength = 15

	glass_name = "Brave Bull"
	glass_desc = "Tequilla and coffee liquor, brought together in a mouthwatering mixture. Drink up."

/datum/reagent/ethanol/changelingsting
	name = "Changeling Sting"
	description = "You take a tiny sip and feel a burning sensation..."
	taste_description = "your brain coming out your nose"
	color = "#2e6671"
	strength = 10

	glass_name = "Changeling Sting"
	glass_desc = "A stingy drink."

/datum/reagent/ethanol/martini
	name = "Classic Martini"
	description = "Vermouth with Gin. Not quite how 007 enjoyed it, but still delicious."
	taste_description = "dry class"
	color = "#bff5ee"
	strength = 25

	glass_name = "classic martini"
	glass_desc = "Damn, the bartender even stirred it, not shook it."

/datum/reagent/ethanol/cuba_libre
	name = "Cuba Libre"
	description = "Rum, mixed with cola. Viva la revolucion."
	taste_description = "cola"
	color = "#3e1b00"
	strength = 30

	glass_name = "Cuba Libre"
	glass_desc = "A classic mix of rum and cola."

/datum/reagent/ethanol/demonsblood
	name = "Demons Blood"
	description = "AHHHH!!!!"
	taste_description = "sweet tasting iron"
	taste_mult = 1.5
	color = "#820000"
	strength = 15

	glass_name = "Demons' Blood"
	glass_desc = "Just looking at this thing makes the hair at the back of your neck stand up."

/datum/reagent/ethanol/devilskiss
	name = "Devils Kiss"
	description = "Creepy time!"
	taste_description = "bitter iron"
	color = "#a68310"
	strength = 15

	glass_name = "Devil's Kiss"
	glass_desc = "Creepy time!"

/datum/reagent/ethanol/driestmartini
	name = "Driest Martini"
	description = "Only for the experienced. You think you see sand floating in the glass."
	taste_description = "a beach"
	nutriment_factor = 1
	color = "#2e6671"
	strength = 12

	glass_name = "Driest Martini"
	glass_desc = "Only for the experienced. You think you see sand floating in the glass."

/datum/reagent/ethanol/ginfizz
	name = "Gin Fizz"
	description = "Refreshingly lemony, deliciously dry."
	taste_description = "dry, tart lemons"
	color = "#ffffae"
	strength = 30

	glass_name = "gin fizz"
	glass_desc = "Refreshingly lemony, deliciously dry."

/datum/reagent/ethanol/grog
	name = "Grog"
	description = "Watered-down rum, pirate approved!"
	taste_description = "a poor excuse for alcohol"
	reagent_state = LIQUID
	color = "#ffbb00"
	strength = 100

	glass_name = "grog"
	glass_desc = "A fine and cepa drink for Space."

/datum/reagent/ethanol/erikasurprise
	name = "Erika Surprise"
	description = "The surprise is, it's green!"
	taste_description = "tartness and bananas"
	color = "#2e6671"
	strength = 15

	glass_name = "Erika Surprise"
	glass_desc = "The surprise is, it's green!"

/datum/reagent/ethanol/gargle_blaster
	name = "Pan-Galactic Gargle Blaster"
	description = "Whoah, this stuff looks volatile!"
	taste_description = "your brains smashed out by a lemon wrapped around a gold brick"
	taste_mult = 5
	reagent_state = LIQUID
	color = "#7f00ff"
	strength = 10

	glass_name = "Pan-Galactic Gargle Blaster"
	glass_desc = "Does... does this mean that Arthur and Ford are here? Oh joy."

/datum/reagent/ethanol/gintonic
	name = "Gin and Tonic"
	description = "An all time classic, mild cocktail."
	taste_description = "mild tartness" //???
	color = "#bef3f3"
	strength = 50

	glass_name = "gin and tonic"
	glass_desc = "A mild but still great cocktail. Drink up, like a true Englishman."

/datum/reagent/ethanol/goldschlager
	name = "Goldschlager"
	description = "100 proof cinnamon schnapps, made for alcoholic teen girls on spring break."
	taste_description = "burning cinnamon"
	taste_mult = 1.3
	color = "#f4e46d"
	strength = 15

	glass_name = "Goldschlager"
	glass_desc = "100 proof that teen girls will drink anything with gold in it."

/datum/reagent/ethanol/hippies_delight
	name = "Hippies' Delight"
	description = "You just don't get it maaaan."
	taste_description = "giving peace a chance"
	reagent_state = LIQUID
	color = "#ff88ff"
	strength = 15
	druggy = 50

	glass_name = "Hippie's Delight"
	glass_desc = "A drink enjoyed by people during the 1960's."

/datum/reagent/ethanol/hooch
	name = "Hooch"
	description = "Either someone's failure at cocktail making or attempt in alchohol production. In any case, do you really want to drink that?"
	taste_description = "pure resignation"
	color = "#4c3100"
	strength = 25
	toxicity = 2

	glass_name = "Hooch"
	glass_desc = "You've really hit rock bottom now... your liver packed its bags and left last night."

/datum/reagent/ethanol/iced_beer
	name = "Iced Beer"
	description = "A beer which is so cold the air around it freezes."
	taste_description = "refreshingly cold"
	color = "#ffd300"
	strength = 50
	adj_temp = -20
	targ_temp = 270

	glass_name = "iced beer"
	glass_desc = "A beer so frosty, the air around it freezes."
	glass_special = list(DRINK_ICE)

/datum/reagent/ethanol/irishslammer
	name = "Irish Slammer"
	description = "Mmm, tastes like chocolate cake..."
	taste_description = "delicious anger"
	color = "#2e6671"
	strength = 15

	glass_name = "Irish slammer"
	glass_desc = "An Irish slammer, mixed with cream, whiskey, and ale."

/datum/reagent/ethanol/coffee/irishcoffee
	name = "Irish Coffee"
	description = "Coffee, and alcohol. More fun than a Mimosa to drink in the morning."
	taste_description = "giving up on the day"
	color = "#4c3100"
	strength = 15

	glass_name = "Irish coffee"
	glass_desc = "Coffee and alcohol. More fun than a Mimosa to drink in the morning."

/datum/reagent/ethanol/irish_cream
	name = "Irish Cream"
	description = "Whiskey-imbued cream, what else would you expect from the Irish."
	taste_description = "creamy alcohol"
	color = "#dddd9a"
	strength = 25

	glass_name = "Irish cream"
	glass_desc = "It's cream, mixed with whiskey. What else would you expect from the Irish?"

/datum/reagent/ethanol/longislandicedtea
	name = "Long Island Iced Tea"
	description = "The liquor cabinet, brought together in a delicious mix. Intended for middle-aged alcoholic women only."
	taste_description = "a mixture of cola and alcohol"
	color = "#895b1f"
	strength = 12

	glass_name = "Long Island iced tea"
	glass_desc = "The liquor cabinet, brought together in a delicious mix. Intended for middle-aged alcoholic women only."

/datum/reagent/ethanol/manhattan
	name = "Manhattan"
	description = "The Detective's undercover drink of choice. He never could stomach gin..."
	taste_description = "mild dryness"
	color = "#c13600"
	strength = 15

	glass_name = "Manhattan"
	glass_desc = "The Detective's undercover drink of choice. He never could stomach gin..."

/datum/reagent/ethanol/manhattan_proj
	name = "Manhattan Project"
	description = "A scientist's drink of choice, for pondering ways to blow stuff up."
	taste_description = "death, the destroyer of worlds"
	color = "#c15d00"
	strength = 10
	druggy = 30

	glass_name = "Manhattan Project"
	glass_desc = "A scientist's drink of choice, for pondering ways to blow stuff up."

/datum/reagent/ethanol/manly_dorf
	name = "The Manly Dorf"
	description = "Beer and Ale, brought together in a delicious mix. Intended for true men only."
	taste_description = "hair on your chest and your chin"
	color = "#4c3100"
	strength = 25

	glass_name = "The Manly Dorf"
	glass_desc = "A manly concotion made from Ale and Beer. Intended for true men only."

/datum/reagent/ethanol/margarita
	name = "Margarita"
	description = "On the rocks with salt on the rim. Arriba~!"
	taste_description = "dry and salty"
	color = "#8cff8c"
	strength = 15

	glass_name = "margarita"
	glass_desc = "On the rocks with salt on the rim. Arriba~!"

/datum/reagent/ethanol/battuta
	name = "Ibn Batutta"
	description = "One of the Official Cocktails of the Expeditionary Corps, celebrating Muhammad Ibn Battuta."
	taste_description = "a Moroccan garden"
	color = "#dfbe00"
	strength = 18

	glass_name = "Ibn Batutta cocktail"
	glass_desc = "A refreshing blend of herbal liquor, the juice of an orange and a hint of mint. Named for Muhammad Ibn Battuta, whose travels spanned from Mali eastward to China in the 14th century."

/datum/reagent/ethanol/magellan
	name = "Magellan"
	description = "One of the Official Cocktails of the Expeditionary Corps, celebrating Ferdinand Magellan."
	taste_description = "an aristrocatic experience"
	color = "#6b3535"
	strength = 13

	glass_name = "Magellan cocktail"
	glass_desc = "A tasty sweetened blend of wine and fine whiskey. Named for Ferdinand Magellan, who led the first expedition to circumnavigate Earth in the 15th century."

/datum/reagent/ethanol/zhenghe
	name = "Zheng He"
	description = "One of the Official Cocktails of the Expeditionary Corps, celebrating Zheng He."
	taste_description = "herbal bitterness"
	color = "#173b06"
	strength = 20

	glass_name = "Zheng He cocktail"
	glass_desc = "A rather bitter blend of vermouth and well-steeped black tea. Named for Zheng He, who travelled from Nanjing in China as far as Mogadishu in the Horn of Africa in the 15th century."

/datum/reagent/ethanol/armstrong
	name = "Armstrong"
	description = "One of the Official Cocktails of the Expeditionary Corps, celebrating Neil Armstrong."
	taste_description = "limes and alcoholic beer"
	color = "#ffd300"
	strength = 15

	glass_name = "Armstrong cocktail"
	glass_desc = "Beer, vodka and lime come together in this instant classic. Named for Neil Armstrong, who was the first man to set foot on Luna, in the 20th century."

/datum/reagent/ethanol/mead
	name = "Mead"
	description = "A Viking's drink, though a cheap one."
	taste_description = "sweet, sweet alcohol"
	reagent_state = LIQUID
	color = "#ffbb00"
	strength = 30
	nutriment_factor = 1

	glass_name = "mead"
	glass_desc = "A Viking's beverage, though a cheap one."

/datum/reagent/ethanol/moonshine
	name = "Moonshine"
	description = "You've really hit rock bottom now... your liver packed its bags and left last night."
	taste_description = "bitterness"
	taste_mult = 2.5
	color = "#0064c8"
	strength = 12

	glass_name = "moonshine"
	glass_desc = "You've really hit rock bottom now... your liver packed its bags and left last night."

/datum/reagent/ethanol/neurotoxin
	name = "Neurotoxin"
	description = "A strong neurotoxin that puts the subject into a death-like state."
	taste_description = "a numbing sensation"
	reagent_state = LIQUID
	color = "#2e2e61"
	strength = 10

	glass_name = "Neurotoxin"
	glass_desc = "A drink that is guaranteed to knock you silly."
	glass_icon = DRINK_ICON_NOISY
	glass_special = list("neuroright")

/datum/reagent/ethanol/neurotoxin/affect_ingest(var/mob/living/carbon/M, var/alien, var/removed)
	..()
	M.Weaken(3)
	M.add_chemical_effect(CE_PULSE, -1)

/datum/reagent/ethanol/patron
	name = "Patron"
	description = "Tequila with silver in it, a favorite of alcoholic women in the club scene."
	taste_description = "metallic and expensive"
	color = "#585840"
	strength = 30

	glass_name = "Patron"
	glass_desc = "Drinking patron in the bar, with all the subpar ladies."

/datum/reagent/ethanol/pwine
	name = "Poison Wine"
	description = "Is this even wine? Toxic! Hallucinogenic! Probably consumed in boatloads by your superiors!"
	taste_description = "purified alcoholic death"
	color = "#000000"
	strength = 10
	druggy = 50
	halluci = 10

	glass_name = "???"
	glass_desc = "A black ichor with an oily purple sheer on top. Are you sure you should drink this?"

/datum/reagent/ethanol/pwine/affect_ingest(var/mob/living/carbon/M, var/alien, var/removed)
	..()
	if(M.chem_doses[type] > 30)
		M.adjustToxLoss(2 * removed)
	if(M.chem_doses[type] > 60 && ishuman(M) && prob(5))
		var/mob/living/carbon/human/H = M
		var/obj/item/organ/internal/heart/L = H.internal_organs_by_name[BP_HEART]
		if (L && istype(L))
			if(M.chem_doses[type] < 120)
				L.take_internal_damage(10 * removed, 0)
			else
				L.take_internal_damage(100, 0)

/datum/reagent/ethanol/red_mead
	name = "Red Mead"
	description = "The true Viking's drink! Even though it has a strange red color."
	taste_description = "sweet and salty alcohol"
	color = "#c73c00"
	strength = 30

	glass_name = "red mead"
	glass_desc = "A true Viking's beverage, though its color is strange."

/datum/reagent/ethanol/sbiten
	name = "Sbiten"
	description = "A spicy Mead! Might be a little hot for the little guys!"
	taste_description = "hot and spice"
	color = "#ffa371"
	strength = 15
	adj_temp = 50
	targ_temp = 360

	glass_name = "Sbiten"
	glass_desc = "A spicy mix of Mead and Spice. Very hot."

/datum/reagent/ethanol/screwdrivercocktail
	name = "Screwdriver"
	description = "Vodka, mixed with plain ol' orange juice. The result is surprisingly delicious."
	taste_description = "oranges"
	color = "#a68310"
	strength = 15

	glass_name = "Screwdriver"
	glass_desc = "A simple, yet superb mixture of Vodka and orange juice. Just the thing for the tired engineer."

/datum/reagent/ethanol/ships_surgeon
	name = "Ship's Surgeon"
	description = "Rum and Dr. Gibb. Served ice cold, like the scalpel."
	taste_description = "black comedy"
	color = "#524d0f"
	strength = 15

	glass_name = "ship's surgeon"
	glass_desc = "Rum qualified for surgical practice by Dr. Gibb. Smooth and steady."

/datum/reagent/ethanol/silencer
	name = "Silencer"
	description = "A drink from Mime Heaven."
	taste_description = "a pencil eraser"
	taste_mult = 1.2
	nutriment_factor = 1
	color = "#ffffff"
	strength = 12

	glass_name = "Silencer"
	glass_desc = "A drink from mime Heaven."

/datum/reagent/ethanol/singulo
	name = "Singulo"
	description = "A blue-space beverage!"
	taste_description = "concentrated matter"
	color = "#2e6671"
	strength = 10

	glass_name = "Singulo"
	glass_desc = "A blue-space beverage."

/datum/reagent/ethanol/snowwhite
	name = "Snow White"
	description = "A cold refreshment"
	taste_description = "refreshing cold"
	color = "#ffffff"
	strength = 30

	glass_name = "Snow White"
	glass_desc = "A cold refreshment."

/datum/reagent/ethanol/suidream
	name = "Sui Dream"
	description = "Comprised of: White soda, blue curacao, melon liquor."
	taste_description = "fruit"
	color = "#00a86b"
	strength = 100

	glass_name = "Sui Dream"
	glass_desc = "A froofy, fruity, and sweet mixed drink. Understanding the name only brings shame."

/datum/reagent/ethanol/syndicatebomb
	name = "Syndicate Bomb"
	description = "Tastes like terrorism!"
	taste_description = "purified antagonism"
	color = "#2e6671"
	strength = 10

	glass_name = "Syndicate Bomb"
	glass_desc = "Tastes like terrorism!"

/datum/reagent/ethanol/tequilla_sunrise
	name = "Tequila Sunrise"
	description = "Tequila and orange juice. Much like a Screwdriver, only Mexican~"
	taste_description = "oranges"
	color = "#ffe48c"
	strength = 25

	glass_name = "Tequilla Sunrise"
	glass_desc = "Oh great, now you feel nostalgic about sunrises back on Terra..."

/datum/reagent/ethanol/threemileisland
	name = "Three Mile Island Iced Tea"
	description = "Made for a woman, strong enough for a man."
	taste_description = "dry"
	color = "#666340"
	strength = 10
	druggy = 50

	glass_name = "Three Mile Island iced tea"
	glass_desc = "A glass of this is sure to prevent a meltdown."

/datum/reagent/ethanol/toxins_special
	name = "Toxins Special"
	description = "This thing is ON FIRE! CALL THE DAMN SHUTTLE!"
	taste_description = "spicy toxins"
	reagent_state = LIQUID
	color = "#7f00ff"
	strength = 10
	adj_temp = 15
	targ_temp = 330

	glass_name = "Toxins Special"
	glass_desc = "Whoah, this thing is on FIRE"

/datum/reagent/ethanol/vodkamartini
	name = "Vodka Martini"
	description = "Vodka with Gin. Not quite how 007 enjoyed it, but still delicious."
	taste_description = "shaken, not stirred"
	color = "#b8e3e7"
	strength = 12

	glass_name = "vodka martini"
	glass_desc ="A bastardisation of the classic martini. Still great."


/datum/reagent/ethanol/vodkatonic
	name = "Vodka and Tonic"
	description = "For when a gin and tonic isn't russian enough."
	taste_description = "tart bitterness"
	color = "#c1dcf7" // rgb: 0, 100, 200
	strength = 15

	glass_name = "vodka and tonic"
	glass_desc = "For when a gin and tonic isn't Russian enough."


/datum/reagent/ethanol/white_russian
	name = "White Russian"
	description = "That's just, like, your opinion, man..."
	taste_description = "bitter cream"
	color = "#aa976e"
	strength = 15

	glass_name = "White Russian"
	glass_desc = "A very nice looking drink. But that's just, like, your opinion, man."


/datum/reagent/ethanol/whiskey_cola
	name = "Whiskey Cola"
	description = "Whiskey, mixed with cola. Surprisingly refreshing."
	taste_description = "cola"
	color = "#3e1b00"
	strength = 25

	glass_name = "whiskey cola"
	glass_desc = "An innocent-looking mixture of cola and Whiskey. Delicious."


/datum/reagent/ethanol/whiskeysoda
	name = "Whiskey Soda"
	description = "For the more refined griffon."
	color = "#eab300"
	strength = 15

	glass_name = "whiskey soda"
	glass_desc = "Ultimate refreshment."

/datum/reagent/ethanol/specialwhiskey // I have no idea what this is and where it comes from
	name = "Special Blend Whiskey"
	description = "Just when you thought regular whiskey was good... This silky, amber goodness has to come along and ruin everything."
	taste_description = "liquid fire"
	color = "#523600"
	strength = 25

	glass_name = "special blend whiskey"
	glass_desc = "Just when you thought regular whiskey was good... This silky, amber goodness has to come along and ruin everything."

//black tea
/datum/reagent/drink/tea
	name = "Black Tea"
	description = "Tasty black tea, it has antioxidants, it's good for you!"
	taste_description = "tart black tea"
	color = "#101000"
	adj_dizzy = -2
	adj_drowsy = -1
	adj_sleepy = -3
	adj_temp = 20

	glass_name = "black tea"
	glass_desc = "Tasty black tea, it has antioxidants, it's good for you!"

/datum/reagent/drink/tea/affect_ingest(var/mob/living/carbon/M, var/alien, var/removed)
	..()
	if(alien == IS_DIONA)
		return
	M.adjustToxLoss(-0.5 * removed)

/datum/reagent/drink/tea/icetea
	name = "Iced Black Tea"
	description = "It's the black tea you know and love, but now it's cold."
	taste_description = "cold black tea"
	adj_temp = -5

	glass_name = "iced black tea"
	glass_desc = "It's the black tea you know and love, but now it's cold."
	glass_special = list(DRINK_ICE)

/datum/reagent/drink/tea/icetea/sweet
	name = "Sweet Black Tea"
	description = "It's the black tea you know and love, but now it's cold. And sweet."
	taste_description = "sweet tea"

	glass_name = "sweet black tea"
	glass_desc = "It's the black tea you know and love, but now it's cold. And sweet."

/datum/reagent/drink/tea/barongrey
	name = "Baron Grey Tea"
	description = "Black tea prepared with standard orange flavoring. Much less fancy than the bergamot in Earl Grey, but the chances of you getting any of that stuff out here is pretty slim."
	taste_description = "tangy black tea"

	glass_name = "Baron Grey tea"
	glass_desc = "Black tea prepared with standard orange flavoring. Much less fancy than the bergamot in Earl Grey, but the chances of you getting any of that stuff out here is pretty slim."

/datum/reagent/drink/tea/barongrey/latte
	name = "London Fog"
	description = "A blend of Earl Grey (Or more likely Baron Grey) and steamed milk, making a pleasant tangy tea latte."
	taste_description = "creamy, tangy black tea"

	glass_name = "London Fog"
	glass_desc = "A blend of Earl Grey (Or more likely Baron Grey) and steamed milk, making a pleasant tangy tea latte."

/datum/reagent/drink/tea/barongrey/soy_latte
	name = "Soy London Fog"
	description = "A blend of Earl Grey (Or more likely Baron Grey) and steamed soy milk, making a pleasant tangy tea latte."
	taste_description = "creamy, tangy black tea"

	glass_name = "Soy London Fog"
	glass_desc = "A blend of Earl Grey (Or more likely Baron Grey) and steamed soy milk, making a pleasant tangy tea latte."

/datum/reagent/drink/tea/icetea/barongrey/latte
	name = "Iced London Fog"
	description = "A blend of Earl Grey (Or more likely Baron Grey) and steamed milk, making a pleasant tangy tea latte. This one's cold."
	taste_description = "cold, creamy, tangy black tea"

	glass_name = "iced london fog"
	glass_desc = "A blend of Earl Grey (Or more likely Baron Grey) and steamed milk, making a pleasant tangy tea latte. This one's cold."

/datum/reagent/drink/tea/icetea/barongrey/soy_latte
	name = "Iced Soy London Fog"
	description = "A blend of Earl Grey (Or more likely Baron Grey) and steamed soy milk, making a pleasant tangy tea latte. This one's cold."
	taste_description = "cold, creamy, tangy black tea"

	glass_name = "iced soy london fog"
	glass_desc = "A blend of Earl Grey (Or more likely Baron Grey) and steamed soy milk, making a pleasant tangy tea latte. This one's cold."

//green tea
/datum/reagent/drink/tea/green
	name = "Green Tea"
	description = "Subtle green tea, it has antioxidants, it's good for you!"
	taste_description = "subtle green tea"
	color = "#b4cd94"

	glass_name = "green tea"
	glass_desc = "Subtle green tea, it has antioxidants, it's good for you!"

/datum/reagent/drink/tea/icetea/green
	name = "Iced Green Tea"
	description = "It's the green tea you know and love, but now it's cold."
	taste_description = "cold green tea"
	color = "#b4cd94"

	glass_name = "iced green tea"
	glass_desc = "It's the green tea you know and love, but now it's cold."

/datum/reagent/drink/tea/icetea/green/sweet
	name = "Sweet Green Tea"
	description = "It's the green tea you know and love, but now it's cold. And sweet."
	taste_description = "sweet green tea"
	color = "#b4cd94"

	glass_name = "sweet green tea"
	glass_desc = "It's the green tea you know and love, but now it's cold. And sweet."

/datum/reagent/drink/tea/icetea/green/sweet/mint
	name = "Maghrebi Tea"
	description = "Iced green tea prepared with mint and sugar. Refreshing!"
	taste_description = "refreshing mint tea"

	glass_name = "Maghrebi mint tea"
	glass_desc = "Iced green tea prepared with mint and sugar. Refreshing!"

/datum/reagent/drink/tea/chai
	name = "Chai Tea"
	description = "A spiced, dark tea. Goes great with milk."
	taste_description = "spiced black tea"
	color = "#151000"

	glass_name = "chai tea"
	glass_desc = "A spiced, dark tea. Goes great with milk."

/datum/reagent/drink/tea/icetea/chai
	name = "Iced Chai Tea"
	description = "It's the chai tea you know and love, but now it's cold."
	taste_description = "cold spiced black tea"
	color = "#151000"

	glass_name = "iced chai tea"
	glass_desc = "It's the chai tea you know and love, but now it's cold."

/datum/reagent/drink/tea/icetea/chai/sweet
	name = "Sweet Chai Tea"
	description = "It's the chai tea you know and love, but now it's cold. And sweet."
	taste_description = "sweet spiced black tea"

	glass_name = "sweet chai tea"
	glass_desc = "It's the chai tea you know and love, but now it's cold. And sweet."

/datum/reagent/drink/tea/chai/latte
	name = "Chai Latte"
	description = "A warm, inviting cup of spiced, dark tea mixed with steamed milk."
	taste_description = "creamy spiced tea"
	color = "#c8a988"

	glass_name = "chai latte"
	glass_desc = "A warm, inviting cup of spiced, dark tea mixed with steamed milk."

/datum/reagent/drink/tea/chai/soy_latte
	name = "Chai Soy Latte"
	description = "A warm, inviting cup of spiced, dark tea mixed with steamed soy milk."
	taste_description = "creamy spiced tea"
	color = "#c8a988"

	glass_name = "chai soy latte"
	glass_desc = "A warm, inviting cup of spiced, dark tea mixed with steamed soy milk."

/datum/reagent/drink/tea/icetea/chai/latte
	name = "Iced Chai Latte"
	description = "A warm, inviting cup of spiced, dark tea mixed with steamed milk. This one's cold."
	taste_description = "cold creamy spiced tea"
	color = "#c8a988"

	glass_name = "iced chai latte"
	glass_desc = "A warm, inviting cup of spiced, dark tea mixed with steamed milk. This one's cold."

/datum/reagent/drink/tea/icetea/chai/soy_latte
	name = "Iced Chai Soy Latte"
	description = "A warm, inviting cup of spiced, dark tea mixed with steamed soy milk. This one's cold."
	taste_description = "cold creamy spiced tea"
	color = "#c8a988"

	glass_name = "iced chai soy latte"
	glass_desc = "A warm, inviting cup of spiced, dark tea mixed with steamed soy milk. This one's cold."

/datum/reagent/drink/tea/red
	name = "Rooibos Tea"
	description = "A caffeine-free dark red tea, flavorful and full of antioxidants."
	taste_description = "nutty red tea"
	color = "#ab4c3a"

	glass_name = "rooibos tea"
	glass_desc = "A caffeine-free dark red tea, flavorful and full of antioxidants."

/datum/reagent/drink/tea/icetea/red
	name = "Iced Rooibos Tea"
	description = "It's the red tea you know and love, but now it's cold."
	taste_description = "cold nutty red tea"
	color = "#ab4c3a"

	glass_name = "iced rooibos tea"
	glass_desc = "It's the red tea you know and love, but now it's cold."

/datum/reagent/drink/tea/icetea/red/sweet
	name = "Sweet Rooibos Tea"
	description = "It's the red tea you know and love, but now it's cold. And sweet."
	taste_description = "sweet nutty red tea"

	glass_name = "sweet rooibos tea"
	glass_desc = "It's the red tea you know and love, but now it's cold. And sweet."

/datum/reagent/drink/syrup_chocolate
	name = "Chocolate Syrup"
	description = "Thick chocolate syrup used to flavor drinks."
	taste_description = "chocolate"
	color = "#542a0c"

	glass_name = "chocolate syrup"
	glass_desc = "Thick chocolate syrup used to flavor drinks."

/datum/reagent/drink/syrup_caramel
	name = "Caramel Syrup"
	description = "Thick caramel syrup used to flavor drinks."
	taste_description = "caramel"
	color = "#85461e"

	glass_name = "caramel syrup"
	glass_desc = "Thick caramel syrup used to flavor drinks."

/datum/reagent/drink/syrup_vanilla
	name = "Vanilla Syrup"
	description = "Thick vanilla syrup used to flavor drinks."
	taste_description = "vanilla"
	color = "#f3e5ab"

	glass_name = "vanilla syrup"
	glass_desc = "Thick vanilla syrup used to flavor drinks."

/datum/reagent/drink/syrup_pumpkin
	name = "Pumpkin Spice Syrup"
	description = "Thick spiced pumpkin syrup used to flavor drinks."
	taste_description = "spiced pumpkin"
	color = "#d88b4c"

	glass_name = "pumpkin spice syrup"
	glass_desc = "Thick spiced pumpkin syrup used to flavor drinks."

// Alcohol Expansion

/datum/reagent/ethanol/applecider
	name = "Apple Cider"
	description = "A refreshing glass of apple cider."
	taste_description = "cool apple cider"
	color = "#cac089"
	strength = 50

	glass_name = "Apple Cider"
	glass_desc = "A refreshing glass of apple cider."

/datum/reagent/ethanol/arak
	name = "Arak"
	description = "An unsweetened aniseed and grape mixture."
	taste_description = "oil and licorice"
	color = "#f7f6e0"
	strength = 20

	glass_name = "arak"
	glass_desc = "An unsweetened mixture of aniseed and grape."

/datum/reagent/ethanol/blackstrap
	name = "Blackstrap"
	description = "A classic mix of rum and molasses, typically consumed by Tersteners."
	taste_description = "sweet and strong alcohol"
	color = "#161612"
	strength = 30

	glass_name = "blackstrap"
	glass_desc = "A classic mix of rum and molasses."

/datum/reagent/ethanol/bogus
	name = "Bogus"
	description = "A blend of Gin and Blackstrap."
	taste_description = "conflicting tastes and a delicious resolution"
	color = "#e8dfc1"
	strength = 30

	glass_name = "bogus"
	glass_desc = "A blend of Gin and Molasses."

/datum/reagent/ethanol/champagne
	name = "Champagne"
	description = "Smooth sparkling wine, produced in the same region of France as it has for centuries."
	taste_description = "a superior taste of sparkling wine"
	color = "#e8dfc1"
	strength = 25

	glass_name = "champagne"
	glass_desc = "Smooth sparkling wine, produced in the same region of France as it has for centuries."

/datum/reagent/ethanol/coffee/gargled
	name = "Gargled"
	description = "A blend of Blackstrap and Coffee. An ideal pick-me-up for any rancher."
	taste_description = "comforting warmth"
	color = "#e8dfc1"
	strength = 50

	glass_name = "gargled"
	glass_desc = "A blend of Blackstrap and Coffee. An ideal pick-me-up for any rancher."

/datum/reagent/ethanol/springpunch
	name = "Gilgamesh Spring Punch"
	description = "A mix of vodka and lemon, extremely popular with Terrans."
	taste_description = "refreshing clear fizz"
	color = "#dfdeda"
	strength = 30

	glass_name = "Gilgamesh spring punch"
	glass_desc = "A mix of vodka and lemon, extremely popular with Terrans."

/datum/reagent/ethanol/hellshenpa
	name = "Hellshen Pale Ale"
	description = "A type of ale drunk in the Hellshen regions of Mars."
	taste_description = "dark musty hops and Martian pride"
	color = "#aa9162"
	strength = 50

	glass_name = "Hellshen Pale Ale"
	glass_desc = "A type of ale drunk in the Hellshen regions of Mars."

/datum/reagent/ethanol/jagerbomb
	name = "Jagerbomb"
	description = "A mix of energy drink and alcohol. Guaranteed to make you feel like an underage drinker again."
	taste_description = "a pick-me-up and put-me-down"
	color = "#996862"
	strength = 10

	glass_name = "jagerbomb"
	glass_desc = "A mix of energy drink and alcohol. Guaranteed to make you feel like an underage drinker again."

/datum/reagent/ethanol/jagermeister
	name = "Jagermeister"
	description = "A special blend of alcohol, herbs, and spices. It has remained a popular Earther drink."
	taste_description = "herbs, spices, and alcohol"
	color = "#596e3e"
	strength = 20

	glass_name = "jagermeister"
	glass_desc = "A special blend of alcohol, herbs, and spaces. It has remained a popular Earther drink."

/datum/reagent/ethanol/jimmygideon
	name = "Jimmy Gideon"
	description = "The drink of choice of Jimmy Gideon, first man on Mars."
	taste_description = "the legacy of greatness and chocolate"
	color = "#d9cfa5"
	strength = 30

	glass_name = "Jimmy"
	glass_desc = "The drink of choice of Jimmy Gideon, first man on Mars."

/datum/reagent/ethanol/kvass
	name = "Kvass"
	description = "An alcoholic drink commonly made from bread."
	taste_description = "vkusnyy kvas, ypa!"
	color = "#362f22"
	strength = 30

	glass_name = "kvass"
	glass_desc = "An alcoholic drink commonly made from bread."

/datum/reagent/ethanol/llanbrydewhiskey
	name = "Llanbryde Whiskey"
	description = "Welsh Whiskey. So good it should be illegal."
	taste_description = "distilled welsh highlands"
	color = "#805200"
	strength = 10

	glass_name = "Llanbryde whiskey"
	glass_desc = "A premium Welsh whiskey."

/datum/reagent/ethanol/lonestarmule
	name = "Lonestar Mule"
	description = "A classic Martian take on the moscow mule. Replaces vodka with molasses."
	taste_description = "crisp, refreshing ginger beer and molasses"
	color = "#92938a"
	strength = 15

	glass_name = "lonestar mule"
	glass_desc = "A blend of whiskey, ginger beer, and lime juice."

/datum/reagent/ethanol/lordaniawine
	name = "Lordanian Wine"
	description = "An earthy type of wine distilled from grapes on Lordania."
	taste_description = "an acquired taste and elitism"
	color = "#362f22"
	strength = 10

	glass_name = "Lordanian wine"
	glass_desc = "An earthy type of wine distilled from grapes on Lordania."

/datum/reagent/ethanol/lunabrandy
	name = "Lunar Brandy"
	description = "A strong fermented brandy typically consumed on Luna."
	taste_description = "distilled wine and snobbery"
	color = "#bdb6a9"
	strength = 20

	glass_name = "Lunar Brandy"
	glass_desc = "A strong brandy largely consumed by the upper classes of Luna."

/datum/reagent/ethanol/moscowmule
	name = "Moscow Mule"
	description = "A blend of vodka, ginger beer, and lime juice."
	taste_description = "crisp, refreshing ginger and vodka"
	color = "#e1dfd6"
	strength = 15

	glass_name = "moscow mule"
	glass_desc = "A blend of vodka, ginger beer, and lime juice."

/datum/reagent/ethanol/nevadan_gold
	name = "Nevadan Gold Whiskey"
	description = "A warm blend of 98 spices. Made in the heartlands of Tersten."
	taste_description = "strong, creamy whiskey"
	color = "#ce1900"
	strength = 10

	glass_name = "Nevadan gold whiskey"
	glass_desc = "A warm blend of 98 spices, brewed on Tersten. A delicious mix."

/datum/reagent/ethanol/prosecco
	name = "Prosecco"
	description = "A delightful blend of glera grapes, native to Earth."
	taste_description = "the trials of being a young woman in a rich man's world"
	color = "#e8dfc1"
	strength = 30

	glass_name = "prosecco"
	glass_desc = "A delightful blend of glera grapes, native to Earth."

/datum/reagent/ethanol/red_whiskey
	name = "Red Whiskey"
	description = "A dark red looking substance that smells like strong whiskey."
	taste_description = "an intense throat burning sensation"
	color = "#ce1900"
	strength = 10

	glass_name = "red whiskey"
	glass_desc = "A dark red looking substance that smells like strong whiskey."

/datum/reagent/ethanol/stag
	name = "Stag"
	description = "A traditional brew consumed by various members of the Fleet."
	taste_description = "relief from duty"
	color = "#362f22"
	strength = 100
	glass_name = "stag"
	glass_desc = "A classic mix of rum and tea, ideal for long nights on watch."

/datum/reagent/ethanol/vodkacola
	name = "Vodka Cola"
	description = "A refreshing mix of vodka and cola."
	taste_description = "vodka and cola"
	color = "#474238"
	strength = 15
	glass_name = "vodka cola"
	glass_desc = "A refreshing mix of vodka and cola."

// Alien Drinks

/datum/reagent/drink/alien/unathijuice
	name = "Hrukhza Leaf Extract"
	description = "A bitter liquid used in most recipes on Moghes."
	taste_description = "bland, disgusting bitterness"
	color = "#e78108"
	glass_name = "hrukhza leaf extract"
	glass_desc = "A bitter extract from the hrukhza."

/datum/reagent/drink/alien/kzkzaa
	name = "Kzkzaa"
	description = "Fish extract from Moghes."
	taste_description = "fishy fish"
	color = "#e78108"
	glass_name = "kzkzaa"
	glass_desc = "A glass of Kzkzaa, fish extract, commonly drank on Moghes."

/datum/reagent/drink/alien/mumbaksting
	name = "Mumbak Sting"
	description = "A drink made from the venom of the Yuum."
	taste_description = "harsh and stinging sweetness"
	color = "#7e4c2e"
	glass_name = "Mumbak sting"
	glass_desc = "A drink made from the venom of the Yuum."

/datum/reagent/ethanol/alien/wasgaelhi
	name = "Wasgaelhi"
	description = "Wine made from various fruits from the swamps of Moghes."
	taste_description = "swampy fruit"
	color = "#678e46"
	strength = 10
	glass_name = "wasgaelhi"
	glass_desc = "Wine made from various fruits from the swamps of Moghes."

/datum/reagent/drink/alien/skrianhi
	name = "Skrianhi Tea"
	description = "A blend of teas from Moghes, commonly drank by Unathi."
	taste_description = "bitter energising tea"
	color = "#0e0900"
	glass_name = "skiranhi tea"
	glass_desc = "A blend of teas from Moghes, commonly drank by Unathi."

// Non-Alcoholic Drinks

/datum/reagent/drink/fools_gold
	name = "Fool's Gold"
	description = "A non-alcoholic beverage typically served as an alternative to whiskey."
	taste_description = "watered down whiskey"
	color = "#e78108"
	glass_name = "fools gold"
	glass_desc = "A non-alcoholic beverage typically served as an alternative to whiskey."

/datum/reagent/drink/snowball
	name = "Snowball"
	description = "A cold pick-me-up frequently drunk in scientific outposts and academic fields."
	taste_description = "intellectual thought and brain-freeze"
	color = "#eeecea"
	adj_temp = -5
	glass_name = "snowball"
	glass_desc = "A cold pick-me-up frequently drunk in scientific outposts and academic fields."

/datum/reagent/drink/browndwarf
	name = "Brown Dwarf"
	description = "A large gas body made of chocolate that has failed to sustain nuclear fusion."
	taste_description = "dark chocolatey matter"
	color = "#44371f"
	glass_name = "brown dwarf"
	glass_desc = "A large gas body made of chocolate that has failed to sustain nuclear fusion."

/datum/reagent/drink/gingerbeer
	name = "Ginger Beer"
	description = "A hearty, non-alcoholic beverage extremely popular around the SCG."
	taste_description = "carbonated ginger"
	color = "#44371f"
	glass_name = "ginger beer"
	glass_desc = "A hearty, non-alcoholic beverage extremely popular around the SCG."

/datum/reagent/drink/beastenergy
	name = "Beast Energy"
	description = "A bottle of 100% pure energy."
	taste_description = "your heart crying"
	color = "#d69115"
	glass_name = "beast energy"
	glass_desc = "Why would you drink this without mixer?"

/datum/reagent/drink/beastenergy/affect_ingest(var/mob/living/carbon/M, var/alien, var/removed)
	..()
	if(alien == IS_DIONA)
		return
	M.drowsyness = max(0, M.drowsyness - 7)
	M.make_jittery(2)
	M.add_chemical_effect(CE_PULSE, 1)

/datum/reagent/drink/kefir
	name = "Kefir"
	description = "Fermented milk. Actually very tasty."
	taste_description = "sharp, frothy yougurt"
	color = "#ece4e3"
	glass_name = "Kefir"
	glass_desc = "Fermented milk, looks a lot like yougurt."

// fruit expansion

/datum/reagent/drink/juice/melon
	name = "Melon Juice"
	description = "Juice from a freshly squeezed melon."
	taste_description = "tangy, sweet melon"
	color = "#e9ba33"
	glass_name = "Melon juice"
	glass_desc = "A glass of tasty melon juice."

/datum/reagent/drink/juice/grape/green
	name = "Green Grape Juice"
	description = "Grape juice from green grapes."
	taste_description = "green grapes"
	color = "#42ed2f"

	glass_name = "green grape juice"
	glass_desc = "Grape juice from green grapes."

/datum/reagent/drink/juice/grape/white
	name = "White Grape Juice"
	description = "Grape juice from white grapes."
	taste_description = "white grapes"
	color = "#42ed2f"

	glass_name = "white grape juice"
	glass_desc = "Grape juice from white grapes."

/datum/reagent/drink/juice/pineapple
	name = "Pineapple Juice"
	description = "Juice from a pineapple."
	taste_description = "delicious pineapple juice"
	color = "#f6e12d"

	glass_name = "pineapple juice"
	glass_desc = "Juice from a pineapple."

/datum/reagent/drink/coconut
	name = "Coconut Water"
	description = "Unfiltered water from a coconut."
	taste_description = "coconut water"
	color = "#619494"

	glass_name = "coconut water"
	glass_desc = "Unfiltered water from a coconut."

/datum/reagent/drink/coconut/milk
	name = "Coconut Milk"
	description = "Delicious milk from a coconut."
	taste_description = "cool coconut milk"
	color = "#619494"

	glass_name = "coconut milk"
	glass_desc = "Delicious milk from a coconut."

/datum/reagent/ethanol/alien/qokkloa
	name = "Qokk'loa"
	description = "An unrefined hallucinogenic substance, potent to humans and harmless to Skrell."
	taste_description = "cold, slimey mushroom"
	color = "#e700e7"
	strength = 50

	glass_name = "qokk'loa"
	glass_desc = "An unrefined hallucigenic substance, potent to humans and harmless to Skrell."

/datum/reagent/ethanol/alien/qokkloa/affect_ingest(var/mob/living/carbon/M, var/alien, var/removed)
	..()
	if(alien == IS_SKRELL)
		return
	if(alien == IS_DIONA)
		return

	if(M.chem_doses[type] < 5)
		M.adjustToxLoss(5 * removed)
	if(M.chem_doses[type] > 5 && ishuman(M))
		var/mob/living/carbon/human/H = M
		var/obj/item/organ/internal/heart/L = H.internal_organs_by_name[BP_HEART]
		if (istype(L))
			if(M.chem_doses[type] < 10)
				L.take_internal_damage(2 * removed, 0)
				M.adjustToxLoss(5 * removed)
			else
				L.take_internal_damage(5 * removed, 0)
				M.adjustToxLoss(10 * removed)

/datum/reagent/ethanol/pinacolada
	name = "Pina Colada"
	description = "A sweet cocktail of rum and pineapple."
	taste_description = "refreshing tropical fruit"
	color = "#f1fa56"
	strength = 15

	glass_name = "pina colada"
	glass_desc = "A sweet cocktail of rum and pineapple."

/datum/reagent/ethanol/alien/qokkhrona
	name = "Qokk'hrona"
	description = "Delicious Skrellian wine from refined qokk'loa."
	taste_description = "a thick potion of mushroom, slime, and hard alcohol"
	color = "#c76c4d"
	strength = 100
	druggy = 5

	glass_name = "qokk'hrona"
	glass_desc = "Delicious Skrellian wine from refined qokk'loa."

/datum/reagent/cinnamon
	name = "Cinnamon"
	description = "Delicious ground cinnamon spice. "
	taste_description = "cinnamon"
	reagent_state = SOLID
	color = "#cd6139"
	value = 0.1

	glass_name = "cinnamon"
	glass_desc = "Delicious ground cinnamon spice, why would you drink this?"

/datum/reagent/ethanol/horchata
	name = "Horchata"
	description = "A delightful horchata de chufa."
	taste_description = "creamy, mediterranean alcohol"
	color = "#f5ecb8"
	strength = 40

	glass_name = "horchata"
	glass_desc = "A lovely looking horchata del chufa."

/datum/reagent/oliveoil
	name = "Olive Oil"
	description = "Olive oil, an essential part of cooking."
	taste_description = "grease"
	color = "#cacf70"

	glass_name = "olive oil"
	glass_desc = "Oily."

/datum/reagent/drink/affelerin
	name = "Affelerin Nectar"
	description = "A thick syrup-like nectar from the Affelerin, common across many desert worlds."
	taste_description = "sweet, thick syrup"
	color = "#ac43e0"
	glass_name = "affelerin nectar"
	glass_desc = "A thick syrup-like nectar from the Affelerin, common across many desert worlds."

/datum/reagent/ethanol/iridast
	name = "Iridast Berry Juice"
	description = "An intoxicating juice made from the Iridast Berry, common across human worlds."
	taste_description = "incredible sweetness"
	color = "#fa68ff"
	strength = 50

	glass_name = "iridast berry juice"
	glass_desc = "An intoxicating juice made from the Iridast Berry, common across human worlds."