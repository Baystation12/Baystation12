// For convenience and easier comparing and maintaining of item prices,
// all these will be defined here and sorted in different sections.

// The item price in thalers. atom/movable so we can also assign a price to animals and other things.
/atom/movable/var/price_tag = null

// The proc that is called when the price is being asked for. Use this to refer to another object if necessary.
/atom/movable/proc/get_retail_cost()
	return price_tag


//***************//
//---Beverages---//
//***************//

/datum/reagent/var/price_tag = null


// Juices, soda and similar //

/datum/reagent/water
	price_tag = 2

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

/datum/reagent/drink/roy_rogers
	price_tag = 2

/datum/reagent/drink/shirley_temple
	price_tag = 2

/datum/reagent/drink/arnold_palmer
	price_tag = 2

/datum/reagent/drink/collins_mix
	price_tag = 2


// Beer //

/datum/reagent/ethanol/ale
	price_tag = 2

/datum/reagent/ethanol/beer
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

/obj/item/weapon/reagent_containers/food/drinks/coffee
	price_tag = 3

/obj/item/weapon/reagent_containers/food/drinks/tea
	price_tag = 3

/obj/item/weapon/reagent_containers/food/drinks/h_chocolate
	price_tag = 3


// Spirituous liquors //

/datum/reagent/ethanol/irish_cream
	price_tag = 5

/datum/reagent/ethanol/absinthe
	price_tag = 5

/datum/reagent/ethanol/bluecuracao
	price_tag = 5

/datum/reagent/ethanol/deadrum
	price_tag = 5

/datum/reagent/ethanol/gin
	price_tag = 5

/datum/reagent/ethanol/coffee/kahlua
	price_tag = 5

/datum/reagent/ethanol/melonliquor
	price_tag = 5

/datum/reagent/ethanol/rum
	price_tag = 5

/datum/reagent/ethanol/tequilla
	price_tag = 5

/datum/reagent/ethanol/thirteenloko
	price_tag = 5

/datum/reagent/ethanol/vodka
	price_tag = 5

/datum/reagent/ethanol/whiskey
	price_tag = 5

/datum/reagent/ethanol/specialwhiskey
	price_tag = 5

/datum/reagent/ethanol/patron
	price_tag = 5

/datum/reagent/ethanol/goldschlager
	price_tag = 5

/datum/reagent/ethanol/coffee/brave_bull // Not an original liquor in its own. But since it's a mix of purely Tequila
	price_tag = 5						 // and Kahlua, it's basically just another one and gets the same price.


// Wines //

/datum/reagent/ethanol/wine
	price_tag = 8

/datum/reagent/ethanol/cognac
	price_tag = 8

/datum/reagent/ethanol/sake
	price_tag = 8

/datum/reagent/ethanol/vermouth
	price_tag = 8

/datum/reagent/ethanol/pwine
	price_tag = 8


// Cocktails //

/datum/reagent/ethanol/acid_spit
	price_tag = 4

/datum/reagent/ethanol/alliescocktail
	price_tag = 4

/datum/reagent/ethanol/aloe
	price_tag = 4

/datum/reagent/ethanol/amasec
	price_tag = 4

/datum/reagent/ethanol/andalusia
	price_tag = 4

/datum/reagent/ethanol/antifreeze
	price_tag = 4

/datum/reagent/ethanol/atomicbomb
	price_tag = 4

/datum/reagent/ethanol/coffee/b52
	price_tag = 4

/datum/reagent/ethanol/bahama_mama
	price_tag = 4

/datum/reagent/ethanol/barefoot
	price_tag = 4

/datum/reagent/ethanol/beepsky_smash
	price_tag = 4

/datum/reagent/ethanol/bilk
	price_tag = 4

/datum/reagent/ethanol/black_russian
	price_tag = 4

/datum/reagent/ethanol/bloody_mary
	price_tag = 4

/datum/reagent/ethanol/booger
	price_tag = 4

/datum/reagent/ethanol/brave_bull
	price_tag = 4

/datum/reagent/ethanol/changeling_sting
	price_tag = 4

/datum/reagent/ethanol/martini
	price_tag = 4

/datum/reagent/ethanol/cuba_libre
	price_tag = 4

/datum/reagent/ethanol/demonsblood
	price_tag = 4

/datum/reagent/ethanol/devilskiss
	price_tag = 4

/datum/reagent/ethanol/driestmartini
	price_tag = 4

/datum/reagent/ethanol/ginfizz
	price_tag = 4

/datum/reagent/ethanol/grog
	price_tag = 4

/datum/reagent/ethanol/erikasurprise
	price_tag = 4

/datum/reagent/ethanol/gargle_blaster
	price_tag = 4

/datum/reagent/ethanol/gintonic
	price_tag = 4

/datum/reagent/ethanol/hippies_delight
	price_tag = 4

/datum/reagent/ethanol/iced_beer
	price_tag = 4

/datum/reagent/ethanol/irishcarbomb
	price_tag = 4

/datum/reagent/ethanol/coffee/irishcoffee
	price_tag = 4

/datum/reagent/ethanol/longislandicedtea
	price_tag = 4

/datum/reagent/ethanol/manhattan
	price_tag = 4

/datum/reagent/ethanol/manhattan_proj
	price_tag = 4

/datum/reagent/ethanol/manly_dorf
	price_tag = 4

/datum/reagent/ethanol/margarita
	price_tag = 4

/datum/reagent/ethanol/mead
	price_tag = 4

/datum/reagent/ethanol/moonshine
	price_tag = 4

/datum/reagent/ethanol/neurotoxin
	price_tag = 4

/datum/reagent/ethanol/red_mead
	price_tag = 4

/datum/reagent/ethanol/sbiten
	price_tag = 4

/datum/reagent/ethanol/screwdrivercocktail
	price_tag = 4

/datum/reagent/ethanol/silencer
	price_tag = 4

/datum/reagent/ethanol/singulo
	price_tag = 4

/datum/reagent/ethanol/snowwhite
	price_tag = 4

/datum/reagent/ethanol/suidream
	price_tag = 4

/datum/reagent/ethanol/syndicatebomb
	price_tag = 4

/datum/reagent/ethanol/tequillasunrise
	price_tag = 4

/datum/reagent/ethanol/threemileisland
	price_tag = 4

/datum/reagent/ethanol/toxins_special
	price_tag = 4

/datum/reagent/ethanol/vodkamartini
	price_tag = 4

/datum/reagent/ethanol/vodkatonic
	price_tag = 4

/datum/reagent/ethanol/white_russian
	price_tag = 4

/datum/reagent/ethanol/whiskey_cola
	price_tag = 4

/datum/reagent/ethanol/whiskeysoda
	price_tag = 4

/datum/reagent/ethanol/binmanbliss
	price_tag = 4

/datum/reagent/ethanol/xanaducannon
	price_tag = 4

/datum/reagent/ethanol/balloon
	price_tag = 4

/datum/reagent/ethanol/coffee/elysiumfacepunch
	price_tag = 4

/datum/reagent/ethanol/saketini
	price_tag = 4

/datum/reagent/ethanol/tokyorose
	price_tag = 4

/datum/reagent/ethanol/ginzamary
	price_tag = 4

/datum/reagent/ethanol/tamagozake
	price_tag = 4

/datum/reagent/ethanol/sakebomb
	price_tag = 4

/datum/reagent/ethanol/erebusmoonrise
	price_tag = 4

// The Cheap Shit //

/datum/reagent/ethanol/hooch
	price_tag = 2

/datum/reagent/ethanol/debugger
	price_tag = 2

/datum/reagent/ethanol/spacersbrew
	price_tag = 2

/datum/reagent/ethanol/natunabrandy
	price_tag = 2

// Cocktails without alcohol //

/datum/reagent/ethanol/bananahonk
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

/obj/item/weapon/reagent_containers/food/drinks/cans/gingerale
	price_tag = 1

//***************//
//----Bottles----//
//***************//

// Juices, soda and similar //

/obj/item/weapon/reagent_containers/food/drinks/bottle/cola
	price_tag = 6

/obj/item/weapon/reagent_containers/food/drinks/bottle/space_up
	price_tag = 6

/obj/item/weapon/reagent_containers/food/drinks/bottle/space_mountain_wind
	price_tag = 6

/obj/item/weapon/reagent_containers/food/drinks/bottle/orangejuice
	price_tag = 6

/obj/item/weapon/reagent_containers/food/drinks/bottle/applejuice
	price_tag = 6

/obj/item/weapon/reagent_containers/food/drinks/bottle/cream
	price_tag = 6

/obj/item/weapon/reagent_containers/food/drinks/bottle/tomatojuice
	price_tag = 6

/obj/item/weapon/reagent_containers/food/drinks/bottle/limejuice
	price_tag = 6


// Beer //

/obj/item/weapon/reagent_containers/food/drinks/bottle/small/beer
	price_tag = 3

/obj/item/weapon/reagent_containers/food/drinks/bottle/small/ale
	price_tag = 3


// Spirituous Liquors //

/obj/item/weapon/reagent_containers/food/drinks/bottle/absinthe
	price_tag = 15

/obj/item/weapon/reagent_containers/food/drinks/bottle/bluecuracao
	price_tag = 15

/obj/item/weapon/reagent_containers/food/drinks/bottle/gin
	price_tag = 15

/obj/item/weapon/reagent_containers/food/drinks/bottle/kahlua
	price_tag = 15

/obj/item/weapon/reagent_containers/food/drinks/bottle/melonliquor
	price_tag = 15

/obj/item/weapon/reagent_containers/food/drinks/bottle/rum
	price_tag = 15

/obj/item/weapon/reagent_containers/food/drinks/bottle/tequilla
	price_tag = 15

/obj/item/weapon/reagent_containers/food/drinks/bottle/vodka
	price_tag = 15

/obj/item/weapon/reagent_containers/food/drinks/bottle/whiskey
	price_tag = 15

/obj/item/weapon/reagent_containers/food/drinks/bottle/specialwhiskey
	price_tag = 15

/obj/item/weapon/reagent_containers/food/drinks/bottle/patron
	price_tag = 15

/obj/item/weapon/reagent_containers/food/drinks/bottle/goldschlager
	price_tag = 15

/obj/item/weapon/reagent_containers/food/drinks/bottle/bottleofnothing
	price_tag = 15

/obj/item/weapon/reagent_containers/food/drinks/bottle/grenadine
	price_tag = 15


// Wines //

/obj/item/weapon/reagent_containers/food/drinks/bottle/wine
	price_tag = 25

/obj/item/weapon/reagent_containers/food/drinks/bottle/cognac
	price_tag = 25

/obj/item/weapon/reagent_containers/food/drinks/bottle/vermouth
	price_tag = 25

/obj/item/weapon/reagent_containers/food/drinks/bottle/pwine
	price_tag = 25

/obj/item/weapon/reagent_containers/food/drinks/bottle/sake
	price_tag = 25

//***************//
//---Foodstuff---//
//***************//

// Snacks //

/obj/item/weapon/reagent_containers/food/snacks/candy
	price_tag = 1

/obj/item/weapon/reagent_containers/food/snacks/sosjerky
	price_tag = 2

/obj/item/weapon/reagent_containers/food/snacks/unajerky
	price_tag = 12

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

/obj/item/weapon/reagent_containers/food/snacks/taco
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

/obj/item/weapon/reagent_containers/food/snacks/slice/margherita
	price_tag = 1

/obj/item/weapon/reagent_containers/food/snacks/slice/meatpizza
	price_tag = 1

/obj/item/weapon/reagent_containers/food/snacks/slice/mushroompizza
	price_tag = 1

/obj/item/weapon/reagent_containers/food/snacks/slice/vegetablepizza
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

/obj/item/weapon/reagent_containers/food/snacks/slice/meatbread
	price_tag = 1

/obj/item/weapon/reagent_containers/food/snacks/sliceable/xenomeatbread
	price_tag = 5

/obj/item/weapon/reagent_containers/food/snacks/slice/xenomeatbread
	price_tag = 1

/obj/item/weapon/reagent_containers/food/snacks/sliceable/bananabread
	price_tag = 5

/obj/item/weapon/reagent_containers/food/snacks/slice/bananabread
	price_tag = 1

/obj/item/weapon/reagent_containers/food/snacks/sliceable/tofubread
	price_tag = 5

/obj/item/weapon/reagent_containers/food/snacks/slice/tofubread
	price_tag = 1

/obj/item/weapon/reagent_containers/food/snacks/sliceable/bread
	price_tag = 5

/obj/item/weapon/reagent_containers/food/snacks/slice/bread
	price_tag = 1

/obj/item/weapon/reagent_containers/food/snacks/sliceable/creamcheesebread
	price_tag = 5

/obj/item/weapon/reagent_containers/food/snacks/slice/creamcheesebread
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

/obj/item/weapon/reagent_containers/food/snacks/slice/carrotcake
	price_tag = 1

/obj/item/weapon/reagent_containers/food/snacks/sliceable/braincake
	price_tag = 5

/obj/item/weapon/reagent_containers/food/snacks/slice/braincake
	price_tag = 1

/obj/item/weapon/reagent_containers/food/snacks/sliceable/cheesecake
	price_tag = 5

/obj/item/weapon/reagent_containers/food/snacks/slice/cheesecake
	price_tag = 1

/obj/item/weapon/reagent_containers/food/snacks/sliceable/plaincake
	price_tag = 5

/obj/item/weapon/reagent_containers/food/snacks/slice/plaincake
	price_tag = 1

/obj/item/weapon/reagent_containers/food/snacks/sliceable/orangecake
	price_tag = 5

/obj/item/weapon/reagent_containers/food/snacks/slice/orangecake
	price_tag = 1

/obj/item/weapon/reagent_containers/food/snacks/sliceable/limecake
	price_tag = 5

/obj/item/weapon/reagent_containers/food/snacks/slice/limecake
	price_tag = 1

/obj/item/weapon/reagent_containers/food/snacks/sliceable/lemoncake
	price_tag = 5

/obj/item/weapon/reagent_containers/food/snacks/slice/lemoncake
	price_tag = 1

/obj/item/weapon/reagent_containers/food/snacks/sliceable/chocolatecake
	price_tag = 5

/obj/item/weapon/reagent_containers/food/snacks/slice/chocolatecake
	price_tag = 1

/obj/item/weapon/reagent_containers/food/snacks/sliceable/birthdaycake
	price_tag = 5

/obj/item/weapon/reagent_containers/food/snacks/slice/birthdaycake
	price_tag = 1

/obj/item/weapon/reagent_containers/food/snacks/sliceable/applecake
	price_tag = 5

/obj/item/weapon/reagent_containers/food/snacks/slice/applecake
	price_tag = 1

/obj/item/weapon/reagent_containers/food/snacks/sliceable/pumpkinpie
	price_tag = 5

/obj/item/weapon/reagent_containers/food/snacks/slice/pumpkinpie
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
	get_retail_cost()
		return get_retail_cost(pizza)


//***************//
//----Smokes-----//
//***************//

/obj/item/weapon/storage/fancy/cigarettes
	price_tag = 15

/obj/item/weapon/storage/fancy/cigarettes/luckystars
	price_tag = 17

/obj/item/weapon/storage/fancy/cigarettes/jerichos
	price_tag = 22

/obj/item/weapon/storage/fancy/cigarettes/menthols
	price_tag = 18

/obj/item/weapon/storage/fancy/cigar
	price_tag = 27

/obj/item/weapon/storage/fancy/cigarettes/carcinomas
	price_tag  = 23

/obj/item/weapon/storage/fancy/cigarettes/professionals
	price_tag = 25

/obj/item/weapon/storage/box/matches
	price_tag = 1

/obj/item/weapon/flame/lighter
	price_tag = 2

/obj/item/weapon/flame/lighter/zippo
	price_tag = 5

//******************************//
//|IN THIS MOMENT I AM EUPHORIC|//
//******************************//

/datum/reagent/ethanol/euphoria
	price_tag = 30
