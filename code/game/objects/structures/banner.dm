/obj/structure/banner
	name = "religious banner"
	desc = "A banner used to contain religious symbols."
	anchored = TRUE
	density = FALSE
	var/rolled = TRUE
	var/static/banner_type = list(
		"blank" = "no symbol"
		, "crucifix" = "the cross, a symbol of Christianity"
		, "starofdavid" = "the Star of David, a symbol of Judaism"
		, "crescentandstar" = "the crescent and star, a symbol of Islam"
		, "aum" = "the Aum, a symbol of Hinduism"
		, "khanda" = "the Khanda, a symbol of Sikhism"
		, "ninepointedstar" = "the nine-pointed star, a symbol of the Baha'i Faith"
		, "dharmachakra" = "the dharmachakra, a symbol of Buddhism"
		, "redandblackstar" = "the red and black star, a symbol of the Quakers"
		, "pentacle" = "the pentacle, a symbol of Wicca"
		, "awen" = "the Awen, a symbol of Druidry"
		, "ahimsa" = "the Ahimsa, a symbol of Jainism"
		, "yinandyang" = "the yin and yang, a symbol of Taoism"
		, "torii" = "the torii, a symbol of Shinto"
		, "lhossek" = "the Lhossek skull, a symbol of the Grand Stratagem, an Unathi faith"
		, "threearrows" = "the Three Arrows, a symbol of the Fruitful Lights, an Unathi faith"
		, "bushroot" = "the Hrukhza bush root, a symbol of the Hand of the Vine, an Unathi faith"
		, "sundial" = "the sundial, a symbol of Precursor worship, an Unathi faith"
		, "cupofknowledge" = "the Cup of Knowledge, a symbol of Markesheli, an Unathi faith"
	)
	icon = 'icons/obj/banner.dmi'
	icon_state = "blank_up"
	var/selected = "blank"

/obj/structure/banner/on_update_icon()
	icon_state = "[selected]_[rolled ? "up" : "down"]"

/obj/structure/banner/verb/toggle()
	set src in oview(1)
	set category = "Object"
	set name = "Toggle Banner"

	if (usr.stat || usr.restrained())
		return

	rolled = !rolled
	to_chat(usr, "You roll [rolled ? "up" : "down"] \the [src].")

	update_icon()

/obj/structure/banner/attack_hand(mob/user)
	if (!istype(user.mind.assigned_job, /datum/job/chaplain))
		to_chat(user, SPAN_WARNING("Only the Chaplain can change the banner!"))
	else
		var/banner = input(user, "Pick a symbol:") as null | anything in banner_type
		if (!banner)
			return
		if (user.stat || !Adjacent(user) || user.restrained())
			to_chat(user, SPAN_WARNING("You're in no condition to change \the [src]."))
			return
		selected = banner

		update_icon()

/obj/structure/banner/examine(mob/user)
	. = ..()
	to_chat(user, "It displays [banner_type[selected]].")

/obj/structure/banner/get_mechanics_info()
	. = ..()
	. += "<p>A Chaplain can change the banner's display by clicking on it with an empty hand. Only characters that joined the round as a chaplain can do this.</p>"
	. += "<p>The banner can be rolled up or unfurled by using the 'Toggle Banner' verb in the Object tab or the right-click menu while adjacent to the banner.</p>"