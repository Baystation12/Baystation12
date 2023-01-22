
/*
 * Backpack
 */

/obj/item/storage/backpack
	name = "backpack"
	desc = "You wear this on your back and put items into it."
	item_icons = list(
		slot_l_hand_str = 'icons/mob/onmob/items/lefthand_backpacks.dmi',
		slot_r_hand_str = 'icons/mob/onmob/items/righthand_backpacks.dmi',
		)
	icon_state = "backpack"
	item_state = null
	//most backpacks use the default backpack state for inhand overlays
	item_state_slots = list(
		slot_l_hand_str = "backpack",
		slot_r_hand_str = "backpack",
		)
	w_class = ITEM_SIZE_HUGE
	slot_flags = SLOT_BACK
	max_w_class = ITEM_SIZE_LARGE
	max_storage_space = DEFAULT_BACKPACK_STORAGE
	open_sound = 'sound/effects/storage/unzip.ogg'
	allow_slow_dump = TRUE
	/// can be opened while worn on back?
	var/worn_access = TRUE

/obj/item/storage/backpack/equipped()
	if(!has_extension(src, /datum/extension/appearance))
		set_extension(src, /datum/extension/appearance/cardborg)
	..()

/obj/item/storage/backpack/attackby(obj/item/W as obj, mob/user as mob)
	if (src.use_sound)
		playsound(src.loc, src.use_sound, 50, 1, -5)
	return ..()

/obj/item/storage/backpack/equipped(var/mob/user, var/slot)
	if (!has_extension(src, /datum/extension/appearance))
		set_extension(src, /datum/extension/appearance/cardborg)
	if (slot == slot_back && src.use_sound)
		playsound(src.loc, src.use_sound, 50, 1, -5)
	if(is_worn() && !worn_access)
		close_all()
	..(user, slot)

/obj/item/storage/backpack/handle_item_insertion(obj/item/W, prevent_warning = FALSE, NoUpdate = 0)
	if(is_worn() && !worn_access)
		to_chat(usr, SPAN_WARNING("You can't insert \the [W] while \the [src] is on your back."))
		return
	..()

/obj/item/storage/backpack/open(mob/user)
	if(is_worn() && !worn_access)
		to_chat(user, SPAN_WARNING("You can't open \the [src] while it is on your back."))
		return
	..()

/obj/item/proc/is_worn()
	if(ishuman(loc))
		var/mob/living/carbon/human/H = loc
		if(H.get_inventory_slot(src) == slot_back)
			return TRUE
	return FALSE

/*
 * Backpack Types
 */

/obj/item/storage/backpack/holding
	name = "bag of holding"
	desc = "A backpack that opens into a localized pocket of Blue Space."
	origin_tech = list(TECH_BLUESPACE = 4)
	icon_state = "holdingpack"
	item_state_slots = list(
		slot_l_hand_str = "holdingpack",
		slot_r_hand_str = "holdingpack"
	)
	max_w_class = ITEM_SIZE_NORMAL
	max_storage_space = 56

/obj/item/storage/backpack/holding/New()
	..()
	return

/obj/item/storage/backpack/holding/attackby(obj/item/W as obj, mob/user as mob)
	if(istype(W, /obj/item/storage/backpack/holding) || istype(W, /obj/item/storage/bag/trash/bluespace))
		to_chat(user, "<span class='warning'>The Bluespace interfaces of the two devices conflict and malfunction.</span>")
		qdel(W)
		return 1
	return ..()

	//Please don't clutter the parent storage item with stupid hacks.
/obj/item/storage/backpack/holding/can_be_inserted(obj/item/W as obj, stop_messages = 0)
	if(istype(W, /obj/item/storage/backpack/holding))
		return 1
	return ..()

/obj/item/storage/backpack/holding/duffle
	name = "dufflebag of holding"
	icon_state = "holdingduffle"
	item_state_slots = list(slot_l_hand_str = "duffle", slot_r_hand_str = "duffle")

/obj/item/storage/backpack/santabag
	name = "\improper Santa's gift bag"
	desc = "Space Santa uses this to deliver toys to all the nice children in space for Christmas! Wow, it's pretty big!"
	icon_state = "giftbag0"
	item_state = "giftbag"
	w_class = ITEM_SIZE_HUGE
	max_w_class = ITEM_SIZE_NORMAL
	max_storage_space = 400 // can store a ton of shit!
	item_state_slots = null

/obj/item/storage/backpack/cultpack
	name = "trophy rack"
	desc = "It's useful for both carrying extra gear, and proudly declaring your dedication to your chosen malevolent deity."
	icon_state = "cultpack"

/obj/item/storage/backpack/clown
	name = "\improper Giggles von Honkerton"
	desc = "It's a very vibrant backpack, made for a clown."
	icon_state = "clownpack"
	item_state_slots = null

/obj/item/storage/backpack/medic
	name = "medical backpack"
	desc = "It's a backpack, designed for use in the sterile confines of the infirmary."
	icon_state = "medicalpack"
	item_state_slots = list(
		slot_l_hand_str = "medicalpack",
		slot_r_hand_str = "medicalpack"
	)

/obj/item/storage/backpack/security
	name = "security backpack"
	desc = "It's a very robust backpack, for security-related needs."
	icon_state = "securitypack"
	item_state_slots = list(
		slot_l_hand_str = "securitypack",
		slot_r_hand_str = "securitypack"
	)

/obj/item/storage/backpack/security/exo
	name = "corporate security backpack"
	desc = "It's a very robust backpack, for security-related needs. This one is in EXO colors."
	icon_state = "securitypack_exo"

/obj/item/storage/backpack/command
	name = "command backpack"
	desc = "It's a special backpack, made exclusively for senior officers."
	icon_state = "captainpack"
	item_state_slots = list(
		slot_l_hand_str = "captainpack",
		slot_r_hand_str = "captainpack"
	)

/obj/item/storage/backpack/industrial
	name = "industrial backpack"
	desc = "It's a tough backpack, made for the daily grind of industrial life."
	icon_state = "engiepack"
	item_state_slots = list(
		slot_l_hand_str = "engiepack",
		slot_r_hand_str = "engiepack"
	)

/obj/item/storage/backpack/toxins
	name = "science backpack"
	desc = "It's a stain-resistant light backpack, modeled for use in laboratories and other scientific settings."
	icon_state = "ntpack"
	item_state_slots = list(
		slot_l_hand_str = "ntpack",
		slot_r_hand_str = "ntpack"
	)

/obj/item/storage/backpack/hydroponics
	name = "hydroponics backpack"
	desc = "It's a green backpack, with many pockets to store plants and tools in."
	icon_state = "hydpack"
	item_state_slots = list(
		slot_l_hand_str = "hydpack",
		slot_r_hand_str = "hydpack"
	)

/obj/item/storage/backpack/genetics
	name = "genetics backpack"
	desc = "It's a backpack, fitted with slots for diskettes and other workplace tools."
	icon_state = "genpack"
	item_state_slots = list(
		slot_l_hand_str = "genpack",
		slot_r_hand_str = "genpack"
	)

/obj/item/storage/backpack/virology
	name = "sterile backpack"
	desc = "It's a sterile backpack, specially designed for work in areas with a biosafety classification level."
	icon_state = "viropack"
	item_state_slots = list(
		slot_l_hand_str = "viropack",
		slot_r_hand_str = "viropack"
	)

/obj/item/storage/backpack/chemistry
	name = "pharmacy backpack"
	desc = "It's a sterile orange backpack, which was designed to hold beakers, pill bottles, and other reagent containers."
	icon_state = "chempack"
	item_state_slots = list(
		slot_l_hand_str = "chempack",
		slot_r_hand_str = "chempack"
	)

/obj/item/storage/backpack/rucksack
	name = "black rucksack"
	desc = "A sturdy, military-grade backpack with low-profile straps. Designed to work well with armor."
	icon_state = "rucksack"
	item_state_slots = list(
		slot_l_hand_str = "rucksack",
		slot_r_hand_str = "rucksack"
	)

/obj/item/storage/backpack/rucksack/blue
	name = "blue rucksack"
	icon_state = "rucksack_blue"
	item_state_slots = list(
		slot_l_hand_str = "rucksack_blue",
		slot_r_hand_str = "rucksack_blue"
	)

/obj/item/storage/backpack/rucksack/green
	name = "green rucksack"
	icon_state = "rucksack_green"
	item_state_slots = list(
		slot_l_hand_str = "rucksack_green",
		slot_r_hand_str = "rucksack_green"
	)

/obj/item/storage/backpack/rucksack/navy
	name = "navy rucksack"
	icon_state = "rucksack_navy"
	item_state_slots = list(
		slot_l_hand_str = "rucksack_navy",
		slot_r_hand_str = "rucksack_navy"
	)

/obj/item/storage/backpack/rucksack/tan
	name = "tan rucksack"
	icon_state = "rucksack_tan"
	item_state_slots = list(
		slot_l_hand_str = "rucksack_tan",
		slot_r_hand_str = "rucksack_tan"
	)

/*
 * Duffle Types
 */

/obj/item/storage/backpack/dufflebag
	name = "dufflebag"
	desc = "A large dufflebag for holding extra things."
	icon_state = "duffle"
	item_state_slots = null
	w_class = ITEM_SIZE_HUGE
	max_storage_space = DEFAULT_BACKPACK_STORAGE + 10
	worn_access = FALSE

/obj/item/storage/backpack/dufflebag/syndie
	name = "black dufflebag"
	desc = "A large dufflebag for holding extra tactical supplies."
	icon_state = "duffle_syndie"
	item_state_slots = list(slot_l_hand_str = "duffle_syndie", slot_r_hand_str = "duffle_syndie")

/obj/item/storage/backpack/dufflebag/syndie/med
	name = "medical dufflebag"
	desc = "A large dufflebag for holding extra tactical medical supplies."
	icon_state = "duffle_syndiemed"
	item_state_slots = list(slot_l_hand_str = "duffle_syndiemed", slot_r_hand_str = "duffle_syndiemed")

/obj/item/storage/backpack/dufflebag/syndie/med/full
	startswith = list(
		/obj/item/roller,
		/obj/item/storage/box/syringes,
		/obj/item/clothing/gloves/latex/nitrile,
		/obj/item/clothing/glasses/hud/health,
		/obj/item/device/scanner/health,
		/obj/item/auto_cpr,
		/obj/item/defibrillator/loaded,
		/obj/item/reagent_containers/ivbag/nanoblood,
		/obj/item/storage/firstaid/adv
	)

/obj/item/storage/backpack/dufflebag/syndie/ammo
	name = "ammunition dufflebag"
	desc = "A large dufflebag for holding extra weapons ammunition and supplies."
	icon_state = "duffle_syndieammo"
	item_state_slots = list(slot_l_hand_str = "duffle_syndieammo", slot_r_hand_str = "duffle_syndieammo")

/obj/item/storage/backpack/dufflebag/com
	name = "command dufflebag"
	desc = "A large dufflebag for holding extra goods for senior command."
	icon_state = "duffle_captain"
	item_state_slots = list(slot_l_hand_str = "duffle_captain", slot_r_hand_str = "duffle_captain")

/obj/item/storage/backpack/dufflebag/med
	name = "medical dufflebag"
	desc = "A large dufflebag for holding extra medical supplies."
	icon_state = "duffle_med"
	item_state_slots = list(slot_l_hand_str = "duffle_med", slot_r_hand_str = "duffle_med")

/obj/item/storage/backpack/dufflebag/sec
	name = "security dufflebag"
	desc = "A large dufflebag for holding extra security supplies and ammunition."
	icon_state = "duffle_sec"
	item_state_slots = list(slot_l_hand_str = "duffle_sec", slot_r_hand_str = "duffle_sec")

/obj/item/storage/backpack/dufflebag/eng
	name = "industrial dufflebag"
	desc = "A large dufflebag for holding extra tools and supplies."
	icon_state = "duffle_eng"
	item_state_slots = list(slot_l_hand_str = "duffle_eng", slot_r_hand_str = "duffle_eng")

/obj/item/storage/backpack/dufflebag/firefighter
	name = "firefighter's dufflebag"
	desc = "A large dufflebag containing equipment to fight fires with."
	startswith = list(
		/obj/item/storage/belt/fire_belt/full,
		/obj/item/clothing/suit/fire/firefighter,
		/obj/item/extinguisher,
		/obj/item/clothing/gloves/fire,
		/obj/item/clothing/accessory/fire_overpants,
		/obj/item/tank/oxygen_scba,
		/obj/item/clothing/head/hardhat/firefighter,
		/obj/item/extinguisher
	)
/*
 * Satchel Types
 */

/obj/item/storage/backpack/satchel
	name = "satchel"
	desc = "A trendy-looking satchel."
	icon_state = "satchel-norm"

/obj/item/storage/backpack/satchel/grey
	name = "grey satchel"

/obj/item/storage/backpack/satchel/grey/withwallet
	startswith = list(/obj/item/storage/wallet/random)

/obj/item/storage/backpack/satchel/leather //brown, master type
	name = "brown leather satchel"
	desc = "A very fancy satchel made of some kind of leather."
	icon_state = "satchel"
	color = "#3d2711"

/obj/item/storage/backpack/satchel/leather/khaki
	name = "khaki leather satchel"
	color = "#baa481"

/obj/item/storage/backpack/satchel/leather/black
	name = "black leather satchel"
	color = "#212121"

/obj/item/storage/backpack/satchel/leather/navy
	name = "navy leather satchel"
	color = "#1c2133"

/obj/item/storage/backpack/satchel/leather/olive
	name = "olive leather satchel"
	color = "#544f3d"

/obj/item/storage/backpack/satchel/leather/reddish
	name = "auburn leather satchel"
	color = "#512828"

/obj/item/storage/backpack/satchel/pocketbook //black, master type
	name = "black pocketbook"
	desc = "A neat little folding clasp pocketbook with a shoulder sling."
	icon_state = "pocketbook"
	w_class = ITEM_SIZE_HUGE // to avoid recursive backpacks
	slot_flags = SLOT_BACK
	max_w_class = ITEM_SIZE_NORMAL
	max_storage_space = DEFAULT_LARGEBOX_STORAGE
	color = "#212121"

/obj/item/storage/backpack/satchel/pocketbook/brown
	name = "brown pocketbook"
	color = "#3d2711"

/obj/item/storage/backpack/satchel/pocketbook/reddish
	name = "auburn pocketbook"
	color = "#512828"

/obj/item/storage/backpack/satchel/eng
	name = "industrial satchel"
	desc = "A tough satchel with extra pockets."
	icon_state = "satchel-eng"
	item_state_slots = list(
		slot_l_hand_str = "engiepack",
		slot_r_hand_str = "engiepack",
		)

/obj/item/storage/backpack/satchel/med
	name = "medical satchel"
	desc = "A sterile satchel designed for use in the sterile confines of the infirmary."
	icon_state = "satchel-med"
	item_state_slots = list(
		slot_l_hand_str = "medicalpack",
		slot_r_hand_str = "medicalpack",
		)

/obj/item/storage/backpack/satchel/vir
	name = "sterile satchel"
	desc = "It's a sterile satchel, rated for use in areas with a biosafety classification level."
	icon_state = "satchel-vir"

/obj/item/storage/backpack/satchel/chem
	name = "pharmacy satchel"
	desc = "It's a sterile orange satchel, designed to hold beakers, pill bottles, and other reagent containers."
	icon_state = "satchel-chem"

/obj/item/storage/backpack/satchel/gen
	name = "genetics satchel"
	desc = "A green satchel, filled with slots for diskettes and other workplace tools."
	icon_state = "satchel-gen"

/obj/item/storage/backpack/satchel/tox
	name = "science satchel"
	desc = "It's a stain-resistant satchel, modeled for use in laboratories and other scientific settings."
	icon_state = "satchel-nt"

/obj/item/storage/backpack/satchel/sec
	name = "security satchel"
	desc = "A robust satchel for security-related needs."
	icon_state = "satchel-sec"
	item_state_slots = list(
		slot_l_hand_str = "securitypack",
		slot_r_hand_str = "securitypack",
		)

/obj/item/storage/backpack/satchel/sec/exo
	name = "corporate security satchel"
	desc = "A robust satchel for corporate security-related needs. This one is in EXO colors."
	icon_state = "satchel-sec_exo"

/obj/item/storage/backpack/satchel/hyd
	name = "hydroponics satchel"
	desc = "A green satchel for plant related work."
	icon_state = "satchel_hyd"

/obj/item/storage/backpack/satchel/com
	name = "command satchel"
	desc = "An exclusive satchel for senior officers."
	icon_state = "satchel-cap"
	item_state_slots = list(
		slot_l_hand_str = "satchel-cap",
		slot_r_hand_str = "satchel-cap",
		)

//Smuggler's satchel
/obj/item/storage/backpack/satchel/flat
	name = "\improper Smuggler's satchel"
	desc = "A very slim satchel, that can easily fit into tight spaces."
	icon_state = "satchel-flat"
	item_state = "satchel-norm"
	level = 1
	w_class = ITEM_SIZE_NORMAL //Can fit in backpacks itself.
	storage_slots = 5
	max_w_class = ITEM_SIZE_NORMAL
	max_storage_space = 15
	cant_hold = list(/obj/item/storage/backpack/satchel/flat) //muh recursive backpacks
	startswith = list(
		/obj/item/stack/tile/floor,
		/obj/item/crowbar
		)

/obj/item/storage/backpack/satchel/flat/MouseDrop(var/obj/over_object)
	var/turf/T = get_turf(src)
	if(hides_under_flooring() && isturf(T) && !T.is_plating())
		return
	..()

/obj/item/storage/backpack/satchel/flat/hide(var/i)
	set_invisibility(i ? 101 : 0)
	anchored = i ? TRUE : FALSE
	alpha = i ? 128 : initial(alpha)

/obj/item/storage/backpack/satchel/flat/attackby(obj/item/W, mob/user)
	var/turf/T = get_turf(src)
	if(hides_under_flooring() && isturf(T) && !T.is_plating())
		to_chat(user, "<span class='warning'>You must remove the plating first.</span>")
		return 1
	return ..()

//ERT backpacks.
/obj/item/storage/backpack/ert
	name = "emergency response team backpack"
	desc = "A spacious backpack with lots of pockets, used by members of the Emergency Response Team."
	icon_state = "ert_commander"
	item_state_slots = list(
		slot_l_hand_str = "securitypack",
		slot_r_hand_str = "securitypack",
		)

//Commander
/obj/item/storage/backpack/ert/commander
	name = "emergency response team commander backpack"
	desc = "A spacious backpack with lots of pockets, worn by the commander of an Emergency Response Team."

//Security
/obj/item/storage/backpack/ert/security
	name = "emergency response team security backpack"
	desc = "A spacious backpack with lots of pockets, worn by security members of an Emergency Response Team."
	icon_state = "ert_security"

//Engineering
/obj/item/storage/backpack/ert/engineer
	name = "emergency response team engineer backpack"
	desc = "A spacious backpack with lots of pockets, worn by engineering members of an Emergency Response Team."
	icon_state = "ert_engineering"

//Medical
/obj/item/storage/backpack/ert/medical
	name = "emergency response team corpsman backpack"
	desc = "A spacious backpack with lots of pockets, worn by the corpsmen of an Emergency Response Team."
	icon_state = "ert_medical"

/*
 * Messenger Bags
 */

/obj/item/storage/backpack/messenger
	name = "messenger bag"
	desc = "A small, sturdy backpack, worn over one shoulder."
	icon_state = "courierbag"

/obj/item/storage/backpack/messenger/chem
	name = "pharmacy messenger bag"
	desc = "A small, sterile backpack, worn over one shoulder. This one was designed to hold beakers, pill bottles, and other reagent containers."
	icon_state = "courierbagchem"

/obj/item/storage/backpack/messenger/med
	name = "medical messenger bag"
	desc = "A small, sterile backpack worn over one shoulder. This one was designed for use in the sterile confines of the infirmary."
	icon_state = "courierbagmed"

/obj/item/storage/backpack/messenger/viro
	name = "virology messenger bag"
	desc = "A small, sterile backpack worn over one shoulder. This one was designed for work in areas with a biosafety classification level."
	icon_state = "courierbagviro"

/obj/item/storage/backpack/messenger/tox
	name = "science messenger bag"
	desc = "A small, stain-resistant backpack worn over one shoulder. This one was modeled for use in laboratories and other scientific settings."
	icon_state = "courierbagnt"

/obj/item/storage/backpack/messenger/com
	name = "command messenger bag"
	desc = "A small backpack worn over one shoulder. This one was made specifically for senior officers."
	icon_state = "courierbagcom"

/obj/item/storage/backpack/messenger/engi
	name = "industrial messenger bag"
	desc = "A small, tough backpack worn over one shoulder. This one was designed for industrial work."
	icon_state = "courierbagengi"

/obj/item/storage/backpack/messenger/hyd
	name = "hydroponics messenger bag"
	desc = "A small backpack worn over one shoulder. This one was designed for plant-related work."
	icon_state = "courierbaghyd"

/obj/item/storage/backpack/messenger/sec
	name = "security messenger bag"
	desc = "A small, tactical backpack worn over one shoulder."
	icon_state = "courierbagsec"

/obj/item/storage/backpack/messenger/sec/exo
	name = "corporate security messenger bag"
	desc = "A small, tactical backpack worn over one shoulder. This one is in EXO colors."
	icon_state = "courierbagsec_exo"
