/obj/item/bone
	icon = 'icons/obj/structures/butchery.dmi'
	var/bone_amt = 1
	var/obj/item/carve_product


/obj/item/bone/use_tool(obj/item/tool, mob/living/user, list/click_params)
	if (carve_product && is_sharp(tool))
		if (!isturf(loc))
			to_chat(user, SPAN_WARNING("You must put \the [src] down before carving it."))
			return TRUE
		user.visible_message(
			SPAN_ITALIC("\The [user] begins carving \a [src] with \a [tool]."),
			SPAN_ITALIC("You begin carving \the [src] into \a [initial(carve_product.name)] with \the [tool]."),
			range = 5
		)
		if (!do_after(user, 10 SECONDS, src))
			return TRUE
		user.visible_message(
			SPAN_ITALIC("\The [user] finishes carving \a [src] into \a [initial(carve_product.name)]."),
			SPAN_ITALIC("You finish carving \the [src]."),
			range = 5
		)
		new carve_product (loc)
		qdel(src)
		return TRUE

	return ..()


/obj/item/bone/skull
	name = "skull"
	desc = "Looks like someone lost their head."
	bone_amt = 3


/obj/item/bone/skull/deer
	name = "deer skull"
	icon_state = "deer_skull"
	carve_product = /obj/item/clothing/head/skull/deer


/obj/item/clothing/head/skull
	abstract_type = /obj/item/clothing/head/skull
	w_class = ITEM_SIZE_NORMAL
	light_overlay = null
	flags_inv = HIDEFACE | HIDEEYES | CLOTHING_BULKY
	siemens_coefficient = 0.1
	equip_delay = 2 SECONDS
	body_parts_covered = FULL_HEAD
	armor = list(
		melee = ARMOR_MELEE_SMALL,
		laser = ARMOR_LASER_MINOR,
		energy = ARMOR_ENERGY_SMALL
	)

	var/obj/item/device/flashlight/pen/eyeglow_source


/obj/item/clothing/head/skull/Destroy()
	QDEL_NULL(eyeglow_source)
	return ..()


/obj/item/clothing/head/skull/use_tool(obj/item/tool, mob/living/user, list/click_params)
	if (light_overlay && !eyeglow_source && istype(tool, /obj/item/device/flashlight/pen))
		if (!user.unEquip(tool, src))
			return
		user.visible_message(
			SPAN_ITALIC("\The [user] fits \a [tool] into \a [src]."),
			SPAN_ITALIC("You fit \the [tool] into \the [src]."),
			range = 5
		)
		eyeglow_source = tool
		on = eyeglow_source.on
		update_icon()
		return
	return ..()


/obj/item/clothing/head/skull/on_update_icon()
	update_clothing_icon()
	..()


/obj/item/clothing/head/skull/ui_action_click(mob/living/user)
	if (!eyeglow_source)
		to_chat(user, SPAN_WARNING("\The [src] has no pen light."))
		return
	on = !on
	if (eyeglow_source.activation_sound)
		playsound(get_turf(src), eyeglow_source.activation_sound, 33, TRUE)
	update_icon()


/obj/item/clothing/head/skull/attack_self(mob/living/user)
	if (eyeglow_source)
		eyeglow_source.dropInto(get_turf(src))
		user.put_in_hands(eyeglow_source)
		eyeglow_source = null
		update_icon()
		return
	..()


/obj/item/clothing/head/skull/deer
	name = "carved deer skull"
	icon = 'icons/obj/structures/butchery.dmi'
	icon_state = "deer_skull"
	light_overlay = "deer_skull"
	action_button_name = "Toggle Deer Skull"


/obj/item/clothing/head/skull/deer/prepared/Initialize()
	. = ..()
	eyeglow_source = new (src)
