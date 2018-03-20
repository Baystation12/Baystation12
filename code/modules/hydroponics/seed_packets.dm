var/global/list/plant_seed_sprites = list()

//Seed packet object/procs.
/obj/item/seeds
	name = "packet of seeds"
	icon = 'icons/obj/seeds.dmi'
	icon_state = "blank"
	w_class = ITEM_SIZE_SMALL

	var/seed_type
	var/datum/seed/seed
	var/modified = 0

/obj/item/seeds/Initialize()
	update_seed()
	. = ..()

//Grabs the appropriate seed datum from the global list.
/obj/item/seeds/proc/update_seed()
	if(!seed && seed_type && !isnull(plant_controller.seeds) && plant_controller.seeds[seed_type])
		seed = plant_controller.seeds[seed_type]
	update_appearance()

//Updates strings and icon appropriately based on seed datum.
/obj/item/seeds/proc/update_appearance()
	if(!seed) return

	// Update icon.
	overlays.Cut()
	var/is_seeds = ((seed.seed_noun in list("seeds","pits","nodes")) ? 1 : 0)
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
		src.name = "packet of [seed.seed_name] [seed.seed_noun]"
		src.desc = "It has a picture of [seed.display_name] on the front."
	else
		src.name = "sample of [seed.seed_name] [seed.seed_noun]"
		src.desc = "It's labelled as coming from [seed.display_name]."

/obj/item/seeds/examine(mob/user)
	. = ..(user)
	if(seed && !seed.roundstart)
		to_chat(user, "It's tagged as variety #[seed.uid].")

/obj/item/seeds/cutting
	name = "cuttings"
	desc = "Some plant cuttings."

/obj/item/seeds/cutting/update_appearance()
	..()
	src.name = "packet of [seed.seed_name] cuttings"

/obj/item/seeds/random
	seed_type = null

/obj/item/seeds/random/Initialize()
	seed = plant_controller.create_random_seed()
	seed_type = seed.name
	. = ..()

/obj/item/seeds/chiliseed
	seed_type = "chili"
	name = "chili seeds"
/obj/item/seeds/plastiseed
	seed_type = "plastic"
	name = "plastic seeds"
/obj/item/seeds/grapeseed
	seed_type = "grapes"
	name = "grape seeds"
/obj/item/seeds/greengrapeseed
	seed_type = "greengrapes"
	name = "green grape seeds"
/obj/item/seeds/peanutseed
	seed_type = "peanut"
	name = "peanut seeds"
/obj/item/seeds/cabbageseed
	seed_type = "cabbage"
	name = "cabbage seeds"
/obj/item/seeds/shandseed
	seed_type = "shand"
	name = "shand seeds"
/obj/item/seeds/mtearseed
	seed_type = "mtear"
	name = "mtear seeds"
/obj/item/seeds/berryseed
	seed_type = "berries"
	name = "berry seeds"
/obj/item/seeds/blueberryseed
	seed_type = "blueberries"
	name = "blueberry seeds"
/obj/item/seeds/glowberryseed
	seed_type = "glowberries"
	name = "glowberry seeds"
/obj/item/seeds/bananaseed
	seed_type = "banana"
	name = "banana seeds"
/obj/item/seeds/eggplantseed
	seed_type = "eggplant"
	name = "eggplant seeds"
/obj/item/seeds/bloodtomatoseed
	seed_type = "bloodtomato"
	name = "blood tomato seeds"
/obj/item/seeds/tomatoseed
	seed_type = "tomato"
	name = "tomato seeds"
/obj/item/seeds/killertomatoseed
	seed_type = "killertomato"
	name = "killer tomato seeds"
/obj/item/seeds/bluetomatoseed
	seed_type = "bluetomato"
	name = "blue tomato seeds"
/obj/item/seeds/bluespacetomatoseed
	seed_type = "bluespacetomato"
	name = "bluespace tomato seeds"
/obj/item/seeds/cornseed
	seed_type = "corn"
	name = "corn seeds"
/obj/item/seeds/poppyseed
	seed_type = "poppies"
	name = "poppy seeds"
/obj/item/seeds/potatoseed
	seed_type = "potato"
	name = "potato seeds"
/obj/item/seeds/icepepperseed
	seed_type = "icechili"
	name = "ice chili seeds"
/obj/item/seeds/soyaseed
	seed_type = "soybean"
	name = "soybean seeds"
/obj/item/seeds/wheatseed
	seed_type = "wheat"
	name = "wheat seeds"
/obj/item/seeds/riceseed
	seed_type = "rice"
	name = "rice seeds"
/obj/item/seeds/carrotseed
	seed_type = "carrot"
	name = "carrot seeds"
/obj/item/seeds/reishimycelium
	seed_type = "reishi"
	name = "reishi seeds"
/obj/item/seeds/amanitamycelium
	seed_type = "amanita"
	name = "amanita seeds"
/obj/item/seeds/angelmycelium
	seed_type = "destroyingangel"
	name = "angel seeds"
/obj/item/seeds/libertymycelium
	seed_type = "libertycap"
	name = "liberty seeds"
/obj/item/seeds/chantermycelium
	seed_type = "mushrooms"
	name = "chanter seeds"
/obj/item/seeds/towermycelium
	seed_type = "towercap"
	name = "towercap seeds"
/obj/item/seeds/glowshroom
	seed_type = "glowshroom"
	name = "glowshroom seeds"
/obj/item/seeds/plumpmycelium
	seed_type = "plumphelmet"
	name = "plump helmet seeds"
/obj/item/seeds/walkingmushroommycelium
	seed_type = "walkingmushroom"
	name = "walking mushroom seeds"
/obj/item/seeds/nettleseed
	seed_type = "nettle"
	name = "nettle seeds"
/obj/item/seeds/deathnettleseed
	seed_type = "deathnettle"
	name = "death nettle seeds"
/obj/item/seeds/weeds
	seed_type = "weeds"
	name = "weed seeds"
/obj/item/seeds/harebell
	seed_type = "harebells"
	name = "harebell seeds"
/obj/item/seeds/sunflowerseed
	seed_type = "sunflowers"
	name = "sunflower seeds"
/obj/item/seeds/lavenderseed
	seed_type = "lavender"
	name = "lavender seeds"
/obj/item/seeds/brownmold
	seed_type = "mold"
	name = "mold seeds"
/obj/item/seeds/appleseed
	seed_type = "apple"
	name = "apple seeds"
/obj/item/seeds/poisonedappleseed
	seed_type = "poisonapple"
	name = "poison apple seeds"
/obj/item/seeds/goldappleseed
	seed_type = "goldapple"
	name = "golden apple seeds"
/obj/item/seeds/ambrosiavulgarisseed
	seed_type = "ambrosia"
	name = "ambrosia vulgaris seeds"
/obj/item/seeds/ambrosiadeusseed
	seed_type = "ambrosiadeus"
	name = "ambrosia deus seeds"
/obj/item/seeds/whitebeetseed
	seed_type = "whitebeet"
	name = "white beet seeds"
/obj/item/seeds/sugarcaneseed
	seed_type = "sugarcane"
	name = "sugarcane seeds"
/obj/item/seeds/watermelonseed
	seed_type = "watermelon"
	name = "watermelon seeds"
/obj/item/seeds/pumpkinseed
	seed_type = "pumpkin"
	name = "pumpkin seeds"
/obj/item/seeds/limeseed
	seed_type = "lime"
	name = "lime seeds"
/obj/item/seeds/lemonseed
	seed_type = "lemon"
	name = "lemon seeds"
/obj/item/seeds/orangeseed
	seed_type = "orange"
	name = "orange seeds"
/obj/item/seeds/poisonberryseed
	seed_type = "poisonberries"
	name = "poisonberry seeds"
/obj/item/seeds/deathberryseed
	seed_type = "deathberries"
	name = "deathberry seeds"
/obj/item/seeds/grassseed
	seed_type = "grass"
	name = "grass seeds"
/obj/item/seeds/cocoapodseed
	seed_type = "cocoa"
	name = "cocoa seeds"
/obj/item/seeds/cherryseed
	seed_type = "cherry"
	name = "cherry seeds"
/obj/item/seeds/tobaccoseed
	seed_type = "tobacco"
	name = "tobacco seeds"
/obj/item/seeds/kudzuseed
	seed_type = "kudzu"
	name = "kudzu seeds"