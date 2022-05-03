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

/datum/reagent/ethanol/baijiu
	name = "Baijiu"
	description = "An extremely popular clear, alcoholic drink made from sorghum or rice."
	taste_description = "sweet fruit and nuts"
	color = "#f7f6e0"
	strength = 25
	alpha = 120

	glass_name = "baijiu"
	glass_desc = "A clear glass of baijiu."

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

/datum/reagent/ethanol/blackstrap
	name = "Blackstrap"
	description = "A classic mix of rum and molasses, favorite of frontiersmen everywhere."
	taste_description = "sweet and strong alcohol"
	color = "#161612"
	strength = 30

	glass_name = "blackstrap"
	glass_desc = "A classic mix of rum and molasses."

/datum/reagent/ethanol/bluecuracao
	name = "Blue Curacao"
	description = "Exotically blue, fruity drink, distilled from oranges."
	taste_description = "oranges"
	taste_mult = 1.1
	color = "#0000cd"
	strength = 15

	glass_name = "blue curacao"
	glass_desc = "Exotically blue, fruity drink, distilled from oranges."

/datum/reagent/ethanol/cachaca
	name = "Cachaca"
	description = "A sweet alcoholic drink made from fermented sugarcane."
	taste_description = "sweet, tropical juice"
	color = "#d7d3b4"
	strength = 25

	glass_name = "cachaca"
	glass_desc = "A sweet alcoholic drink made from fermented sugarcane."

/datum/reagent/ethanol/champagne
	name = "Champagne"
	description = "Smooth sparkling wine, produced in the same region of France as it has for centuries."
	taste_description = "a superior taste of sparkling wine"
	color = "#e8dfc1"
	strength = 25

	glass_name = "champagne"
	glass_desc = "Smooth sparkling wine, produced in the same region of France as it has for centuries."

/datum/reagent/ethanol/cognac
	name = "Cognac"
	description = "A sweet and strongly alchoholic drink, made after numerous distillations and years of maturing. Classy as fornication."
	taste_description = "rich and smooth alcohol"
	taste_mult = 1.1
	color = "#ab3c05"
	strength = 15

	glass_name = "cognac"
	glass_desc = "Damn, you feel like some kind of French aristocrat just by holding this."

/datum/reagent/ethanol/creme_de_cacao
	name = "Creme de Cacao"
	description = "A chocolatey liqueur for those who like their drinks undeniably sweet."
	taste_description = "rustic chocolate"
	color = "#2e2312"
	strength = 50

	glass_name = "creme de cacao"
	glass_desc = "Perfect for a night in the lodge."

/datum/reagent/ethanol/creme_de_menthe
	name = "Creme de Menthe"
	description = "A sweet, mint-flavored alcoholic beverage"
	taste_description = "melted breathmints"
	color = "#98ecb4"
	strength = 50

	glass_name = "creme de menthe"
	glass_desc = "It's hard not to imagine it as mouthwash."

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

/datum/reagent/ethanol/iridast
	name = "Iridast Berry Juice"
	description = "An intoxicating juice made from the Iridast Berry, common across human worlds."
	taste_description = "incredible sweetness"
	color = "#fa68ff"
	strength = 50

	glass_name = "iridast berry juice"
	glass_desc = "An intoxicating juice made from the Iridast Berry, common across human worlds."

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

/datum/reagent/ethanol/llanbrydewhiskey
	name = "Llanbryde Whiskey"
	description = "Welsh Whiskey. So good it should be illegal."
	taste_description = "distilled welsh highlands"
	color = "#805200"
	strength = 10

	glass_name = "Llanbryde whiskey"
	glass_desc = "A premium Welsh whiskey."

/datum/reagent/ethanol/melonliquor
	name = "Melon Liquor"
	description = "A relatively sweet and fruity 46 proof liquor."
	taste_description = "fruity alcohol"
	color = "#138808" // rgb: 19, 136, 8
	strength = 50

	glass_name = "melon liquor"
	glass_desc = "A relatively sweet and fruity 46 proof liquor."

/datum/reagent/ethanol/rakia
	name = "Rakia"
	description = "Fruit brandy, typically made from grapes or other fruits."
	taste_description = "dry grape"
	color = "#c2d6b7"
	strength = 25

	glass_name = "Rakia"
	glass_desc = "Fruit brandy. Delicious."

/datum/reagent/ethanol/rum
	name = "Rum"
	description = "The historic drink of Earth navies. Extremely popular across Sol space."
	taste_description = "spiked butterscotch"
	taste_mult = 1.1
	color = "#ecb633"
	strength = 15

	glass_name = "rum"
	glass_desc = "Now you want to Pray for a pirate suit, don't you?"

/datum/reagent/ethanol/prosecco
	name = "Prosecco"
	description = "A delightful blend of glera grapes, native to Earth."
	taste_description = "the trials of being a young woman in a rich man's world"
	color = "#e8dfc1"
	strength = 30

	glass_name = "prosecco"
	glass_desc = "A delightful blend of glera grapes, native to Earth."

/datum/reagent/ethanol/sake
	name = "Sake"
	description = "Anime's favorite drink."
	taste_description = "dry alcohol"
	color = "#dddddd"
	strength = 25

	glass_name = "sake"
	glass_desc = "A glass of sake."

/datum/reagent/ethanol/soju
	name = "Soju"
	description = "An alcoholic drink made with rice."
	taste_description = "subtle, mild sweetness"
	color = "#dddddd"
	strength = 25

	glass_name = "soju"
	glass_desc = "A glass of soju."

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

/datum/reagent/ethanol/triple_sec
	name = "Triple Sec"
	description = "It smells like oranges."
	taste_description = "sweet citrus"
	color = "#fac840"
	strength = 15

	glass_name = "triple sec"
	glass_desc = "For when you want to get drunk, but don't want to taste the alcohol."

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

/datum/reagent/ethanol/specialwhiskey
	name = "Special Blend Whiskey"
	description = "Just when you thought regular whiskey was good... This silky, amber goodness has to come along and ruin everything."
	taste_description = "liquid fire"
	color = "#523600"
	strength = 25

	glass_name = "special blend whiskey"
	glass_desc = "Just when you thought regular whiskey was good... This silky, amber goodness has to come along and ruin everything."

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

/datum/reagent/ethanol/alexander
	name = "Alexander"
	description = "Better be careful - it's stronger than it looks..."
	taste_description = "chocolate covered brandy"
	color = "#745e3d"
	strength = 15

	glass_name = "Alexander"
	glass_desc = "A drink for those who wish to conquer the world, while looking classy at the same time."

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
	protein_amount = 0.3

	glass_name = "B-52"
	glass_desc = "Kahlua, Irish cream, and congac. You will get bombed."

/datum/reagent/ethanol/bad_touch
	name = "Bad Touch"
	description = "We're nothing but mammals, after all."
	taste_description = "sour sadness"
	color = "#0f8a42"
	strength = 20

	glass_name = "Bad Touch"
	glass_desc = "We're nothing but mammals, after all."

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

/datum/reagent/ethanol/drifter
	name = "Drifter"
	description = "Because you'll be drifting off to sleep pretty soon."
	taste_description = "heavy, sticky booze and a hint of citrus"
	color = "#e7d534"
	strength = 12

	glass_name = "Drifter"
	glass_desc = "A heavy duty nightcap. The taste might wake you up, though."

/datum/reagent/ethanol/drifter/affect_ingest(mob/living/carbon/M, alien, removed)
	. = ..()
	if (alien == IS_DIONA)
		return
	var/sleep_chance = 1
	if (alien == IS_SKRELL)
		sleep_chance = 2
	if (prob(sleep_chance))
		M.sleeping = max(M.sleeping, 1)

/datum/reagent/ethanol/bilk
	name = "Bilk"
	description = "This appears to be beer mixed with milk. Disgusting."
	taste_description = "desperation and lactate"
	color = "#895c4c"
	strength = 50
	nutriment_factor = 2
	protein_amount = 0.5

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

/datum/reagent/ethanol/bogus
	name = "Bogus"
	description = "A blend of Gin and Blackstrap."
	taste_description = "conflicting tastes and a delicious resolution"
	color = "#e8dfc1"
	strength = 30

	glass_name = "bogus"
	glass_desc = "A blend of Gin and Molasses."

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

/datum/reagent/ethanol/caesar
	name = "Bloody Caesar"
	description = "Vodka, mixed with tomato juice and hot sauce. Dash with salt and pepper."
	taste_description = "broth, protein, and spicy vodka, eh?"
	color = "#712e2e"
	strength = 30

	glass_name = "Bloody Caesar"
	glass_desc = "Vodka with a special tomato and hot sauce mix. Dash with salt and pepper and serve with lime."

/datum/reagent/ethanol/caipirinha
	name = "Capirinha"
	description = "Cachaca and lime. Felicidades!"
	taste_description = "sweet tropical alcohol and lime"
	color = "#fafedf"
	strength = 30

	glass_name = "capirinha"
	glass_desc = "Cachaca and lime. Felicidades!."

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

/datum/reagent/ethanol/cobalt_velvet
	name = "Cobalt Velvet"
	description = "It's like champagne served in a cup that had a bit of cola left."
	taste_description = "burning sweetness"
	color = "#238b99"
	strength = 40

	glass_name = "Cobalt Velvet"
	glass_desc = "It's like champagne served in a cup that had a bit of cola left."

/datum/reagent/ethanol/daiquiri
	name = "Daiquiri"
	description = "Rum, mixed with lime juice and syrup."
	taste_description = "a historically bad decision"
	color = "#3e1b00"
	strength = 30

	glass_name = "Daiquiri"
	glass_desc = "A classic cocktail made with rum."

/datum/reagent/ethanol/dawa
	name = "Dawa"
	description = "Vodka, honey, and lime. Perfect."
	taste_description = "a warm savannah"
	color = "#d7baa4"
	strength = 30

	glass_name = "Deva"
	glass_desc = "A classic cocktail made with vodka, honey, and lime."

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

/datum/reagent/ethanol/forget_me_shot
	name = "Forget Me Shot"
	description = "If you haven't heard of it, that means it worked."
	taste_description = "mind-numbing venom"
	color = "#a8934b"
	strength = 5

	glass_name = "Forget Me Shot"
	glass_desc = "Mixed with a pregnancy test until it turned positive."

/datum/reagent/ethanol/ginfizz
	name = "Gin Fizz"
	description = "Refreshingly lemony, deliciously dry."
	taste_description = "dry, tart lemons"
	color = "#ffffae"
	strength = 30

	glass_name = "gin fizz"
	glass_desc = "Refreshingly lemony, deliciously dry."

/datum/reagent/ethanol/grasshopper
	name = "Grasshopper"
	description = "Like a chocolate mint, but alcoholic!"
	taste_description = "minty chocolate"
	color = "#59c08d"
	strength = 30

	glass_name = "Grasshopper"
	glass_desc = "For a nice after-dinner drink."

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

/datum/reagent/ethanol/fringe_weaver
	name = "Fringe Weaver"
	description = "It's like drinking ethylic alcohol with a spoonful of sugar."
	taste_description = "burning with a hint of sweetness"
	color = "#ffafe0"
	strength = 10

	glass_name = "Fringe Weaver"
	glass_desc = "It's like drinking ethylic alcohol with a spoonful of sugar."

/datum/reagent/ethanol/coffee/gargled
	name = "Gargled"
	description = "A blend of Blackstrap and Coffee. An ideal pick-me-up for any rancher."
	taste_description = "comforting warmth"
	color = "#e8dfc1"
	strength = 50

	glass_name = "gargled"
	glass_desc = "A blend of Blackstrap and Coffee. An ideal pick-me-up for any rancher."

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

/datum/reagent/ethanol/honeywine
	name = "Honey Wine"
	description = "A mixture of hops and honey. Also known as Tej."
	taste_description = "sweet and tanic alcohol"
	color = "#898873"
	strength = 50

	glass_name = "honey wine"
	glass_desc = "A mixture of hops and honey. Also known as Tej."

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
	protein_amount = 0.5

	glass_name = "Irish cream"
	glass_desc = "It's cream, mixed with whiskey. What else would you expect from the Irish?"

/datum/reagent/ethanol/kamikaze
	name = "Kamikaze"
	description = "One must truly prepare themselves for this drink."
	taste_description = "sour explosions"
	color = "#e6e945"
	strength = 15

	glass_name = "Kamikaze"
	glass_desc = "This must have started as a joke, right? No one is supposed to drink this..."

/datum/reagent/ethanol/kvass
	name = "Kvass"
	description = "An alcoholic drink commonly made from bread."
	taste_description = "vkusnyy kvas, ypa!"
	color = "#362f22"
	strength = 30

	glass_name = "kvass"
	glass_desc = "An alcoholic drink commonly made from bread."

/datum/reagent/ethanol/lager
	name = "Lager"
	description = "A dark, musty beer commonly consumed across space."
	taste_description = "smooth, crisp lager"
	color = "#e0b900"
	strength = 50
	nutriment_factor = 1

	glass_name = "lager"
	glass_desc = "A dark, musty beer commonly consumed across space."

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

/datum/reagent/ethanol/stinger
	name = "Stinger"
	description = "A popular drink, known for its ability to mask the taste of inferior brandies with the strong flavor of creme de menthe."
	taste_description = "the prohibition"
	color = "#8f8465"
	strength = 13

	glass_name = "Stinger"
	glass_desc = "Holding this glass will make you seem like high-soceity... if you were from the 1800s."

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

/datum/reagent/ethanol/oldfashioned
	name = "Old Fashioned"
	description = "A classic mix of whiskey, sugar, and herbal liqour."
	taste_description = "smooth silkiness"
	color = "#976100"
	strength = 25

	glass_name = "old fashioned"
	glass_desc = "This iconic cocktail demands respect."

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

/datum/reagent/ethanol/nevadan_gold
	name = "Nevadan Gold Whiskey"
	description = "A warm blend of 98 spices. Made on the homeworld."
	taste_description = "strong, creamy whiskey"
	color = "#ce1900"
	strength = 10

	glass_name = "Nevadan gold whiskey"
	glass_desc = "A warm blend of 98 spices, brewed on Earth. A delicious mix."

/datum/reagent/ethanol/patron
	name = "Patron"
	description = "Tequila with silver in it, a favorite of alcoholic women in the club scene."
	taste_description = "metallic and expensive"
	color = "#585840"
	strength = 30

	glass_name = "Patron"
	glass_desc = "Drinking patron in the bar, with all the subpar ladies."

/datum/reagent/ethanol/pinacolada
	name = "Pina Colada"
	description = "A sweet cocktail of rum and pineapple."
	taste_description = "refreshing tropical fruit"
	color = "#f1fa56"
	strength = 15

	glass_name = "pina colada"
	glass_desc = "A sweet cocktail of rum and pineapple."

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

/datum/reagent/ethanol/posset
	name = "Posset"
	description = "A type of hot milk mixed with lemon and ale. Known mostly as a Terran delicacy."
	taste_description = "warm cream and lemon"
	color = "#e3e5bf"
	strength = 50
	protein_amount = 0.5

	glass_name = "posset"
	glass_desc = "A sweet hot milk mixed with lemon and ale. A Terran delicacy"

/datum/reagent/ethanol/red_mead
	name = "Red Mead"
	description = "The true Viking's drink! Even though it has a strange red color."
	taste_description = "sweet and salty alcohol"
	color = "#c73c00"
	strength = 30

	glass_name = "red mead"
	glass_desc = "A true Viking's beverage, though its color is strange."

/datum/reagent/ethanol/red_whiskey
	name = "Red Whiskey"
	description = "A dark red looking substance that smells like strong whiskey."
	taste_description = "an intense throat burning sensation"
	color = "#ce1900"
	strength = 10

	glass_name = "red whiskey"
	glass_desc = "A dark red looking substance that smells like strong whiskey."

/datum/reagent/ethanol/sangria
	name = "Sangria"
	description = "A mix of red wine and orange juice. Serve with slices."
	taste_description = "fruity wine"
	color = "#e06c3a"
	strength = 30

	glass_name = "sangria"
	glass_desc = "A mix of red wine and orange juice. Serve with slices."

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

/datum/reagent/ethanol/sidecar
	name = "Sidecar"
	description = "A mix of cognac, lemon juice, and curacao."
	taste_description = "smooth, rich, sweetness"
	color = "#2e6671"
	strength = 30

	glass_name = "Sidecar"
	glass_desc = "A classic cocktail of cognac and lemon juice."

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

/datum/reagent/ethanol/stag
	name = "Stag"
	description = "A traditional brew consumed by various members of the Fleet."
	taste_description = "relief from duty"
	color = "#362f22"
	strength = 100
	glass_name = "stag"
	glass_desc = "A classic mix of rum and tea, ideal for long nights on watch."

/datum/reagent/ethanol/sugar_rush
	name = "Sugar Rush"
	description = "Sweet, light, and fruity - as girly as it gets."
	taste_description = "unbearable sweetness"
	color = "#f37ee9"
	strength = 100

	glass_name = "Sugar Rush"
	glass_desc = "Sweet, light, and fruity - as girly as it gets."

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

/datum/reagent/ethanol/vodkacola
	name = "Vodka Cola"
	description = "A refreshing mix of vodka and cola."
	taste_description = "vodka and cola"
	color = "#474238"
	strength = 15
	glass_name = "vodka cola"
	glass_desc = "A refreshing mix of vodka and cola."

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

/datum/reagent/ethanol/lonestarmule
	name = "Lonestar Mule"
	description = "A classic Martian take on the moscow mule. Replaces vodka with molasses."
	taste_description = "crisp, refreshing ginger beer and molasses"
	color = "#92938a"
	strength = 15

	glass_name = "lonestar mule"
	glass_desc = "A blend of whiskey, ginger beer, and lime juice."

/datum/reagent/ethanol/tadmorwine
	name = "Tadmoran Wine"
	description = "An earthy type of wine distilled from grapes on Tadmor."
	taste_description = "an acquired taste and holier-than-thou vibes"
	color = "#362f22"
	strength = 10

	glass_name = "Tadmor wine"
	glass_desc = "An earthy type of wine distilled from grapes on Tadmor."

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

/datum/reagent/ethanol/alien/qokkhrona
	name = "Qokk'hrona"
	description = "Delicious Skrellian wine from refined qokk'loa."
	taste_description = "a thick potion of mushroom, slime, and hard alcohol"
	color = "#c76c4d"
	strength = 100
	druggy = 5

	glass_name = "qokk'hrona"
	glass_desc = "Delicious Skrellian wine from refined qokk'loa."

/datum/reagent/ethanol/horchata
	name = "Horchata"
	description = "A delightful horchata de chufa."
	taste_description = "creamy, mediterranean alcohol"
	color = "#f5ecb8"
	strength = 40

	glass_name = "horchata"
	glass_desc = "A lovely looking horchata del chufa."