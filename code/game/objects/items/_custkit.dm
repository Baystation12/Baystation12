/obj/item/custkit
	name = "customization kit"
	desc = "This is OOC object, you should not see it. Ударьте этот подарок предметом, который нужно изменить."
	icon = 'icons/obj/items.dmi'
	icon_state = "gift2"
	w_class = ITEM_SIZE_SMALL
	var/can_unkit = 0 // is we can get all back 1
	var/_is_unkit = 0
	var/unkit_icon
	var/unkit_icon_state
	var/input
	var/output
	var/delay_time = 0
	var/delay = 30 SECONDS
	var/list/sides
	var/list/revsides
	trade_blacklisted = TRUE

/obj/item/custkit/New()
	..()
	unkit_icon = unkit_icon ? unkit_icon : icon
	unkit_icon_state = unkit_icon_state ? unkit_icon_state : icon_state
	sides = list(input, output)
	revsides = list(output, input)

/obj/item/custkit/proc/trans()
	switch(_is_unkit)
		if (TRUE)
			name = initial(name)
			icon = initial(icon)
			icon_state = initial(icon_state)
		if (FALSE)
			name = "customization unkit"
			icon = unkit_icon
			icon_state = unkit_icon_state

	_is_unkit = !_is_unkit

/obj/item/custkit/attackby(obj/item/I, mob/user, params)
	var/delta = TimeOfGame - delay_time
	if(delta <= delay)
		to_chat(user, SPAN_WARNING("You must wait [seconds_to_readable(round((delay - delta)/10, 1))] until can use it again!"))
		return

	var/mod = (can_unkit&&_is_unkit)+1
	if(istype(I, sides[mod]))
		qdel(I)
		var/nw = revsides[mod]
		user.put_in_hands(new nw)
		if(!can_unkit)
			return qdel(src)
		trans()
		delay_time = TimeOfGame

/obj/item/custkit/sprite //changes sprite, doesn't mades new obj
	name = "sprite customization kit"
	var/sprite

/obj/item/custkit/sprite/inherit_custom_item_data(datum/custom_item/citem)
	name = citem.item_name
	desc = citem.item_desc
	input = text2path(citem.additional_data["itemtype"])
	can_unkit = citem.additional_data["can_unkit"] ? TRUE : FALSE
	sprite = citem.item_icon_state

/obj/item/custkit/sprite/attackby(obj/item/I, mob/user, params)
	var/delta = TimeOfGame - delay_time
	if(delta <= delay)
		to_chat(user, SPAN_WARNING("You must wait [seconds_to_readable(round((delay - delta)/10, 1))] until can use it again!"))
		return

	if(istype(I, input))
		switch(_is_unkit)
			if (TRUE)
				I.icon = initial(I.icon)
				I.icon_state = initial(I.icon_state)
			if (FALSE)
				I.icon = CUSTOM_ITEM_OBJ //we can add a new var in future for a better icons managment
				I.icon_state = sprite
		_is_unkit = !_is_unkit
		delay_time = TimeOfGame
		if(!can_unkit)
			qdel(src)
