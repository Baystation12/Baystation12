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
	if (alien == IS_SKRELL && protein_amount > 0)
		var/datum/species/skrell/S = M.species
		S.handle_protein(M, src)
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

/datum/reagent/drink/juice/cabbage
	name = "Cabbage Juice"
	description = "It's a health drink, apparently."
	taste_description = "cabbage"
	color = "#1fb848"

	glass_name = "cabbage juice"
	glass_desc = "It's a health drink, apparently."

// Everything else

/datum/reagent/drink/milk
	name = "Milk"
	description = "An opaque white liquid produced by the mammary glands of mammals."
	taste_description = "milk"
	color = "#dfdfdf"

	glass_name = "milk"
	glass_desc = "White and nutritious goodness!"
	protein_amount = 0.75

/datum/reagent/drink/milk/affect_ingest(mob/living/carbon/M, alien, removed)
	..()
	if (alien == IS_DIONA)
		return
	M.heal_organ_damage(0.5 * removed, 0)
	holder.remove_reagent(/datum/reagent/capsaicin, 10 * removed)

/datum/reagent/drink/milk/chocolate
	name =  "Chocolate Milk"
	description = "A mixture of perfectly healthy milk and delicious chocolate."
	taste_description = "chocolate milk"
	color = "#74533b"

	glass_name = "chocolate milk"
	glass_desc = "Deliciously fattening!"
	protein_amount = 0.6

/datum/reagent/drink/milk/cream
	name = "Cream"
	description = "The fatty, still liquid part of milk. Why don't you mix this with sum scotch, eh?"
	taste_description = "creamy milk"
	color = "#dfd7af"

	glass_name = "cream"
	glass_desc = "Ewwww..."
	protein_amount = 1

/datum/reagent/drink/milk/soymilk
	name = "Soy Milk"
	description = "An opaque white liquid made from soybeans."
	taste_description = "soy milk"
	color = "#dfdfc7"

	glass_name = "soy milk"
	glass_desc = "White and nutritious soy goodness!"
	protein_amount = 0

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
	var/make_jittery = TRUE

/datum/reagent/drink/coffee/decaf
	name = "Decaffeinated Coffee"
	description = "Coffee but without the caffeine."
	taste_description = "decaffeinated bitterness"
	color = "#482000"
	glass_name = "decaf coffee"
	glass_desc = "Don't drop it, or you'll send scalding liquid and glass shards everywhere."
	make_jittery = FALSE

/datum/reagent/drink/coffee/decaf/build_presentation_name_from_reagents(var/obj/item/prop, var/supplied)
	. = "decaf [..()]"

// This is a bit of a hacky mess as it was originally written for a decl
// reagent system that didn't need to worry about all this bollocks.
GLOBAL_LIST_INIT(coffee_flavour_modifiers, new)
/datum/reagent/drink/coffee/New()
	..()
	if(!length(GLOB.coffee_flavour_modifiers))
		var/obj/item/temporary_holder = new
		temporary_holder.create_reagents(length(subtypesof(/datum/reagent/drink/syrup)))
		for(var/stype in subtypesof(/datum/reagent/drink/syrup))
			temporary_holder.reagents.add_reagent(stype, 1)
			var/inserted
			var/datum/reagent/drink/syrup/syrup = temporary_holder.reagents.get_reagent(stype)
			for(var/i = 1 to length(GLOB.coffee_flavour_modifiers))
				var/datum/reagent/drink/syrup/osyrup = GLOB.coffee_flavour_modifiers[i]
				if(syrup.coffee_priority <= osyrup.coffee_priority)
					GLOB.coffee_flavour_modifiers.Insert(i, syrup)
					inserted = TRUE
					break
			if(!inserted)
				GLOB.coffee_flavour_modifiers += syrup

/datum/reagent/drink/coffee/build_presentation_name_from_reagents(var/obj/item/prop, var/supplied)

	var/is_flavoured
	for(var/datum/reagent/drink/syrup/syrup in GLOB.coffee_flavour_modifiers)
		if(prop.reagents.has_reagent(syrup.type))
			is_flavoured = TRUE
			. = "[.][syrup.coffee_modifier] "

	var/milk =  prop.reagents.has_reagent(/datum/reagent/drink/milk)
	var/soy =   prop.reagents.has_reagent(/datum/reagent/drink/milk/soymilk)
	var/cream = prop.reagents.has_reagent(/datum/reagent/drink/milk/cream)
	var/chai =  prop.reagents.has_reagent(/datum/reagent/drink/tea/chai) ? "dirty " : ""
	if(!soy && !milk && !cream)
		if(is_flavoured)
			. = "[.]flavoured [chai]coffee"
		else
			. = "[.][chai]coffee"
	else if((milk+cream) > soy)
		. = "[.][chai]latte"
	else
		. = "[.][chai]soy latte"
	. = ..(prop, .)

/datum/reagent/drink/coffee/affect_ingest(var/mob/living/carbon/M, var/alien, var/removed)
	if(alien == IS_DIONA)
		return
	..()

	if(adj_temp > 0)
		holder.remove_reagent(/datum/reagent/frostoil, 10 * removed)
	if(!make_jittery)
		if(volume > 15)
			M.add_chemical_effect(CE_PULSE, 1)
		if(volume > 45)
			M.add_chemical_effect(CE_PULSE, 1)

/datum/reagent/drink/coffee/affect_blood(var/mob/living/carbon/M, var/alien, var/removed)
	..()
	if(!make_jittery)
		M.add_chemical_effect(CE_PULSE, 2)

/datum/reagent/drink/coffee/overdose(var/mob/living/carbon/M, var/alien)
	if(alien == IS_DIONA)
		return
	if(!make_jittery)
		M.make_jittery(5)
		M.add_chemical_effect(CE_PULSE, 1)

/datum/reagent/drink/hot_coco
	name = "Hot Chocolate"
	description = "Made with love! And cocoa beans."
	taste_description = "creamy chocolate"
	reagent_state = LIQUID
	color = "#403010"
	nutrition = 2
	adj_temp = 5
	protein_amount = 0.5

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

/datum/reagent/drink/triplecitrus
	name = "Triple Citrus"
	description = "Triple the citrus, triple the fun."
	taste_description = "unbearable sweetness"
	color = "#ff7f07"
	adj_temp = -5

	glass_name = "Triple Citrus"
	glass_desc = "Triple the citrus, triple the fun."

/datum/reagent/drink/orange_soda
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

/datum/reagent/drink/apple_soda
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
	protein_amount = 0.8

	glass_name = "Pork Soda"
	glass_desc = "I asked for a glass of PORT!"
	glass_special = list(DRINK_FIZZ)

/datum/reagent/drink/milkshake
	name = "Milkshake"
	description = "Glorious brainfreezing mixture."
	taste_description = "creamy vanilla"
	color = "#aee5e4"
	adj_temp = -9
	protein_amount = 0.5

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

/datum/reagent/drink/maplesyrup
	name = "Maple Syrup"
	description = "Canada is still going at it, no one can stop them."
	taste_description = "nutty, sugary goodness"
	color = "#b24403"

	glass_name = "maple syrup"
	glass_desc = "Thick and very sweet, the perfect Canadian treat to enjoy under a clear sky."

/datum/reagent/drink/maplesyrup/affect_ingest(mob/living/carbon/M, alien, removed)
	..()
	if(alien == IS_UNATHI)
		var/datum/species/unathi/S = M.species
		S.handle_sugar(M, src, 0.66)	//Maple syrup is about 2/3 sugar in real life

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

/datum/reagent/cinnamon
	name = "Cinnamon"
	description = "Delicious ground cinnamon spice. "
	taste_description = "cinnamon"
	reagent_state = SOLID
	color = "#cd6139"
	value = 0.1

	glass_name = "cinnamon"
	glass_desc = "Delicious ground cinnamon spice, why would you drink this?"

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

/datum/reagent/drink/milkshake/float
	name = "Cola Float"
	description = "A delicious combination of ice cream and cola."
	taste_description = "carbonated ice cream"
	reagent_state = LIQUID
	color = "#cfe5ae"
	adj_drowsy = -3
	adj_temp = -5
	protein_amount = 0.5

	glass_name = "Cola Float"
	glass_desc = "A delicious combination ofice cream and cola"
	glass_special = list(DRINK_FIZZ)

/datum/reagent/drink/vanilla_cola
	name = "Vanilla Cola"
	description = "A refreshing cola in vanilla flavour."
	taste_description = "vanilla cola"
	reagent_state = LIQUID
	color = "#100800"
	adj_drowsy = -3
	adj_temp = -5

	glass_name = "Space Cola"
	glass_desc = "A glass of refreshing Space Cola"
	glass_special = list(DRINK_FIZZ)

/datum/reagent/drink/orange_cola
	name = "Orange Cola"
	description = "A refreshing cola in orange flavour."
	taste_description = "orange cola"
	reagent_state = LIQUID
	color = "#100800"
	adj_drowsy = -3
	adj_temp = -5

	glass_name = "Space Cola"
	glass_desc = "A glass of refreshing Space Cola"
	glass_special = list(DRINK_FIZZ)

/datum/reagent/drink/cherry_cola
	name = "Cherry Cola"
	description = "A refreshing cola in cherry flavour."
	taste_description = "cherry cola"
	reagent_state = LIQUID
	color = "#100800"
	adj_drowsy = -3
	adj_temp = -5

	glass_name = "Space Cola"
	glass_desc = "A glass of refreshing Space Cola"
	glass_special = list(DRINK_FIZZ)

/datum/reagent/drink/coffee/coffee_cola
	name = "Coffee Cola"
	description = "There are people in town, man, crazy people in town."
	taste_description = "coffee and cola"
	reagent_state = LIQUID
	color = "#100800"
	adj_drowsy = -3
	adj_temp = -5

	glass_name = "Coffee Cola"
	glass_desc = "All you need is some bread and butter and honey"
	glass_special = list(DRINK_FIZZ)

/datum/reagent/drink/diet_cola
	name = "Diet Cola"
	description = "Refreshing diet cola. Contains anti-nutritional value."
	taste_description = "diet cola"
	reagent_state = LIQUID
	color = "#100800"
	adj_drowsy = -3
	adj_temp = -5

	glass_name = "Space Cola"
	glass_desc = "A glass of refreshing Space Cola"
	glass_special = list(DRINK_FIZZ)

/datum/reagent/drink/ionbru
	name = "Ion-Bru"
	description = "The official drink of some faraway, mountainous land."
	taste_description = "sweet orangy-creamy soda"
	color = "#a77718"
	adj_drowsy = -7
	adj_sleepy = -1
	adj_temp = -5

	glass_name = "Ion-Bru"
	glass_desc = "The official drink of some faraway, mountainous land."
	glass_special = list(DRINK_FIZZ)

/datum/reagent/drink/ironbru
	name = "Iron-Bru"
	description = "Tastes like industrial shipbuilding capability."
	taste_description = "metal girders"
	color = "#a77718"
	adj_drowsy = -7
	adj_sleepy = -1
	adj_temp = -5

	glass_name = "Iron-Bru"
	glass_desc = "The official drink of shipbuilders."
	glass_special = list(DRINK_FIZZ)

/datum/reagent/drink/dandelionburdock
	name = "Dandelion and Burdock"
	description = "Does not contain any Taraxacum officinale, or Arctium lappa."
	taste_description = "sassafras"
	reagent_state = LIQUID
	color = "#ff8cff"
	nutrition = 1

	glass_name = "Dandelion and Burdock"
	glass_desc = "A tall glass of DnB"

/datum/reagent/drink/doogh
	name = "Doogh"
	description = "A yogurt-based drink seasoned with salt and mint."
	taste_description = "savoury sourness"
	color = "#f7f5ca"

	glass_name = "doogh"
	glass_desc = "A yogurt-based drink seasoned with salt and mint."

/datum/reagent/drink/eggnog
	name = "Eggnog"
	description = "A chilled dairy-rich beverage. Too cool to keep to the holidays."
	taste_description = "eggy noggyness"
	color = "#619494"
	protein_amount = 0.8

	glass_name = "eggnog"
	glass_desc = "A delicious glass of eggnog."

/datum/reagent/drink/posca
	name = "Posca"
	description = "An ancient energy drink revived by Roman cosplayers on Luna."
	taste_description = "spiced vinegar"
	color = "#b3b599"

	glass_name = "posca"
	glass_desc = "An energy drink invented by the Romans and made space-famous by Luna cosplayers."

/datum/reagent/drink/alcoholfreebeer
	name = "Non-Alcoholic Beer"
	description = "An alcoholic beverage made from malted grains, hops, yeast, and water. This seems to be non-alcoholic"
	taste_description = "non-alcoholic piss water"
	color = "#ffd300"

	glass_name = "beer"
	glass_desc = "A freezing container of beer"

// Tea
/datum/reagent/drink/tea
	adj_dizzy = -2
	adj_drowsy = -1
	adj_sleepy = -3
	adj_temp = 20

/datum/reagent/drink/tea/build_presentation_name_from_reagents(var/obj/item/prop, var/supplied)
	. = supplied || glass_name
	if(prop.reagents.has_reagent(/datum/reagent/sugar) || prop.reagents.has_reagent(/datum/reagent/nutriment/honey))
		. = "sweet [.]"
	if(prop.reagents.has_reagent(/datum/reagent/drink/syrup/mint))
		. = "mint [.]"
	. = ..(prop, .)

/datum/reagent/drink/tea/affect_ingest(var/mob/living/carbon/M, var/alien, var/removed)
	..()
	if(alien == IS_DIONA)
		return
	M.adjustToxLoss(-0.5 * removed)

// black tea
/datum/reagent/drink/tea/black
	name = "Black Tea"
	description = "Tasty black tea, it has antioxidants, it's good for you!"
	taste_description = "tart black tea"
	color = "#101000"

	glass_name = "black tea"
	glass_desc = "Tasty black tea, it has antioxidants, it's good for you!"

/datum/reagent/drink/tea/black/build_presentation_name_from_reagents(var/obj/item/prop, var/supplied)
	if(prop.reagents.has_reagent(/datum/reagent/drink/juice/orange))
		if(prop.reagents.has_reagent(/datum/reagent/drink/milk))
			. = "London Fog"
		else if(prop.reagents.has_reagent(/datum/reagent/drink/milk/soymilk))
			. = "soy London Fog"
		else
			. = "Baron Grey"
	. = ..(prop, .)

//green tea
/datum/reagent/drink/tea/green
	name = "Green Tea"
	description = "Subtle green tea, it has antioxidants, it's good for you!"
	taste_description = "subtle green tea"
	color = "#b4cd94"

	glass_name = "green tea"
	glass_desc = "Subtle green tea, it has antioxidants, it's good for you!"

/datum/reagent/drink/tea/green/build_presentation_name_from_reagents(var/obj/item/prop, var/supplied)
	if(prop?.reagents?.has_reagent(/datum/reagent/drink/syrup/mint))
		. = "Maghrebi tea"
	. = ..(prop, .)

/datum/reagent/drink/tea/chai
	name = "Chai Tea"
	description = "A spiced, dark tea. Goes great with milk."
	taste_description = "spiced black tea"
	color = "#151000"

	glass_name = "chai tea"
	glass_desc = "A spiced, dark tea. Goes great with milk."

/datum/reagent/drink/tea/chai/build_presentation_name_from_reagents(var/obj/item/prop, var/supplied)
	if(prop.reagents.has_reagent(/datum/reagent/drink/milk))
		. = "chai latte"
	else if(prop.reagents.has_reagent(/datum/reagent/drink/milk/soymilk))
		. = "soy chai latte"
	. = ..(prop, .)

/datum/reagent/drink/tea/red
	name = "Rooibos Tea"
	description = "A caffeine-free dark red tea, flavorful and full of antioxidants."
	taste_description = "nutty red tea"
	color = "#ab4c3a"

	glass_name = "rooibos tea"
	glass_desc = "A caffeine-free dark red tea, flavorful and full of antioxidants."

/datum/reagent/drink/syrup
	var/coffee_priority
	var/coffee_modifier

/datum/reagent/drink/syrup/New()
	..()
	if(!coffee_modifier)
		coffee_modifier = taste_description

/datum/reagent/drink/syrup/mint
	name = "Mint Syrup"
	description = "Thick mint syrup used to flavor drinks."
	taste_description = "sweet mint"
	color = "#07aab2"
	coffee_priority = 1
	coffee_modifier = "mint"

	glass_name = "mint syrup"
	glass_desc = "Thick mint syrup used to flavor drinks."

/datum/reagent/drink/syrup/chocolate
	name = "Chocolate Syrup"
	description = "Thick chocolate syrup used to flavor drinks."
	taste_description = "chocolate"
	color = "#542a0c"
	coffee_modifier = "mocha"
	coffee_priority = 5

	glass_name = "chocolate syrup"
	glass_desc = "Thick chocolate syrup used to flavor drinks."

/datum/reagent/drink/syrup/caramel
	name = "Caramel Syrup"
	description = "Thick caramel syrup used to flavor drinks."
	taste_description = "caramel"
	color = "#85461e"
	coffee_priority = 2

	glass_name = "caramel syrup"
	glass_desc = "Thick caramel syrup used to flavor drinks."

/datum/reagent/drink/syrup/vanilla
	name = "Vanilla Syrup"
	description = "Thick vanilla syrup used to flavor drinks."
	taste_description = "vanilla"
	color = "#f3e5ab"
	coffee_priority = 3

	glass_name = "vanilla syrup"
	glass_desc = "Thick vanilla syrup used to flavor drinks."

/datum/reagent/drink/syrup/pumpkin
	name = "Pumpkin Spice Syrup"
	description = "Thick spiced pumpkin syrup used to flavor drinks."
	taste_description = "spiced pumpkin"
	color = "#d88b4c"
	coffee_priority = 4

	glass_name = "pumpkin spice syrup"
	glass_desc = "Thick spiced pumpkin syrup used to flavor drinks."

// Alien Drinks

/datum/reagent/drink/alien/unathijuice
	name = "Hrukhza Leaf Extract"
	description = "A bitter liquid used in most recipes on Moghes."
	taste_description = "bland, disgusting bitterness"
	color = "#345c52"
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
	color = "#550000"
	glass_name = "Mumbak sting"
	glass_desc = "A drink made from the venom of the Yuum."

/datum/reagent/ethanol/alien/wasgaelhi
	name = "Wasgaelhi"
	description = "Wine made from various fruits from the swamps of Moghes."
	taste_description = "swampy fruit"
	color = "#6b596b"
	strength = 10
	glass_name = "wasgaelhi"
	glass_desc = "Wine made from various fruits from the swamps of Moghes."

/datum/reagent/drink/alien/skrianhi
	name = "Skrianhi Tea"
	description = "A blend of teas from Moghes, commonly drank by Unathi."
	taste_description = "bitter energising tea"
	color = "#0e0900"
	glass_name = "skrianhi tea"
	glass_desc = "A blend of teas from Moghes, commonly drank by Unathi."