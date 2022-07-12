/obj/item/pickaxe/xeno
	name = "master xenoarch pickaxe"
	desc = "A miniature excavation tool for precise digging."
	icon = 'icons/obj/xenoarchaeology.dmi'
	item_state = "xenoarch_pick"
	force = 3
	throwforce = 0
	attack_verb = list("stabbed", "jabbed", "spiked", "attacked")
	matter = list(MATERIAL_STEEL = 75)
	w_class = ITEM_SIZE_SMALL
	drill_verb = "delicately picking"
	digspeed = 20
	excavation_amount = 0
	sharp = TRUE

/obj/item/pickaxe/xeno/examine(mob/user)
	. = ..()
	to_chat(user, "This tool has a [excavation_amount] centimeter excavation depth.")

/obj/item/pickaxe/xeno/brush
	name = "wire brush"
	icon_state = "pick_brush"
	slot_flags = SLOT_EARS
	force = 1
	attack_verb = list("prodded", "attacked")
	desc = "A polymer-handled brush with thick metallic wires for clearing away dust and loose scree."
	excavation_amount = 1
	drill_sound = 'sound/weapons/thudswoosh.ogg'
	drill_verb = "brushing"
	sharp = FALSE

/obj/item/pickaxe/xeno/one_pick
	name = "2cm pick"
	icon_state = "pick1"
	excavation_amount = 2
	drill_sound = 'sound/items/Screwdriver.ogg'

/obj/item/pickaxe/xeno/two_pick
	name = "4cm pick"
	icon_state = "pick2"
	excavation_amount = 4
	drill_sound = 'sound/items/Screwdriver.ogg'

/obj/item/pickaxe/xeno/three_pick
	name = "6cm pick"
	icon_state = "pick3"
	excavation_amount = 6
	drill_sound = 'sound/items/Screwdriver.ogg'

/obj/item/pickaxe/xeno/four_pick
	name = "8cm pick"
	icon_state = "pick4"
	excavation_amount = 8
	drill_sound = 'sound/items/Screwdriver.ogg'

/obj/item/pickaxe/xeno/five_pick
	name = "10cm pick"
	icon_state = "pick5"
	excavation_amount = 10
	drill_sound = 'sound/items/Screwdriver.ogg'

/obj/item/pickaxe/xeno/six_pick
	name = "12cm pick"
	icon_state = "pick6"
	excavation_amount = 12

/obj/item/pickaxe/xeno/hand
	name = "hand pickaxe"
	icon_state = "pick_hand"
	item_state = "pickaxe"
	digspeed = 30
	desc = "A smaller, more precise version of the pickaxe."
	excavation_amount = 30
	drill_sound = 'sound/items/Crowbar.ogg'
	drill_verb = "clearing"
	matter = list(MATERIAL_STEEL = 150)
	w_class = ITEM_SIZE_NORMAL
	force = 6
	throwforce = 3

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// Adjustable drills from research work

/obj/item/pickaxe/xeno/drill
	name = "excavation drill"
	icon_state = "pick_drill1"
	item_state = "xenoarch_device"
	digspeed = 15
	desc = "A miniature excavation tool for precise digging, equipped with an adjustable drill tip. Not recommended for dental work."
	excavation_amount = 1
	drill_sound = 'sound/items/jaws_pry.ogg'
	drill_verb = "carefully drilling"
	origin_tech = list(TECH_MATERIAL = 4, TECH_ENGINEERING = 5)
	matter = list(MATERIAL_STEEL = 2000, MATERIAL_GLASS = 700, MATERIAL_ALUMINIUM = 250)
	w_class = ITEM_SIZE_NORMAL
	force = 12
	throwforce = 6
	var/max_depth = 15

/obj/item/pickaxe/xeno/drill/attack_self(mob/user)
	var/depth = round(input("Input the desired depth.", "Set Depth", excavation_amount) as num | null)
	if (isnull(depth))
		return
	if(depth>max_depth || depth<1)
		to_chat(user, SPAN_WARNING("Invalid depth, input a number from 1 to [max_depth]."))
		return
	excavation_amount = depth
	to_chat(user, SPAN_NOTICE("You set the depth to [depth]cm."))
	playsound(loc, 'sound/items/Screwdriver.ogg', 40)
	update_icon()

/obj/item/pickaxe/xeno/drill/on_update_icon()
	if (excavation_amount <6)
		icon_state = "pick_drill1"
	else if (excavation_amount >=6 && excavation_amount <11)
		icon_state = "pick_drill2"
	else
		icon_state = "pick_drill3"

/obj/item/pickaxe/xeno/drill/examine(mob/user)
	. = ..()
	to_chat(user, SPAN_NOTICE("This tool can have its excavation depth adjusted up to [max_depth]cm."))

/obj/item/pickaxe/xeno/drill/plasma
	name = "excavation plasma torch"
	icon_state = "pick_cutter1"
	item_state = "xenoarch_device"
	digspeed = 5
	desc = "A phoron fueled, high emission plasma emitter the size of a small handgun with its own laser cleaning protocols. Perfect for excavations, or cutting limbs off really small xenos."
	excavation_amount = 1
	drill_sound = 'sound/weapons/plasma_cutter.ogg'
	drill_verb = "carefully cutting"
	origin_tech = list(TECH_MATERIAL = 4, TECH_PHORON = 4, TECH_ENGINEERING = 6, TECH_BLUESPACE = 2)
	matter = list(MATERIAL_STEEL = 1800, MATERIAL_GLASS = 1000, MATERIAL_ALUMINIUM = 500)
	w_class = ITEM_SIZE_NORMAL
	force = 12
	throwforce = 6
	max_depth = 50
	sharp = FALSE

/obj/item/pickaxe/xeno/drill/plasma/attack_self(mob/user)
	var/depth = round(input("Input the desired depth.", "Set Depth", excavation_amount) as num | null)
	if(depth>max_depth || depth<1)
		to_chat(user, SPAN_WARNING("Invalid depth, input a number from 1 to [max_depth]."))
		return
	excavation_amount = depth
	to_chat(user, SPAN_NOTICE("You set the depth to [depth]cm."))
	playsound(loc, 'sound/weapons/armbomb.ogg', 40)
	update_icon()

/obj/item/pickaxe/xeno/drill/plasma/on_update_icon()
	if (excavation_amount <11)
		icon_state = "pick_cutter1"
	else if (excavation_amount >=11 && excavation_amount <21)
		icon_state = "pick_cutter2"
	else if (excavation_amount >=21 && excavation_amount <31)
		icon_state = "pick_cutter3"
	else if (excavation_amount >=31 && excavation_amount <41)
		icon_state = "pick_cutter4"
	else
		icon_state = "pick_cutter5"

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// Pack for holding pickaxes

/obj/item/storage/excavation
	name = "excavation pick set"
	icon = 'icons/obj/storage.dmi'
	icon_state = "excavation"
	item_state = "utility"
	desc = "A rugged metal case containing a set of standardized picks used in archaeological digs."
	origin_tech = list(TECH_MATERIAL = 3, TECH_ENGINEERING = 2)
	matter = list(MATERIAL_STEEL = 700)
	item_state = "syringe_kit"
	storage_slots = 7
	slot_flags = SLOT_BELT
	w_class = ITEM_SIZE_NORMAL
	can_hold = list(/obj/item/pickaxe/xeno)
	max_storage_space = 18
	max_w_class = ITEM_SIZE_NORMAL
	use_to_pickup = 1
	startswith = list(
		/obj/item/pickaxe/xeno/brush,
		/obj/item/pickaxe/xeno/one_pick,
		/obj/item/pickaxe/xeno/two_pick,
		/obj/item/pickaxe/xeno/three_pick,
		/obj/item/pickaxe/xeno/four_pick,
		/obj/item/pickaxe/xeno/five_pick,
		/obj/item/pickaxe/xeno/six_pick)

/obj/item/storage/excavation/handle_item_insertion()
	..()
	sort_picks()

/obj/item/storage/excavation/proc/sort_picks()
	var/list/obj/item/pickaxe/xeno/picksToSort = list()
	for(var/obj/item/pickaxe/xeno/P in src)
		picksToSort += P
		P.loc = null
	while(picksToSort.len)
		var/min = 200 // No pick is bigger than 200
		var/selected = 0
		for(var/i = 1 to picksToSort.len)
			var/obj/item/pickaxe/xeno/current = picksToSort[i]
			if(current.excavation_amount <= min)
				selected = i
				min = current.excavation_amount
		var/obj/item/pickaxe/xeno/smallest = picksToSort[selected]
		smallest.loc = src
		picksToSort -= smallest
	prepare_ui()
