/obj/item/weapon/forensics/slide
	name = "microscope slide"
	desc = "A pair of thin glass panes used in the examination of samples beneath a microscope."
	icon_state = "slide"
	var/obj/item/weapon/forensics/swab/has_swab
	var/obj/item/weapon/sample/fibers/has_sample

/obj/item/weapon/forensics/slide/attackby(var/obj/item/weapon/W, var/mob/user)
	if(has_swab || has_sample)
		user << "<span class='warning'>There is already a sample in the slide.</span>"
		return
	if(istype (W, /obj/item/weapon/forensics/swab))
		has_swab = W
	else if(istype(W, /obj/item/weapon/sample/fibers))
		has_sample = W
	else
		user << "<span class='warning'>You don't think this will fit.</span>"
		return
	user << "<span class='notice'>You insert the sample into the slide.</span>"
	user.unEquip(W)
	W.forceMove(src)
	update_icon()

/obj/item/weapon/forensics/slide/attack_self(var/mob/user)
	if(has_swab || has_sample)
		user << "<span class='notice'>You remove \the sample from \the [src].</span>"
		if(has_swab)
			has_swab.loc = get_turf(src)
			has_swab = null
		if(has_sample)
			has_sample.forceMove(get_turf(src))
			has_sample = null
		update_icon()
		return

/obj/item/weapon/forensics/slide/update_icon()
	if(!has_swab && !has_sample)
		icon_state = "slide"
	else if(has_swab)
		icon_state = "slideswab"
	else if(has_sample)
		icon_state = "slidefiber"
