var/global/list/plant_seed_sprites = list()

//Seed packet object/procs.
/obj/item/seeds
	name = "packet of seeds"
	icon = 'icons/obj/seeds.dmi'
	icon_state = "seedy"
	w_class = ITEM_SIZE_SMALL

	var/seed_type
	var/datum/seed/seed
	var/modified = 0

/obj/item/seeds/Initialize()
	update_seed()
	. = ..()

//Grabs the appropriate seed datum from the global list.
/obj/item/seeds/proc/update_seed()
	if(!seed && seed_type && !isnull(SSplants.seeds) && SSplants.seeds[seed_type])
		seed = SSplants.seeds[seed_type]
	update_appearance()

//Updates strings and icon appropriately based on seed datum.
/obj/item/seeds/proc/update_appearance()
	if(!seed) return

	// Update icon.
	overlays.Cut()
	var/is_seeds = ((seed.seed_noun in list(SEED_NOUN_SEEDS, SEED_NOUN_PITS, SEED_NOUN_NODES)) ? 1 : 0)
	var/image/seed_mask
	var/seed_base_key = "base-[is_seeds ? seed.get_trait(TRAIT_PLANT_COLOUR) : "spores"]"
	if(plant_seed_sprites[seed_base_key])
		seed_mask = plant_seed_sprites[seed_base_key]
	else
		seed_mask = image('icons/obj/seeds.dmi',"[is_seeds ? "seed" : "spore"]-mask")
		if(is_seeds) // Spore glass bits aren't coloured.
			seed_mask.color = seed.get_trait(TRAIT_PLANT_COLOUR)
		plant_seed_sprites[seed_base_key] = seed_mask

	var/image/seed_overlay
	var/seed_overlay_key = "[seed.get_trait(TRAIT_PRODUCT_ICON)]-[seed.get_trait(TRAIT_PRODUCT_COLOUR)]"
	if(plant_seed_sprites[seed_overlay_key])
		seed_overlay = plant_seed_sprites[seed_overlay_key]
	else
		seed_overlay = image('icons/obj/seeds.dmi',"[seed.get_trait(TRAIT_PRODUCT_ICON)]")
		seed_overlay.color = seed.get_trait(TRAIT_PRODUCT_COLOUR)
		plant_seed_sprites[seed_overlay_key] = seed_overlay

	overlays |= seed_mask
	overlays |= seed_overlay

	if(is_seeds)
		src.SetName("packet of [seed.seed_name] [seed.seed_noun]")
		src.desc = "It has a picture of [seed.display_name] on the front."
	else
		src.SetName("sample of [seed.seed_name] [seed.seed_noun]")
		src.desc = "It's labelled as coming from [seed.display_name]."

/obj/item/seeds/examine(mob/user)
	. = ..()
	if(seed && !seed.roundstart)
		to_chat(user, "It's tagged as variety #[seed.uid].")

/obj/item/seeds/cutting
	name = "cuttings"
	desc = "Some plant cuttings."

/obj/item/seeds/cutting/update_appearance()
	..()
	src.SetName("packet of [seed.seed_name] cuttings")

/obj/item/seeds/random
	seed_type = null

/obj/item/seeds/random/Initialize()
	seed = SSplants.create_random_seed()
	seed_type = seed.name
	. = ..()

/obj/item/seeds/replicapod
	seed_type = "diona"

/obj/item/seeds/chiliseed
	seed_type = "chili"

/obj/item/seeds/plastiseed
	seed_type = "plastic"

/obj/item/seeds/grapeseed
	seed_type = "grapes"

/obj/item/seeds/greengrapeseed
	seed_type = "greengrapes"

/obj/item/seeds/peanutseed
	seed_type = "peanut"

/obj/item/seeds/cabbageseed
	seed_type = "cabbage"

/obj/item/seeds/shandseed
	seed_type = "shand"

/obj/item/seeds/mtearseed
	seed_type = "mtear"

/obj/item/seeds/berryseed
	seed_type = "berries"

/obj/item/seeds/blueberryseed
	seed_type = "blueberries"

/obj/item/seeds/glowberryseed
	seed_type = "glowberries"

/obj/item/seeds/bananaseed
	seed_type = "banana"

/obj/item/seeds/eggplantseed
	seed_type = "eggplant"

/obj/item/seeds/bloodtomatoseed
	seed_type = "bloodtomato"

/obj/item/seeds/tomatoseed
	seed_type = "tomato"

/obj/item/seeds/killertomatoseed
	seed_type = "killertomato"

/obj/item/seeds/bluetomatoseed
	seed_type = "bluetomato"

/obj/item/seeds/bluespacetomatoseed
	seed_type = "bluespacetomato"

/obj/item/seeds/cornseed
	seed_type = "corn"

/obj/item/seeds/poppyseed
	seed_type = "poppies"

/obj/item/seeds/potatoseed
	seed_type = "potato"

/obj/item/seeds/icepepperseed
	seed_type = "icechili"

/obj/item/seeds/soyaseed
	seed_type = "soybean"

/obj/item/seeds/wheatseed
	seed_type = "wheat"

/obj/item/seeds/riceseed
	seed_type = "rice"

/obj/item/seeds/carrotseed
	seed_type = "carrot"

/obj/item/seeds/reishimycelium
	seed_type = "reishi"

/obj/item/seeds/amanitamycelium
	seed_type = "amanita"

/obj/item/seeds/angelmycelium
	seed_type = "destroyingangel"

/obj/item/seeds/libertymycelium
	seed_type = "libertycap"

/obj/item/seeds/chantermycelium
	seed_type = "mushrooms"

/obj/item/seeds/towermycelium
	seed_type = "towercap"

/obj/item/seeds/glowshroom
	seed_type = "glowshroom"

/obj/item/seeds/plumpmycelium
	seed_type = "plumphelmet"

/obj/item/seeds/walkingmushroommycelium
	seed_type = "walkingmushroom"

/obj/item/seeds/nettleseed
	seed_type = "nettle"

/obj/item/seeds/deathnettleseed
	seed_type = "deathnettle"

/obj/item/seeds/weeds
	seed_type = "weeds"

/obj/item/seeds/harebell
	seed_type = "harebells"

/obj/item/seeds/sunflowerseed
	seed_type = "sunflowers"

/obj/item/seeds/lavenderseed
	seed_type = "lavender"

/obj/item/seeds/brownmold
	seed_type = "mold"

/obj/item/seeds/appleseed
	seed_type = "apple"

/obj/item/seeds/poisonedappleseed
	seed_type = "poisonapple"

/obj/item/seeds/goldappleseed
	seed_type = "goldapple"

/obj/item/seeds/ambrosiavulgarisseed
	seed_type = "ambrosia"

/obj/item/seeds/ambrosiadeusseed
	seed_type = "ambrosiadeus"

/obj/item/seeds/whitebeetseed
	seed_type = "whitebeet"

/obj/item/seeds/sugarcaneseed
	seed_type = "sugarcane"

/obj/item/seeds/watermelonseed
	seed_type = "watermelon"

/obj/item/seeds/pumpkinseed
	seed_type = "pumpkin"

/obj/item/seeds/limeseed
	seed_type = "lime"

/obj/item/seeds/lemonseed
	seed_type = "lemon"

/obj/item/seeds/orangeseed
	seed_type = "orange"

/obj/item/seeds/poisonberryseed
	seed_type = "poisonberries"

/obj/item/seeds/deathberryseed
	seed_type = "deathberries"

/obj/item/seeds/grassseed
	seed_type = "grass"

/obj/item/seeds/cocoapodseed
	seed_type = "cocoa"

/obj/item/seeds/cherryseed
	seed_type = "cherry"

/obj/item/seeds/tobaccoseed
	seed_type = "tobacco"

/obj/item/seeds/finetobaccoseed
	seed_type = "finetobacco"

/obj/item/seeds/puretobaccoseed
	seed_type = "puretobacco"

/obj/item/seeds/kudzuseed
	seed_type = "kudzu"

/obj/item/seeds/peppercornseed
	seed_type = "peppercorn"

/obj/item/seeds/garlicseed
	seed_type = "garlic"

/obj/item/seeds/onionseed
	seed_type = "onion"

/obj/item/seeds/algaeseed
	seed_type = "algae"

/obj/item/seeds/bamboo
	seed_type = "bamboo"

/obj/item/seeds/breather/seed_type = "breather"

/obj/item/seeds/resin/seed_type = "resinplant"

// fruit expansion

/obj/item/seeds/melonseed
	seed_type = "melon"

/obj/item/seeds/coffeeseed
	seed_type = "coffee"

/obj/item/seeds/whitegrapeseed
	seed_type = "whitegrapes"

/obj/item/seeds/vanillaseed
	seed_type = "vanilla"

/obj/item/seeds/pineappleseed
	seed_type = "pineapples"

/obj/item/seeds/gukhe
	seed_type = "gukhe"

/obj/item/seeds/hrukhza
	seed_type = "hrukhza"

/obj/item/seeds/okrri
	seed_type = "okrri"

/obj/item/seeds/ximikoa
	seed_type = "ximikoa"

/obj/item/seeds/pearseed
	seed_type = "pears"

/obj/item/seeds/coconutseed
	seed_type = "coconuts"

/obj/item/seeds/qokkloa
	seed_type = "qokkloa"

/obj/item/seeds/aghrassh
	seed_type = "aghrassh"

/obj/item/seeds/cinnamon
	seed_type = "cinnamon"

/obj/item/seeds/olives
	seed_type = "olives"

/obj/item/seeds/gummen
	seed_type = "gummen"

/obj/item/seeds/iridast
	seed_type = "iridast"

/obj/item/seeds/affelerin
	seed_type = "affelerin"
