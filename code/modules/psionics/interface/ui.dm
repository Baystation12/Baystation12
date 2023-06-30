/obj/screen/psi
	icon = 'icons/screen/psi.dmi'
	var/mob/living/owner
	var/hidden = TRUE

/obj/screen/psi/Initialize(mapload)
	. = ..()
	owner = loc
	loc = null
	update_icon()

/obj/screen/psi/Destroy()
	if(owner && owner.client)
		owner.client.screen -= src
	. = ..()

/obj/screen/psi/on_update_icon()
	if(hidden)
		invisibility = INVISIBILITY_ABSTRACT
	else
		invisibility = 0
