// **********************
// Other harvested materials from plants (that are not food)
// **********************

/obj/item/bananapeel
	name = "banana peel"
	desc = "A peel from a banana."
	icon = 'icons/obj/items.dmi'
	icon_state = "banana_peel"
	item_state = "banana_peel"
	w_class = ITEM_SIZE_SMALL
	throwforce = 0
	throw_speed = 4
	throw_range = 20

/obj/item/carvable
	name = "master carvable item"
	desc = "you should not see this."
	var/list/allow_tool_types = list(
		/obj/item/material/knife,
		/obj/item/material/hatchet,
		/obj/item/circular_saw
	)
	var/carve_time = 5 SECONDS
	var/result_type = null

/obj/item/carvable/attackby(obj/item/W, mob/user)
	..()
	if (result_type && is_type_in_list(W, allow_tool_types))
		user.visible_message(
			SPAN_ITALIC("\The [user] starts to carve \the [src] with \a [W]."),
			blind_message = SPAN_ITALIC("You can hear quiet scraping."),
			range = 5
		)
		if (!do_after(user, carve_time, src))
			to_chat(user, SPAN_ITALIC("You stop carving \the [src]."))
			return
		var/result = new result_type()
		user.put_in_hands(result)
		user.visible_message(
			SPAN_ITALIC("\The [user] finishes carving \a [result]."),
			range = 5
		)
		qdel(src)

/obj/item/carvable/corncob
	name = "corn cob"
	desc = "A reminder of meals gone by."
	icon = 'icons/obj/trash.dmi'
	icon_state = "corncob"
	item_state = "corncob"
	w_class = ITEM_SIZE_SMALL
	throwforce = 0
	throw_speed = 4
	throw_range = 20
	result_type = /obj/item/clothing/mask/smokable/pipe/cobpipe

/obj/item/carvable/corncob/hollowpineapple
	name = "hollow pineapple"
	icon_state = "hollowpineapple"
	item_state = "hollowpineapple"
	result_type = /obj/item/reagent_containers/food/drinks/glass2/pineapple

/obj/item/carvable/corncob/hollowcoconut
	name = "hollow coconut"
	icon_state = "hollowcoconut"
	item_state = "hollowcoconut"
	result_type = /obj/item/reagent_containers/food/drinks/glass2/coconut
