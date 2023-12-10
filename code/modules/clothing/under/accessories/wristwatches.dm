/obj/item/clothing/accessory/wristwatch
	name = "black wrist watch"
	desc = "A sleek timekeeping device. Its nylon strap fits snugly on the wrist."
	icon_state = "wristwatch_black"
	body_location = HANDS


/obj/item/clothing/accessory/wristwatch/leather
	name = "leather wrist watch"
	desc = "A rugged timekeeping device. Its leather strap is quite fashionable."
	icon_state = "wristwatch_leather"


/obj/item/clothing/accessory/wristwatch/fancy
	name = "fancy wrist watch"
	desc = "A gaudy timekeeping device. It probably cost more than your education."
	icon_state = "wristwatch_fancy"


/obj/item/clothing/accessory/wristwatch/examine(mob/user, distance)
	. = ..()
	if (distance <= 1)
		CheckTime(user)


/obj/item/clothing/accessory/wristwatch/proc/CheckTime(mob/user)
	var/extra_days = round(station_time_in_ticks / (1 DAY)) DAYS
	var/timeofday = world.timeofday + extra_days
	to_chat(user, "You check \the [src]. The time is [stationtime2text()] on the [time2text(timeofday, "DD")]\th of [time2text(timeofday, "Month")], [GLOB.using_map.game_year].")


/obj/item/clothing/accessory/wristwatch/OnTopic(mob/user, list/href_list)
	if(href_list["check_watch"])
		if(istype(user))
			examinate(user, src)
			return TOPIC_HANDLED
