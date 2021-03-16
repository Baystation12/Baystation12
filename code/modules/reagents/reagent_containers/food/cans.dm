/obj/item/reagent_containers/food/drinks/cans
	volume = 40 //just over one and a half cups
	amount_per_transfer_from_this = 5
	atom_flags = 0 //starts closed
	matter = list(MATERIAL_ALUMINIUM = 30)

//DRINKS

/obj/item/reagent_containers/food/drinks/cans/cola
	name = "space cola"
	desc = "Cola. in space."
	icon_state = "cola"
	center_of_mass = "x=16;y=10"

/obj/item/reagent_containers/food/drinks/cans/cola/Initialize()
	. = ..()
	reagents.add_reagent(/datum/reagent/drink/space_cola, 30)

/obj/item/reagent_containers/food/drinks/cans/waterbottle
	name = "bottled water"
	desc = "Pure drinking water, imported from the Martian poles."
	icon_state = "waterbottle"
	center_of_mass = "x=15;y=8"
	matter = list(MATERIAL_PLASTIC = 40)

/obj/item/reagent_containers/food/drinks/cans/waterbottle/Initialize()
	. = ..()
	reagents.add_reagent(/datum/reagent/water, 30)

/obj/item/reagent_containers/food/drinks/cans/waterbottle/open(mob/user)
	playsound(loc,'sound/effects/bonebreak1.ogg', rand(10,50), 1)
	to_chat(user, "<span class='notice'>You twist open \the [src], destroying the safety seal!</span>")
	atom_flags |= ATOM_FLAG_OPEN_CONTAINER

/obj/item/reagent_containers/food/drinks/cans/space_mountain_wind
	name = "space mountain wind"
	desc = "Blows right through you like a space wind."
	icon_state = "space_mountain_wind"
	center_of_mass = "x=16;y=10"

/obj/item/reagent_containers/food/drinks/cans/space_mountain_wind/Initialize()
	. = ..()
	reagents.add_reagent(/datum/reagent/drink/spacemountainwind, 30)

/obj/item/reagent_containers/food/drinks/cans/thirteenloko
	name = "thirteen loko"
	desc = "The CMO has advised crew members that consumption of Thirteen Loko may result in seizures, blindness, drunkeness, or even death. Please Drink Responsibly."
	icon_state = "thirteen_loko"
	center_of_mass = "x=16;y=8"

/obj/item/reagent_containers/food/drinks/cans/thirteenloko/Initialize()
	. = ..()
	reagents.add_reagent(/datum/reagent/ethanol/thirteenloko, 30)

/obj/item/reagent_containers/food/drinks/cans/dr_gibb
	name = "dr. gibb"
	desc = "A delicious mixture of 42 different flavors."
	icon_state = "dr_gibb"
	center_of_mass = "x=16;y=10"

/obj/item/reagent_containers/food/drinks/cans/dr_gibb/Initialize()
	. = ..()
	reagents.add_reagent(/datum/reagent/drink/dr_gibb, 30)

/obj/item/reagent_containers/food/drinks/cans/space_up
	name = "space-up"
	desc = "Tastes like a hull breach in your mouth."
	icon_state = "space-up"
	center_of_mass = "x=16;y=10"

/obj/item/reagent_containers/food/drinks/cans/space_up/Initialize()
	. = ..()
	reagents.add_reagent(/datum/reagent/drink/space_up, 30)

/obj/item/reagent_containers/food/drinks/cans/lemon_lime
	name = "lemon-lime"
	desc = "You wanted ORANGE. It gave you Lemon Lime."
	icon_state = "lemon-lime"
	center_of_mass = "x=16;y=10"

/obj/item/reagent_containers/food/drinks/cans/lemon_lime/Initialize()
	. = ..()
	reagents.add_reagent(/datum/reagent/drink/lemon_lime, 30)

/obj/item/reagent_containers/food/drinks/cans/iced_tea
	name = "vrisk serket iced tea"
	desc = "That sweet, refreshing southern earthy flavor. That's where it's from, right? South Earth?"
	icon_state = "ice_tea_can"
	center_of_mass = "x=16;y=10"

/obj/item/reagent_containers/food/drinks/cans/iced_tea/Initialize()
	. = ..()
	reagents.add_reagent(/datum/reagent/drink/tea/icetea, 30)

/obj/item/reagent_containers/food/drinks/cans/grape_juice
	name = "grapel juice"
	desc = "500 pages of rules of how to appropriately enter into a combat with this juice!"
	icon_state = "purple_can"
	center_of_mass = "x=16;y=10"

/obj/item/reagent_containers/food/drinks/cans/grape_juice/Initialize()
	. = ..()
	reagents.add_reagent(/datum/reagent/drink/juice/grape, 30)

/obj/item/reagent_containers/food/drinks/cans/tonic
	name = "t-borg's tonic water"
	desc = "Quinine tastes funny, but at least it'll keep that Space Malaria away."
	icon_state = "tonic"
	center_of_mass = "x=16;y=10"

/obj/item/reagent_containers/food/drinks/cans/tonic/Initialize()
	. = ..()
	reagents.add_reagent(/datum/reagent/drink/tonic, 30)

/obj/item/reagent_containers/food/drinks/cans/sodawater
	name = "soda water"
	desc = "A can of soda water. Still water's more refreshing cousin."
	icon_state = "sodawater"
	center_of_mass = "x=16;y=10"

/obj/item/reagent_containers/food/drinks/cans/sodawater/Initialize()
	. = ..()
	reagents.add_reagent(/datum/reagent/drink/sodawater, 30)

/obj/item/reagent_containers/food/drinks/cans/beastenergy
	name = "beast energy"
	desc = "100% pure energy, and 150% pure liver disease."
	icon_state = "beastenergy"
	center_of_mass = "x=16;y=6"

/obj/item/reagent_containers/food/drinks/cans/beastenergy/Initialize()
	. = . = ..()
	reagents.add_reagent(/datum/reagent/drink/beastenergy, 30)

//Items exclusive to the BODA machine on deck 4 and wherever else it pops up. First two are a bit jokey. Second two are genuine article.

/obj/item/reagent_containers/food/drinks/cans/syndicolax
	name = "red army twist"
	desc = "A taste of what keeps our glorious nation running! Served as Space Commissariat Stahlin prefers it! Luke warm."
	icon_state = "syndi_cola_x"
	center_of_mass = "x=16;y=10"

/obj/item/reagent_containers/food/drinks/cans/syndicolax/Initialize()
	. = ..()
	reagents.add_reagent(/datum/reagent/drink/juice/potato, 30)

/obj/item/reagent_containers/food/drinks/cans/artbru
	name = "arstotzka bru"
	desc = "Just what any bureaucrat needs to get through the day. Keep stamping those papers!"
	icon_state = "art_bru"
	center_of_mass = "x=16;y=10"

/obj/item/reagent_containers/food/drinks/cans/artbru/Initialize()
	. = ..()
	reagents.add_reagent(/datum/reagent/drink/juice/turnip, 30)

/obj/item/reagent_containers/food/drinks/cans/syndicola
	name = "terra-cola"
	desc = "A can of the only soft drink state approved for the benefit of the people. Served at room temperature regardless of ambient temperatures thanks to innovative Terran insulation technology."
	icon_state = "syndi_cola"
	center_of_mass = "x=16;y=10"

/obj/item/reagent_containers/food/drinks/cans/syndicola/Initialize()
	. = ..()
	reagents.add_reagent(/datum/reagent/water, 25)
	reagents.add_reagent(/datum/reagent/iron, 5)

/obj/item/reagent_containers/food/drinks/glass2/square/boda
	name = "boda"
	desc = "A tall glass of refreshing Boda!"
	center_of_mass = "x=16;y=10"

/obj/item/reagent_containers/food/drinks/glass2/square/boda/Initialize()
	. = ..()
	reagents.add_reagent(/datum/reagent/drink/sodawater, 30)

/obj/item/reagent_containers/food/drinks/glass2/square/bodaplus
	name = "tri kopeiki sirop boda"
	desc = "A tall glass of even more refreshing Boda! Now with Sok!"
	center_of_mass = "x=16;y=10"

/obj/item/reagent_containers/food/drinks/glass2/square/bodaplus/Initialize()
	. = ..()
	reagents.add_reagent(/datum/reagent/drink/sodawater, 15)
	reagents.add_reagent(pick(list(
				/datum/reagent/drink/kiraspecial,
				/datum/reagent/drink/juice/grape,
				/datum/reagent/drink/juice/orange,
				/datum/reagent/drink/juice/lemon,
				/datum/reagent/drink/juice/lime,
				/datum/reagent/drink/juice/apple,
				/datum/reagent/drink/juice/pear,
				/datum/reagent/drink/juice/banana,
				/datum/reagent/drink/juice/berry,
				/datum/reagent/drink/juice/watermelon)), 15)

//Canned alcohols.

/obj/item/reagent_containers/food/drinks/cans/speer
	name = "space beer"
	desc = "Now in a can!"
	icon_state = "beercan"
	center_of_mass = "x=16;y=10"

/obj/item/reagent_containers/food/drinks/cans/speer/Initialize()
	. = ..()
	reagents.add_reagent(/datum/reagent/ethanol/beer/good, 30)

/obj/item/reagent_containers/food/drinks/cans/ale
	name = "magm-ale"
	desc = "Now in a can!"
	icon_state = "alecan"
	center_of_mass = "x=16;y=10"

/obj/item/reagent_containers/food/drinks/cans/ale/Initialize()
	. = ..()
	reagents.add_reagent(/datum/reagent/ethanol/ale, 30)


//Fox's Sodas from Legacy Bay: NSV Luna



/obj/item/reagent_containers/food/drinks/cans/cola_diet
	name = "diet space cola"
	desc = "Cola... in space! Now with extra self-confidence."
	icon_state = "cola-blue"

/obj/item/reagent_containers/food/drinks/cans/cola_diet/Initialize()
	. = ..()
	reagents.add_reagent(/datum/reagent/drink/diet_cola, 30)

/obj/item/reagent_containers/food/drinks/cans/rootbeer
	name = "rocket root beer"
	desc = "Blast away with Rocket Root Beer!"
	icon_state = "cola-brown"

/obj/item/reagent_containers/food/drinks/cans/rootbeer/Initialize()
	. = ..()
	reagents.add_reagent(/datum/reagent/drink/rootbeer, 30)

/obj/item/reagent_containers/food/drinks/cans/cola_apple
	name = "andromeda apple"
	desc = "Look to the stars with Andromeda Apple!"
	icon_state = "cola-green"

/obj/item/reagent_containers/food/drinks/cans/cola_apple/Initialize()
	. = ..()
	reagents.add_reagent(/datum/reagent/drink/apple_soda, 30)

/obj/item/reagent_containers/food/drinks/cans/cola_orange
	name = "orbital orange"
	desc = "Feel out-of-this-world with Orbital Orange!"
	icon_state = "cola-orange"

/obj/item/reagent_containers/food/drinks/cans/cola_orange/Initialize()
	. = ..()
	reagents.add_reagent(/datum/reagent/drink/orange_soda, 30)

/obj/item/reagent_containers/food/drinks/cans/cola_grape
	name = "gravity grape"
	desc = "Feel the planetfall with Gravity Grape!"
	icon_state = "cola-purple"

/obj/item/reagent_containers/food/drinks/cans/cola_grape/Initialize()
	. = ..()
	reagents.add_reagent(/datum/reagent/drink/grapesoda, 30)

/obj/item/reagent_containers/food/drinks/cans/cola_lemonlime
	name = "citrus star"
	desc = "Shoot to space with Citrus Star!"
	icon_state = "cola-yellow"

/obj/item/reagent_containers/food/drinks/cans/cola_lemonlime/Initialize()
	. = ..()
	reagents.add_reagent(/datum/reagent/drink/lemon_lime, 30)

/obj/item/reagent_containers/food/drinks/cans/cola_strawberry
	name = "sirius strawberry"
	desc = "See stars with Sirius Strawberry!"
	icon_state = "cola-pink"

/obj/item/reagent_containers/food/drinks/cans/cola_strawberry/Initialize()
	. = ..()
	reagents.add_reagent(/datum/reagent/drink/strawberry_soda, 30)

/obj/item/reagent_containers/food/drinks/cans/cola_pork
	name = "pork soda"
	desc = "Primus sucks!"
	icon_state = "cola-pork"

/obj/item/reagent_containers/food/drinks/cans/cola_pork/Initialize()
	. = ..()
	reagents.add_reagent(/datum/reagent/drink/porksoda, 30)

// Cola

/obj/item/reagent_containers/food/drinks/cans/vanillacola
	name = "vanilla cola"
	desc = "Delicious vanilla cola in a can."
	icon_state = "vcola"
	center_of_mass = "x=16;y=6"

/obj/item/reagent_containers/food/drinks/cans/vanillacola/Initialize()
	. = . = ..()
	reagents.add_reagent(/datum/reagent/drink/vanilla_cola, 30)

/obj/item/reagent_containers/food/drinks/cans/cherrycola
	name = "cherry cola"
	desc = "Delicious cherry cola in a can."
	icon_state = "ccola"
	center_of_mass = "x=16;y=6"

/obj/item/reagent_containers/food/drinks/cans/cherrycola/Initialize()
	. = . = ..()
	reagents.add_reagent(/datum/reagent/drink/cherry_cola, 30)

/obj/item/reagent_containers/food/drinks/cans/orangecola
	name = "orange cola"
	desc = "Delicious orange cola in a can."
	icon_state = "ocola"
	center_of_mass = "x=16;y=6"

/obj/item/reagent_containers/food/drinks/cans/orangecola/Initialize()
	. = . = ..()
	reagents.add_reagent(/datum/reagent/drink/orange_cola, 30)

/obj/item/reagent_containers/food/drinks/cans/coffeecola
	name = "coffee cola"
	desc = "Delicious coffee cola in a can."
	icon_state = "ccola"
	center_of_mass = "x=16;y=6"

/obj/item/reagent_containers/food/drinks/cans/coffeecola/Initialize()
	. = . = ..()
	reagents.add_reagent(/datum/reagent/drink/coffee/coffee_cola, 30)

/obj/item/reagent_containers/food/drinks/cans/ionbru
	name = "ion-bru"
	desc = "Ion-Bru, the drink of all true scotsmen."
	icon_state = "ionbru"
	center_of_mass = "x=16;y=6"

/obj/item/reagent_containers/food/drinks/cans/ionbru/Initialize()
	. = . = ..()
	reagents.add_reagent(/datum/reagent/drink/ionbru, 30)
