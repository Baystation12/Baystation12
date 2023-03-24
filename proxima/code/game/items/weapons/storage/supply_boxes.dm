/obj/item/storage/fancy/supply_box
	icon = 'proxima/icons/obj/supply_boxes.dmi'
	icon_state = "mre_box"
	name = "MRE box (5x)"
	desc = "A box for a certain type of item."
	storage_slots = 5
	max_w_class = ITEM_SIZE_NORMAL
	w_class = ITEM_SIZE_NORMAL
	matter = list(MATERIAL_STEEL = 2000)
	origin_tech = list(TECH_MATERIAL = 2)

	key_type = /obj/item/storage/mre
	can_hold = list(/obj/item/storage/mre)

	startswith = list(/obj/item/storage/mre = 5)

	var/can_be_welded = 1
	var/welded = 0
	var/image/overlay

/obj/item/storage/fancy/supply_box/attackby(obj/item/W, mob/user)
	if((isWelder(W)) && (!opened) && (can_be_welded))
		var/obj/item/weldingtool/weld = W
		if(!weld.remove_fuel(0,user))
			to_chat(user, SPAN_NOTICE("Your [W.name] doesn't have enough fuel."))
			return
		playsound(src, 'sound/items/Welder.ogg', 50, 1)
		user.visible_message(SPAN_WARNING("\The [user] begins welding \the [src] [welded ? "open" : "closed"]!"),
							SPAN_NOTICE("You begin welding \the [src] [welded ? "open" : "closed"]."))
		if(do_after(usr, (rand(3,5)) SECONDS, src, DO_DEFAULT | DO_USER_UNIQUE_ACT | DO_PUBLIC_PROGRESS))
			playsound(src, 'sound/items/Welder2.ogg', 50, 1)
			welded = !welded
			overlay = image(icon, icon_state = "welded_overlay")
			update_icon()
			return
		else
			to_chat(user, SPAN_NOTICE("You must remain still to complete this task."))
			return
	else if(isWelder(W))
		to_chat(user, SPAN_WARNING("This box is already open or cannot be welded at all."))
		return

	if((isCrowbar(W)) && (!opened) && (!welded))
		visible_message(SPAN_NOTICE("[usr] starts to open up the [src]."))
		if(do_after(usr, (rand(2,4)) SECONDS, src, DO_SHOW_PROGRESS | DO_PUBLIC_PROGRESS | DO_BAR_OVER_USER))
			opened = 1
			visible_message(SPAN_NOTICE("[usr] opens the [src]."))
			playsound(src, 'sound/items/Crowbar.ogg', 100, 1)
			update_icon()
			return
		else
			to_chat(user, SPAN_NOTICE("You must remain still to complete this task."))
			return
	else if(isCrowbar(W) && (welded))
		to_chat(user, SPAN_WARNING("The box is welded and cannot be opened. First try to unweld it."))
		return

	if(opened)
		. = ..() //When open work like ordinary fancy storage. Same with commands below
	else
		to_chat(usr, SPAN_WARNING("You need a crowbar to open this box."))
		return

/obj/item/storage/fancy/supply_box/MouseDrop(obj/over_object as obj)
	if(opened)
		. = ..()
	else
		to_chat(usr, SPAN_WARNING("You need a crowbar to open this box."))
		return

/obj/item/storage/fancy/supply_box/AltClick(mob/usr)
	if(opened)
		. = ..()
	else
		to_chat(usr, SPAN_WARNING("You need a crowbar to open this box."))
		return

/obj/item/storage/fancy/supply_box/attack_hand(mob/user as mob)
	if(opened)
		. = ..()
	else
		usr.put_in_active_hand(src)

/obj/item/storage/fancy/supply_box/examine(mob/user, distance)
    . = ..()
    if((distance < 4) && (welded))
        to_chat(usr, SPAN_NOTICE("You notice that this box is welded."))
        return

/obj/item/storage/fancy/supply_box/on_update_icon()
	. = ..()
	if((welded) && (overlay))
		src.overlays += overlay
	else
		src.overlays -= overlay

	overlay = null

/* OTHER TYPES OF
   SUPPLY BOXES    */

/obj/item/storage/fancy/supply_box/cell
	icon_state = "cell_box"
	name = "cell box (5x)"

	key_type = /obj/item/cell
	can_hold = list(/obj/item/cell)

	startswith = list(/obj/item/cell/high = 5)

	can_be_welded = 0

/obj/item/storage/fancy/supply_box/flare
	icon_state = "flare_box"
	name = "flare box (8x)"
	storage_slots = 8

	key_type = /obj/item/device/flashlight/flare
	can_hold = list(/obj/item/device/flashlight/flare)

	startswith = list(/obj/item/device/flashlight/flare = 8)

/obj/item/storage/fancy/supply_box/water
	icon_state = "water_box"
	name = "water box (7x)"
	storage_slots = 7

	key_type = /obj/item/reagent_containers/food/drinks/cans/waterbottle
	can_hold = list(/obj/item/reagent_containers/food/drinks/cans/waterbottle)

	startswith = list(/obj/item/reagent_containers/food/drinks/cans/waterbottle = 7)

/obj/item/storage/fancy/supply_box/flashlight
	icon_state = "flashlight_box"
	name = "flashlight box (6x)"
	storage_slots = 6

	key_type = /obj/item/device/flashlight
	can_hold = list(/obj/item/device/flashlight)

	startswith = list(/obj/item/device/flashlight = 6)

/obj/item/storage/fancy/supply_box/grenade
	icon_state = "m67_box"
	name = "frag grenade box (5x)"

	key_type = /obj/item/grenade/frag
	can_hold = list(/obj/item/grenade/frag)

	startswith = list(/obj/item/grenade/frag = 5)

/obj/item/storage/fancy/supply_box/lightgrenade
	icon_state = "lightgrenade_box"
	name = "light grenade box (6x)"

	key_type = /obj/item/grenade/light
	can_hold = list(/obj/item/grenade/light)

	startswith = list(/obj/item/grenade/light = 6)

/obj/item/storage/fancy/supply_box/bumaga
	icon_state = "bumaga_box"
	name = "toilet paper box (5x)"

	key_type = /obj/item/taperoll/bog
	can_hold = list(/obj/item/taperoll/bog)

	startswith = list(/obj/item/taperoll/bog = 5)
