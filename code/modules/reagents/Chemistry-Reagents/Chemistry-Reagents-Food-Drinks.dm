/* Food */

/datum/reagent/nutriment
	name = "Nutriment"
	id = "nutriment"
	description = "All the vitamins, minerals, and carbohydrates the body needs in pure form."
	taste_mult = 4
	reagent_state = SOLID
	metabolism = REM * 4
	var/nutriment_factor = 30 // Per unit
	var/injectable = 0
	color = "#664330"

/datum/reagent/nutriment/mix_data(var/list/newdata, var/newamount)

	if(!islist(newdata) || !newdata.len)
		return

	//add the new taste data
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
	switch(alien)
		if(IS_RESOMI) removed *= 0.8 // Resomi get a bit more nutrition from meat, a bit less from other stuff to compensate
		if(IS_UNATHI) removed *= 0.1 // Unathi get most of their nutrition from meat.
	M.nutrition += nutriment_factor * removed // For hunger and fatness

/datum/reagent/nutriment/glucose
	name = "Glucose"
	id = "glucose"
	color = "#FFFFFF"

	injectable = 1

/datum/reagent/nutriment/protein // Bad for Skrell!
	name = "animal protein"
	taste_description = "some sort of protein"
	id = "protein"
	color = "#440000"

/datum/reagent/nutriment/protein/affect_ingest(var/mob/living/carbon/M, var/alien, var/removed)
	switch(alien)
		if(IS_SKRELL)
			M.adjustToxLoss(0.5 * removed)
			return
	..()

/datum/reagent/nutriment/protein/adjust_nutrition(var/mob/living/carbon/M, var/alien, var/removed)
	switch(alien)
		if(IS_RESOMI) removed *= 1.25
		if(IS_UNATHI) removed *= 2.25
	M.nutrition += nutriment_factor * removed // For hunger and fatness

/datum/reagent/nutriment/protein/affect_blood(var/mob/living/carbon/M, var/alien, var/removed)
	if(alien && alien == IS_SKRELL)
		M.adjustToxLoss(2 * removed)
		return
	..()

/datum/reagent/nutriment/protein/egg // Also bad for skrell.
	name = "egg yolk"
	taste_description = "egg"
	id = "egg"
	color = "#FFFFAA"

/datum/reagent/nutriment/honey
	name = "Honey"
	id = "honey"
	description = "A golden yellow syrup, loaded with sugary sweetness."
	taste_description = "sweetness"
	nutriment_factor = 10
	color = "#FFFF00"

/datum/reagent/honey/affect_ingest(var/mob/living/carbon/M, var/alien, var/removed)
	..()

	if(alien == IS_UNATHI)
		if(dose < 2)
			if(dose == metabolism * 2 || prob(5))
				M.emote("yawn")
		else if(dose < 5)
			M.eye_blurry = max(M.eye_blurry, 10)
		else if(dose < 20)
			if(prob(50))
				M.Weaken(2)
			M.drowsyness = max(M.drowsyness, 20)
		else
			M.sleeping = max(M.sleeping, 20)
			M.drowsyness = max(M.drowsyness, 60)

/datum/reagent/nutriment/flour
	name = "flour"
	id = "flour"
	description = "This is what you rub all over yourself to pretend to be a ghost."
	taste_description = "chalky wheat"
	reagent_state = SOLID
	nutriment_factor = 1
	color = "#FFFFFF"

/datum/reagent/nutriment/flour/touch_turf(var/turf/simulated/T)
	if(!istype(T, /turf/space))
		new /obj/effect/decal/cleanable/flour(T)

/datum/reagent/nutriment/coco
	name = "Coco Powder"
	id = "coco"
	description = "A fatty, bitter paste made from coco beans."
	taste_description = "bitterness"
	taste_mult = 1.3
	reagent_state = SOLID
	nutriment_factor = 5
	color = "#302000"

/datum/reagent/nutriment/soysauce
	name = "Soysauce"
	id = "soysauce"
	description = "A salty sauce made from the soy plant."
	taste_description = "umami"
	taste_mult = 1.1
	reagent_state = LIQUID
	nutriment_factor = 2
	color = "#792300"

/datum/reagent/nutriment/ketchup
	name = "Ketchup"
	id = "ketchup"
	description = "Ketchup, catsup, whatever. It's tomato paste."
	taste_description = "ketchup"
	reagent_state = LIQUID
	nutriment_factor = 5
	color = "#731008"

/datum/reagent/nutriment/rice
	name = "Rice"
	id = "rice"
	description = "Enjoy the great taste of nothing."
	taste_description = "rice"
	taste_mult = 0.4
	reagent_state = SOLID
	nutriment_factor = 1
	color = "#FFFFFF"

/datum/reagent/nutriment/cherryjelly
	name = "Cherry Jelly"
	id = "cherryjelly"
	description = "Totally the best. Only to be spread on foods with excellent lateral symmetry."
	taste_description = "cherry"
	taste_mult = 1.3
	reagent_state = LIQUID
	nutriment_factor = 1
	color = "#801E28"

/datum/reagent/nutriment/cornoil
	name = "Corn Oil"
	id = "cornoil"
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

/datum/reagent/nutriment/virus_food
	name = "Virus Food"
	id = "virusfood"
	description = "A mixture of water, milk, and oxygen. Virus cells can use this mixture to reproduce."
	taste_description = "vomit"
	taste_mult = 2
	reagent_state = LIQUID
	nutriment_factor = 2
	color = "#899613"

/datum/reagent/nutriment/sprinkles
	name = "Sprinkles"
	id = "sprinkles"
	description = "Multi-colored little bits of sugar, commonly found on donuts. Loved by cops."
	taste_description = "childhood whimsy"
	nutriment_factor = 1
	color = "#FF00FF"

/datum/reagent/nutriment/mint
	name = "Mint"
	id = "mint"
	description = "Also known as Mentha."
	taste_description = "mint"
	reagent_state = LIQUID
	color = "#CF3600"

/datum/reagent/lipozine // The anti-nutriment.
	name = "Lipozine"
	id = "lipozine"
	description = "A chemical compound that causes a powerful fat-burning reaction."
	taste_description = "mothballs"
	reagent_state = LIQUID
	color = "#BBEDA4"
	overdose = REAGENTS_OVERDOSE

/datum/reagent/lipozine/affect_blood(var/mob/living/carbon/M, var/alien, var/removed)
	M.nutrition = max(M.nutrition - 10 * removed, 0)

/* Non-food stuff like condiments */

/datum/reagent/sodiumchloride
	name = "Table Salt"
	id = "sodiumchloride"
	description = "A salt made of sodium chloride. Commonly used to season food."
	taste_description = "salt"
	reagent_state = SOLID
	color = "#FFFFFF"
	overdose = REAGENTS_OVERDOSE

/datum/reagent/blackpepper
	name = "Black Pepper"
	id = "blackpepper"
	description = "A powder ground from peppercorns. *AAAACHOOO*"
	taste_description = "pepper"
	reagent_state = SOLID
	color = "#000000"

/datum/reagent/enzyme
	name = "Universal Enzyme"
	id = "enzyme"
	description = "A universal enzyme used in the preperation of certain chemicals and foods."
	taste_description = "sweetness"
	taste_mult = 0.7
	reagent_state = LIQUID
	color = "#365E30"
	overdose = REAGENTS_OVERDOSE

/datum/reagent/frostoil
	name = "Frost Oil"
	id = "frostoil"
	description = "A special oil that noticably chills the body. Extracted from Ice Peppers."
	taste_description = "mint"
	taste_mult = 1.5
	reagent_state = LIQUID
	color = "#B31008"

/datum/reagent/frostoil/affect_blood(var/mob/living/carbon/M, var/alien, var/removed)
	if(alien == IS_DIONA)
		return
	M.bodytemperature = max(M.bodytemperature - 10 * TEMPERATURE_DAMAGE_COEFFICIENT, 0)
	if(prob(1))
		M.emote("shiver")
	if(istype(M, /mob/living/carbon/slime))
		M.bodytemperature = max(M.bodytemperature - rand(10,20), 0)
	holder.remove_reagent("capsaicin", 5)

/datum/reagent/capsaicin
	name = "Capsaicin Oil"
	id = "capsaicin"
	description = "This is what makes chilis hot."
	taste_description = "hot peppers"
	taste_mult = 1.5
	reagent_state = LIQUID
	color = "#B31008"
	var/agony_dose = 5
	var/agony_amount = 2
	var/discomfort_message = "<span class='danger'>Your insides feel uncomfortably hot!</span>"
	var/slime_temp_adj = 10

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
	if(dose < agony_dose)
		if(prob(5) || dose == metabolism) //dose == metabolism is a very hacky way of forcing the message the first time this procs
			to_chat(M, discomfort_message)
	else
		M.apply_effect(agony_amount, PAIN, 0)
		if(prob(5))
			M.custom_emote(2, "[pick("dry heaves!","coughs!","splutters!")]")
			to_chat(M, "<span class='danger'>You feel like your insides are burning!</span>")
	if(istype(M, /mob/living/carbon/slime))
		M.bodytemperature += rand(0, 15) + slime_temp_adj
	holder.remove_reagent("frostoil", 5)

/datum/reagent/capsaicin/condensed
	name = "Condensed Capsaicin"
	id = "condensedcapsaicin"
	description = "A chemical agent used for self-defense and in police work."
	taste_description = "scorching agony"
	taste_mult = 10
	reagent_state = LIQUID
	touch_met = 50 // Get rid of it quickly
	color = "#B31008"
	agony_dose = 0.5
	agony_amount = 4
	discomfort_message = "<span class='danger'>You feel like your insides are burning!</span>"
	slime_temp_adj = 15

/datum/reagent/capsaicin/condensed/affect_touch(var/mob/living/carbon/M, var/alien, var/removed)
	var/eyes_covered = 0
	var/mouth_covered = 0
	var/no_pain = 0
	var/obj/item/eye_protection = null
	var/obj/item/face_protection = null

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
			if((I.body_parts_covered & FACE) && !(I.item_flags & FLEXIBLEMATERIAL))
				mouth_covered = 1
				face_protection = I.name

	var/message = null
	if(eyes_covered)
		if(!mouth_covered)
			message = "<span class='warning'>Your [eye_protection] protects your eyes from the pepperspray!</span>"
	else
		message = "<span class='warning'>The pepperspray gets in your eyes!</span>"
		if(mouth_covered)
			M.eye_blurry = max(M.eye_blurry, effective_strength * 3)
			M.eye_blind = max(M.eye_blind, effective_strength)
		else
			M.eye_blurry = max(M.eye_blurry, effective_strength * 5)
			M.eye_blind = max(M.eye_blind, effective_strength * 2)

	if(mouth_covered)
		if(!message)
			message = "<span class='warning'>Your [face_protection] protects you from the pepperspray!</span>"
	else if(!no_pain)
		message = "<span class='danger'>Your face and throat burn!</span>"
		if(prob(25))
			M.custom_emote(2, "[pick("coughs!","coughs hysterically!","splutters!")]")
		M.Stun(5)
		M.Weaken(5)

/datum/reagent/condensedcapsaicin/affect_ingest(var/mob/living/carbon/M, var/alien, var/removed)
	if(ishuman(M))
		var/mob/living/carbon/human/H = M
		if(!H.can_feel_pain())
			return
	if(dose == metabolism)
		to_chat(M, "<span class='danger'>You feel like your insides are burning!</span>")
	else
		M.apply_effect(4, PAIN, 0)
		if(prob(5))
			M.visible_message("<span class='warning'>[M] [pick("dry heaves!","coughs!","splutters!")]</span>", "<span class='danger'>You feel like your insides are burning!</span>")
	if(istype(M, /mob/living/carbon/slime))
		M.bodytemperature += rand(15, 30)
	holder.remove_reagent("frostoil", 5)

/* Drinks */

/datum/reagent/drink
	name = "Drink"
	id = "drink"
	description = "Uh, some kind of drink."
	reagent_state = LIQUID
	color = "#E78108"
	var/nutrition = 0 // Per unit
	var/adj_dizzy = 0 // Per tick
	var/adj_drowsy = 0
	var/adj_sleepy = 0
	var/adj_temp = 0

/datum/reagent/drink/affect_blood(var/mob/living/carbon/M, var/alien, var/removed)
	M.adjustToxLoss(removed) // Probably not a good idea; not very deadly though
	return

/datum/reagent/drink/affect_ingest(var/mob/living/carbon/M, var/alien, var/removed)
	M.nutrition += nutrition * removed
	M.dizziness = max(0, M.dizziness + adj_dizzy)
	M.drowsyness = max(0, M.drowsyness + adj_drowsy)
	M.sleeping = max(0, M.sleeping + adj_sleepy)
	if(adj_temp > 0 && M.bodytemperature < 310) // 310 is the normal bodytemp. 310.055
		M.bodytemperature = min(310, M.bodytemperature + (adj_temp * TEMPERATURE_DAMAGE_COEFFICIENT))
	if(adj_temp < 0 && M.bodytemperature > 310)
		M.bodytemperature = min(310, M.bodytemperature - (adj_temp * TEMPERATURE_DAMAGE_COEFFICIENT))

// Juices
/datum/reagent/drink/juice/affect_ingest(var/mob/living/carbon/M, var/alien, var/removed)
	..()

	var/effective_dose = dose/2
	if(alien == IS_UNATHI)
		if(effective_dose < 2)
			if(effective_dose == metabolism * 2 || prob(5))
				M.emote("yawn")
		else if(effective_dose < 5)
			M.eye_blurry = max(M.eye_blurry, 10)
		else if(effective_dose < 20)
			if(prob(50))
				M.Weaken(2)
			M.drowsyness = max(M.drowsyness, 20)
		else
			M.sleeping = max(M.sleeping, 20)
			M.drowsyness = max(M.drowsyness, 60)

/datum/reagent/drink/juice/banana
	name = "Banana Juice"
	id = "banana"
	description = "The raw essence of a banana."
	taste_description = "banana"
	color = "#C3AF00"

	glass_name = "banana juice"
	glass_desc = "The raw essence of a banana. HONK!"

/datum/reagent/drink/juice/berry
	name = "Berry Juice"
	id = "berryjuice"
	description = "A delicious blend of several different kinds of berries."
	taste_description = "berries"
	color = "#990066"

	glass_name = "berry juice"
	glass_desc = "Berry juice. Or maybe it's jam. Who cares?"

/datum/reagent/drink/juice/carrot
	name = "Carrot juice"
	id = "carrotjuice"
	description = "It is just like a carrot but without crunching."
	taste_description = "carrots"
	color = "#FF8C00" // rgb: 255, 140, 0

	glass_name = "carrot juice"
	glass_desc = "It is just like a carrot but without crunching."

/datum/reagent/drink/juice/carrot/affect_ingest(var/mob/living/carbon/M, var/alien, var/removed)
	..()
	M.reagents.add_reagent("imidazoline", removed * 0.2)

/datum/reagent/drink/juice/grape
	name = "Grape Juice"
	id = "grapejuice"
	description = "It's grrrrrape!"
	taste_description = "grapes"
	color = "#863333"

	glass_name = "grape juice"
	glass_desc = "It's grrrrrape!"

/datum/reagent/drink/juice/lemon
	name = "Lemon Juice"
	id = "lemonjuice"
	description = "This juice is VERY sour."
	taste_description = "sourness"
	taste_mult = 1.1
	color = "#AFAF00"

	glass_name = "lemon juice"
	glass_desc = "Sour..."

/datum/reagent/drink/juice/lime
	name = "Lime Juice"
	id = "limejuice"
	description = "The sweet-sour juice of limes."
	taste_description = "unbearable sourness"
	taste_mult = 1.1
	color = "#365E30"

	glass_name = "lime juice"
	glass_desc = "A glass of sweet-sour lime juice"

/datum/reagent/drink/juice/lime/affect_ingest(var/mob/living/carbon/M, var/alien, var/removed)
	..()
	if(alien == IS_DIONA)
		return
	M.adjustToxLoss(-0.5 * removed)

/datum/reagent/drink/juice/orange
	name = "Orange juice"
	id = "orangejuice"
	description = "Both delicious AND rich in Vitamin C, what more do you need?"
	taste_description = "oranges"
	color = "#E78108"

	glass_name = "orange juice"
	glass_desc = "Vitamins! Yay!"

/datum/reagent/drink/juice/orange/affect_ingest(var/mob/living/carbon/M, var/alien, var/removed)
	..()
	if(alien == IS_DIONA)
		return
	M.adjustOxyLoss(-2 * removed)

/datum/reagent/toxin/poisonberryjuice // It has more in common with toxins than drinks... but it's a juice
	name = "Poison Berry Juice"
	id = "poisonberryjuice"
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
	id = "potato"
	description = "Juice of the potato. Bleh."
	taste_description = "irish sadness"
	nutrition = 2
	color = "#302000"

	glass_name = "potato juice"
	glass_desc = "Juice from a potato. Bleh."

/datum/reagent/drink/juice/tomato
	name = "Tomato Juice"
	id = "tomatojuice"
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
	id = "watermelonjuice"
	description = "Delicious juice made from watermelon."
	taste_description = "sweet watermelon"
	color = "#B83333"

	glass_name = "watermelon juice"
	glass_desc = "Delicious juice made from watermelon."

// Everything else

/datum/reagent/drink/milk
	name = "Milk"
	id = "milk"
	description = "An opaque white liquid produced by the mammary glands of mammals."
	taste_description = "milk"
	color = "#DFDFDF"

	glass_name = "milk"
	glass_desc = "White and nutritious goodness!"

/datum/reagent/drink/milk/chocolate
	name =  "Chocolate Milk"
	id = "chocolate_milk"
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
	holder.remove_reagent("capsaicin", 10 * removed)

/datum/reagent/drink/milk/cream
	name = "Cream"
	id = "cream"
	description = "The fatty, still liquid part of milk. Why don't you mix this with sum scotch, eh?"
	taste_description = "creamy milk"
	color = "#DFD7AF"

	glass_name = "cream"
	glass_desc = "Ewwww..."

/datum/reagent/drink/milk/soymilk
	name = "Soy Milk"
	id = "soymilk"
	description = "An opaque white liquid made from soybeans."
	taste_description = "soy milk"
	color = "#DFDFC7"

	glass_name = "soy milk"
	glass_desc = "White and nutritious soy goodness!"

/datum/reagent/drink/tea
	name = "Tea"
	id = "tea"
	description = "Tasty black tea, it has antioxidants, it's good for you!"
	taste_description = "tart black tea"
	color = "#101000"
	adj_dizzy = -2
	adj_drowsy = -1
	adj_sleepy = -3
	adj_temp = 20

	glass_name = "cup of tea"
	glass_desc = "Tasty black tea, it has antioxidants, it's good for you!"

/datum/reagent/drink/tea/affect_ingest(var/mob/living/carbon/M, var/alien, var/removed)
	..()
	if(alien == IS_DIONA)
		return
	M.adjustToxLoss(-0.5 * removed)

/datum/reagent/drink/tea/icetea
	name = "Iced Tea"
	id = "icetea"
	description = "No relation to a certain rap artist/ actor."
	taste_description = "sweet tea"
	color = "#104038" // rgb: 16, 64, 56
	adj_temp = -5

	glass_name = "iced tea"
	glass_desc = "No relation to a certain rap artist/ actor."
	glass_special = list(DRINK_ICE)

/datum/reagent/drink/coffee
	name = "Coffee"
	id = "coffee"
	description = "Coffee is a brewed drink prepared from roasted seeds, commonly called coffee beans, of the coffee plant."
	taste_description = "bitterness"
	taste_mult = 1.3
	color = "#482000"
	adj_dizzy = -5
	adj_drowsy = -3
	adj_sleepy = -2
	adj_temp = 25
	overdose = 45

	glass_name = "cup of coffee"
	glass_desc = "Don't drop it, or you'll send scalding liquid and glass shards everywhere."

/datum/reagent/drink/coffee/affect_ingest(var/mob/living/carbon/M, var/alien, var/removed)
	if(alien == IS_DIONA)
		return
	..()
	if(alien == IS_TAJARA)
		M.adjustToxLoss(0.5 * removed)
		M.make_jittery(4) //extra sensitive to caffine
	if(adj_temp > 0)
		holder.remove_reagent("frostoil", 10 * removed)
	M.add_chemical_effect(CE_PULSE, 1)

/datum/reagent/nutriment/coffee/affect_blood(var/mob/living/carbon/M, var/alien, var/removed)
	..()
	if(alien == IS_TAJARA)
		M.adjustToxLoss(2 * removed)
		M.make_jittery(4)
		return

/datum/reagent/drink/coffee/overdose(var/mob/living/carbon/M, var/alien)
	if(alien == IS_DIONA)
		return
	if(alien == IS_TAJARA)
		M.adjustToxLoss(4 * REM)
		M.apply_effect(3, STUTTER)
	M.make_jittery(5)
	M.add_chemical_effect(CE_PULSE, 2)

/datum/reagent/drink/coffee/icecoffee
	name = "Iced Coffee"
	id = "icecoffee"
	description = "Coffee and ice, refreshing and cool."
	taste_description = "bitter coldness"
	color = "#102838"
	adj_temp = -5

	glass_name = "iced coffee"
	glass_desc = "A drink to perk you up and refresh you!"
	glass_special = list(DRINK_ICE)

/datum/reagent/drink/coffee/soy_latte
	name = "Soy Latte"
	id = "soy_latte"
	description = "A nice and tasty beverage while you are reading your hippie books."
	taste_description = "creamy coffee"
	color = "#C65905"
	adj_temp = 5

	glass_name = "soy latte"
	glass_desc = "A nice and refrshing beverage while you are reading."

/datum/reagent/drink/coffee/soy_latte/affect_ingest(var/mob/living/carbon/M, var/alien, var/removed)
	..()
	M.heal_organ_damage(0.5 * removed, 0)

/datum/reagent/drink/coffee/cafe_latte
	name = "Cafe Latte"
	id = "cafe_latte"
	description = "A nice, strong and tasty beverage while you are reading."
	taste_description = "bitter cream"
	color = "#C65905"
	adj_temp = 5

	glass_name = "cafe latte"
	glass_desc = "A nice, strong and refreshing beverage while you are reading."

/datum/reagent/drink/coffee/cafe_latte/affect_ingest(var/mob/living/carbon/M, var/alien, var/removed)
	..()
	M.heal_organ_damage(0.5 * removed, 0)

/datum/reagent/drink/hot_coco
	name = "Hot Chocolate"
	id = "hot_coco"
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
	id = "sodawater"
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
	id = "grapesoda"
	description = "Grapes made into a fine drank."
	taste_description = "grape soda"
	color = "#421C52"
	adj_drowsy = -3

	glass_name = "grape soda"
	glass_desc = "Looks like a delicious drink!"
	glass_special = list(DRINK_FIZZ)

/datum/reagent/drink/tonic
	name = "Tonic Water"
	id = "tonic"
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
	id = "lemonade"
	color = "#FFFF00"
	adj_temp = -5

	glass_name = "lemonade"
	glass_desc = "Oh the nostalgia..."
	glass_special = list(DRINK_FIZZ)

/datum/reagent/drink/kiraspecial
	name = "Kira Special"
	description = "Long live the guy who everyone had mistaken for a girl. Baka!"
	taste_description = "fruity sweetness"
	id = "kiraspecial"
	color = "#CCCC99"
	adj_temp = -5

	glass_name = "Kira Special"
	glass_desc = "Long live the guy who everyone had mistaken for a girl. Baka!"
	glass_special = list(DRINK_FIZZ)

/datum/reagent/drink/brownstar
	name = "Brown Star"
	description = "It's not what it sounds like..."
	taste_description = "orange and cola soda"
	id = "brownstar"
	color = "#9F3400"
	adj_temp = -2

	glass_name = "Brown Star"
	glass_desc = "It's not what it sounds like..."

/datum/reagent/drink/milkshake
	name = "Milkshake"
	description = "Glorious brainfreezing mixture."
	taste_description = "creamy vanilla"
	id = "milkshake"
	color = "#AEE5E4"
	adj_temp = -9

	glass_name = "milkshake"
	glass_desc = "Glorious brainfreezing mixture."

/datum/reagent/milkshake/affect_ingest(var/mob/living/carbon/M, var/alien, var/removed)
	..()

	var/effective_dose = dose/2
	if(alien == IS_UNATHI)
		if(effective_dose < 2)
			if(effective_dose == metabolism * 2 || prob(5))
				M.emote("yawn")
		else if(effective_dose < 5)
			M.eye_blurry = max(M.eye_blurry, 10)
		else if(effective_dose < 20)
			if(prob(50))
				M.Weaken(2)
			M.drowsyness = max(M.drowsyness, 20)
		else
			M.sleeping = max(M.sleeping, 20)
			M.drowsyness = max(M.drowsyness, 60)

/datum/reagent/drink/rewriter
	name = "Rewriter"
	description = "The secret of the sanctuary of the Libarian..."
	taste_description = "a bad night out"
	id = "rewriter"
	color = "#485000"
	adj_temp = -5

	glass_name = "Rewriter"
	glass_desc = "The secret of the sanctuary of the Libarian..."

/datum/reagent/drink/rewriter/affect_ingest(var/mob/living/carbon/M, var/alien, var/removed)
	..()
	M.make_jittery(5)

/datum/reagent/drink/nuka_cola
	name = "Nuka Cola"
	id = "nuka_cola"
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
	id = "grenadine"
	description = "Made in the modern day with proper pomegranate substitute. Who uses real fruit, anyways?"
	taste_description = "100% pure pomegranate"
	color = "#FF004F"

	glass_name = "grenadine syrup"
	glass_desc = "Sweet and tangy, a bar syrup used to add color or flavor to drinks."

/datum/reagent/drink/space_cola
	name = "Space Cola"
	id = "cola"
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
	id = "spacemountainwind"
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
	id = "dr_gibb"
	description = "A delicious blend of 42 different flavours"
	taste_description = "cherry soda"
	color = "#102000"
	adj_drowsy = -6
	adj_temp = -5

	glass_name = "Dr. Gibb"
	glass_desc = "Dr. Gibb. Not as dangerous as the name might imply."

/datum/reagent/drink/space_up
	name = "Space-Up"
	id = "space_up"
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
	id = "lemon_lime"
	color = "#878F00"
	adj_temp = -8

	glass_name = "lemon lime soda"
	glass_desc = "A tangy substance made of 0.5% natural citrus!"
	glass_special = list(DRINK_FIZZ)

/datum/reagent/drink/doctor_delight
	name = "The Doctor's Delight"
	id = "doctorsdelight"
	description = "A gulp a day keeps the MediBot away. That's probably for the best."
	taste_description = "homely fruit"
	reagent_state = LIQUID
	color = "#FF8CFF"
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
	id = "dry_ramen"
	description = "Space age food, since August 25, 1958. Contains dried noodles, vegetables, and chemicals that boil in contact with water."
	taste_description = "dry and cheap noodles"
	reagent_state = SOLID
	nutrition = 1
	color = "#302000"

/datum/reagent/drink/hot_ramen
	name = "Hot Ramen"
	id = "hot_ramen"
	description = "The noodles are boiled, the flavors are artificial, just like being back in school."
	taste_description = "wet and cheap noodles"
	reagent_state = LIQUID
	color = "#302000"
	nutrition = 5
	adj_temp = 5

/datum/reagent/drink/hell_ramen
	name = "Hell Ramen"
	id = "hell_ramen"
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

/datum/reagent/drink/ice
	name = "Ice"
	id = "ice"
	description = "Frozen water, your dentist wouldn't like you chewing this."
	taste_description = "ice"
	taste_mult = 1.5
	reagent_state = SOLID
	color = "#619494"
	adj_temp = -5

	glass_name = "ice"
	glass_desc = "Generally, you're supposed to put something else in there too..."
	glass_icon = DRINK_ICON_NOISY

/datum/reagent/drink/nothing
	name = "Nothing"
	id = "nothing"
	description = "Absolutely nothing."
	taste_description = "nothing"

	glass_name = "nothing"
	glass_desc = "Absolutely nothing."

/* Alcohol */

// Basic

/datum/reagent/ethanol/absinthe
	name = "Absinthe"
	id = "absinthe"
	description = "Watch out that the Green Fairy doesn't come for you!"
	taste_description = "death and licorice"
	taste_mult = 1.5
	color = "#33EE00"
	strength = 12

	glass_name = "absinthe"
	glass_desc = "Wormwood, anise, oh my."

/datum/reagent/ethanol/ale
	name = "Ale"
	id = "ale"
	description = "A dark alchoholic beverage made by malted barley and yeast."
	taste_description = "hearty barley ale"
	color = "#4C3100"
	strength = 50

	glass_name = "ale"
	glass_desc = "A freezing pint of delicious ale"

/datum/reagent/ethanol/beer
	name = "Beer"
	id = "beer"
	description = "An alcoholic beverage made from malted grains, hops, yeast, and water."
	taste_description = "piss water"
	color = "#FFD300"
	strength = 50
	nutriment_factor = 1

	glass_name = "beer"
	glass_desc = "A freezing pint of beer"

/datum/reagent/ethanol/beer/affect_ingest(var/mob/living/carbon/M, var/alien, var/removed)
	..()
	if(alien == IS_DIONA)
		return
	M.jitteriness = max(M.jitteriness - 3, 0)

/datum/reagent/ethanol/bluecuracao
	name = "Blue Curacao"
	id = "bluecuracao"
	description = "Exotically blue, fruity drink, distilled from oranges."
	taste_description = "oranges"
	taste_mult = 1.1
	color = "#0000CD"
	strength = 15

	glass_name = "blue curacao"
	glass_desc = "Exotically blue, fruity drink, distilled from oranges."

/datum/reagent/ethanol/cognac
	name = "Cognac"
	id = "cognac"
	description = "A sweet and strongly alchoholic drink, made after numerous distillations and years of maturing. Classy as fornication."
	taste_description = "rich and smooth alcohol"
	taste_mult = 1.1
	color = "#AB3C05"
	strength = 15

	glass_name = "cognac"
	glass_desc = "Damn, you feel like some kind of French aristocrat just by holding this."

/datum/reagent/ethanol/deadrum
	name = "Deadrum"
	id = "deadrum"
	description = "Popular with the sailors. Not very popular with everyone else."
	taste_description = "salty sea water"
	color = "#ECB633"
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
	id = "gin"
	description = "It's gin. In space. I say, good sir."
	taste_description = "an alcoholic christmas tree"
	color = "#0064C6"
	strength = 50

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
	if(alien == IS_TAJARA)
		M.adjustToxLoss(0.5 * removed)
		M.make_jittery(4) //extra sensitive to caffine

/datum/reagent/ethanol/coffee/affect_blood(var/mob/living/carbon/M, var/alien, var/removed)
	if(alien == IS_TAJARA)
		M.adjustToxLoss(2 * removed)
		M.make_jittery(4)
		return
	..()

/datum/reagent/ethanol/coffee/overdose(var/mob/living/carbon/M, var/alien)
	if(alien == IS_DIONA)
		return
	if(alien == IS_TAJARA)
		M.adjustToxLoss(4 * REM)
		M.apply_effect(3, STUTTER)
	M.make_jittery(5)

/datum/reagent/ethanol/coffee/kahlua
	name = "Kahlua"
	id = "kahlua"
	description = "A widely known, Mexican coffee-flavoured liqueur. In production since 1936!"
	taste_description = "spiked latte"
	taste_mult = 1.1
	color = "#4C3100"
	strength = 15

	glass_name = "RR coffee liquor"
	glass_desc = "DAMN, THIS THING LOOKS ROBUST"

/datum/reagent/ethanol/melonliquor
	name = "Melon Liquor"
	id = "melonliquor"
	description = "A relatively sweet and fruity 46 proof liquor."
	taste_description = "fruity alcohol"
	color = "#138808" // rgb: 19, 136, 8
	strength = 50

	glass_name = "melon liquor"
	glass_desc = "A relatively sweet and fruity 46 proof liquor."

/datum/reagent/ethanol/rum
	name = "Rum"
	id = "rum"
	description = "Yohoho and all that."
	taste_description = "spiked butterscotch"
	taste_mult = 1.1
	color = "#ECB633"
	strength = 15

	glass_name = "rum"
	glass_desc = "Now you want to Pray for a pirate suit, don't you?"

/datum/reagent/ethanol/sake
	name = "Sake"
	id = "sake"
	description = "Anime's favorite drink."
	taste_description = "dry alcohol"
	color = "#DDDDDD"
	strength = 25

	glass_name = "sake"
	glass_desc = "A glass of sake."

/datum/reagent/ethanol/tequilla
	name = "Tequila"
	id = "tequilla"
	description = "A strong and mildly flavoured, mexican produced spirit. Feeling thirsty hombre?"
	taste_description = "paint stripper"
	color = "#FFFF91"
	strength = 25

	glass_name = "Tequilla"
	glass_desc = "Now all that's missing is the weird colored shades!"

/datum/reagent/ethanol/thirteenloko
	name = "Thirteen Loko"
	id = "thirteenloko"
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
	id = "vermouth"
	description = "You suddenly feel a craving for a martini..."
	taste_description = "dry alcohol"
	taste_mult = 1.3
	color = "#91FF91" // rgb: 145, 255, 145
	strength = 15

	glass_name = "vermouth"
	glass_desc = "You wonder why you're even drinking this straight."

/datum/reagent/ethanol/vodka
	name = "Vodka"
	id = "vodka"
	description = "Number one drink AND fueling choice for Russians worldwide."
	taste_description = "grain alcohol"
	color = "#0064C8" // rgb: 0, 100, 200
	strength = 15

	glass_name = "vodka"
	glass_desc = "The glass contain wodka. Xynta."

/datum/reagent/ethanol/vodka/affect_ingest(var/mob/living/carbon/M, var/alien, var/removed)
	..()
	M.apply_effect(max(M.radiation - 1 * removed, 0), IRRADIATE, blocked = 0)

/datum/reagent/ethanol/whiskey
	name = "Whiskey"
	id = "whiskey"
	description = "A superb and well-aged single-malt whiskey. Damn."
	taste_description = "molasses"
	color = "#4C3100"
	strength = 25

	glass_name = "whiskey"
	glass_desc = "The silky, smokey whiskey goodness inside the glass makes the drink look very classy."

/datum/reagent/ethanol/wine
	name = "Wine"
	id = "wine"
	description = "An premium alchoholic beverage made from distilled grape juice."
	taste_description = "bitter sweetness"
	color = "#7E4043" // rgb: 126, 64, 67
	strength = 15

	glass_name = "wine"
	glass_desc = "A very classy looking drink."

// Cocktails

/datum/reagent/ethanol/acid_spit
	name = "Acid Spit"
	id = "acidspit"
	description = "A drink for the daring, can be deadly if incorrectly prepared!"
	taste_description = "stomach acid"
	reagent_state = LIQUID
	color = "#365000"
	strength = 30

	glass_name = "Acid Spit"
	glass_desc = "A drink from the company archives. Made from live aliens."

/datum/reagent/ethanol/alliescocktail
	name = "Allies Cocktail"
	id = "alliescocktail"
	description = "A drink made from your allies, not as sweet as when made from your enemies."
	taste_description = "bitter yet free"
	color = "#D8AC45"
	strength = 25

	glass_name = "Allies cocktail"
	glass_desc = "A drink made from your allies."

/datum/reagent/ethanol/aloe
	name = "Aloe"
	id = "aloe"
	description = "So very, very, very good."
	taste_description = "sweet 'n creamy"
	color = "#B7EA75"
	strength = 15

	glass_name = "Aloe"
	glass_desc = "Very, very, very good."

/datum/reagent/ethanol/amasec
	name = "Amasec"
	id = "amasec"
	description = "Official drink of the Gun Club!"
	taste_description = "dark and metallic"
	reagent_state = LIQUID
	color = "#FF975D"
	strength = 25

	glass_name = "Amasec"
	glass_desc = "Always handy before COMBAT!!!"

/datum/reagent/ethanol/andalusia
	name = "Andalusia"
	id = "andalusia"
	description = "A nice, strangely named drink."
	taste_description = "lemons"
	color = "#F4EA4A"
	strength = 15

	glass_name = "Andalusia"
	glass_desc = "A nice, strange named drink."

/datum/reagent/ethanol/antifreeze
	name = "Anti-freeze"
	id = "antifreeze"
	description = "Ultimate refreshment."
	taste_description = "Jack Frost's piss"
	color = "#56DEEA"
	strength = 12
	adj_temp = 20
	targ_temp = 330

	glass_name = "Anti-freeze"
	glass_desc = "The ultimate refreshment."

/datum/reagent/ethanol/atomicbomb
	name = "Atomic Bomb"
	id = "atomicbomb"
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
	id = "b52"
	description = "Coffee, Irish Cream, and cognac. You will get bombed."
	taste_description = "angry and irish"
	taste_mult = 1.3
	color = "#997650"
	strength = 12

	glass_name = "B-52"
	glass_desc = "Kahlua, Irish cream, and congac. You will get bombed."

/datum/reagent/ethanol/bahama_mama
	name = "Bahama mama"
	id = "bahama_mama"
	description = "Tropical cocktail."
	taste_description = "lime and orange"
	color = "#FF7F3B"
	strength = 25

	glass_name = "Bahama Mama"
	glass_desc = "Tropical cocktail"

/datum/reagent/ethanol/bananahonk
	name = "Banana Mama"
	id = "bananahonk"
	description = "A drink from Clown Heaven."
	taste_description = "a bad joke"
	nutriment_factor = 1
	color = "#FFFF91"
	strength = 12

	glass_name = "Banana Honk"
	glass_desc = "A drink from Banana Heaven."

/datum/reagent/ethanol/barefoot
	name = "Barefoot"
	id = "barefoot"
	description = "Barefoot and pregnant"
	taste_description = "creamy berries"
	color = "#FFCDEA"
	strength = 30

	glass_name = "Barefoot"
	glass_desc = "Barefoot and pregnant"

/datum/reagent/ethanol/beepsky_smash
	name = "Beepsky Smash"
	id = "beepskysmash"
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
	id = "bilk"
	description = "This appears to be beer mixed with milk. Disgusting."
	taste_description = "desperation and lactate"
	color = "#895C4C"
	strength = 50
	nutriment_factor = 2

	glass_name = "bilk"
	glass_desc = "A brew of milk and beer. For those alcoholics who fear osteoporosis."

/datum/reagent/ethanol/black_russian
	name = "Black Russian"
	id = "blackrussian"
	description = "For the lactose-intolerant. Still as classy as a White Russian."
	taste_description = "bitterness"
	color = "#360000"
	strength = 15

	glass_name = "Black Russian"
	glass_desc = "For the lactose-intolerant. Still as classy as a White Russian."

/datum/reagent/ethanol/bloody_mary
	name = "Bloody Mary"
	id = "bloodymary"
	description = "A strange yet pleasurable mixture made of vodka, tomato and lime juice. Or at least you THINK the red stuff is tomato juice."
	taste_description = "tomatoes with a hint of lime"
	color = "#B40000"
	strength = 15

	glass_name = "Bloody Mary"
	glass_desc = "Tomato juice, mixed with Vodka and a lil' bit of lime. Tastes like liquid murder."

/datum/reagent/ethanol/booger
	name = "Booger"
	id = "booger"
	description = "Ewww..."
	taste_description = "sweet 'n creamy"
	color = "#8CFF8C"
	strength = 30

	glass_name = "Booger"
	glass_desc = "Ewww..."

/datum/reagent/ethanol/coffee/brave_bull
	name = "Brave Bull"
	id = "bravebull"
	description = "It's just as effective as Dutch-Courage!"
	taste_description = "alcoholic bravery"
	taste_mult = 1.1
	color = "#4C3100"
	strength = 15

	glass_name = "Brave Bull"
	glass_desc = "Tequilla and coffee liquor, brought together in a mouthwatering mixture. Drink up."

/datum/reagent/ethanol/changelingsting
	name = "Changeling Sting"
	id = "changelingsting"
	description = "You take a tiny sip and feel a burning sensation..."
	taste_description = "your brain coming out your nose"
	color = "#2E6671"
	strength = 10

	glass_name = "Changeling Sting"
	glass_desc = "A stingy drink."

/datum/reagent/ethanol/martini
	name = "Classic Martini"
	id = "martini"
	description = "Vermouth with Gin. Not quite how 007 enjoyed it, but still delicious."
	taste_description = "dry class"
	color = "#0064C8"
	strength = 25

	glass_name = "classic martini"
	glass_desc = "Damn, the bartender even stirred it, not shook it."

/datum/reagent/ethanol/cuba_libre
	name = "Cuba Libre"
	id = "cubalibre"
	description = "Rum, mixed with cola. Viva la revolucion."
	taste_description = "cola"
	color = "#3E1B00"
	strength = 30

	glass_name = "Cuba Libre"
	glass_desc = "A classic mix of rum and cola."

/datum/reagent/ethanol/demonsblood
	name = "Demons Blood"
	id = "demonsblood"
	description = "AHHHH!!!!"
	taste_description = "sweet tasting iron"
	taste_mult = 1.5
	color = "#820000"
	strength = 15

	glass_name = "Demons' Blood"
	glass_desc = "Just looking at this thing makes the hair at the back of your neck stand up."

/datum/reagent/ethanol/devilskiss
	name = "Devils Kiss"
	id = "devilskiss"
	description = "Creepy time!"
	taste_description = "bitter iron"
	color = "#A68310"
	strength = 15

	glass_name = "Devil's Kiss"
	glass_desc = "Creepy time!"

/datum/reagent/ethanol/driestmartini
	name = "Driest Martini"
	id = "driestmartini"
	description = "Only for the experienced. You think you see sand floating in the glass."
	taste_description = "a beach"
	nutriment_factor = 1
	color = "#2E6671"
	strength = 12

	glass_name = "Driest Martini"
	glass_desc = "Only for the experienced. You think you see sand floating in the glass."

/datum/reagent/ethanol/ginfizz
	name = "Gin Fizz"
	id = "ginfizz"
	description = "Refreshingly lemony, deliciously dry."
	taste_description = "dry, tart lemons"
	color = "#FFFFAE"
	strength = 30

	glass_name = "gin fizz"
	glass_desc = "Refreshingly lemony, deliciously dry."

/datum/reagent/ethanol/grog
	name = "Grog"
	id = "grog"
	description = "Watered-down rum, pirate approved!"
	taste_description = "a poor excuse for alcohol"
	reagent_state = LIQUID
	color = "#FFBB00"
	strength = 100


	glass_name = "grog"
	glass_desc = "A fine and cepa drink for Space."

/datum/reagent/ethanol/erikasurprise
	name = "Erika Surprise"
	id = "erikasurprise"
	description = "The surprise is, it's green!"
	taste_description = "tartness and bananas"
	color = "#2E6671"
	strength = 15

	glass_name = "Erika Surprise"
	glass_desc = "The surprise is, it's green!"

/datum/reagent/ethanol/gargle_blaster
	name = "Pan-Galactic Gargle Blaster"
	id = "gargleblaster"
	description = "Whoah, this stuff looks volatile!"
	taste_description = "your brains smashed out by a lemon wrapped around a gold brick"
	taste_mult = 5
	reagent_state = LIQUID
	color = "#7F00FF"
	strength = 10

	glass_name = "Pan-Galactic Gargle Blaster"
	glass_desc = "Does... does this mean that Arthur and Ford are on the station? Oh joy."

/datum/reagent/ethanol/gintonic
	name = "Gin and Tonic"
	id = "gintonic"
	description = "An all time classic, mild cocktail."
	taste_description = "mild and tart"
	color = "#0064C8"
	strength = 50

	glass_name = "gin and tonic"
	glass_desc = "A mild but still great cocktail. Drink up, like a true Englishman."

/datum/reagent/ethanol/goldschlager
	name = "Goldschlager"
	id = "goldschlager"
	description = "100 proof cinnamon schnapps, made for alcoholic teen girls on spring break."
	taste_description = "burning cinnamon"
	taste_mult = 1.3
	color = "#F4E46D"
	strength = 15

	glass_name = "Goldschlager"
	glass_desc = "100 proof that teen girls will drink anything with gold in it."

/datum/reagent/ethanol/hippies_delight
	name = "Hippies' Delight"
	id = "hippiesdelight"
	description = "You just don't get it maaaan."
	taste_description = "giving peace a chance"
	reagent_state = LIQUID
	color = "#FF88FF"
	strength = 15
	druggy = 50

	glass_name = "Hippie's Delight"
	glass_desc = "A drink enjoyed by people during the 1960's."

/datum/reagent/ethanol/hooch
	name = "Hooch"
	id = "hooch"
	description = "Either someone's failure at cocktail making or attempt in alchohol production. In any case, do you really want to drink that?"
	taste_description = "pure resignation"
	color = "#4C3100"
	strength = 25
	toxicity = 2

	glass_name = "Hooch"
	glass_desc = "You've really hit rock bottom now... your liver packed its bags and left last night."

/datum/reagent/ethanol/iced_beer
	name = "Iced Beer"
	id = "iced_beer"
	description = "A beer which is so cold the air around it freezes."
	taste_description = "refreshingly cold"
	color = "#FFD300"
	strength = 50
	adj_temp = -20
	targ_temp = 270

	glass_name = "iced beer"
	glass_desc = "A beer so frosty, the air around it freezes."
	glass_special = list(DRINK_ICE)

/datum/reagent/ethanol/irishcarbomb
	name = "Irish Car Bomb"
	id = "irishcarbomb"
	description = "Mmm, tastes like chocolate cake..."
	taste_description = "delicious anger"
	color = "#2E6671"
	strength = 15

	glass_name = "Irish Car Bomb"
	glass_desc = "An irish car bomb."

/datum/reagent/ethanol/coffee/irishcoffee
	name = "Irish Coffee"
	id = "irishcoffee"
	description = "Coffee, and alcohol. More fun than a Mimosa to drink in the morning."
	taste_description = "giving up on the day"
	color = "#4C3100"
	strength = 15

	glass_name = "Irish coffee"
	glass_desc = "Coffee and alcohol. More fun than a Mimosa to drink in the morning."

/datum/reagent/ethanol/irish_cream
	name = "Irish Cream"
	id = "irishcream"
	description = "Whiskey-imbued cream, what else would you expect from the Irish."
	taste_description = "creamy alcohol"
	color = "#DDDD9A3"
	strength = 25

	glass_name = "Irish cream"
	glass_desc = "It's cream, mixed with whiskey. What else would you expect from the Irish?"

/datum/reagent/ethanol/longislandicedtea
	name = "Long Island Iced Tea"
	id = "longislandicedtea"
	description = "The liquor cabinet, brought together in a delicious mix. Intended for middle-aged alcoholic women only."
	taste_description = "a mixture of cola and alcohol"
	color = "#895B1F"
	strength = 12

	glass_name = "Long Island iced tea"
	glass_desc = "The liquor cabinet, brought together in a delicious mix. Intended for middle-aged alcoholic women only."

/datum/reagent/ethanol/manhattan
	name = "Manhattan"
	id = "manhattan"
	description = "The Detective's undercover drink of choice. He never could stomach gin..."
	taste_description = "mild dryness"
	color = "#C13600"
	strength = 15

	glass_name = "Manhattan"
	glass_desc = "The Detective's undercover drink of choice. He never could stomach gin..."

/datum/reagent/ethanol/manhattan_proj
	name = "Manhattan Project"
	id = "manhattan_proj"
	description = "A scientist's drink of choice, for pondering ways to blow up the station."
	taste_description = "death, the destroyer of worlds"
	color = "#C15D00"
	strength = 10
	druggy = 30

	glass_name = "Manhattan Project"
	glass_desc = "A scienitst drink of choice, for thinking how to blow up the station."

/datum/reagent/ethanol/manly_dorf
	name = "The Manly Dorf"
	id = "manlydorf"
	description = "Beer and Ale, brought together in a delicious mix. Intended for true men only."
	taste_description = "hair on your chest and your chin"
	color = "#4C3100"
	strength = 25

	glass_name = "The Manly Dorf"
	glass_desc = "A manly concotion made from Ale and Beer. Intended for true men only."

/datum/reagent/ethanol/margarita
	name = "Margarita"
	id = "margarita"
	description = "On the rocks with salt on the rim. Arriba~!"
	taste_description = "dry and salty"
	color = "#8CFF8C"
	strength = 15

	glass_name = "margarita"
	glass_desc = "On the rocks with salt on the rim. Arriba~!"

/datum/reagent/ethanol/mead
	name = "Mead"
	id = "mead"
	description = "A Viking's drink, though a cheap one."
	taste_description = "sweet, sweet alcohol"
	reagent_state = LIQUID
	color = "#FFBB00"
	strength = 30
	nutriment_factor = 1

	glass_name = "mead"
	glass_desc = "A Viking's beverage, though a cheap one."

/datum/reagent/ethanol/moonshine
	name = "Moonshine"
	id = "moonshine"
	description = "You've really hit rock bottom now... your liver packed its bags and left last night."
	taste_description = "bitterness"
	taste_mult = 2.5
	color = "#0064C8"
	strength = 12

	glass_name = "moonshine"
	glass_desc = "You've really hit rock bottom now... your liver packed its bags and left last night."

/datum/reagent/ethanol/neurotoxin
	name = "Neurotoxin"
	id = "neurotoxin"
	description = "A strong neurotoxin that puts the subject into a death-like state."
	taste_description = "a numbing sensation"
	reagent_state = LIQUID
	color = "#2E2E61"
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
	id = "patron"
	description = "Tequila with silver in it, a favorite of alcoholic women in the club scene."
	taste_description = "metallic and expensive"
	color = "#585840"
	strength = 30

	glass_name = "Patron"
	glass_desc = "Drinking patron in the bar, with all the subpar ladies."

/datum/reagent/ethanol/pwine
	name = "Poison Wine"
	id = "pwine"
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
	if(dose > 30)
		M.adjustToxLoss(2 * removed)
	if(dose > 60 && ishuman(M) && prob(5))
		var/mob/living/carbon/human/H = M
		var/obj/item/organ/internal/heart/L = H.internal_organs_by_name[BP_HEART]
		if (L && istype(L))
			if(dose < 120)
				L.take_damage(10 * removed, 0)
			else
				L.take_damage(100, 0)

/datum/reagent/ethanol/red_mead
	name = "Red Mead"
	id = "red_mead"
	description = "The true Viking's drink! Even though it has a strange red color."
	taste_description = "sweet and salty alcohol"
	color = "#C73C00"
	strength = 30

	glass_name = "red mead"
	glass_desc = "A true Viking's beverage, though its color is strange."

/datum/reagent/ethanol/sbiten
	name = "Sbiten"
	id = "sbiten"
	description = "A spicy Mead! Might be a little hot for the little guys!"
	taste_description = "hot and spice"
	color = "#FFA371"
	strength = 15
	adj_temp = 50
	targ_temp = 360

	glass_name = "Sbiten"
	glass_desc = "A spicy mix of Mead and Spice. Very hot."

/datum/reagent/ethanol/screwdrivercocktail
	name = "Screwdriver"
	id = "screwdrivercocktail"
	description = "Vodka, mixed with plain ol' orange juice. The result is surprisingly delicious."
	taste_description = "oranges"
	color = "#A68310"
	strength = 15

	glass_name = "Screwdriver"
	glass_desc = "A simple, yet superb mixture of Vodka and orange juice. Just the thing for the tired engineer."

/datum/reagent/ethanol/silencer
	name = "Silencer"
	id = "silencer"
	description = "A drink from Mime Heaven."
	taste_description = "a pencil eraser"
	taste_mult = 1.2
	nutriment_factor = 1
	color = "#FFFFFF"
	strength = 12

	glass_name = "Silencer"
	glass_desc = "A drink from mime Heaven."

/datum/reagent/ethanol/singulo
	name = "Singulo"
	id = "singulo"
	description = "A blue-space beverage!"
	taste_description = "concentrated matter"
	color = "#2E6671"
	strength = 10

	glass_name = "Singulo"
	glass_desc = "A blue-space beverage."

/datum/reagent/ethanol/snowwhite
	name = "Snow White"
	id = "snowwhite"
	description = "A cold refreshment"
	taste_description = "refreshing cold"
	color = "#FFFFFF"
	strength = 30

	glass_name = "Snow White"
	glass_desc = "A cold refreshment."

/datum/reagent/ethanol/suidream
	name = "Sui Dream"
	id = "suidream"
	description = "Comprised of: White soda, blue curacao, melon liquor."
	taste_description = "fruit"
	color = "#00A86B"
	strength = 100

	glass_name = "Sui Dream"
	glass_desc = "A froofy, fruity, and sweet mixed drink. Understanding the name only brings shame."

/datum/reagent/ethanol/syndicatebomb
	name = "Syndicate Bomb"
	id = "syndicatebomb"
	description = "Tastes like terrorism!"
	taste_description = "purified antagonism"
	color = "#2E6671"
	strength = 10

	glass_name = "Syndicate Bomb"
	glass_desc = "Tastes like terrorism!"

/datum/reagent/ethanol/tequilla_sunrise
	name = "Tequila Sunrise"
	id = "tequillasunrise"
	description = "Tequila and orange juice. Much like a Screwdriver, only Mexican~"
	taste_description = "oranges"
	color = "#FFE48C"
	strength = 25

	glass_name = "Tequilla Sunrise"
	glass_desc = "Oh great, now you feel nostalgic about sunrises back on Terra..."

/datum/reagent/ethanol/threemileisland
	name = "Three Mile Island Iced Tea"
	id = "threemileisland"
	description = "Made for a woman, strong enough for a man."
	taste_description = "dry"
	color = "#666340"
	strength = 10
	druggy = 50

	glass_name = "Three Mile Island iced tea"
	glass_desc = "A glass of this is sure to prevent a meltdown."

/datum/reagent/ethanol/toxins_special
	name = "Toxins Special"
	id = "phoronspecial"
	description = "This thing is ON FIRE! CALL THE DAMN SHUTTLE!"
	taste_description = "spicy toxins"
	reagent_state = LIQUID
	color = "#7F00FF"
	strength = 10
	adj_temp = 15
	targ_temp = 330

	glass_name = "Toxins Special"
	glass_desc = "Whoah, this thing is on FIRE"

/datum/reagent/ethanol/vodkamartini
	name = "Vodka Martini"
	id = "vodkamartini"
	description = "Vodka with Gin. Not quite how 007 enjoyed it, but still delicious."
	taste_description = "shaken, not stirred"
	color = "#0064C8"
	strength = 12

	glass_name = "vodka martini"
	glass_desc ="A bastardisation of the classic martini. Still great."


/datum/reagent/ethanol/vodkatonic
	name = "Vodka and Tonic"
	id = "vodkatonic"
	description = "For when a gin and tonic isn't russian enough."
	taste_description = "tart bitterness"
	color = "#0064C8" // rgb: 0, 100, 200
	strength = 15

	glass_name = "vodka and tonic"
	glass_desc = "For when a gin and tonic isn't Russian enough."


/datum/reagent/ethanol/white_russian
	name = "White Russian"
	id = "whiterussian"
	description = "That's just, like, your opinion, man..."
	taste_description = "bitter cream"
	color = "#A68340"
	strength = 15

	glass_name = "White Russian"
	glass_desc = "A very nice looking drink. But that's just, like, your opinion, man."


/datum/reagent/ethanol/whiskey_cola
	name = "Whiskey Cola"
	id = "whiskeycola"
	description = "Whiskey, mixed with cola. Surprisingly refreshing."
	taste_description = "cola"
	color = "#3E1B00"
	strength = 25

	glass_name = "whiskey cola"
	glass_desc = "An innocent-looking mixture of cola and Whiskey. Delicious."


/datum/reagent/ethanol/whiskeysoda
	name = "Whiskey Soda"
	id = "whiskeysoda"
	description = "For the more refined griffon."
	color = "#EAB300"
	strength = 15

	glass_name = "whiskey soda"
	glass_desc = "Ultimate refreshment."

/datum/reagent/ethanol/specialwhiskey // I have no idea what this is and where it comes from
	name = "Special Blend Whiskey"
	id = "specialwhiskey"
	description = "Just when you thought regular station whiskey was good... This silky, amber goodness has to come along and ruin everything."
	taste_description = "liquid fire"
	color = "#523600"
	strength = 25

	glass_name = "special blend whiskey"
	glass_desc = "Just when you thought regular station whiskey was good... This silky, amber goodness has to come along and ruin everything."
