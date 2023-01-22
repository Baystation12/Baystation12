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

/datum/reagent/drink/juice/lettuce
	name = "Lettuce Juice"
	description = "It's mostly water, just a bit more lettucy"
	taste_description = "fresh greens"
	color = "#29df4b"

	glass_name = "lettuce juice"
	glass_desc = "This is just lettuce water. Fresh but boring."

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
	protein_amount = 0.5

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
	protein_amount = 0.5

	glass_name = "iced cafe latte"
	glass_desc = "A nice, strong and refreshing beverage while you are reading. This one's cold."

/datum/reagent/drink/coffee/icecoffee/cafe_latte/affect_ingest(var/mob/living/carbon/M, var/alien, var/removed)
	..()
	M.heal_organ_damage(0.5 * removed, 0)

/datum/reagent/drink/coffee/cafe_latte/mocha
	name = "Mocha Latte"
	description = "Coffee and chocolate, smooth and creamy."
	taste_description = "bitter creamy chocolate"
	protein_amount = 0.3
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
	protein_amount = 0.3

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
	protein_amount = 0.3

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
	color = "#55381b"
	adj_drowsy = -3
	adj_temp = -5

	glass_name = "Vanilla Cola"
	glass_desc = "A glass of refreshing Space Cola with hints of vanilla."
	glass_special = list(DRINK_FIZZ)

/datum/reagent/drink/orange_cola
	name = "Orange Cola"
	description = "A refreshing cola in orange flavour."
	taste_description = "orange cola"
	reagent_state = LIQUID
	color = "#a86017"
	adj_drowsy = -3
	adj_temp = -5

	glass_name = "Orange Cola"
	glass_desc = "A glass of refreshing Space Cola with orange flavoring."
	glass_special = list(DRINK_FIZZ)

/datum/reagent/drink/cherry_cola
	name = "Cherry Cola"
	description = "A refreshing cola in cherry flavour."
	taste_description = "cherry cola"
	reagent_state = LIQUID
	color = "#641010"
	adj_drowsy = -3
	adj_temp = -5

	glass_name = "Cherry Cola"
	glass_desc = "A glass of refreshing Space Cola with cherry flavoring."
	glass_special = list(DRINK_FIZZ)

/datum/reagent/drink/coffee/coffee_cola
	name = "Coffee Cola"
	description = "There are people in town, man, crazy people in town."
	taste_description = "coffee and cola"
	reagent_state = LIQUID
	color = "#3b240c"
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

	glass_name = "Diet Cola"
	glass_desc = "A glass of refreshing Space Cola. This one's calorie-free!"
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
// black tea
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
	protein_amount = 0.5

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
	protein_amount = 0.5

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
	protein_amount = 0.5

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
	protein_amount = 0.5

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

/datum/reagent/drink/decafcoffee
	name = "Decaffeinated Coffee"
	description = "Coffee but without the caffeine."
	taste_description = "decaffeinated bitterness"
	color = "#482000"

	glass_name = "decaf coffee"
	glass_desc = "Don't drop it, or you'll send scalding liquid and glass shards everywhere."

/datum/reagent/drink/coffee/espresso
	name = "Espresso"
	description = "Extra strong coffee."
	taste_description = "deluxe bitterness"
	color = "#482000"

	glass_name = "espresso"
	glass_desc = "Don't drop it, or you'll send scalding liquid and glass shards everywhere."

/datum/reagent/drink/coffee/americano
	name = "Americano"
	description = "Diluted Espresso."
	taste_description = "dark bitterness"
	color = "#482000"

	glass_name = "americano"
	glass_desc = "Pa pa l' americano"

/datum/reagent/drink/coffee/yuenyeung
	name = "Yuenyeung"
	description = "Also known as Coffee with Tea."
	taste_description = "refreshing and energising"
	color = "#482000"

	glass_name = "yeunyeung"
	glass_desc = "Coffee with tea. Delicious."

/datum/reagent/drink/coffee/iced/frappe
	name = "Iced Frappe"
	description = "A cool coffee chilled with ice."
	taste_description = "refreshing brainfreeze"
	color = "#482000"

	glass_name = "iced frappe"
	glass_desc = "A cool coffee with ice."

/datum/reagent/ethanol/coffee/carajillo
	name = "Carajillo"
	description = "Just a regular coffee, hombre."
	taste_description = "la voluntad de vivir"
	color = "#482000"

	glass_name = "iced frappe"
	glass_desc = "A cool, milky coffee with ice... And Kahlua."

/datum/reagent/drink/tea/decaf
	name = "Decaffeinated Tea"
	description = "Tea, already with limited caffeine, now with even less."
	taste_description = "bitter tea"
	color = "#101000"

	glass_name = "decaf tea"
	glass_desc = "Tasty black tea, it has antioxidants, it's good for you!"

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
