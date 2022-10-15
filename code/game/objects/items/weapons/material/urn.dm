/obj/item/material/urn
	name = "urn"
	desc = "A vase used to store the ashes of the deceased."
	icon = 'icons/obj/urn.dmi'
	icon_state = "urn"
	max_force = 5
	applies_material_colour = TRUE
	w_class = ITEM_SIZE_SMALL
	default_material = MATERIAL_WOOD

/obj/item/material/urn/afterattack(obj/A, mob/user, proximity)
	if(!istype(A, /obj/effect/decal/cleanable/ash))
		return ..()
	else if(proximity)
		if(contents.len)
			to_chat(user, SPAN_WARNING("\The [src] is already full!"))
			return
		user.visible_message("\The [user] scoops \the [A] into \the [src], securing the lid.", "You scoop \the [A] into \the [src], securing the lid.")
		A.forceMove(src)

/obj/item/material/urn/attack_self(mob/user)
	if(!contents.len)
		to_chat(user, SPAN_WARNING("\The [src] is empty!"))
		return
	else
		for(var/obj/effect/decal/cleanable/ash/A in contents)
			A.dropInto(loc)
			user.visible_message("\The [user] pours \the [A] out from \the [src].", "You pour \the [A] out from \the [src].")

/obj/item/material/urn/examine(mob/user)
	. = ..()
	if(contents.len)
		to_chat(user, "\The [src] is full.")
