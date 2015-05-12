
/datum/reagent/nutriment
	name = "Nutriment"
	id = "nutriment"
	description = "All the vitamins, minerals, and carbohydrates the body needs in pure form."
	reagent_state = SOLID
	nutriment_factor = 15 * REAGENTS_METABOLISM
	color = "#664330" // rgb: 102, 67, 48

/datum/reagent/nutriment/on_mob_life(var/mob/living/M as mob)
	if(!M) M = holder.my_atom
	if(prob(50)) M.heal_organ_damage(1,0)
	M.nutrition += nutriment_factor	// For hunger and fatness
	..()
	return

/datum/reagent/nutriment/protein // Bad for Skrell!
	name = "animal protein"
	id = "protein"
	color = "#440000"

/datum/reagent/nutriment/protein/on_mob_life(var/mob/living/M, var/alien)
	if(alien && alien == IS_SKRELL)
		M.adjustToxLoss(0.5)
		M.nutrition -= nutriment_factor
	..()

/datum/reagent/nutriment/egg // Also bad for skrell. Not a child of protein because it might mess up, not sure.
	name = "egg yolk"
	id = "egg"
	color = "#FFFFAA"

/datum/reagent/nutriment/egg/on_mob_life(var/mob/living/M, var/alien)
	if(alien && alien == IS_SKRELL)
		M.adjustToxLoss(0.5)
		M.nutrition -= nutriment_factor
	..()

/datum/reagent/flour
	name = "flour"
	id = "flour"
	description = "This is what you rub all over yourself to pretend to be a ghost."
	reagent_state = SOLID
	nutriment_factor = 1 * REAGENTS_METABOLISM
	color = "#FFFFFF" // rgb: 0, 0, 0

/datum/reagent/flour/on_mob_life(var/mob/living/M as mob)
	M.nutrition += nutriment_factor
	..()
	return

/datum/reagent/flour/reaction_turf(var/turf/T, var/volume)
	src = null
	if(!istype(T, /turf/space))
		new /obj/effect/decal/cleanable/flour(T)

/datum/reagent/coco
	name = "Coco Powder"
	id = "coco"
	description = "A fatty, bitter paste made from coco beans."
	reagent_state = SOLID
	nutriment_factor = 5 * REAGENTS_METABOLISM
	color = "#302000" // rgb: 48, 32, 0

/datum/reagent/coco/on_mob_life(var/mob/living/M as mob)
	M.nutrition += nutriment_factor
	..()
	return

/datum/reagent/soysauce
	name = "Soysauce"
	id = "soysauce"
	description = "A salty sauce made from the soy plant."
	reagent_state = LIQUID
	nutriment_factor = 2 * REAGENTS_METABOLISM
	color = "#792300" // rgb: 121, 35, 0

/datum/reagent/ketchup
	name = "Ketchup"
	id = "ketchup"
	description = "Ketchup, catsup, whatever. It's tomato paste."
	reagent_state = LIQUID
	nutriment_factor = 5 * REAGENTS_METABOLISM
	color = "#731008" // rgb: 115, 16, 8

/datum/reagent/rice
	name = "Rice"
	id = "rice"
	description = "Enjoy the great taste of nothing."
	reagent_state = SOLID
	nutriment_factor = 1 * REAGENTS_METABOLISM
	color = "#FFFFFF" // rgb: 0, 0, 0

/datum/reagent/rice/on_mob_life(var/mob/living/M as mob)
	M.nutrition += nutriment_factor
	..()
	return

/datum/reagent/cherryjelly
	name = "Cherry Jelly"
	id = "cherryjelly"
	description = "Totally the best. Only to be spread on foods with excellent lateral symmetry."
	reagent_state = LIQUID
	nutriment_factor = 1 * REAGENTS_METABOLISM
	color = "#801E28" // rgb: 128, 30, 40

/datum/reagent/cherryjelly/on_mob_life(var/mob/living/M as mob)
	M.nutrition += nutriment_factor
	..()
	return

/datum/reagent/cornoil
	name = "Corn Oil"
	id = "cornoil"
	description = "An oil derived from various types of corn."
	reagent_state = LIQUID
	nutriment_factor = 20 * REAGENTS_METABOLISM
	color = "#302000" // rgb: 48, 32, 0

/datum/reagent/cornoil/on_mob_life(var/mob/living/M as mob)
		M.nutrition += nutriment_factor
		..()
		return

/datum/reagent/cornoil/reaction_turf(var/turf/simulated/T, var/volume)
	if (!istype(T)) return
	src = null
	if(volume >= 3)
		if(T.wet >= 1) return
		T.wet = 1
		if(T.wet_overlay)
			T.overlays -= T.wet_overlay
			T.wet_overlay = null
		T.wet_overlay = image('icons/effects/water.dmi',T,"wet_floor")
		T.overlays += T.wet_overlay

		spawn(800)
			if (!istype(T)) return
			if(T.wet >= 2) return
			T.wet = 0
			if(T.wet_overlay)
				T.overlays -= T.wet_overlay
				T.wet_overlay = null
	var/hotspot = (locate(/obj/fire) in T)
	if(hotspot)
		var/datum/gas_mixture/lowertemp = T.remove_air( T:air:total_moles )
		lowertemp.temperature = max( min(lowertemp.temperature-2000,lowertemp.temperature / 2) ,0)
		lowertemp.react()
		T.assume_air(lowertemp)
		qdel(hotspot)

/datum/reagent/virus_food
	name = "Virus Food"
	id = "virusfood"
	description = "A mixture of water, milk, and oxygen. Virus cells can use this mixture to reproduce."
	reagent_state = LIQUID
	nutriment_factor = 2 * REAGENTS_METABOLISM
	color = "#899613" // rgb: 137, 150, 19

/datum/reagent/virus_food/on_mob_life(var/mob/living/M as mob)
	if(!M) M = holder.my_atom
	M.nutrition += nutriment_factor*REM
	..()
	return

/datum/reagent/sprinkles
	name = "Sprinkles"
	id = "sprinkles"
	description = "Multi-colored little bits of sugar, commonly found on donuts. Loved by cops."
	nutriment_factor = 1 * REAGENTS_METABOLISM
	color = "#FF00FF" // rgb: 255, 0, 255

/datum/reagent/sprinkles/on_mob_life(var/mob/living/M as mob)
	M.nutrition += nutriment_factor
	/*if(istype(M, /mob/living/carbon/human) && M.job in list("Security Officer", "Head of Security", "Detective", "Warden"))
		if(!M) M = holder.my_atom
		M.heal_organ_damage(1,1)
		M.nutrition += nutriment_factor
		..()
		return
	*/
	..()

/datum/reagent/toxin/minttoxin
	name = "Mint Toxin"
	id = "minttoxin"
	description = "Useful for dealing with undesirable customers."
	reagent_state = LIQUID
	color = "#CF3600" // rgb: 207, 54, 0
	toxpwr = 0

/datum/reagent/toxin/minttoxin/on_mob_life(var/mob/living/M as mob)
	if(!M) M = holder.my_atom
	if (FAT in M.mutations)
		M.gib()
	..()
	return

/datum/reagent/lipozine
	name = "Lipozine" // The anti-nutriment.
	id = "lipozine"
	description = "A chemical compound that causes a powerful fat-burning reaction."
	reagent_state = LIQUID
	nutriment_factor = 10 * REAGENTS_METABOLISM
	color = "#BBEDA4" // rgb: 187, 237, 164
	overdose = REAGENTS_OVERDOSE

/datum/reagent/lipozine/on_mob_life(var/mob/living/M as mob)
	if(!M) M = holder.my_atom
	M.nutrition = max(M.nutrition - nutriment_factor, 0)
	M.overeatduration = 0
	if(M.nutrition < 0)//Prevent from going into negatives.
		M.nutrition = 0
	..()
	return

/datum/reagent/sodiumchloride
	name = "Table Salt"
	id = "sodiumchloride"
	description = "A salt made of sodium chloride. Commonly used to season food."
	reagent_state = SOLID
	color = "#FFFFFF" // rgb: 255,255,255
	overdose = REAGENTS_OVERDOSE

/datum/reagent/blackpepper
	name = "Black Pepper"
	id = "blackpepper"
	description = "A powder ground from peppercorns. *AAAACHOOO*"
	reagent_state = SOLID
	// no color (ie, black)

/datum/reagent/enzyme
	name = "Universal Enzyme"
	id = "enzyme"
	description = "A universal enzyme used in the preperation of certain chemicals and foods."
	reagent_state = LIQUID
	color = "#365E30" // rgb: 54, 94, 48
	overdose = REAGENTS_OVERDOSE

/datum/reagent/frostoil
	name = "Frost Oil"
	id = "frostoil"
	description = "A special oil that noticably chills the body. Extracted from Ice Peppers."
	reagent_state = LIQUID
	color = "#B31008" // rgb: 139, 166, 233

/datum/reagent/frostoil/on_mob_life(var/mob/living/M as mob)
	if(!M)
		M = holder.my_atom
	M.bodytemperature = max(M.bodytemperature - 10 * TEMPERATURE_DAMAGE_COEFFICIENT, 0)
	if(prob(1))
		M.emote("shiver")
	if(istype(M, /mob/living/carbon/slime))
		M.bodytemperature = max(M.bodytemperature - rand(10,20), 0)
	holder.remove_reagent("capsaicin", 5)
	holder.remove_reagent(src.id, FOOD_METABOLISM)
	..()
	return

/datum/reagent/frostoil/reaction_turf(var/turf/simulated/T, var/volume)
	for(var/mob/living/carbon/slime/M in T)
		M.adjustToxLoss(rand(15,30))

/datum/reagent/capsaicin
	name = "Capsaicin Oil"
	id = "capsaicin"
	description = "This is what makes chilis hot."
	reagent_state = LIQUID
	color = "#B31008" // rgb: 179, 16, 8

/datum/reagent/capsaicin/on_mob_life(var/mob/living/M as mob)
	if(!M)
		M = holder.my_atom
	if(!data)
		data = 1
	if(ishuman(M))
		var/mob/living/carbon/human/H = M
		if(H.species && !(H.species.flags & (NO_PAIN | IS_SYNTHETIC)) )
			switch(data)
				if(1 to 2)
					H << "\red <b>Your insides feel uncomfortably hot !</b>"
				if(2 to 20)
					if(prob(5))
						H << "\red <b>Your insides feel uncomfortably hot !</b>"
				if(20 to INFINITY)
					H.apply_effect(2,AGONY,0)
					if(prob(5))
						H.visible_message("<span class='warning'>[H] [pick("dry heaves!","coughs!","splutters!")]</span>")
						H << "\red <b>You feel like your insides are burning !</b>"
	else if(istype(M, /mob/living/carbon/slime))
		M.bodytemperature += rand(10,25)
	holder.remove_reagent("frostoil", 5)
	holder.remove_reagent(src.id, FOOD_METABOLISM)
	data++
	..()
	return

/datum/reagent/condensedcapsaicin
	name = "Condensed Capsaicin"
	id = "condensedcapsaicin"
	description = "A chemical agent used for self-defense and in police work."
	reagent_state = LIQUID
	color = "#B31008" // rgb: 179, 16, 8

/datum/reagent/condensedcapsaicin/reaction_mob(var/mob/living/M, var/method=TOUCH, var/volume)
	if(!istype(M, /mob/living))
		return
	if(method == TOUCH)
		if(istype(M, /mob/living/carbon/human))
			var/mob/living/carbon/human/victim = M
			var/mouth_covered = 0
			var/eyes_covered = 0
			var/obj/item/safe_thing = null
			if( victim.wear_mask )
				if ( victim.wear_mask.flags & MASKCOVERSEYES )
					eyes_covered = 1
					safe_thing = victim.wear_mask
				if ( victim.wear_mask.flags & MASKCOVERSMOUTH )
					mouth_covered = 1
					safe_thing = victim.wear_mask
			if( victim.head )
				if ( victim.head.flags & MASKCOVERSEYES )
					eyes_covered = 1
					safe_thing = victim.head
				if ( victim.head.flags & MASKCOVERSMOUTH )
					mouth_covered = 1
					safe_thing = victim.head
			if(victim.glasses)
				eyes_covered = 1
				if ( !safe_thing )
					safe_thing = victim.glasses
			if ( eyes_covered && mouth_covered )
				victim << "\red Your [safe_thing] protects you from the pepperspray!"
				return
			else if ( eyes_covered )	// Reduced effects if partially protected
				victim << "\red Your [safe_thing] protect you from most of the pepperspray!"
				victim.eye_blurry = max(M.eye_blurry, 15)
				victim.eye_blind = max(M.eye_blind, 5)
				victim.Stun(5)
				victim.Weaken(5)
				//victim.Paralyse(10)
				//victim.drop_item()
				return
			else if ( mouth_covered ) // Mouth cover is better than eye cover
				victim << "\red Your [safe_thing] protects your face from the pepperspray!"
				if (!(victim.species && (victim.species.flags & NO_PAIN)))
					victim.emote("scream")
				victim.eye_blurry = max(M.eye_blurry, 5)
				return
			else // Oh dear :D
				if (!(victim.species && (victim.species.flags & NO_PAIN)))
					victim.emote("scream")
				victim << "\red You're sprayed directly in the eyes with pepperspray!"
				victim.eye_blurry = max(M.eye_blurry, 25)
				victim.eye_blind = max(M.eye_blind, 10)
				victim.Stun(5)
				victim.Weaken(5)
				//victim.Paralyse(10)
				//victim.drop_item()

/datum/reagent/condensedcapsaicin/on_mob_life(var/mob/living/M as mob)
	if(!M)
		M = holder.my_atom
	if(!data)
		data = 1
	if(ishuman(M))
		var/mob/living/carbon/human/H = M
		if(H.species && !(H.species.flags & (NO_PAIN | IS_SYNTHETIC)) )
			switch(data)
				if(1)
					H << "\red <b>You feel like your insides are burning !</b>"
				if(2 to INFINITY)
					H.apply_effect(4,AGONY,0)
					if(prob(5))
						H.visible_message("<span class='warning'>[H] [pick("dry heaves!","coughs!","splutters!")]</span>")
						H << "\red <b>You feel like your insides are burning !</b>"
	else if(istype(M, /mob/living/carbon/slime))
		M.bodytemperature += rand(15,30)
	holder.remove_reagent("frostoil", 5)
	holder.remove_reagent(src.id, FOOD_METABOLISM)
	data++
	..()
	return

/datum/reagent/drink
	name = "Drink"
	id = "drink"
	description = "Uh, some kind of drink."
	reagent_state = LIQUID
	nutriment_factor = 1 * REAGENTS_METABOLISM
	color = "#E78108" // rgb: 231, 129, 8
	var/adj_dizzy = 0
	var/adj_drowsy = 0
	var/adj_sleepy = 0
	var/adj_temp = 0

/datum/reagent/drink/on_mob_life(var/mob/living/M as mob)
	if(!M) M = holder.my_atom
	M.nutrition += nutriment_factor
	holder.remove_reagent(src.id, FOOD_METABOLISM)
	// Drinks should be used up faster than other reagents.
	holder.remove_reagent(src.id, FOOD_METABOLISM)
	if (adj_dizzy) M.dizziness = max(0,M.dizziness + adj_dizzy)
	if (adj_drowsy)	M.drowsyness = max(0,M.drowsyness + adj_drowsy)
	if (adj_sleepy) M.sleeping = max(0,M.sleeping + adj_sleepy)
	if (adj_temp)
		if (M.bodytemperature < 310)//310 is the normal bodytemp. 310.055
			M.bodytemperature = min(310, M.bodytemperature + (25 * TEMPERATURE_DAMAGE_COEFFICIENT))

	..()
	return

/datum/reagent/drink/banana
	name = "Banana Juice"
	id = "banana"
	description = "The raw essence of a banana."
	color = "#C3AF00" // rgb: 195, 175, 0

	glass_icon_state = "banana"
	glass_name = "glass of banana juice"
	glass_desc = "The raw essence of a banana. HONK!"

/datum/reagent/drink/berryjuice
	name = "Berry Juice"
	id = "berryjuice"
	description = "A delicious blend of several different kinds of berries."
	color = "#990066" // rgb: 153, 0, 102

	glass_icon_state = "berryjuice"
	glass_name = "glass of berry juice"
	glass_desc = "Berry juice. Or maybe it's jam. Who cares?"

/datum/reagent/drink/carrotjuice
	name = "Carrot juice"
	id = "carrotjuice"
	description = "It is just like a carrot but without crunching."
	color = "#FF8C00" // rgb: 255, 140, 0

	glass_icon_state = "carrotjuice"
	glass_name = "glass of carrot juice"
	glass_desc = "It is just like a carrot but without crunching."

/datum/reagent/drink/carrotjuice/on_mob_life(var/mob/living/M as mob)
	..()
	M.eye_blurry = max(M.eye_blurry-1 , 0)
	M.eye_blind = max(M.eye_blind-1 , 0)
	if(!data) data = 1
	switch(data)
		if(1 to 20)
			//nothing
		if(21 to INFINITY)
			if (prob(data-10))
				M.disabilities &= ~NEARSIGHTED
	data++
	return

/datum/reagent/drink/grapejuice
	name = "Grape Juice"
	id = "grapejuice"
	description = "It's grrrrrape!"
	color = "#863333" // rgb: 134, 51, 51

	glass_icon_state = "grapejuice"
	glass_name = "glass of grape juice"
	glass_desc = "It's grrrrrape!"

/datum/reagent/drink/lemonjuice
	name = "Lemon Juice"
	id = "lemonjuice"
	description = "This juice is VERY sour."
	color = "#AFAF00" // rgb: 175, 175, 0

	glass_icon_state = "lemonjuice"
	glass_name = "glass of lemon juice"
	glass_desc = "Sour..."

/datum/reagent/drink/limejuice
	name = "Lime Juice"
	id = "limejuice"
	description = "The sweet-sour juice of limes."
	color = "#365E30" // rgb: 54, 94, 48

	glass_icon_state = "glass_green"
	glass_name = "glass of lime juice"
	glass_desc = "A glass of sweet-sour lime juice"

/datum/reagent/drink/limejuice/on_mob_life(var/mob/living/M as mob)
	..()
	if(M.getToxLoss() && prob(20)) M.adjustToxLoss(-1*REM)
	return

/datum/reagent/drink/orangejuice
	name = "Orange juice"
	id = "orangejuice"
	description = "Both delicious AND rich in Vitamin C, what more do you need?"
	color = "#E78108" // rgb: 231, 129, 8

	glass_icon_state = "glass_orange"
	glass_name = "glass of orange juice"
	glass_desc = "Vitamins! Yay!"

/datum/reagent/drink/orangejuice/on_mob_life(var/mob/living/M as mob)
	..()
	if(M.getOxyLoss() && prob(30)) M.adjustOxyLoss(-1)
	return

/datum/reagent/drink/poisonberryjuice
	name = "Poison Berry Juice"
	id = "poisonberryjuice"
	description = "A tasty juice blended from various kinds of very deadly and toxic berries."
	color = "#863353" // rgb: 134, 51, 83

	glass_icon_state = "poisonberryjuice"
	glass_name = "glass of poison berry juice"
	glass_desc = "A glass of deadly juice."

/datum/reagent/drink/poisonberryjuice/on_mob_life(var/mob/living/M as mob)
	..()
	M.adjustToxLoss(1)
	return

/datum/reagent/drink/potato_juice
	name = "Potato Juice"
	id = "potato"
	description = "Juice of the potato. Bleh."
	nutriment_factor = 2 * FOOD_METABOLISM
	color = "#302000" // rgb: 48, 32, 0

	glass_icon_state = "glass_brown"
	glass_name = "glass of potato juice"
	glass_desc = "Juice from a potato. Bleh."

/datum/reagent/drink/tomatojuice
	name = "Tomato Juice"
	id = "tomatojuice"
	description = "Tomatoes made into juice. What a waste of big, juicy tomatoes, huh?"
	color = "#731008" // rgb: 115, 16, 8

	glass_icon_state = "glass_red"
	glass_name = "glass of tomato juice"
	glass_desc = "Are you sure this is tomato juice?"

/datum/reagent/drink/tomatojuice/on_mob_life(var/mob/living/M as mob)
	..()
	if(M.getFireLoss() && prob(20)) M.heal_organ_damage(0,1)
	return

/datum/reagent/drink/watermelonjuice
	name = "Watermelon Juice"
	id = "watermelonjuice"
	description = "Delicious juice made from watermelon."
	color = "#B83333" // rgb: 184, 51, 51

	glass_icon_state = "glass_red"
	glass_name = "glass of watermelon juice"
	glass_desc = "Delicious juice made from watermelon."

/datum/reagent/drink/milk
	name = "Milk"
	id = "milk"
	description = "An opaque white liquid produced by the mammary glands of mammals."
	color = "#DFDFDF" // rgb: 223, 223, 223

	glass_icon_state = "glass_white"
	glass_name = "glass of milk"
	glass_desc = "White and nutritious goodness!"

/datum/reagent/drink/milk/on_mob_life(var/mob/living/M as mob)
	if(M.getBruteLoss() && prob(20)) M.heal_organ_damage(1,0)
	holder.remove_reagent("capsaicin", 10*REAGENTS_METABOLISM)
	..()
	return

/datum/reagent/drink/milk/cream
	name = "Cream"
	id = "cream"
	description = "The fatty, still liquid part of milk. Why don't you mix this with sum scotch, eh?"
	color = "#DFD7AF" // rgb: 223, 215, 175

	glass_icon_state = "glass_white"
	glass_name = "glass of cream"
	glass_desc = "Ewwww..."

/datum/reagent/drink/milk/soymilk
	name = "Soy Milk"
	id = "soymilk"
	description = "An opaque white liquid made from soybeans."
	color = "#DFDFC7" // rgb: 223, 223, 199

	glass_icon_state = "glass_white"
	glass_name = "glass of soy milk"
	glass_desc = "White and nutritious soy goodness!"

/datum/reagent/drink/tea
	name = "Tea"
	id = "tea"
	description = "Tasty black tea, it has antioxidants, it's good for you!"
	color = "#101000" // rgb: 16, 16, 0
	adj_dizzy = -2
	adj_drowsy = -1
	adj_sleepy = -3
	adj_temp = 20

	glass_icon_state = "bigteacup"
	glass_name = "cup of tea"
	glass_desc = "Tasty black tea, it has antioxidants, it's good for you!"

/datum/reagent/drink/tea/on_mob_life(var/mob/living/M as mob)
	..()
	if(M.getToxLoss() && prob(20))
		M.adjustToxLoss(-1)
	return

/datum/reagent/drink/tea/icetea
	name = "Iced Tea"
	id = "icetea"
	description = "No relation to a certain rap artist/ actor."
	color = "#104038" // rgb: 16, 64, 56
	adj_temp = -5

	glass_icon_state = "icedteaglass"
	glass_name = "glass of iced tea"
	glass_desc = "No relation to a certain rap artist/ actor."
	glass_center_of_mass = list("x"=15, "y"=10)

/datum/reagent/drink/coffee
	name = "Coffee"
	id = "coffee"
	description = "Coffee is a brewed drink prepared from roasted seeds, commonly called coffee beans, of the coffee plant."
	color = "#482000" // rgb: 72, 32, 0
	adj_dizzy = -5
	adj_drowsy = -3
	adj_sleepy = -2
	adj_temp = 25

	glass_icon_state = "hot_coffee"
	glass_name = "cup of coffee"
	glass_desc = "Don't drop it, or you'll send scalding liquid and glass shards everywhere."

/datum/reagent/drink/coffee/on_mob_life(var/mob/living/M as mob)
	..()
	M.make_jittery(5)
	if(adj_temp > 0)
		holder.remove_reagent("frostoil", 10*REAGENTS_METABOLISM)

	holder.remove_reagent(src.id, 0.1)

/datum/reagent/drink/coffee/icecoffee
	name = "Iced Coffee"
	id = "icecoffee"
	description = "Coffee and ice, refreshing and cool."
	color = "#102838" // rgb: 16, 40, 56
	adj_temp = -5

	glass_icon_state = "icedcoffeeglass"
	glass_name = "glass of iced coffee"
	glass_desc = "A drink to perk you up and refresh you!"

/datum/reagent/drink/coffee/soy_latte
	name = "Soy Latte"
	id = "soy_latte"
	description = "A nice and tasty beverage while you are reading your hippie books."
	color = "#664300" // rgb: 102, 67, 0
	adj_sleepy = 0
	adj_temp = 5

	glass_icon_state = "soy_latte"
	glass_name = "glass of soy latte"
	glass_desc = "A nice and refrshing beverage while you are reading."
	glass_center_of_mass = list("x"=15, "y"=9)

/datum/reagent/drink/coffee/soy_latte/on_mob_life(var/mob/living/M as mob)
	..()
	M.sleeping = 0
	if(M.getBruteLoss() && prob(20)) M.heal_organ_damage(1,0)
	return

/datum/reagent/drink/coffee/cafe_latte
	name = "Cafe Latte"
	id = "cafe_latte"
	description = "A nice, strong and tasty beverage while you are reading."
	color = "#664300" // rgb: 102, 67, 0
	adj_sleepy = 0
	adj_temp = 5

	glass_icon_state = "cafe_latte"
	glass_name = "glass of cafe latte"
	glass_desc = "A nice, strong and refreshing beverage while you are reading."
	glass_center_of_mass = list("x"=15, "y"=9)

/datum/reagent/drink/coffee/cafe_latte/on_mob_life(var/mob/living/M as mob)
	..()
	M.sleeping = 0
	if(M.getBruteLoss() && prob(20)) M.heal_organ_damage(1,0)
	return

/datum/reagent/hot_coco // there's also drink/hot_coco for whatever reason
	name = "Hot Chocolate"
	id = "hot_coco"
	description = "Made with love! And cocoa beans."
	reagent_state = LIQUID
	nutriment_factor = 2 * REAGENTS_METABOLISM
	color = "#403010" // rgb: 64, 48, 16

	glass_icon_state  = "chocolateglass"
	glass_name = "glass of hot chocolate"
	glass_desc = "Made with love! And cocoa beans."

/datum/reagent/hot_coco/on_mob_life(var/mob/living/M as mob)
	if (M.bodytemperature < 310)//310 is the normal bodytemp. 310.055
		M.bodytemperature = min(310, M.bodytemperature + (5 * TEMPERATURE_DAMAGE_COEFFICIENT))
	M.nutrition += nutriment_factor
	..()
	return

/datum/reagent/drink/hot_coco
	name = "Hot Chocolate"
	id = "hot_coco"
	description = "Made with love! And cocoa beans."
	nutriment_factor = 2 * FOOD_METABOLISM
	color = "#403010" // rgb: 64, 48, 16
	adj_temp = 5

	glass_icon_state = "chocolateglass"
	glass_name = "glass of hot chocolate"
	glass_desc = "Made with love! And cocoa beans."

/datum/reagent/drink/cold/sodawater
	name = "Soda Water"
	id = "sodawater"
	description = "A can of club soda. Why not make a scotch and soda?"
	color = "#619494" // rgb: 97, 148, 148
	adj_dizzy = -5
	adj_drowsy = -3

	glass_icon_state = "glass_clear"
	glass_name = "glass of soda water"
	glass_desc = "Soda water. Why not make a scotch and soda?"

/datum/reagent/drink/grapesoda
	name = "Grape Soda"
	id = "grapesoda"
	description = "Grapes made into a fine drank."
	color = "#421C52" // rgb: 98, 57, 53
	adj_drowsy 	= 	-3

	glass_icon_state = "gsodaglass"
	glass_name = "glass of grape soda"
	glass_desc = "Looks like a delicious drink!"

/datum/reagent/drink/cold/tonic
	name = "Tonic Water"
	id = "tonic"
	description = "It tastes strange but at least the quinine keeps the Space Malaria at bay."
	color = "#664300" // rgb: 102, 67, 0
	adj_dizzy = -5
	adj_drowsy = -3
	adj_sleepy = -2

	glass_icon_state = "glass_clear"
	glass_name = "glass of tonic water"
	glass_desc = "Quinine tastes funny, but at least it'll keep that Space Malaria away."

/datum/reagent/drink/cold/lemonade
	name = "Lemonade"
	description = "Oh the nostalgia..."
	id = "lemonade"
	color = "#FFFF00" // rgb: 255, 255, 0

	glass_icon_state = "lemonadeglass"
	glass_name = "glass of lemonade"
	glass_desc = "Oh the nostalgia..."

/datum/reagent/drink/cold/kiraspecial
	name = "Kira Special"
	description = "Long live the guy who everyone had mistaken for a girl. Baka!"
	id = "kiraspecial"
	color = "#CCCC99" // rgb: 204, 204, 153

	glass_icon_state = "kiraspecial"
	glass_name = "glass of Kira Special"
	glass_desc = "Long live the guy who everyone had mistaken for a girl. Baka!"
	glass_center_of_mass = list("x"=16, "y"=12)

/datum/reagent/drink/cold/brownstar
	name = "Brown Star"
	description = "It's not what it sounds like..."
	id = "brownstar"
	color = "#9F3400" // rgb: 159, 052, 000
	adj_temp = - 2

	glass_icon_state = "brownstar"
	glass_name = "glass of Brown Star"
	glass_desc = "It's not what it sounds like..."

/datum/reagent/drink/cold/milkshake
	name = "Milkshake"
	description = "Glorious brainfreezing mixture."
	id = "milkshake"
	color = "#AEE5E4" // rgb" 174, 229, 228
	adj_temp = -9

	glass_icon_state = "milkshake"
	glass_name = "glass of milkshake"
	glass_desc = "Glorious brainfreezing mixture."
	glass_center_of_mass = list("x"=16, "y"=7)

/datum/reagent/drink/cold/milkshake/on_mob_life(var/mob/living/M as mob)
	if(!M)
		M = holder.my_atom
	if(prob(1))
		M.emote("shiver")
	M.bodytemperature = max(M.bodytemperature - 10 * TEMPERATURE_DAMAGE_COEFFICIENT, 0)
	if(istype(M, /mob/living/carbon/slime))
		M.bodytemperature = max(M.bodytemperature - rand(10,20), 0)
	holder.remove_reagent("capsaicin", 5)
	holder.remove_reagent(src.id, FOOD_METABOLISM)
	..()
	return

/datum/reagent/drink/cold/rewriter
	name = "Rewriter"
	description = "The secret of the sanctuary of the Libarian..."
	id = "rewriter"
	color = "#485000" // rgb:72, 080, 0

	glass_icon_state = "rewriter"
	glass_name = "glass of Rewriter"
	glass_desc = "The secret of the sanctuary of the Libarian..."
	glass_center_of_mass = list("x"=16, "y"=9)

/datum/reagent/drink/cold/rewriter/on_mob_life(var/mob/living/M as mob)
	..()
	M.make_jittery(5)
	return

/datum/reagent/drink/cold/nuka_cola
	name = "Nuka Cola"
	id = "nuka_cola"
	description = "Cola, cola never changes."
	color = "#100800" // rgb: 16, 8, 0
	adj_sleepy = -2

	glass_icon_state = "nuka_colaglass"
	glass_name = "glass of Nuka-Cola"
	glass_desc = "Don't cry, Don't raise your eye, It's only nuclear wasteland"
	glass_center_of_mass = list("x"=16, "y"=6)

/datum/reagent/drink/cold/nuka_cola/on_mob_life(var/mob/living/M as mob)
	M.make_jittery(20)
	M.druggy = max(M.druggy, 30)
	M.dizziness +=5
	M.drowsyness = 0
	..()
	return

/datum/reagent/drink/grenadine
	name = "Grenadine Syrup"
	id = "grenadine"
	description = "Made in the modern day with proper pomegranate substitute. Who uses real fruit, anyways?"
	color = "#FF004F" // rgb: 255, 0, 79

	glass_icon_state = "grenadineglass"
	glass_name = "glass of grenadine syrup"
	glass_desc = "Sweet and tangy, a bar syrup used to add color or flavor to drinks."
	glass_center_of_mass = list("x"=17, "y"=6)

/datum/reagent/drink/cold/space_cola
	name = "Space Cola"
	id = "cola"
	description = "A refreshing beverage."
	reagent_state = LIQUID
	color = "#100800" // rgb: 16, 8, 0
	adj_drowsy 	= 	-3

	glass_icon_state  = "glass_brown"
	glass_name = "glass of Space Cola"
	glass_desc = "A glass of refreshing Space Cola"

/datum/reagent/drink/cold/spacemountainwind
	name = "Mountain Wind"
	id = "spacemountainwind"
	description = "Blows right through you like a space wind."
	color = "#102000" // rgb: 16, 32, 0
	adj_drowsy = -7
	adj_sleepy = -1

	glass_icon_state = "Space_mountain_wind_glass"
	glass_name = "glass of Space Mountain Wind"
	glass_desc = "Space Mountain Wind. As you know, there are no mountains in space, only wind."

/datum/reagent/drink/cold/dr_gibb
	name = "Dr. Gibb"
	id = "dr_gibb"
	description = "A delicious blend of 42 different flavours"
	color = "#102000" // rgb: 16, 32, 0
	adj_drowsy = -6

	glass_icon_state = "dr_gibb_glass"
	glass_name = "glass of Dr. Gibb"
	glass_desc = "Dr. Gibb. Not as dangerous as the name might imply."

/datum/reagent/drink/cold/space_up
	name = "Space-Up"
	id = "space_up"
	description = "Tastes like a hull breach in your mouth."
	color = "#202800" // rgb: 32, 40, 0
	adj_temp = -8

	glass_icon_state = "space-up_glass"
	glass_name = "glass of Space-up"
	glass_desc = "Space-up. It helps keep your cool."

/datum/reagent/drink/cold/lemon_lime
	name = "Lemon Lime"
	description = "A tangy substance made of 0.5% natural citrus!"
	id = "lemon_lime"
	color = "#878F00" // rgb: 135, 40, 0
	adj_temp = -8

	glass_icon_state = "lemonlime"
	glass_name = "glass of lemon lime soda"
	glass_desc = "A tangy substance made of 0.5% natural citrus!"

/datum/reagent/doctor_delight
	name = "The Doctor's Delight"
	id = "doctorsdelight"
	description = "A gulp a day keeps the MediBot away. That's probably for the best."
	reagent_state = LIQUID
	color = "#FF8CFF" // rgb: 255, 140, 255
	nutriment_factor = 1 * FOOD_METABOLISM

	glass_icon_state = "doctorsdelightglass"
	glass_name = "glass of The Doctor's Delight"
	glass_desc = "A healthy mixture of juices, guaranteed to keep you healthy until the next toolboxing takes place."
	glass_center_of_mass = list("x"=16, "y"=8)

/datum/reagent/doctor_delight/on_mob_life(var/mob/living/M as mob)
	M:nutrition += nutriment_factor
	holder.remove_reagent(src.id, FOOD_METABOLISM)
	if(!M) M = holder.my_atom
	if(M:getOxyLoss() && prob(50)) M:adjustOxyLoss(-2)
	if(M:getBruteLoss() && prob(60)) M:heal_organ_damage(2,0)
	if(M:getFireLoss() && prob(50)) M:heal_organ_damage(0,2)
	if(M:getToxLoss() && prob(50)) M:adjustToxLoss(-2)
	if(M.dizziness !=0) M.dizziness = max(0,M.dizziness-15)
	if(M.confused !=0) M.confused = max(0,M.confused - 5)
	..()
	return

/datum/reagent/dry_ramen
	name = "Dry Ramen"
	id = "dry_ramen"
	description = "Space age food, since August 25, 1958. Contains dried noodles, vegetables, and chemicals that boil in contact with water."
	reagent_state = SOLID
	nutriment_factor = 1 * REAGENTS_METABOLISM
	color = "#302000" // rgb: 48, 32, 0

/datum/reagent/dry_ramen/on_mob_life(var/mob/living/M as mob)
	M.nutrition += nutriment_factor
	..()
	return

/datum/reagent/hot_ramen
	name = "Hot Ramen"
	id = "hot_ramen"
	description = "The noodles are boiled, the flavors are artificial, just like being back in school."
	reagent_state = LIQUID
	nutriment_factor = 5 * REAGENTS_METABOLISM
	color = "#302000" // rgb: 48, 32, 0

/datum/reagent/hot_ramen/on_mob_life(var/mob/living/M as mob)
	M.nutrition += nutriment_factor
	if (M.bodytemperature < 310)//310 is the normal bodytemp. 310.055
		M.bodytemperature = min(310, M.bodytemperature + (10 * TEMPERATURE_DAMAGE_COEFFICIENT))
	..()
	return

/datum/reagent/hell_ramen
	name = "Hell Ramen"
	id = "hell_ramen"
	description = "The noodles are boiled, the flavors are artificial, just like being back in school."
	reagent_state = LIQUID
	nutriment_factor = 5 * REAGENTS_METABOLISM
	color = "#302000" // rgb: 48, 32, 0

/datum/reagent/hell_ramen/on_mob_life(var/mob/living/M as mob)
	M.nutrition += nutriment_factor
	M.bodytemperature += 10 * TEMPERATURE_DAMAGE_COEFFICIENT
	..()
	return

/datum/reagent/drink/cold/ice
	name = "Ice"
	id = "ice"
	description = "Frozen water, your dentist wouldn't like you chewing this."
	reagent_state = SOLID
	color = "#619494" // rgb: 97, 148, 148

	glass_icon_state = "iceglass"
	glass_name = "glass of ice"
	glass_desc = "Generally, you're supposed to put something else in there too..."

/datum/reagent/drink/nothing
	name = "Nothing"
	id = "nothing"
	description = "Absolutely nothing."

	glass_icon_state = "nothing"
	glass_name = "glass of nothing"
	glass_desc = "Absolutely nothing."

/datum/reagent/drink/cold
	name = "Cold drink"
	adj_temp = -5

/datum/reagent/ethanol/absinthe
	name = "Absinthe"
	id = "absinthe"
	description = "Watch out that the Green Fairy doesn't come for you!"
	color = "#33EE00" // rgb: 51, 238, 0
	boozepwr = 4
	dizzy_adj = 5
	slur_start = 15
	confused_start = 30

	glass_icon_state = "absintheglass"
	glass_name = "glass of absinthe"
	glass_desc = "Wormwood, anise, oh my."
	glass_center_of_mass = list("x"=16, "y"=5)

/datum/reagent/ethanol/ale
	name = "Ale"
	id = "ale"
	description = "A dark alchoholic beverage made by malted barley and yeast."
	color = "#664300" // rgb: 102, 67, 0
	boozepwr = 1

	glass_icon_state = "aleglass"
	glass_name = "glass of ale"
	glass_desc = "A freezing pint of delicious ale"
	glass_center_of_mass = list("x"=16, "y"=8)

/datum/reagent/ethanol/beer
	name = "Beer"
	id = "beer"
	description = "An alcoholic beverage made from malted grains, hops, yeast, and water."
	color = "#664300" // rgb: 102, 67, 0
	boozepwr = 1
	nutriment_factor = 1 * FOOD_METABOLISM

	glass_icon_state = "beerglass"
	glass_name = "glass of beer"
	glass_desc = "A freezing pint of beer"
	glass_center_of_mass = list("x"=16, "y"=8)

/datum/reagent/ethanol/beer/on_mob_life(var/mob/living/M as mob)
	M:jitteriness = max(M:jitteriness-3,0)
	..()
	return

/datum/reagent/ethanol/bluecuracao
	name = "Blue Curacao"
	id = "bluecuracao"
	description = "Exotically blue, fruity drink, distilled from oranges."
	color = "#0000CD" // rgb: 0, 0, 205
	boozepwr = 1.5

	glass_icon_state = "curacaoglass"
	glass_name = "glass of blue curacao"
	glass_desc = "Exotically blue, fruity drink, distilled from oranges."
	glass_center_of_mass = list("x"=16, "y"=5)

/datum/reagent/ethanol/cognac
	name = "Cognac"
	id = "cognac"
	description = "A sweet and strongly alchoholic drink, made after numerous distillations and years of maturing. Classy as fornication."
	color = "#AB3C05" // rgb: 171, 60, 5
	boozepwr = 1.5
	dizzy_adj = 4
	confused_start = 115	//amount absorbed after which mob starts confusing directions

	glass_icon_state = "cognacglass"
	glass_name = "glass of cognac"
	glass_desc = "Damn, you feel like some kind of French aristocrat just by holding this."
	glass_center_of_mass = list("x"=16, "y"=6)

/datum/reagent/ethanol/deadrum
	name = "Deadrum"
	id = "rum" // duplicate ids?
	description = "Popular with the sailors. Not very popular with everyone else."
	color = "#664300" // rgb: 102, 67, 0
	boozepwr = 1

	glass_icon_state = "rumglass"
	glass_name = "glass of rum"
	glass_desc = "Now you want to Pray for a pirate suit, don't you?"
	glass_center_of_mass = list("x"=16, "y"=12)

/datum/reagent/ethanol/deadrum/on_mob_life(var/mob/living/M as mob)
	..()
	M.dizziness +=5
	return

/datum/reagent/ethanol/gin
	name = "Gin"
	id = "gin"
	description = "It's gin. In space. I say, good sir."
	color = "#664300" // rgb: 102, 67, 0
	boozepwr = 1
	dizzy_adj = 3

	glass_icon_state = "ginvodkaglass"
	glass_name = "glass of gin"
	glass_desc = "A crystal clear glass of Griffeater gin."
	glass_center_of_mass = list("x"=16, "y"=12)

/datum/reagent/ethanol/kahlua
	name = "Kahlua"
	id = "kahlua"
	description = "A widely known, Mexican coffee-flavoured liqueur. In production since 1936!"
	color = "#664300" // rgb: 102, 67, 0
	boozepwr = 1.5
	dizzy_adj = -5
	adj_drowsy = -3
	adj_sleepy = -2

	glass_icon_state = "kahluaglass"
	glass_name = "glass of RR coffee liquor"
	glass_desc = "DAMN, THIS THING LOOKS ROBUST"
	glass_center_of_mass = list("x"=15, "y"=7)

/datum/reagent/ethanol/kahlua/on_mob_life(var/mob/living/M as mob)
	M.make_jittery(5)
	..()
	return

/datum/reagent/ethanol/melonliquor
	name = "Melon Liquor"
	id = "melonliquor"
	description = "A relatively sweet and fruity 46 proof liquor."
	color = "#138808" // rgb: 19, 136, 8
	boozepwr = 1

	glass_icon_state = "emeraldglass"
	glass_name = "glass of melon liquor"
	glass_desc = "A relatively sweet and fruity 46 proof liquor."
	glass_center_of_mass = list("x"=16, "y"=5)

/datum/reagent/ethanol/rum
	name = "Rum"
	id = "rum"
	description = "Yohoho and all that."
	color = "#664300" // rgb: 102, 67, 0
	boozepwr = 1.5

	glass_icon_state = "rumglass"
	glass_name = "glass of rum"
	glass_desc = "Now you want to Pray for a pirate suit, don't you?"
	glass_center_of_mass = list("x"=16, "y"=12)

/datum/reagent/ethanol/sake
	name = "Sake"
	id = "sake"
	description = "Anime's favorite drink."
	color = "#664300" // rgb: 102, 67, 0
	boozepwr = 2

	glass_icon_state = "ginvodkaglass"
	glass_name = "glass of sake"
	glass_desc = "A glass of sake."
	glass_center_of_mass = list("x"=16, "y"=12)

/datum/reagent/ethanol/tequilla
	name = "Tequila"
	id = "tequilla"
	description = "A strong and mildly flavoured, mexican produced spirit. Feeling thirsty hombre?"
	color = "#FFFF91" // rgb: 255, 255, 145
	boozepwr = 2

	glass_icon_state = "tequillaglass"
	glass_name = "glass of Tequilla"
	glass_desc = "Now all that's missing is the weird colored shades!"
	glass_center_of_mass = list("x"=16, "y"=12)

/datum/reagent/ethanol/thirteenloko
	name = "Thirteen Loko"
	id = "thirteenloko"
	description = "A potent mixture of caffeine and alcohol."
	color = "#102000" // rgb: 16, 32, 0
	boozepwr = 2
	nutriment_factor = 1 * FOOD_METABOLISM

	glass_icon_state = "thirteen_loko_glass"
	glass_name = "glass of Thirteen Loko"
	glass_desc = "This is a glass of Thirteen Loko, it appears to be of the highest quality. The drink, not the glass."

/datum/reagent/ethanol/thirteenloko/on_mob_life(var/mob/living/M as mob)
	M:drowsyness = max(0,M:drowsyness-7)
	if (M.bodytemperature > 310)
		M.bodytemperature = max(310, M.bodytemperature - (5 * TEMPERATURE_DAMAGE_COEFFICIENT))
	M.make_jittery(5)
	..()
	return

/datum/reagent/ethanol/vermouth
	name = "Vermouth"
	id = "vermouth"
	description = "You suddenly feel a craving for a martini..."
	color = "#91FF91" // rgb: 145, 255, 145
	boozepwr = 1.5

	glass_icon_state = "vermouthglass"
	glass_name = "glass of vermouth"
	glass_desc = "You wonder why you're even drinking this straight."
	glass_center_of_mass = list("x"=16, "y"=12)

/datum/reagent/ethanol/vodka
	name = "Vodka"
	id = "vodka"
	description = "Number one drink AND fueling choice for Russians worldwide."
	color = "#0064C8" // rgb: 0, 100, 200
	boozepwr = 2

	glass_icon_state = "ginvodkaglass"
	glass_name = "glass of vodka"
	glass_desc = "The glass contain wodka. Xynta."
	glass_center_of_mass = list("x"=16, "y"=12)

/datum/reagent/ethanol/vodka/on_mob_life(var/mob/living/M as mob)
	M.radiation = max(M.radiation-1,0)
	..()
	return

/datum/reagent/ethanol/whiskey
	name = "Whiskey"
	id = "whiskey"
	description = "A superb and well-aged single-malt whiskey. Damn."
	color = "#664300" // rgb: 102, 67, 0
	boozepwr = 2
	dizzy_adj = 4

	glass_icon_state = "whiskeyglass"
	glass_name = "glass of whiskey"
	glass_desc = "The silky, smokey whiskey goodness inside the glass makes the drink look very classy."
	glass_center_of_mass = list("x"=16, "y"=12)

/datum/reagent/ethanol/wine
	name = "Wine"
	id = "wine"
	description = "An premium alchoholic beverage made from distilled grape juice."
	color = "#7E4043" // rgb: 126, 64, 67
	boozepwr = 1.5
	dizzy_adj = 2
	slur_start = 65			//amount absorbed after which mob starts slurring
	confused_start = 145	//amount absorbed after which mob starts confusing directions

	glass_icon_state = "wineglass"
	glass_name = "glass of wine"
	glass_desc = "A very classy looking drink."
	glass_center_of_mass = list("x"=15, "y"=7)

/datum/reagent/ethanol/acid_spit
	name = "Acid Spit"
	id = "acidspit"
	description = "A drink for the daring, can be deadly if incorrectly prepared!"
	reagent_state = LIQUID
	color = "#365000" // rgb: 54, 80, 0
	boozepwr = 1.5

	glass_icon_state = "acidspitglass"
	glass_name = "glass of Acid Spit"
	glass_desc = "A drink from Nanotrasen. Made from live aliens."
	glass_center_of_mass = list("x"=16, "y"=7)

/datum/reagent/ethanol/alliescocktail
	name = "Allies Cocktail"
	id = "alliescocktail"
	description = "A drink made from your allies, not as sweet as when made from your enemies."
	color = "#664300" // rgb: 102, 67, 0
	boozepwr = 2

	glass_icon_state = "alliescocktail"
	glass_name = "glass of Allies cocktail"
	glass_desc = "A drink made from your allies."
	glass_center_of_mass = list("x"=17, "y"=8)

/datum/reagent/ethanol/aloe
	name = "Aloe"
	id = "aloe"
	description = "So very, very, very good."
	color = "#664300" // rgb: 102, 67, 0
	boozepwr = 3

	glass_icon_state = "aloe"
	glass_name = "glass of Aloe"
	glass_desc = "Very, very, very good."
	glass_center_of_mass = list("x"=17, "y"=8)

/datum/reagent/ethanol/amasec
	name = "Amasec"
	id = "amasec"
	description = "Official drink of the NanoTrasen Gun-Club!"
	reagent_state = LIQUID
	color = "#664300" // rgb: 102, 67, 0
	boozepwr = 2

/datum/reagent/ethanol/andalusia
	name = "Andalusia"
	id = "andalusia"
	description = "A nice, strangely named drink."
	color = "#664300" // rgb: 102, 67, 0
	boozepwr = 3

	glass_icon_state = "andalusia"
	glass_name = "glass of Andalusia"
	glass_desc = "A nice, strange named drink."
	glass_center_of_mass = list("x"=16, "y"=9)

	glass_icon_state = "amasecglass"
	glass_name = "glass of Amasec"
	glass_desc = "Always handy before COMBAT!!!"
	glass_center_of_mass = list("x"=16, "y"=9)

/datum/reagent/ethanol/antifreeze
	name = "Anti-freeze"
	id = "antifreeze"
	description = "Ultimate refreshment."
	color = "#664300" // rgb: 102, 67, 0
	boozepwr = 4

	glass_icon_state = "antifreeze"
	glass_name = "glass of Anti-freeze"
	glass_desc = "The ultimate refreshment."
	glass_center_of_mass = list("x"=16, "y"=8)

/datum/reagent/ethanol/antifreeze/on_mob_life(var/mob/living/M as mob)
	if (M.bodytemperature < 330)
		M.bodytemperature = min(330, M.bodytemperature + (20 * TEMPERATURE_DAMAGE_COEFFICIENT)) //310 is the normal bodytemp. 310.055
	..()
	return

/datum/reagent/atomicbomb
	name = "Atomic Bomb"
	id = "atomicbomb"
	description = "Nuclear proliferation never tasted so good."
	reagent_state = LIQUID
	color = "#666300" // rgb: 102, 99, 0

	glass_icon_state = "atomicbombglass"
	glass_name = "glass of Atomic Bomb"
	glass_desc = "Nanotrasen cannot take legal responsibility for your actions after imbibing."
	glass_center_of_mass = list("x"=15, "y"=7)

/datum/reagent/atomicbomb/on_mob_life(var/mob/living/M as mob)
	M.druggy = max(M.druggy, 50)
	M.confused = max(M.confused+2,0)
	M.make_dizzy(10)
	if (!M.stuttering) M.stuttering = 1
	M.stuttering += 3
	if(!data) data = 1
	data++
	switch(data)
		if(51 to 200)
			M.sleeping += 1
		if(201 to INFINITY)
			M.sleeping += 1
			M.adjustToxLoss(2)
	..()
	return

/datum/reagent/ethanol/b52
	name = "B-52"
	id = "b52"
	description = "Coffee, Irish Cream, and cognac. You will get bombed."
	color = "#664300" // rgb: 102, 67, 0
	boozepwr = 4

	glass_icon_state = "b52glass"
	glass_name = "glass of B-52"
	glass_desc = "Kahlua, Irish cream, and congac. You will get bombed."

/datum/reagent/ethanol/bahama_mama
	name = "Bahama mama"
	id = "bahama_mama"
	description = "Tropical cocktail."
	color = "#FF7F3B" // rgb: 255, 127, 59
	boozepwr = 2

	glass_icon_state = "bahama_mama"
	glass_name = "glass of Bahama Mama"
	glass_desc = "Tropical cocktail"
	glass_center_of_mass = list("x"=16, "y"=5)

/datum/reagent/ethanol/bananahonk
	name = "Banana Mama"
	id = "bananahonk"
	description = "A drink from Clown Heaven."
	nutriment_factor = 1 * REAGENTS_METABOLISM
	color = "#FFFF91" // rgb: 255, 255, 140
	boozepwr = 4

	glass_icon_state = "bananahonkglass"
	glass_name = "glass of Banana Honk"
	glass_desc = "A drink from Banana Heaven."
	glass_center_of_mass = list("x"=16, "y"=8)

/datum/reagent/ethanol/barefoot
	name = "Barefoot"
	id = "barefoot"
	description = "Barefoot and pregnant"
	color = "#664300" // rgb: 102, 67, 0
	boozepwr = 1.5

	glass_icon_state = "b&p"
	glass_name = "glass of Barefoot"
	glass_desc = "Barefoot and pregnant"
	glass_center_of_mass = list("x"=17, "y"=8)

/datum/reagent/ethanol/beepsky_smash
	name = "Beepsky Smash"
	id = "beepskysmash"
	description = "Deny drinking this and prepare for THE LAW."
	reagent_state = LIQUID
	color = "#664300" // rgb: 102, 67, 0
	boozepwr = 4

	glass_icon_state = "beepskysmashglass"
	glass_name = "Beepsky Smash"
	glass_desc = "Heavy, hot and strong. Just like the Iron fist of the LAW."
	glass_center_of_mass = list("x"=18, "y"=10)

/datum/reagent/ethanol/beepsky_smash/on_mob_life(var/mob/living/M as mob)
	M.Stun(2)
	..()
	return

/datum/reagent/ethanol/bilk
	name = "Bilk"
	id = "bilk"
	description = "This appears to be beer mixed with milk. Disgusting."
	color = "#895C4C" // rgb: 137, 92, 76
	boozepwr = 1
	nutriment_factor = 2 * FOOD_METABOLISM

	glass_icon_state = "glass_brown"
	glass_name = "glass of bilk"
	glass_desc = "A brew of milk and beer. For those alcoholics who fear osteoporosis."

/datum/reagent/ethanol/black_russian
	name = "Black Russian"
	id = "blackrussian"
	description = "For the lactose-intolerant. Still as classy as a White Russian."
	color = "#360000" // rgb: 54, 0, 0
	boozepwr = 3

	glass_icon_state = "blackrussianglass"
	glass_name = "glass of Black Russian"
	glass_desc = "For the lactose-intolerant. Still as classy as a White Russian."
	glass_center_of_mass = list("x"=16, "y"=9)

/datum/reagent/ethanol/bloody_mary
	name = "Bloody Mary"
	id = "bloodymary"
	description = "A strange yet pleasurable mixture made of vodka, tomato and lime juice. Or at least you THINK the red stuff is tomato juice."
	color = "#664300" // rgb: 102, 67, 0
	boozepwr = 3

	glass_icon_state = "bloodymaryglass"
	glass_name = "glass of Bloody Mary"
	glass_desc = "Tomato juice, mixed with Vodka and a lil' bit of lime. Tastes like liquid murder."

/datum/reagent/ethanol/booger
	name = "Booger"
	id = "booger"
	description = "Ewww..."
	color = "#8CFF8C" // rgb: 140, 255, 140
	boozepwr = 1.5

	glass_icon_state = "booger"
	glass_name = "glass of Booger"
	glass_desc = "Ewww..."

/datum/reagent/ethanol/brave_bull
	name = "Brave Bull"
	id = "bravebull"
	description = "It's just as effective as Dutch-Courage!"
	color = "#664300" // rgb: 102, 67, 0
	boozepwr = 3

	glass_icon_state = "bravebullglass"
	glass_name = "glass of Brave Bull"
	glass_desc = "Tequilla and coffee liquor, brought together in a mouthwatering mixture. Drink up."
	glass_center_of_mass = list("x"=15, "y"=8)

/datum/reagent/ethanol/changelingsting
	name = "Changeling Sting"
	id = "changelingsting"
	description = "You take a tiny sip and feel a burning sensation..."
	color = "#2E6671" // rgb: 46, 102, 113
	boozepwr = 5

	glass_icon_state = "changelingsting"
	glass_name = "glass of Changeling Sting"
	glass_desc = "A stingy drink."

/datum/reagent/ethanol/martini
	name = "Classic Martini"
	id = "martini"
	description = "Vermouth with Gin. Not quite how 007 enjoyed it, but still delicious."
	color = "#664300" // rgb: 102, 67, 0
	boozepwr = 2

	glass_icon_state = "martiniglass"
	glass_name = "glass of classic martini"
	glass_desc = "Damn, the bartender even stirred it, not shook it."
	glass_center_of_mass = list("x"=17, "y"=8)

/datum/reagent/ethanol/cuba_libre
	name = "Cuba Libre"
	id = "cubalibre"
	description = "Rum, mixed with cola. Viva la revolucion."
	color = "#3E1B00" // rgb: 62, 27, 0
	boozepwr = 1.5

	glass_icon_state = "cubalibreglass"
	glass_name = "glass of Cuba Libre"
	glass_desc = "A classic mix of rum and cola."
	glass_center_of_mass = list("x"=16, "y"=8)

/datum/reagent/ethanol/demonsblood
	name = "Demons Blood"
	id = "demonsblood"
	description = "AHHHH!!!!"
	color = "#820000" // rgb: 130, 0, 0
	boozepwr = 3

	glass_icon_state = "demonsblood"
	glass_name = "glass of Demons' Blood"
	glass_desc = "Just looking at this thing makes the hair at the back of your neck stand up."
	glass_center_of_mass = list("x"=16, "y"=2)

/datum/reagent/ethanol/devilskiss
	name = "Devils Kiss"
	id = "devilskiss"
	description = "Creepy time!"
	color = "#A68310" // rgb: 166, 131, 16
	boozepwr = 3

	glass_icon_state = "devilskiss"
	glass_name = "glass of Devil's Kiss"
	glass_desc = "Creepy time!"
	glass_center_of_mass = list("x"=16, "y"=8)

/datum/reagent/ethanol/driestmartini
	name = "Driest Martini"
	id = "driestmartini"
	description = "Only for the experienced. You think you see sand floating in the glass."
	nutriment_factor = 1 * FOOD_METABOLISM
	color = "#2E6671" // rgb: 46, 102, 113
	boozepwr = 4

	glass_icon_state = "driestmartiniglass"
	glass_name = "glass of Driest Martini"
	glass_desc = "Only for the experienced. You think you see sand floating in the glass."
	glass_center_of_mass = list("x"=17, "y"=8)

/datum/reagent/ethanol/ginfizz
	name = "Gin Fizz"
	id = "ginfizz"
	description = "Refreshingly lemony, deliciously dry."
	color = "#664300" // rgb: 102, 67, 0
	boozepwr = 1.5
	dizzy_adj = 4
	slurr_adj = 3

	glass_icon_state = "ginfizzglass"
	glass_name = "glass of gin fizz"
	glass_desc = "Refreshingly lemony, deliciously dry."
	glass_center_of_mass = list("x"=16, "y"=7)

/datum/reagent/ethanol/grog
	name = "Grog"
	id = "grog"
	description = "Watered down rum, NanoTrasen approves!"
	reagent_state = LIQUID
	color = "#664300" // rgb: 102, 67, 0
	boozepwr = 0.5

	glass_icon_state = "grogglass"
	glass_name = "glass of grog"
	glass_desc = "A fine and cepa drink for Space."

/datum/reagent/ethanol/erikasurprise
	name = "Erika Surprise"
	id = "erikasurprise"
	description = "The surprise is it's green!"
	color = "#2E6671" // rgb: 46, 102, 113
	boozepwr = 3

	glass_icon_state = "erikasurprise"
	glass_name = "glass of Erika Surprise"
	glass_desc = "The surprise is, it's green!"
	glass_center_of_mass = list("x"=16, "y"=9)

/datum/reagent/gargle_blaster
	name = "Pan-Galactic Gargle Blaster"
	id = "gargleblaster"
	description = "Whoah, this stuff looks volatile!"
	reagent_state = LIQUID
	color = "#664300" // rgb: 102, 67, 0

	glass_icon_state = "gargleblasterglass"
	glass_name = "glass of Pan-Galactic Gargle Blaster"
	glass_desc = "Does... does this mean that Arthur and Ford are on the station? Oh joy."
	glass_center_of_mass = list("x"=17, "y"=6)

/datum/reagent/gargle_blaster/on_mob_life(var/mob/living/M as mob)
	if(!data) data = 1
	data++
	M.dizziness +=6
	switch(data)
		if(15 to 45)
			M.stuttering = max(M.stuttering+3,0)
		if(45 to 55)
			if (prob(50))
				M.confused = max(M.confused+3,0)
		if(55 to 200)
			M.druggy = max(M.druggy, 55)
		if(200 to INFINITY)
			M.adjustToxLoss(2)
	..()

/datum/reagent/ethanol/gintonic
	name = "Gin and Tonic"
	id = "gintonic"
	description = "An all time classic, mild cocktail."
	color = "#664300" // rgb: 102, 67, 0
	boozepwr = 1

	glass_icon_state = "gintonicglass"
	glass_name = "glass of gin and tonic"
	glass_desc = "A mild but still great cocktail. Drink up, like a true Englishman."
	glass_center_of_mass = list("x"=16, "y"=7)

/datum/reagent/ethanol/goldschlager
	name = "Goldschlager"
	id = "goldschlager"
	description = "100 proof cinnamon schnapps, made for alcoholic teen girls on spring break."
	color = "#664300" // rgb: 102, 67, 0
	boozepwr = 3

	glass_icon_state = "ginvodkaglass"
	glass_name = "glass of Goldschlager"
	glass_desc = "100 proof that teen girls will drink anything with gold in it."
	glass_center_of_mass = list("x"=16, "y"=12)

/datum/reagent/hippies_delight
	name = "Hippies' Delight"
	id = "hippiesdelight"
	description = "You just don't get it maaaan."
	reagent_state = LIQUID
	color = "#664300" // rgb: 102, 67, 0

	glass_icon_state = "hippiesdelightglass"
	glass_name = "glass of Hippie's Delight"
	glass_desc = "A drink enjoyed by people during the 1960's."
	glass_center_of_mass = list("x"=16, "y"=8)

/datum/reagent/hippies_delight/on_mob_life(var/mob/living/M as mob)
	if(!M) M = holder.my_atom
	M.druggy = max(M.druggy, 50)
	if(!data) data = 1
	data++
	switch(data)
		if(1 to 5)
			if (!M.stuttering) M.stuttering = 1
			M.make_dizzy(10)
			if(prob(10)) M.emote(pick("twitch","giggle"))
		if(5 to 10)
			if (!M.stuttering) M.stuttering = 1
			M.make_jittery(20)
			M.make_dizzy(20)
			M.druggy = max(M.druggy, 45)
			if(prob(20)) M.emote(pick("twitch","giggle"))
		if (10 to 200)
			if (!M.stuttering) M.stuttering = 1
			M.make_jittery(40)
			M.make_dizzy(40)
			M.druggy = max(M.druggy, 60)
			if(prob(30)) M.emote(pick("twitch","giggle"))
		if(200 to INFINITY)
			if (!M.stuttering) M.stuttering = 1
			M.make_jittery(60)
			M.make_dizzy(60)
			M.druggy = max(M.druggy, 75)
			if(prob(40)) M.emote(pick("twitch","giggle"))
			if(prob(30)) M.adjustToxLoss(2)
	holder.remove_reagent(src.id, 0.2)
	..()
	return

/datum/reagent/ethanol/hooch
	name = "Hooch"
	id = "hooch"
	description = "Either someone's failure at cocktail making or attempt in alchohol production. In any case, do you really want to drink that?"
	color = "#664300" // rgb: 102, 67, 0
	boozepwr = 2
	dizzy_adj = 6
	slurr_adj = 5
	slur_start = 35			//amount absorbed after which mob starts slurring
	confused_start = 90	//amount absorbed after which mob starts confusing directions

	glass_icon_state = "glass_brown2"
	glass_name = "glass of Hooch"
	glass_desc = "You've really hit rock bottom now... your liver packed its bags and left last night."

/datum/reagent/ethanol/iced_beer
	name = "Iced Beer"
	id = "iced_beer"
	description = "A beer which is so cold the air around it freezes."
	color = "#664300" // rgb: 102, 67, 0
	boozepwr = 1

	glass_icon_state = "iced_beerglass"
	glass_name = "glass of iced beer"
	glass_desc = "A beer so frosty, the air around it freezes."
	glass_center_of_mass = list("x"=16, "y"=7)

/datum/reagent/ethanol/iced_beer/on_mob_life(var/mob/living/M as mob)
	if(M.bodytemperature > 270)
		M.bodytemperature = max(270, M.bodytemperature - (20 * TEMPERATURE_DAMAGE_COEFFICIENT)) //310 is the normal bodytemp. 310.055
	..()
	return

/datum/reagent/ethanol/irishcarbomb
	name = "Irish Car Bomb"
	id = "irishcarbomb"
	description = "Mmm, tastes like chocolate cake..."
	color = "#2E6671" // rgb: 46, 102, 113
	boozepwr = 3
	dizzy_adj = 5

	glass_icon_state = "irishcarbomb"
	glass_name = "glass of Irish Car Bomb"
	glass_desc = "An irish car bomb."
	glass_center_of_mass = list("x"=16, "y"=8)

/datum/reagent/ethanol/irish_cream
	name = "Irish Cream"
	id = "irishcream"
	description = "Whiskey-imbued cream, what else would you expect from the Irish."
	color = "#664300" // rgb: 102, 67, 0
	boozepwr = 2

	glass_icon_state = "irishcreamglass"
	glass_name = "glass of Irish cream"
	glass_desc = "It's cream, mixed with whiskey. What else would you expect from the Irish?"
	glass_center_of_mass = list("x"=16, "y"=9)

/datum/reagent/ethanol/longislandicedtea
	name = "Long Island Iced Tea"
	id = "longislandicedtea"
	description = "The liquor cabinet, brought together in a delicious mix. Intended for middle-aged alcoholic women only."
	color = "#664300" // rgb: 102, 67, 0
	boozepwr = 4

	glass_icon_state = "longislandicedteaglass"
	glass_name = "glass of Long Island iced tea"
	glass_desc = "The liquor cabinet, brought together in a delicious mix. Intended for middle-aged alcoholic women only."
	glass_center_of_mass = list("x"=16, "y"=8)

/datum/reagent/ethanol/manhattan
	name = "Manhattan"
	id = "manhattan"
	description = "The Detective's undercover drink of choice. He never could stomach gin..."
	color = "#664300" // rgb: 102, 67, 0
	boozepwr = 3

	glass_icon_state = "manhattanglass"
	glass_name = "glass of Manhattan"
	glass_desc = "The Detective's undercover drink of choice. He never could stomach gin..."
	glass_center_of_mass = list("x"=17, "y"=8)

/datum/reagent/ethanol/manhattan_proj
	name = "Manhattan Project"
	id = "manhattan_proj"
	description = "A scientist's drink of choice, for pondering ways to blow up the station."
	color = "#664300" // rgb: 102, 67, 0
	boozepwr = 5

	glass_icon_state = "proj_manhattanglass"
	glass_name = "glass of Manhattan Project"
	glass_desc = "A scienitst drink of choice, for thinking how to blow up the station."
	glass_center_of_mass = list("x"=17, "y"=8)

/datum/reagent/ethanol/manhattan_proj/on_mob_life(var/mob/living/M as mob)
	M.druggy = max(M.druggy, 30)
	..()
	return

/datum/reagent/ethanol/manly_dorf
	name = "The Manly Dorf"
	id = "manlydorf"
	description = "Beer and Ale, brought together in a delicious mix. Intended for true men only."
	color = "#664300" // rgb: 102, 67, 0
	boozepwr = 2

	glass_icon_state = "manlydorfglass"
	glass_name = "glass of The Manly Dorf"
	glass_desc = "A manly concotion made from Ale and Beer. Intended for true men only."

/datum/reagent/ethanol/margarita
	name = "Margarita"
	id = "margarita"
	description = "On the rocks with salt on the rim. Arriba~!"
	color = "#8CFF8C" // rgb: 140, 255, 140
	boozepwr = 3

	glass_icon_state = "margaritaglass"
	glass_name = "glass of margarita"
	glass_desc = "On the rocks with salt on the rim. Arriba~!"
	glass_center_of_mass = list("x"=16, "y"=8)

/datum/reagent/ethanol/mead
	name = "Mead"
	id = "mead"
	description = "A Viking's drink, though a cheap one."
	reagent_state = LIQUID
	color = "#664300" // rgb: 102, 67, 0
	boozepwr = 1.5
	nutriment_factor = 1 * FOOD_METABOLISM

	glass_icon_state = "meadglass"
	glass_name = "glass of mead"
	glass_desc = "A Viking's beverage, though a cheap one."
	glass_center_of_mass = list("x"=17, "y"=10)

/datum/reagent/ethanol/moonshine
	name = "Moonshine"
	id = "moonshine"
	description = "You've really hit rock bottom now... your liver packed its bags and left last night."
	color = "#664300" // rgb: 102, 67, 0
	boozepwr = 4

	glass_icon_state = "glass_clear"
	glass_name = "glass of moonshine"
	glass_desc = "You've really hit rock bottom now... your liver packed its bags and left last night."

/datum/reagent/neurotoxin
	name = "Neurotoxin"
	id = "neurotoxin"
	description = "A strong neurotoxin that puts the subject into a death-like state."
	reagent_state = LIQUID
	color = "#2E2E61" // rgb: 46, 46, 97

	glass_icon_state = "neurotoxinglass"
	glass_name = "glass of Neurotoxin"
	glass_desc = "A drink that is guaranteed to knock you silly."
	glass_center_of_mass = list("x"=16, "y"=8)

/datum/reagent/neurotoxin/on_mob_life(var/mob/living/carbon/M as mob)
	if(!M) M = holder.my_atom
	M.weakened = max(M.weakened, 3)
	if(!data) data = 1
	data++
	M.dizziness +=6
	switch(data)
		if(15 to 45)
			M.stuttering = max(M.stuttering+3,0)
		if(45 to 55)
			if (prob(50))
				M.confused = max(M.confused+3,0)
		if(55 to 200)
			M.druggy = max(M.druggy, 55)
		if(200 to INFINITY)
			M.adjustToxLoss(2)
	..()

/datum/reagent/ethanol/patron
	name = "Patron"
	id = "patron"
	description = "Tequila with silver in it, a favorite of alcoholic women in the club scene."
	color = "#585840" // rgb: 88, 88, 64
	boozepwr = 1.5

	glass_icon_state = "patronglass"
	glass_name = "glass of Patron"
	glass_desc = "Drinking patron in the bar, with all the subpar ladies."
	glass_center_of_mass = list("x"=7, "y"=8)

/datum/reagent/ethanol/pwine
	name = "Poison Wine"
	id = "pwine"
	description = "Is this even wine? Toxic! Hallucinogenic! Probably consumed in boatloads by your superiors!"
	color = "#000000" // rgb: 0, 0, 0 SHOCKER
	boozepwr = 1
	dizzy_adj = 1
	slur_start = 1
	confused_start = 1

	glass_icon_state = "pwineglass"
	glass_name = "glass of ???"
	glass_desc = "A black ichor with an oily purple sheer on top. Are you sure you should drink this?"
	glass_center_of_mass = list("x"=16, "y"=5)

/datum/reagent/ethanol/pwine/on_mob_life(var/mob/living/M as mob)
	if(!M) M = holder.my_atom
	M.druggy = max(M.druggy, 50)
	if(!data) data = 1
	data++
	switch(data)
		if(1 to 25)
			if (!M.stuttering) M.stuttering = 1
			M.make_dizzy(1)
			M.hallucination = max(M.hallucination, 3)
			if(prob(1)) M.emote(pick("twitch","giggle"))
		if(25 to 75)
			if (!M.stuttering) M.stuttering = 1
			M.hallucination = max(M.hallucination, 10)
			M.make_jittery(2)
			M.make_dizzy(2)
			M.druggy = max(M.druggy, 45)
			if(prob(5)) M.emote(pick("twitch","giggle"))
		if (75 to 150)
			if (!M.stuttering) M.stuttering = 1
			M.hallucination = max(M.hallucination, 60)
			M.make_jittery(4)
			M.make_dizzy(4)
			M.druggy = max(M.druggy, 60)
			if(prob(10)) M.emote(pick("twitch","giggle"))
			if(prob(30)) M.adjustToxLoss(2)
		if (150 to 300)
			if (!M.stuttering) M.stuttering = 1
			M.hallucination = max(M.hallucination, 60)
			M.make_jittery(4)
			M.make_dizzy(4)
			M.druggy = max(M.druggy, 60)
			if(prob(10)) M.emote(pick("twitch","giggle"))
			if(prob(30)) M.adjustToxLoss(2)
			if(prob(5)) if(ishuman(M))
				var/mob/living/carbon/human/H = M
				var/obj/item/organ/heart/L = H.internal_organs_by_name["heart"]
				if (L && istype(L))
					L.take_damage(5, 0)
		if (300 to INFINITY)
			if(ishuman(M))
				var/mob/living/carbon/human/H = M
				var/obj/item/organ/heart/L = H.internal_organs_by_name["heart"]
				if (L && istype(L))
					L.take_damage(100, 0)
	holder.remove_reagent(src.id, FOOD_METABOLISM)

/datum/reagent/ethanol/red_mead
	name = "Red Mead"
	id = "red_mead"
	description = "The true Viking's drink! Even though it has a strange red color."
	color = "#C73C00" // rgb: 199, 60, 0
	boozepwr = 1.5

	glass_icon_state = "red_meadglass"
	glass_name = "glass of red mead"
	glass_desc = "A true Viking's beverage, though its color is strange."
	glass_center_of_mass = list("x"=17, "y"=10)

/datum/reagent/ethanol/sbiten
	name = "Sbiten"
	id = "sbiten"
	description = "A spicy Vodka! Might be a little hot for the little guys!"
	color = "#664300" // rgb: 102, 67, 0
	boozepwr = 3

	glass_icon_state = "sbitenglass"
	glass_name = "glass of Sbiten"
	glass_desc = "A spicy mix of Vodka and Spice. Very hot."
	glass_center_of_mass = list("x"=17, "y"=8)

/datum/reagent/ethanol/sbiten/on_mob_life(var/mob/living/M as mob)
	if (M.bodytemperature < 360)
		M.bodytemperature = min(360, M.bodytemperature + (50 * TEMPERATURE_DAMAGE_COEFFICIENT)) //310 is the normal bodytemp. 310.055
	..()
	return

/datum/reagent/ethanol/screwdrivercocktail
	name = "Screwdriver"
	id = "screwdrivercocktail"
	description = "Vodka, mixed with plain ol' orange juice. The result is surprisingly delicious."
	color = "#A68310" // rgb: 166, 131, 16
	boozepwr = 3

	glass_icon_state = "screwdriverglass"
	glass_name = "glass of Screwdriver"
	glass_desc = "A simple, yet superb mixture of Vodka and orange juice. Just the thing for the tired engineer."
	glass_center_of_mass = list("x"=15, "y"=10)

/datum/reagent/ethanol/silencer
	name = "Silencer"
	id = "silencer"
	description = "A drink from Mime Heaven."
	nutriment_factor = 1 * FOOD_METABOLISM
	color = "#664300" // rgb: 102, 67, 0
	boozepwr = 4

	glass_icon_state = "silencerglass"
	glass_name = "glass of Silencer"
	glass_desc = "A drink from mime Heaven."
	glass_center_of_mass = list("x"=16, "y"=9)

/datum/reagent/ethanol/silencer/on_mob_life(var/mob/living/M as mob)
	if(!data) data = 1
	data++
	M.dizziness +=10
	if(data >= 55 && data <115)
		if (!M.stuttering) M.stuttering = 1
		M.stuttering += 10
	else if(data >= 115 && prob(33))
		M.confused = max(M.confused+15,15)
	..()
	return

/datum/reagent/ethanol/singulo
	name = "Singulo"
	id = "singulo"
	description = "A blue-space beverage!"
	color = "#2E6671" // rgb: 46, 102, 113
	boozepwr = 5
	dizzy_adj = 15
	slurr_adj = 15

	glass_icon_state = "singulo"
	glass_name = "glass of Singulo"
	glass_desc = "A blue-space beverage."
	glass_center_of_mass = list("x"=17, "y"=4)

/datum/reagent/ethanol/snowwhite
	name = "Snow White"
	id = "snowwhite"
	description = "A cold refreshment"
	color = "#FFFFFF" // rgb: 255, 255, 255
	boozepwr = 1.5

	glass_icon_state = "snowwhite"
	glass_name = "glass of Snow White"
	glass_desc = "A cold refreshment."
	glass_center_of_mass = list("x"=16, "y"=8)

/datum/reagent/ethanol/suidream
	name = "Sui Dream"
	id = "suidream"
	description = "Comprised of: White soda, blue curacao, melon liquor."
	color = "#00A86B" // rgb: 0, 168, 107
	boozepwr = 0.5

	glass_icon_state = "sdreamglass"
	glass_name = "glass of Sui Dream"
	glass_desc = "A froofy, fruity, and sweet mixed drink. Understanding the name only brings shame."
	glass_center_of_mass = list("x"=16, "y"=5)

/datum/reagent/ethanol/syndicatebomb
	name = "Syndicate Bomb"
	id = "syndicatebomb"
	description = "Tastes like terrorism!"
	color = "#2E6671" // rgb: 46, 102, 113
	boozepwr = 5

	glass_icon_state = "syndicatebomb"
	glass_name = "glass of Syndicate Bomb"
	glass_desc = "Tastes like terrorism!"
	glass_center_of_mass = list("x"=16, "y"=4)

/datum/reagent/ethanol/tequilla_sunrise
	name = "Tequila Sunrise"
	id = "tequillasunrise"
	description = "Tequila and orange juice. Much like a Screwdriver, only Mexican~"
	color = "#FFE48C" // rgb: 255, 228, 140
	boozepwr = 2

	glass_icon_state = "tequillasunriseglass"
	glass_name = "glass of Tequilla Sunrise"
	glass_desc = "Oh great, now you feel nostalgic about sunrises back on Terra..."

/datum/reagent/ethanol/threemileisland
	name = "Three Mile Island Iced Tea"
	id = "threemileisland"
	description = "Made for a woman, strong enough for a man."
	color = "#666340" // rgb: 102, 99, 64
	boozepwr = 5

	glass_icon_state = "threemileislandglass"
	glass_name = "glass of Three Mile Island iced tea"
	glass_desc = "A glass of this is sure to prevent a meltdown."
	glass_center_of_mass = list("x"=16, "y"=2)

/datum/reagent/ethanol/threemileisland/on_mob_life(var/mob/living/M as mob)
	M.druggy = max(M.druggy, 50)
	..()
	return

/datum/reagent/ethanol/toxins_special
	name = "Toxins Special"
	id = "phoronspecial"
	description = "This thing is ON FIRE! CALL THE DAMN SHUTTLE!"
	reagent_state = LIQUID
	color = "#664300" // rgb: 102, 67, 0
	boozepwr = 5

	glass_icon_state = "toxinsspecialglass"
	glass_name = "glass of Toxins Special"
	glass_desc = "Whoah, this thing is on FIRE"

/datum/reagent/ethanol/toxins_special/on_mob_life(var/mob/living/M as mob)
	if (M.bodytemperature < 330)
		M.bodytemperature = min(330, M.bodytemperature + (15 * TEMPERATURE_DAMAGE_COEFFICIENT)) //310 is the normal bodytemp. 310.055
	..()
	return

/datum/reagent/ethanol/vodkamartini
	name = "Vodka Martini"
	id = "vodkamartini"
	description = "Vodka with Gin. Not quite how 007 enjoyed it, but still delicious."
	color = "#664300" // rgb: 102, 67, 0
	boozepwr = 4

	glass_icon_state = "martiniglass"
	glass_name = "glass of vodka martini"
	glass_desc ="A bastardisation of the classic martini. Still great."
	glass_center_of_mass = list("x"=17, "y"=8)

/datum/reagent/ethanol/vodkatonic
	name = "Vodka and Tonic"
	id = "vodkatonic"
	description = "For when a gin and tonic isn't russian enough."
	color = "#0064C8" // rgb: 0, 100, 200
	boozepwr = 3
	dizzy_adj = 4
	slurr_adj = 3

	glass_icon_state = "vodkatonicglass"
	glass_name = "glass of vodka and tonic"
	glass_desc = "For when a gin and tonic isn't Russian enough."
	glass_center_of_mass = list("x"=16, "y"=7)

/datum/reagent/ethanol/white_russian
	name = "White Russian"
	id = "whiterussian"
	description = "That's just, like, your opinion, man..."
	color = "#A68340" // rgb: 166, 131, 64
	boozepwr = 3

	glass_icon_state = "whiterussianglass"
	glass_name = "glass of White Russian"
	glass_desc = "A very nice looking drink. But that's just, like, your opinion, man."
	glass_center_of_mass = list("x"=16, "y"=9)

/datum/reagent/ethanol/whiskey_cola
	name = "Whiskey Cola"
	id = "whiskeycola"
	description = "Whiskey, mixed with cola. Surprisingly refreshing."
	color = "#3E1B00" // rgb: 62, 27, 0
	boozepwr = 2

	glass_icon_state = "whiskeycolaglass"
	glass_name = "glass of whiskey cola"
	glass_desc = "An innocent-looking mixture of cola and Whiskey. Delicious."
	glass_center_of_mass = list("x"=16, "y"=9)

/datum/reagent/ethanol/whiskeysoda
	name = "Whiskey Soda"
	id = "whiskeysoda"
	description = "For the more refined griffon."
	color = "#664300" // rgb: 102, 67, 0
	boozepwr = 3

	glass_icon_state = "whiskeysodaglass2"
	glass_name = "glass of whiskey soda"
	glass_desc = "Ultimate refreshment."
	glass_center_of_mass = list("x"=16, "y"=9)

/datum/reagent/ethanol/specialwhiskey
	name = "Special Blend Whiskey"
	id = "specialwhiskey"
	description = "Just when you thought regular station whiskey was good... This silky, amber goodness has to come along and ruin everything."
	color = "#664300" // rgb: 102, 67, 0
	boozepwr = 2
	dizzy_adj = 4
	slur_start = 30		//amount absorbed after which mob starts slurring

	glass_icon_state = "whiskeyglass"
	glass_name = "glass of special blend whiskey"
	glass_desc = "Just when you thought regular station whiskey was good... This silky, amber goodness has to come along and ruin everything."
	glass_center_of_mass = list("x"=16, "y"=12)
