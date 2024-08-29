/obj/item/clothing/accessory/wristwatch
	name = "black wrist watch"
	desc = "A sleek timekeeping device. Its nylon strap fits snugly on the wrist."
	icon_state = "wristwatch_black"
	body_location = HANDS


/obj/item/clothing/accessory/wristwatch/examine(mob/user, distance)
	. = ..()
	if (distance > 1)
		return
	var/list/date = text2numlist(stationdate2text(), "-")
	var/year = date[1]
	var/month = GLOB.month_names[date[2]]
	var/day = date[3]
	var/time = stationtime2text()
	to_chat(user, "You check \the [src]. It is [time] on the [day]\th of [month], [year].")


/obj/item/clothing/accessory/wristwatch/OnTopic(mob/user, list/href_list)
	if (href_list["check_watch"])
		if (istype(user))
			examinate(user, src)
			return TOPIC_HANDLED


/obj/item/clothing/accessory/wristwatch/leather
	name = "leather wrist watch"
	desc = "A rugged timekeeping device. Its leather strap is quite fashionable."
	icon_state = "wristwatch_leather"


/obj/item/clothing/accessory/wristwatch/fancy
	name = "fancy wrist watch"
	desc = "A gaudy timekeeping device. It probably cost more than your education."
	icon_state = "wristwatch_fancy"
