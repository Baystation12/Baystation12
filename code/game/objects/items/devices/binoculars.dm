/obj/item/device/binoculars

	name = "binoculars"
	desc = "A pair of binoculars."
	zoomdevicename = "eyepieces"
	icon = 'icons/obj/binoculars.dmi'
	icon_state = "binoculars"
	matter = list(MATERIAL_ALUMINIUM = 300,MATERIAL_GLASS = 60)

	obj_flags = OBJ_FLAG_CONDUCTIBLE
	force = 5.0
	w_class = ITEM_SIZE_SMALL
	throwforce = 5.0
	throw_range = 15
	throw_speed = 3


/obj/item/device/binoculars/attack_self(mob/user)
	if(zoom)
		unzoom(user)
	else
		zoom(user)
