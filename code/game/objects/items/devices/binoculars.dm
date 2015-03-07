/obj/item/device/binoculars

	name = "binoculars"
	desc = "A pair of binoculars."
	icon_state = "binoculars"

	flags = CONDUCT
	force = 5.0
	w_class = 2.0
	throwforce = 5.0
	throw_range = 15
	throw_speed = 3

	//matter = list("metal" = 50,"glass" = 50)


/obj/item/device/binoculars/attack_self(mob/user)
	zoom()
