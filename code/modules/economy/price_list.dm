// For convenience and easier comparing and maintaining of item prices,
// all these will be defined here and sorted in different sections.

// The item price in thalers. atom/movable so we can also assign a price to animals and other things.
/atom/movable/var/price_tag = null

// The proc that is called when the price is being asked for. Use this to refer to another object if necessary.
/atom/movable/proc/get_item_cost()
	return price_tag


//***************//
//---Beverages---//
//***************//

/datum/reagent/var/price_tag = null


// Juices, soda and similar //

/datum/reagent/drink/juice
	price_tag = 2

/datum/reagent/toxin/poisonberryjuice
	price_tag = 2

/datum/reagent/drink/milk
	price_tag = 2

/datum/reagent/drink/soda
	price_tag = 2

/datum/reagent/drink/doctor_delight
	price_tag = 2

/datum/reagent/drink/nothing
	price_tag = 2

/datum/reagent/drink/milkshake
	price_tag = 2


// Beer //

/datum/reagent/drink/ethanol/ale
	price_tag = 2

/datum/reagent/drink/ethanol/beer
	price_tag = 2



// Hot Drinks //

/datum/reagent/drink/rewriter
	price_tag = 3

/datum/reagent/drink/tea
	price_tag = 3

/datum/reagent/drink/coffee
	price_tag = 3

/datum/reagent/drink/hot_coco
	price_tag = 3


// Spirituous liquors //

/datum/reagent/drink/ethanol/irish_cream
	price_tag = 5

/datum/reagent/drink/ethanol/absinthe
	price_tag = 5

/datum/reagent/drink/ethanol/bluecuracao
	price_tag = 5

/datum/reagent/drink/ethanol/deadrum
	price_tag = 5

/datum/reagent/drink/ethanol/gin
	price_tag = 5

/datum/reagent/drink/ethanol/coffee/kahlua
	price_tag = 5

/datum/reagent/drink/ethanol/melonliquor
	price_tag = 5

/datum/reagent/drink/ethanol/rum
	price_tag = 5

/datum/reagent/drink/ethanol/tequilla
	price_tag = 5

/datum/reagent/drink/ethanol/thirteenloko
	price_tag = 5

/datum/reagent/drink/ethanol/vodka
	price_tag = 5

/datum/reagent/drink/ethanol/whiskey
	price_tag = 5


// Wines //

/datum/reagent/drink/ethanol/wine
	price_tag = 8

/datum/reagent/drink/ethanol/cognac
	price_tag = 8

/datum/reagent/drink/ethanol/sake
	price_tag = 8

/datum/reagent/drink/ethanol/vermouth
	price_tag = 8

/datum/reagent/drink/ethanol/pwine
	price_tag = 8


// Cocktails //

/datum/reagent/drink/ethanol/acid_spit
	price_tag = 4

/datum/reagent/drink/ethanol/alliescocktail
	price_tag = 4

/datum/reagent/drink/ethanol/aloe
	price_tag = 4

/datum/reagent/drink/ethanol/amasec
	price_tag = 4

/datum/reagent/drink/ethanol/andalusia
	price_tag = 4

/datum/reagent/drink/ethanol/antifreeze
	price_tag = 4

/datum/reagent/drink/ethanol/atomicbomb
	price_tag = 4

/datum/reagent/drink/ethanol/coffee/b52
	price_tag = 4

/datum/reagent/drink/ethanol/bahama_mama
	price_tag = 4

/datum/reagent/drink/ethanol/barefoot
	price_tag = 4

/datum/reagent/drink/ethanol/beepsky_smash
	price_tag = 4

/datum/reagent/drink/ethanol/bilk
	price_tag = 4

/datum/reagent/drink/ethanol/black_russian
	price_tag = 4

/datum/reagent/drink/ethanol/bloody_mary
	price_tag = 4

/datum/reagent/drink/ethanol/booger
	price_tag = 4

/datum/reagent/drink/ethanol/brave_bull
	price_tag = 4

/datum/reagent/drink/ethanol/changeling_sting
	price_tag = 4

/datum/reagent/drink/ethanol/martini
	price_tag = 4

/datum/reagent/drink/ethanol/cuba_libre
	price_tag = 4

/datum/reagent/drink/ethanol/demonsblood
	price_tag = 4

/datum/reagent/drink/ethanol/devilskiss
	price_tag = 4

/datum/reagent/drink/ethanol/driestmartini
	price_tag = 4

/datum/reagent/drink/ethanol/ginfizz
	price_tag = 4

/datum/reagent/drink/ethanol/grog
	price_tag = 4

/datum/reagent/drink/ethanol/erikasurprise
	price_tag = 4

/datum/reagent/drink/ethanol/gargleblaster
	price_tag = 4

/datum/reagent/drink/ethanol/gintonic
	price_tag = 4

/datum/reagent/drink/ethanol/goldschlager
	price_tag = 4

/datum/reagent/drink/ethanol/hippies_delight
	price_tag = 4

/datum/reagent/drink/ethanol/hooch
	price_tag = 4

/datum/reagent/drink/ethanol/iced_beer
	price_tag = 4

/datum/reagent/drink/ethanol/irishcarbomb
	price_tag = 4

/datum/reagent/drink/ethanol/coffee/irishcoffee
	price_tag = 4

/datum/reagent/drink/ethanol/longislandicedtea
	price_tag = 4

/datum/reagent/drink/ethanol/manhattan
	price_tag = 4

/datum/reagent/drink/ethanol/manhattan_proj
	price_tag = 4

/datum/reagent/drink/ethanol/manly_dorf
	price_tag = 4

/datum/reagent/drink/ethanol/margarita
	price_tag = 4

/datum/reagent/drink/ethanol/mead
	price_tag = 4

/datum/reagent/drink/ethanol/moonshine
	price_tag = 4

/datum/reagent/drink/ethanol/neurotoxin
	price_tag = 4

/datum/reagent/drink/ethanol/patron
	price_tag = 4

/datum/reagent/drink/ethanol/red_mead
	price_tag = 4

/datum/reagent/drink/ethanol/sbiten
	price_tag = 4

/datum/reagent/drink/ethanol/screwdrivercocktail
	price_tag = 4

/datum/reagent/drink/ethanol/silencer
	price_tag = 4

/datum/reagent/drink/ethanol/singulo
	price_tag = 4

/datum/reagent/drink/ethanol/snowwhite
	price_tag = 4

/datum/reagent/drink/ethanol/suidream
	price_tag = 4

/datum/reagent/drink/ethanol/syndicatebomb
	price_tag = 4

/datum/reagent/drink/ethanol/tequillasunrise
	price_tag = 4

/datum/reagent/drink/ethanol/threemileisland
	price_tag = 4

/datum/reagent/drink/ethanol/toxins_special
	price_tag = 4

/datum/reagent/drink/ethanol/vodkamartini
	price_tag = 4

/datum/reagent/drink/ethanol/vodkatonic
	price_tag = 4

/datum/reagent/drink/ethanol/white_russian
	price_tag = 4

/datum/reagent/drink/ethanol/whiskey_cola
	price_tag = 4

/datum/reagent/drink/ethanol/whiskeysoda
	price_tag = 4

/datum/reagent/drink/ethanol/specialwhiskey
	price_tag = 4


// Cocktails without alcohol //

/datum/reagent/drink/ethanol/bananahonk
	price_tag = 3


// From the machine //

/obj/item/weapon/reagent_containers/food/drinks/cans/cola
	price_tag = 1

/obj/item/weapon/reagent_containers/food/drinks/cans/space_mountain_wind
	price_tag = 1

/obj/item/weapon/reagent_containers/food/drinks/cans/dr_gibb
	price_tag = 1

/obj/item/weapon/reagent_containers/food/drinks/cans/starkist
	price_tag = 1

/obj/item/weapon/reagent_containers/food/drinks/cans/waterbottle
	price_tag = 2

/obj/item/weapon/reagent_containers/food/drinks/cans/space_up
	price_tag = 1

/obj/item/weapon/reagent_containers/food/drinks/cans/iced_tea
	price_tag = 1

/obj/item/weapon/reagent_containers/food/drinks/cans/grape_juice
	price_tag = 1


//***************//
//---Foodstuff---//
//***************//


// Snacks //

/obj/item/weapon/reagent_containers/food/snacks/candy
	price_tag = 1

/obj/item/weapon/reagent_containers/food/snacks/sosjerky
	price_tag = 2

/obj/item/weapon/reagent_containers/food/snacks/cheesiehonkers
	price_tag = 1

/obj/item/weapon/reagent_containers/food/snacks/tastybread
	price_tag = 2

/obj/item/weapon/reagent_containers/food/snacks/no_raisin
	price_tag = 1

/obj/item/weapon/reagent_containers/food/snacks/spacetwinkie
	price_tag = 1

/obj/item/weapon/reagent_containers/food/snacks/skrellsnacks
	price_tag = 4

/obj/item/weapon/reagent_containers/food/snacks/chips
	price_tag = 1

/obj/item/weapon/reagent_containers/food/drinks/dry_ramen
	price_tag = 5


// Burger //

/obj/item/weapon/reagent_containers/food/snacks/brainburger
	price_tag = 2

/obj/item/weapon/reagent_containers/food/snacks/ghostburger
	price_tag = 2

/obj/item/weapon/reagent_containers/food/snacks/human/burger
	price_tag = 2

/obj/item/weapon/reagent_containers/food/snacks/cheeseburger
	price_tag = 2

/obj/item/weapon/reagent_containers/food/snacks/monkeyburger
	price_tag = 2

/obj/item/weapon/reagent_containers/food/snacks/fishburger
	price_tag = 2

/obj/item/weapon/reagent_containers/food/snacks/tofuburger
	price_tag = 2

/obj/item/weapon/reagent_containers/food/snacks/roburger
	price_tag = 2

/obj/item/weapon/reagent_containers/food/snacks/roburgerbig
	price_tag = 2

/obj/item/weapon/reagent_containers/food/snacks/xenoburger
	price_tag = 2

/obj/item/weapon/reagent_containers/food/snacks/clownburger
	price_tag = 2

/obj/item/weapon/reagent_containers/food/snacks/mimeburger
	price_tag = 2

/obj/item/weapon/reagent_containers/food/snacks/spellburger
	price_tag = 2

/obj/item/weapon/reagent_containers/food/snacks/jellyburger
	price_tag = 2

/obj/item/weapon/reagent_containers/food/snacks/bigbiteburger
	price_tag = 4

/obj/item/weapon/reagent_containers/food/snacks/superbiteburger
	price_tag = 8


// Sandwiches //

/obj/item/weapon/reagent_containers/food/snacks/sandwich
	price_tag = 3

/obj/item/weapon/reagent_containers/food/snacks/toastedsandwich
	price_tag = 3

/obj/item/weapon/reagent_containers/food/snacks/grilledcheese
	price_tag = 3

/obj/item/weapon/reagent_containers/food/snacks/jellysandwich
	price_tag = 3


// Cookies and Candies //

/obj/item/weapon/reagent_containers/food/snacks/cookie
	price_tag = 1

/obj/item/weapon/reagent_containers/food/snacks/chocolatebar
	price_tag = 1

/obj/item/weapon/reagent_containers/food/snacks/chocolateegg
	price_tag = 1

/obj/item/weapon/reagent_containers/food/snacks/candy_corn
	price_tag = 1

/obj/item/weapon/reagent_containers/food/snacks/donut
	price_tag = 1

/obj/item/weapon/reagent_containers/food/snacks/donut/chaos
	price_tag = 5

/obj/item/weapon/reagent_containers/food/snacks/popcorn
	price_tag = 3

/obj/item/weapon/reagent_containers/food/snacks/fortunecookie
	price_tag = 1

/obj/item/weapon/reagent_containers/food/snacks/candiedapple
	price_tag = 2

/obj/item/weapon/reagent_containers/food/snacks/plumphelmetbiscuit
	price_tag = 1

/obj/item/weapon/reagent_containers/food/snacks/chawanmushi
	price_tag = 2

/obj/item/weapon/reagent_containers/food/snacks/cracker
	price_tag = 1


// Full meals //

/obj/item/weapon/reagent_containers/food/snacks/friedegg
	price_tag = 5

/obj/item/weapon/reagent_containers/food/snacks/tofurkey
	price_tag = 5

/obj/item/weapon/reagent_containers/food/snacks/carpmeat
	price_tag = 5

/obj/item/weapon/reagent_containers/food/snacks/fishfingers
	price_tag = 5

/obj/item/weapon/reagent_containers/food/snacks/omelette
	price_tag = 5

/obj/item/weapon/reagent_containers/food/snacks/berryclafoutis
	price_tag = 5

/obj/item/weapon/reagent_containers/food/snacks/waffles
	price_tag = 5

/obj/item/weapon/reagent_containers/food/snacks/eggplantparm
	price_tag = 5

/obj/item/weapon/reagent_containers/food/snacks/soylentgreen
	price_tag = 5

/obj/item/weapon/reagent_containers/food/snacks/soylenviridians
	price_tag = 5

/obj/item/weapon/reagent_containers/food/snacks/wingfangchu
	price_tag = 5

/obj/item/weapon/reagent_containers/food/snacks/kabob
	price_tag = 5

/obj/item/weapon/reagent_containers/food/snacks/monkeykabob
	price_tag = 5

/obj/item/weapon/reagent_containers/food/snacks/tofukabob
	price_tag = 5

/obj/item/weapon/reagent_containers/food/snacks/cubancarp
	price_tag = 5

/obj/item/weapon/reagent_containers/food/snacks/loadedbakedpotato
	price_tag = 5

/obj/item/weapon/reagent_containers/food/snacks/fries
	price_tag = 5

/obj/item/weapon/reagent_containers/food/snacks/spagetti
	price_tag = 5

/obj/item/weapon/reagent_containers/food/snacks/cheesyfries
	price_tag = 5

/obj/item/weapon/reagent_containers/food/snacks/enchiladas
	price_tag = 5

/obj/item/weapon/reagent_containers/food/snacks/monkeysdelight
	price_tag = 5

/obj/item/weapon/reagent_containers/food/snacks/fishandchips
	price_tag = 5

/obj/item/weapon/reagent_containers/food/snacks/rofflewaffles
	price_tag = 5

/obj/item/weapon/reagent_containers/food/snacks/stew
	price_tag = 5

/obj/item/weapon/reagent_containers/food/snacks/stewedsoymeat
	price_tag = 5

/obj/item/weapon/reagent_containers/food/snacks/boiledspagetti
	price_tag = 5

/obj/item/weapon/reagent_containers/food/snacks/boiledrice
	price_tag = 5

/obj/item/weapon/reagent_containers/food/snacks/ricepudding
	price_tag = 5

/obj/item/weapon/reagent_containers/food/snacks/pastatomato
	price_tag = 5

/obj/item/weapon/reagent_containers/food/snacks/meatballspagetti
	price_tag = 5

/obj/item/weapon/reagent_containers/food/snacks/spesslaw
	price_tag = 5

/obj/item/weapon/reagent_containers/food/snacks/carrotfries
	price_tag = 5

/obj/item/weapon/reagent_containers/food/snacks/appletart
	price_tag = 5

/obj/item/weapon/reagent_containers/food/snacks/sliceable/pizza
	price_tag = 5

/obj/item/weapon/reagent_containers/food/snacks/margheritaslice
	price_tag = 1

/obj/item/weapon/reagent_containers/food/snacks/meatpizzaslice
	price_tag = 1

/obj/item/weapon/reagent_containers/food/snacks/mushroompizzaslice
	price_tag = 1

/obj/item/weapon/reagent_containers/food/snacks/vegetablepizzaslice
	price_tag = 1

/obj/item/weapon/reagent_containers/food/snacks/


// Baked Goods //

/obj/item/weapon/reagent_containers/food/snacks/poppypretzel
	price_tag = 2

/obj/item/weapon/reagent_containers/food/snacks/baguette
	price_tag = 2

/obj/item/weapon/reagent_containers/food/snacks/jelliedtoast
	price_tag = 1

/obj/item/weapon/reagent_containers/food/snacks/twobread
	price_tag = 2

/obj/item/weapon/reagent_containers/food/snacks/sliceable/meatbread
	price_tag = 5

/obj/item/weapon/reagent_containers/food/snacks/meatbreadslice
	price_tag = 1

/obj/item/weapon/reagent_containers/food/snacks/sliceable/xenomeatbread
	price_tag = 5

/obj/item/weapon/reagent_containers/food/snacks/xenomeatbreadslice
	price_tag = 1

/obj/item/weapon/reagent_containers/food/snacks/sliceable/bananabread
	price_tag = 5

/obj/item/weapon/reagent_containers/food/snacks/bananabreadslice
	price_tag = 1

/obj/item/weapon/reagent_containers/food/snacks/sliceable/tofubread
	price_tag = 5

/obj/item/weapon/reagent_containers/food/snacks/tofubreadslice
	price_tag = 1

/obj/item/weapon/reagent_containers/food/snacks/sliceable/bread
	price_tag = 5

/obj/item/weapon/reagent_containers/food/snacks/breadslice
	price_tag = 1

/obj/item/weapon/reagent_containers/food/snacks/sliceable/creamcheesebread
	price_tag = 5

/obj/item/weapon/reagent_containers/food/snacks/creamcheesebreadslice
	price_tag = 1


// Soups //

/obj/item/weapon/reagent_containers/food/snacks/meatballsoup
	price_tag = 3

/obj/item/weapon/reagent_containers/food/snacks/slimesoup
	price_tag = 3

/obj/item/weapon/reagent_containers/food/snacks/bloodsoup
	price_tag = 3

/obj/item/weapon/reagent_containers/food/snacks/clownstears
	price_tag = 3

/obj/item/weapon/reagent_containers/food/snacks/vegetablesoup
	price_tag = 3

/obj/item/weapon/reagent_containers/food/snacks/nettlesoup
	price_tag = 3

/obj/item/weapon/reagent_containers/food/snacks/mysterysoup
	price_tag = 3

/obj/item/weapon/reagent_containers/food/snacks/wishsoup
	price_tag = 3

/obj/item/weapon/reagent_containers/food/snacks/hotchili
	price_tag = 3

/obj/item/weapon/reagent_containers/food/snacks/coldchili
	price_tag = 3

/obj/item/weapon/reagent_containers/food/snacks/tomatosoup
	price_tag = 3

/obj/item/weapon/reagent_containers/food/snacks/milosoup
	price_tag = 3

/obj/item/weapon/reagent_containers/food/snacks/mushroomsoup
	price_tag = 3

/obj/item/weapon/reagent_containers/food/snacks/beetsoup
	price_tag = 3


// Pies //

/obj/item/weapon/reagent_containers/food/snacks/pie
	price_tag = 4

/obj/item/weapon/reagent_containers/food/snacks/meatpie
	price_tag = 4

/obj/item/weapon/reagent_containers/food/snacks/tofupie
	price_tag = 4

/obj/item/weapon/reagent_containers/food/snacks/plump_pie
	price_tag = 4

/obj/item/weapon/reagent_containers/food/snacks/xemeatpie
	price_tag = 4

/obj/item/weapon/reagent_containers/food/snacks/applepie
	price_tag = 4

/obj/item/weapon/reagent_containers/food/snacks/cherrypie
	price_tag = 4


// Cakes //

/obj/item/weapon/reagent_containers/food/snacks/sliceable/carrotcake
	price_tag = 5

/obj/item/weapon/reagent_containers/food/snacks/carrotcakeslice
	price_tag = 1

/obj/item/weapon/reagent_containers/food/snacks/sliceable/braincake
	price_tag = 5

/obj/item/weapon/reagent_containers/food/snacks/braincakeslice
	price_tag = 1

/obj/item/weapon/reagent_containers/food/snacks/sliceable/cheesecake
	price_tag = 5

/obj/item/weapon/reagent_containers/food/snacks/cheesecakeslice
	price_tag = 1

/obj/item/weapon/reagent_containers/food/snacks/sliceable/plaincake
	price_tag = 5

/obj/item/weapon/reagent_containers/food/snacks/plaincakeslice
	price_tag = 1

/obj/item/weapon/reagent_containers/food/snacks/sliceable/orangecake
	price_tag = 5

/obj/item/weapon/reagent_containers/food/snacks/orangecakeslice
	price_tag = 1

/obj/item/weapon/reagent_containers/food/snacks/sliceable/limecake
	price_tag = 5

/obj/item/weapon/reagent_containers/food/snacks/limecakeslice
	price_tag = 1

/obj/item/weapon/reagent_containers/food/snacks/sliceable/lemoncake
	price_tag = 5

/obj/item/weapon/reagent_containers/food/snacks/lemoncakeslice
	price_tag = 1

/obj/item/weapon/reagent_containers/food/snacks/sliceable/chocolatecake
	price_tag = 5

/obj/item/weapon/reagent_containers/food/snacks/chocolatecakeslice
	price_tag = 1

/obj/item/weapon/reagent_containers/food/snacks/sliceable/birthdaycake
	price_tag = 5

/obj/item/weapon/reagent_containers/food/snacks/birthdaycakeslice
	price_tag = 1

/obj/item/weapon/reagent_containers/food/snacks/sliceable/applecake
	price_tag = 5

/obj/item/weapon/reagent_containers/food/snacks/applecakeslice
	price_tag = 1

/obj/item/weapon/reagent_containers/food/snacks/sliceable/pumpkinpie
	price_tag = 5

/obj/item/weapon/reagent_containers/food/snacks/pumpkinpieslice
	price_tag = 1


// Misc //

/obj/item/weapon/reagent_containers/food/snacks/boiledegg
	price_tag = 2

/obj/item/weapon/reagent_containers/food/snacks/donkpocket
	price_tag = 1

/obj/item/weapon/reagent_containers/food/snacks/sausage
	price_tag = 2

/obj/item/weapon/reagent_containers/food/snacks/muffin
	price_tag = 2

/obj/item/weapon/reagent_containers/food/snacks/tossedsalad
	price_tag = 2

/obj/item/weapon/reagent_containers/food/snacks/validsalad
	price_tag = 2

/obj/item/weapon/reagent_containers/food/snacks/dionaroast
	price_tag = 25

/obj/item/pizzabox
	get_item_cost()
		return get_item_cost(pizza)