/obj/item/flag
	name = "flag"
	desc = "A generic flag."
	var/boxed = 1

/obj/item/flag/on_update_icon()
	icon_state = "[initial(icon_state)][boxed ? "" : "-boxed"]"
	boxed = !boxed

/obj/item/flag/attack_self(mob/user)
	to_chat(user, SPAN_NOTICE("You [boxed ? "unbox" : "box"] [src]."))
	update_icon()