

/obj/item/weapon/reagent_containers/food/drinks/drinkingglass
	name = "glass"
	desc = "Your standard drinking glass."
	icon_state = "glass_empty"
	amount_per_transfer_from_this = 10
	volume = 50
	CoM = list("x"=16, "y"=10)

	on_reagent_change()
		/*if(reagents.reagent_list.len > 1 )
			icon_state = "glass_brown"
			name = "Glass of Hooch"
			desc = "Two or more drinks, mixed together."*/
		/*else if(reagents.reagent_list.len == 1)
			for(var/datum/reagent/R in reagents.reagent_list)
				switch(R.id)*/
		if (reagents.reagent_list.len > 0)
			//mrid = R.get_master_reagent_id()
			switch(reagents.get_master_reagent_id())
				if("beer")
					icon_state = "beerglass"
					name = "Beer glass"
					desc = "A freezing pint of beer"
					CoM = list("x"=16, "y"=8)
				if("beer2")
					icon_state = "beerglass"
					name = "Beer glass"
					desc = "A freezing pint of beer"
					CoM = list("x"=16, "y"=8)
				if("ale")
					icon_state = "aleglass"
					name = "Ale glass"
					desc = "A freezing pint of delicious Ale"
					CoM = list("x"=16, "y"=8)
				if("milk")
					icon_state = "glass_white"
					name = "Glass of milk"
					desc = "White and nutritious goodness!"
					CoM = list("x"=16, "y"=10)
				if("cream")
					icon_state  = "glass_white"
					name = "Glass of cream"
					desc = "Ewwww..."
					CoM = list("x"=16, "y"=10)
				if("chocolate")
					icon_state  = "chocolateglass"
					name = "Glass of chocolate"
					desc = "Tasty"
					CoM = list("x"=16, "y"=10)
				if("lemonjuice")
					icon_state  = "lemonglass"
					name = "Glass of lemonjuice"
					desc = "Sour..."
					CoM = list("x"=16, "y"=10)
				if("cola")
					icon_state  = "glass_brown"
					name = "Glass of Space Cola"
					desc = "A glass of refreshing Space Cola"
					CoM = list("x"=16, "y"=10)
				if("nuka_cola")
					icon_state = "nuka_colaglass"
					name = "Nuka Cola"
					desc = "Don't cry, Don't raise your eye, It's only nuclear wasteland"
					CoM = list("x"=16, "y"=6)
				if("orangejuice")
					icon_state = "glass_orange"
					name = "Glass of Orange juice"
					desc = "Vitamins! Yay!"
					CoM = list("x"=16, "y"=10)
				if("tomatojuice")
					icon_state = "glass_red"
					name = "Glass of Tomato juf"
					desc = "Are you sure this is tomato juice?"
					CoM = list("x"=16, "y"=10)
				if("blood")
					icon_state = "glass_red"
					name = "Glass of Tomato juice"
					desc = "Are you sure this is tomato juice?"
					CoM = list("x"=16, "y"=10)
				if("limejuice")
					icon_state = "glass_green"
					name = "Glass of Lime juice"
					desc = "A glass of sweet-sour lime juice."
					CoM = list("x"=16, "y"=10)
				if("whiskey")
					icon_state = "whiskeyglass"
					name = "Glass of whiskey"
					desc = "The silky, smokey whiskey goodness inside the glass makes the drink look very classy."
					CoM = list("x"=16, "y"=12)
				if("gin")
					icon_state = "ginvodkaglass"
					name = "Glass of gin"
					desc = "A crystal clear glass of Griffeater gin."
					CoM = list("x"=16, "y"=12)
				if("vodka")
					icon_state = "ginvodkaglass"
					name = "Glass of vodka"
					desc = "The glass contain wodka. Xynta."
					CoM = list("x"=16, "y"=12)
				if("sake")
					icon_state = "ginvodkaglass"
					name = "Glass of Sake"
					desc = "A glass of Sake."
					CoM = list("x"=16, "y"=12)
				if("goldschlager")
					icon_state = "ginvodkaglass"
					name = "Glass of goldschlager"
					desc = "100 proof that teen girls will drink anything with gold in it."
					CoM = list("x"=16, "y"=12)
				if("wine")
					icon_state = "wineglass"
					name = "Glass of wine"
					desc = "A very classy looking drink."
					CoM = list("x"=15, "y"=7)
				if("cognac")
					icon_state = "cognacglass"
					name = "Glass of cognac"
					desc = "Damn, you feel like some kind of French aristocrat just by holding this."
					CoM = list("x"=16, "y"=6)
				if ("kahlua")
					icon_state = "kahluaglass"
					name = "Glass of RR coffee Liquor"
					desc = "DAMN, THIS THING LOOKS ROBUST"
					CoM = list("x"=15, "y"=7)
				if("vermouth")
					icon_state = "vermouthglass"
					name = "Glass of Vermouth"
					desc = "You wonder why you're even drinking this straight."
					CoM = list("x"=16, "y"=12)
				if("tequilla")
					icon_state = "tequillaglass"
					name = "Glass of Tequilla"
					desc = "Now all that's missing is the weird colored shades!"
					CoM = list("x"=16, "y"=12)
				if("patron")
					icon_state = "patronglass"
					name = "Glass of Patron"
					desc = "Drinking patron in the bar, with all the subpar ladies."
					CoM = list("x"=7, "y"=8)
				if("rum")
					icon_state = "rumglass"
					name = "Glass of Rum"
					desc = "Now you want to Pray for a pirate suit, don't you?"
					CoM = list("x"=16, "y"=12)
				if("gintonic")
					icon_state = "gintonicglass"
					name = "Gin and Tonic"
					desc = "A mild but still great cocktail. Drink up, like a true Englishman."
					CoM = list("x"=16, "y"=7)
				if("whiskeycola")
					icon_state = "whiskeycolaglass"
					name = "Whiskey Cola"
					desc = "An innocent-looking mixture of cola and Whiskey. Delicious."
					CoM = list("x"=16, "y"=9)
				if("whiterussian")
					icon_state = "whiterussianglass"
					name = "White Russian"
					desc = "A very nice looking drink. But that's just, like, your opinion, man."
					CoM = list("x"=16, "y"=9)
				if("screwdrivercocktail")
					icon_state = "screwdriverglass"
					name = "Screwdriver"
					desc = "A simple, yet superb mixture of Vodka and orange juice. Just the thing for the tired engineer."
					CoM = list("x"=15, "y"=10)
				if("bloodymary")
					icon_state = "bloodymaryglass"
					name = "Bloody Mary"
					desc = "Tomato juice, mixed with Vodka and a lil' bit of lime. Tastes like liquid murder."
					CoM = list("x"=16, "y"=10)
				if("martini")
					icon_state = "martiniglass"
					name = "Classic Martini"
					desc = "Damn, the bartender even stirred it, not shook it."
					CoM = list("x"=17, "y"=8)
				if("vodkamartini")
					icon_state = "martiniglass"
					name = "Vodka martini"
					desc ="A bastardisation of the classic martini. Still great."
					CoM = list("x"=17, "y"=8)
				if("gargleblaster")
					icon_state = "gargleblasterglass"
					name = "Pan-Galactic Gargle Blaster"
					desc = "Does... does this mean that Arthur and Ford are on the station? Oh joy."
					CoM = list("x"=17, "y"=6)
				if("bravebull")
					icon_state = "bravebullglass"
					name = "Brave Bull"
					desc = "Tequilla and Coffee liquor, brought together in a mouthwatering mixture. Drink up."
					CoM = list("x"=15, "y"=8)
				if("tequillasunrise")
					icon_state = "tequillasunriseglass"
					name = "Tequilla Sunrise"
					desc = "Oh great, now you feel nostalgic about sunrises back on Terra..."
					CoM = list("x"=16, "y"=10)
				if("phoronspecial")
					icon_state = "phoronspecialglass"
					name = "Toxins Special"
					desc = "Whoah, this thing is on FIRE"
				if("beepskysmash")
					icon_state = "beepskysmashglass"
					name = "Beepsky Smash"
					desc = "Heavy, hot and strong. Just like the Iron fist of the LAW."
					CoM = list("x"=18, "y"=10)
				if("doctorsdelight")
					icon_state = "doctorsdelightglass"
					name = "Doctor's Delight"
					desc = "A healthy mixture of juices, guaranteed to keep you healthy until the next toolboxing takes place."
					CoM = list("x"=16, "y"=8)
				if("manlydorf")
					icon_state = "manlydorfglass"
					name = "The Manly Dorf"
					desc = "A manly concotion made from Ale and Beer. Intended for true men only."
					CoM = list("x"=16, "y"=10)
				if("irishcream")
					icon_state = "irishcreamglass"
					name = "Irish Cream"
					desc = "It's cream, mixed with whiskey. What else would you expect from the Irish?"
					CoM = list("x"=16, "y"=9)
				if("cubalibre")
					icon_state = "cubalibreglass"
					name = "Cuba Libre"
					desc = "A classic mix of rum and cola."
					CoM = list("x"=16, "y"=8)
				if("b52")
					icon_state = "b52glass"
					name = "B-52"
					desc = "Kahlua, Irish Cream, and congac. You will get bombed."
					CoM = list("x"=16, "y"=10)
				if("atomicbomb")
					icon_state = "atomicbombglass"
					name = "Atomic Bomb"
					desc = "Nanotrasen cannot take legal responsibility for your actions after imbibing."
					CoM = list("x"=15, "y"=7)
				if("longislandicedtea")
					icon_state = "longislandicedteaglass"
					name = "Long Island Iced Tea"
					desc = "The liquor cabinet, brought together in a delicious mix. Intended for middle-aged alcoholic women only."
					CoM = list("x"=16, "y"=8)
				if("threemileisland")
					icon_state = "threemileislandglass"
					name = "Three Mile Island Ice Tea"
					desc = "A glass of this is sure to prevent a meltdown."
					CoM = list("x"=16, "y"=2)
				if("margarita")
					icon_state = "margaritaglass"
					name = "Margarita"
					desc = "On the rocks with salt on the rim. Arriba~!"
					CoM = list("x"=16, "y"=8)
				if("blackrussian")
					icon_state = "blackrussianglass"
					name = "Black Russian"
					desc = "For the lactose-intolerant. Still as classy as a White Russian."
					CoM = list("x"=16, "y"=9)
				if("vodkatonic")
					icon_state = "vodkatonicglass"
					name = "Vodka and Tonic"
					desc = "For when a gin and tonic isn't russian enough."
					CoM = list("x"=16, "y"=7)
				if("manhattan")
					icon_state = "manhattanglass"
					name = "Manhattan"
					desc = "The Detective's undercover drink of choice. He never could stomach gin..."
					CoM = list("x"=17, "y"=8)
				if("manhattan_proj")
					icon_state = "proj_manhattanglass"
					name = "Manhattan Project"
					desc = "A scienitst drink of choice, for thinking how to blow up the station."
					CoM = list("x"=17, "y"=8)
				if("ginfizz")
					icon_state = "ginfizzglass"
					name = "Gin Fizz"
					desc = "Refreshingly lemony, deliciously dry."
					CoM = list("x"=16, "y"=7)
				if("irishcoffee")
					icon_state = "irishcoffeeglass"
					name = "Irish Coffee"
					desc = "Coffee and alcohol. More fun than a Mimosa to drink in the morning."
					CoM = list("x"=15, "y"=10)
				if("hooch")
					icon_state = "glass_brown2"
					name = "Hooch"
					desc = "You've really hit rock bottom now... your liver packed its bags and left last night."
					CoM = list("x"=16, "y"=10)
				if("whiskeysoda")
					icon_state = "whiskeysodaglass2"
					name = "Whiskey Soda"
					desc = "Ultimate refreshment."
					CoM = list("x"=16, "y"=9)
				if("tonic")
					icon_state = "glass_clear"
					name = "Glass of Tonic Water"
					desc = "Quinine tastes funny, but at least it'll keep that Space Malaria away."
					CoM = list("x"=16, "y"=10)
				if("sodawater")
					icon_state = "glass_clear"
					name = "Glass of Soda Water"
					desc = "Soda water. Why not make a scotch and soda?"
					CoM = list("x"=16, "y"=10)
				if("water")
					icon_state = "glass_clear"
					name = "Glass of Water"
					desc = "The father of all refreshments."
					CoM = list("x"=16, "y"=10)
				if("spacemountainwind")
					icon_state = "Space_mountain_wind_glass"
					name = "Glass of Space Mountain Wind"
					desc = "Space Mountain Wind. As you know, there are no mountains in space, only wind."
					CoM = list("x"=16, "y"=10)
				if("thirteenloko")
					icon_state = "thirteen_loko_glass"
					name = "Glass of Thirteen Loko"
					desc = "This is a glass of Thirteen Loko, it appears to be of the highest quality. The drink, not the glass"
					CoM = list("x"=16, "y"=10)
				if("dr_gibb")
					icon_state = "dr_gibb_glass"
					name = "Glass of Dr. Gibb"
					desc = "Dr. Gibb. Not as dangerous as the name might imply."
					CoM = list("x"=16, "y"=10)
				if("space_up")
					icon_state = "space-up_glass"
					name = "Glass of Space-up"
					desc = "Space-up. It helps keep your cool."
					CoM = list("x"=16, "y"=10)
				if("moonshine")
					icon_state = "glass_clear"
					name = "Moonshine"
					desc = "You've really hit rock bottom now... your liver packed its bags and left last night."
					CoM = list("x"=16, "y"=10)
				if("soymilk")
					icon_state = "glass_white"
					name = "Glass of soy milk"
					desc = "White and nutritious soy goodness!"
					CoM = list("x"=16, "y"=10)
				if("berryjuice")
					icon_state = "berryjuice"
					name = "Glass of berry juice"
					desc = "Berry juice. Or maybe its jam. Who cares?"
					CoM = list("x"=16, "y"=10)
				if("poisonberryjuice")
					icon_state = "poisonberryjuice"
					name = "Glass of poison berry juice"
					desc = "A glass of deadly juice."
					CoM = list("x"=16, "y"=10)
				if("carrotjuice")
					icon_state = "carrotjuice"
					name = "Glass of  carrot juice"
					desc = "It is just like a carrot but without crunching."
					CoM = list("x"=16, "y"=10)
				if("banana")
					icon_state = "banana"
					name = "Glass of banana juice"
					desc = "The raw essence of a banana. HONK"
					CoM = list("x"=16, "y"=10)
				if("bahama_mama")
					icon_state = "bahama_mama"
					name = "Bahama Mama"
					desc = "Tropic cocktail"
					CoM = list("x"=16, "y"=5)
				if("singulo")
					icon_state = "singulo"
					name = "Singulo"
					desc = "A blue-space beverage."
					CoM = list("x"=17, "y"=4)
				if("alliescocktail")
					icon_state = "alliescocktail"
					name = "Allies cocktail"
					desc = "A drink made from your allies."
					CoM = list("x"=17, "y"=8)
				if("antifreeze")
					icon_state = "antifreeze"
					name = "Anti-freeze"
					desc = "The ultimate refreshment."
					CoM = list("x"=16, "y"=8)
				if("barefoot")
					icon_state = "b&p"
					name = "Barefoot"
					desc = "Barefoot and pregnant"
					CoM = list("x"=17, "y"=8)
				if("demonsblood")
					icon_state = "demonsblood"
					name = "Demons Blood"
					desc = "Just looking at this thing makes the hair at the back of your neck stand up."
					CoM = list("x"=16, "y"=2)
				if("booger")
					icon_state = "booger"
					name = "Booger"
					desc = "Ewww..."
					CoM = list("x"=16, "y"=10)
				if("snowwhite")
					icon_state = "snowwhite"
					name = "Snow White"
					desc = "A cold refreshment."
					CoM = list("x"=16, "y"=8)
				if("aloe")
					icon_state = "aloe"
					name = "Aloe"
					desc = "Very, very, very good."
					CoM = list("x"=17, "y"=8)
				if("andalusia")
					icon_state = "andalusia"
					name = "Andalusia"
					desc = "A nice, strange named drink."
					CoM = list("x"=16, "y"=9)
				if("sbiten")
					icon_state = "sbitenglass"
					name = "Sbiten"
					desc = "A spicy mix of Vodka and Spice. Very hot."
					CoM = list("x"=17, "y"=8)
				if("red_mead")
					icon_state = "red_meadglass"
					name = "Red Mead"
					desc = "A True Vikings Beverage, though its color is strange."
					CoM = list("x"=17, "y"=10)
				if("mead")
					icon_state = "meadglass"
					name = "Mead"
					desc = "A Vikings Beverage, though a cheap one."
					CoM = list("x"=17, "y"=10)
				if("iced_beer")
					icon_state = "iced_beerglass"
					name = "Iced Beer"
					desc = "A beer so frosty, the air around it freezes."
					CoM = list("x"=16, "y"=7)
				if("grog")
					icon_state = "grogglass"
					name = "Grog"
					desc = "A fine and cepa drink for Space."
					CoM = list("x"=16, "y"=10)
				if("soy_latte")
					icon_state = "soy_latte"
					name = "Soy Latte"
					desc = "A nice and refrshing beverage while you are reading."
					CoM = list("x"=15, "y"=9)
				if("cafe_latte")
					icon_state = "cafe_latte"
					name = "Cafe Latte"
					desc = "A nice, strong and refreshing beverage while you are reading."
					CoM = list("x"=15, "y"=9)
				if("acidspit")
					icon_state = "acidspitglass"
					name = "Acid Spit"
					desc = "A drink from Nanotrasen. Made from live aliens."
					CoM = list("x"=16, "y"=7)
				if("amasec")
					icon_state = "amasecglass"
					name = "Amasec"
					desc = "Always handy before COMBAT!!!"
					CoM = list("x"=16, "y"=9)
				if("neurotoxin")
					icon_state = "neurotoxinglass"
					name = "Neurotoxin"
					desc = "A drink that is guaranteed to knock you silly."
					CoM = list("x"=16, "y"=8)
				if("hippiesdelight")
					icon_state = "hippiesdelightglass"
					name = "Hippie's Delight"
					desc = "A drink enjoyed by people during the 1960's."
					CoM = list("x"=16, "y"=8)
				if("bananahonk")
					icon_state = "bananahonkglass"
					name = "Banana Honk"
					desc = "A drink from Banana Heaven."
					CoM = list("x"=16, "y"=8)
				if("silencer")
					icon_state = "silencerglass"
					name = "Silencer"
					desc = "A drink from mime Heaven."
					CoM = list("x"=16, "y"=9)
				if("nothing")
					icon_state = "nothing"
					name = "Nothing"
					desc = "Absolutely nothing."
					CoM = list("x"=16, "y"=10)
				if("devilskiss")
					icon_state = "devilskiss"
					name = "Devils Kiss"
					desc = "Creepy time!"
					CoM = list("x"=16, "y"=8)
				if("changelingsting")
					icon_state = "changelingsting"
					name = "Changeling Sting"
					desc = "A stingy drink."
					CoM = list("x"=16, "y"=10)
				if("irishcarbomb")
					icon_state = "irishcarbomb"
					name = "Irish Car Bomb"
					desc = "An irish car bomb."
					CoM = list("x"=16, "y"=8)
				if("syndicatebomb")
					icon_state = "syndicatebomb"
					name = "Syndicate Bomb"
					desc = "A syndicate bomb."
					CoM = list("x"=16, "y"=4)
				if("erikasurprise")
					icon_state = "erikasurprise"
					name = "Erika Surprise"
					desc = "The surprise is, it's green!"
					CoM = list("x"=16, "y"=9)
				if("driestmartini")
					icon_state = "driestmartiniglass"
					name = "Driest Martini"
					desc = "Only for the experienced. You think you see sand floating in the glass."
					CoM = list("x"=17, "y"=8)
				if("ice")
					icon_state = "iceglass"
					name = "Glass of ice"
					desc = "Generally, you're supposed to put something else in there too..."
					CoM = list("x"=16, "y"=10)
				if("icecoffee")
					icon_state = "icedcoffeeglass"
					name = "Iced Coffee"
					desc = "A drink to perk you up and refresh you!"
					CoM = list("x"=16, "y"=10)
				if("coffee")
					icon_state = "glass_brown"
					name = "Glass of coffee"
					desc = "Don't drop it, or you'll send scalding liquid and glass shards everywhere."
					CoM = list("x"=16, "y"=10)
				if("bilk")
					icon_state = "glass_brown"
					name = "Glass of bilk"
					desc = "A brew of milk and beer. For those alcoholics who fear osteoporosis."
					CoM = list("x"=16, "y"=10)
				if("fuel")
					icon_state = "dr_gibb_glass"
					name = "Glass of welder fuel"
					desc = "Unless you are an industrial tool, this is probably not safe for consumption."
					CoM = list("x"=16, "y"=10)
				if("brownstar")
					icon_state = "brownstar"
					name = "Brown Star"
					desc = "It's not what it sounds like..."
					CoM = list("x"=16, "y"=10)
				if("grapejuice")
					icon_state = "grapejuice"
					name = "Glass of grape juice"
					desc = "It's grrrrrape!"
					CoM = list("x"=16, "y"=10)
				if("grapesoda")
					icon_state = "grapesoda"
					name = "Can of Grape Soda"
					desc = "Looks like a delicious drank!"
					CoM = list("x"=16, "y"=10)
				if("icetea")
					icon_state = "icedteaglass"
					name = "Iced Tea"
					desc = "No relation to a certain rap artist/ actor."
					CoM = list("x"=15, "y"=10)
				if("grenadine")
					icon_state = "grenadineglass"
					name = "Glass of grenadine syrup"
					desc = "Sweet and tangy, a bar syrup used to add color or flavor to drinks."
					CoM = list("x"=17, "y"=6)
				if("milkshake")
					icon_state = "milkshake"
					name = "Milkshake"
					desc = "Glorious brainfreezing mixture."
					CoM = list("x"=16, "y"=7)
				if("lemonade")
					icon_state = "lemonadeglass"
					name = "Lemonade"
					desc = "Oh the nostalgia..."
					CoM = list("x"=16, "y"=10)
				if("kiraspecial")
					icon_state = "kiraspecial"
					name = "Kira Special"
					desc = "Long live the guy who everyone had mistaken for a girl. Baka!"
					CoM = list("x"=16, "y"=12)
				if("rewriter")
					icon_state = "rewriter"
					name = "Rewriter"
					desc = "The secret of the sanctuary of the Libarian..."
					CoM = list("x"=16, "y"=9)
				if("suidream")
					icon_state = "sdreamglass"
					name = "Sui Dream"
					desc = "A froofy, fruity, and sweet mixed drink. Understanding the name only brings shame."
					CoM = list("x"=16, "y"=5)
				if("melonliquor")
					icon_state = "emeraldglass"
					name = "Glass of Melon Liquor"
					desc = "A relatively sweet and fruity 46 proof liquor."
					CoM = list("x"=16, "y"=5)
				if("bluecuracao")
					icon_state = "curacaoglass"
					name = "Glass of Blue Curacao"
					desc = "Exotically blue, fruity drink, distilled from oranges."
					CoM = list("x"=16, "y"=5)
				if("absinthe")
					icon_state = "absintheglass"
					name = "Glass of Absinthe"
					desc = "Wormwood, anise, oh my."
					CoM = list("x"=16, "y"=5)
				if("pwine")
					icon_state = "pwineglass"
					name = "Glass of ???"
					desc = "A black ichor with an oily purple sheer on top. Are you sure you should drink this?"
					CoM = list("x"=16, "y"=5)
				else
					icon_state ="glass_brown"
					name = "Glass of ..what?"
					desc = "You can't really tell what this is."
					CoM = list("x"=16, "y"=10)
		else
			icon_state = "glass_empty"
			name = "Drinking glass"
			desc = "Your standard drinking glass"
			CoM = list("x"=16, "y"=10)
			return

// for /obj/machinery/vending/sovietsoda
/obj/item/weapon/reagent_containers/food/drinks/drinkingglass/soda
	New()
		..()
		reagents.add_reagent("sodawater", 50)
		on_reagent_change()

/obj/item/weapon/reagent_containers/food/drinks/drinkingglass/cola
	New()
		..()
		reagents.add_reagent("cola", 50)
		on_reagent_change()
