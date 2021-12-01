/obj/item/custkit
	name = "customization kit"
	desc = "This is OOC object, you should not see it. Ударьте этот подарок предметом, который нужно изменить."
	icon = 'icons/obj/items.dmi'
	icon_state = "gift2"
	w_class = ITEM_SIZE_SMALL
	var/can_unkit = 0 // is we can get all back 1
	var/is_unkit = 0
	var/unkit_icon
	var/unkit_icon_state
	var/input
	var/output
	var/delay_time = 0
	var/delay = 30 SECONDS
	trade_blacklisted = TRUE

/obj/item/custkit/New()
	..()
	unkit_icon = unkit_icon ? unkit_icon : icon
	unkit_icon_state = unkit_icon_state ? unkit_icon_state : icon_state


/obj/item/custkit/proc/trans()
	if(is_unkit)
		name = initial(name)
		icon = initial(icon)
		icon_state = initial(icon_state)
		is_unkit = 0
	else
		name = "customization unkit"
		icon = unkit_icon
		icon_state = unkit_icon_state
		is_unkit = 1

/obj/item/custkit/attackby(obj/item/I, mob/user, params)
	var/delta = TimeOfGame - delay_time
	if(delta <= delay)
		to_chat(user, SPAN_WARNING("You must wait [seconds_to_readable(round((delay - delta)/10, 1))] until can use it again!"))
		return
	var/t = is_unkit ? output : input
	var/k = is_unkit ? input : output
	if(istype(I, t))
		qdel(I)
		user.put_in_hands(new k)
		if(can_unkit)
			trans()
		else
			qdel(src)
		delay_time = TimeOfGame

/obj/item/custkit/sprite //changes sprite, doesn't mades new obj
	name = "sprite customization kit"

/obj/item/custkit/sprite/inherit_custom_item_data(datum/custom_item/citem)
	name = citem.item_name
	desc = citem.item_desc
	input = citem.item_path
	output = citem.item_icon_state

/obj/item/custkit/sprite/attackby(obj/item/I, mob/user, params)
	if(istype(I, input))
		I.icon = CUSTOM_ITEM_OBJ //we can add a new var in future for a better icons managment
		I.icon_state = output
		qdel(src)
