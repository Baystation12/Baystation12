/obj/item/modular_computer/pda
	name = "\improper PDA"
	desc = "A very compact computer designed to keep its user always connected."
	icon = 'icons/obj/modular_pda.dmi'
	icon_state = "pda"
	icon_state_unpowered = "pda"
	hardware_flag = PROGRAM_PDA
	max_hardware_size = 1
	modifiable = FALSE
	w_class = ITEM_SIZE_SMALL
	light_strength = 5
	slot_flags = SLOT_ID | SLOT_BELT

	var/obj/item/weapon/card/id/stored_id
	var/obj/item/weapon/pen/stored_pen = /obj/item/weapon/pen

/obj/item/modular_computer/pda/Initialize()
	. = ..()

	if(ispath(stored_pen))
		stored_pen = new stored_pen(src)

	update_name()

/obj/item/modular_computer/pda/verb/remove_pen()
	set name = "Remove Pen"
	set category = "Object"
	set src in view(1)

	if(usr.incapacitated() || !istype(usr, /mob/living))
		to_chat(usr, "<span class='warning'>You can't do that.</span>")
		return

	if(!Adjacent(usr))
		to_chat(usr, "<span class='warning'>You can't reach it.</span>")
		return

	if(istype(stored_pen))
		to_chat(usr, "<span class='notice'>You remove [stored_pen] from [src].</span>")
		usr.put_in_hands(stored_pen)
		stored_pen = null
		update_verbs()

/obj/item/modular_computer/pda/verb/remove_id()
	set name = "Remove ID"
	set category = "Object"
	set src in view(1)

	if(usr.incapacitated() || !istype(usr, /mob/living))
		to_chat(usr, "<span class='warning'>You can't do that.</span>")
		return

	if(!Adjacent(usr))
		to_chat(usr, "<span class='warning'>You can't reach it.</span>")
		return

	if(istype(stored_id))
		to_chat(usr, "<span class='notice'>You remove [stored_id] from [src].</span>")
		usr.put_in_hands(stored_id)
		stored_id = null
		update_verbs()

/obj/item/modular_computer/pda/update_verbs()
	..()

	if(istype(stored_id))
		verbs |= /obj/item/modular_computer/pda/verb/remove_id
	if(istype(stored_pen))
		verbs |= /obj/item/modular_computer/pda/verb/remove_pen

/obj/item/modular_computer/pda/proc/update_name()
	var/obj/item/weapon/card/id/id
	if(istype(stored_id))
		id = stored_id
	else
		var/mob/living/L = get_holder_of_type(src, /mob/living)
		if(istype(L) && L.GetIdCard())
			id = L.GetIdCard()
		else
			return

	SetName("[id.get_display_name()]'s PDA")

/obj/item/modular_computer/pda/attackby(var/obj/item/weapon/W as obj, var/mob/user as mob)
	if(istype(W, /obj/item/weapon/card/id))
		if(istype(stored_id))
			to_chat(user, "<span class='notice'>There is already a card in [src].</span>")
			return
		user.drop_from_inventory(W)
		stored_id = W
		W.forceMove(src)
		update_verbs()
		to_chat(user, "<span class='notice'>You insert [W] into [src].</span>")
		update_name()
	else if(istype(W, /obj/item/weapon/pen))
		if(istype(stored_pen))
			to_chat(user, "<span class='notice'>There is already a pen in [src].</span>")
			return
		user.drop_from_inventory(W)
		stored_pen = W
		W.forceMove(src)
		update_verbs()
		to_chat(user, "<span class='notice'>You insert [W] into [src].</span>")
	else
		..()

/obj/item/modular_computer/pda/GetIdCard()
	if(istype(stored_id))
		return stored_id

// PDA box
/obj/item/weapon/storage/box/PDAs
	name = "box of spare PDAs"
	desc = "A box of spare PDA microcomputers."
	icon = 'icons/obj/pda.dmi'
	icon_state = "pdabox"

/obj/item/weapon/storage/box/PDAs/Initialize()
	. = ..()

	new /obj/item/modular_computer/pda(src)
	new /obj/item/modular_computer/pda(src)
	new /obj/item/modular_computer/pda(src)
	new /obj/item/modular_computer/pda(src)
	new /obj/item/modular_computer/pda(src)

// PDA types
/obj/item/modular_computer/pda/medical
	icon_state = "pda-m"
	icon_state_unpowered = "pda-m"

/obj/item/modular_computer/pda/engineering
	icon_state = "pda-e"
	icon_state_unpowered = "pda-e"

/obj/item/modular_computer/pda/security
	icon_state = "pda-s"
	icon_state_unpowered = "pda-s"

/obj/item/modular_computer/pda/science
	icon_state = "pda-nt"
	icon_state_unpowered = "pda-nt"

/obj/item/modular_computer/pda/heads
	icon_state = "pda-h"
	icon_state_unpowered = "pda-h"

/obj/item/modular_computer/pda/heads/paperpusher
	stored_pen = /obj/item/weapon/pen/fancy

/obj/item/modular_computer/pda/heads/hop
	icon_state = "pda-hop"
	icon_state_unpowered = "pda-hop"

/obj/item/modular_computer/pda/heads/hos
	icon_state = "pda-hos"
	icon_state_unpowered = "pda-hos"

/obj/item/modular_computer/pda/heads/ce
	icon_state = "pda-ce"
	icon_state_unpowered = "pda-ce"

/obj/item/modular_computer/pda/heads/cmo
	icon_state = "pda-cmo"
	icon_state_unpowered = "pda-cmo"

/obj/item/modular_computer/pda/heads/rd
	icon_state = "pda-rd"
	icon_state_unpowered = "pda-rd"

/obj/item/modular_computer/pda/captain
	icon_state = "pda-c"
	icon_state_unpowered = "pda-c"

/obj/item/modular_computer/pda/ert
	icon_state = "pda-h"
	icon_state_unpowered = "pda-h"

/obj/item/modular_computer/pda/cargo
	icon_state = "pda-sup"
	icon_state_unpowered = "pda-sup"

/obj/item/modular_computer/pda/syndicate
	icon_state = "pda-syn"
	icon_state_unpowered = "pda-syn"

/obj/item/modular_computer/pda/roboticist
	icon_state = "pda-robot"
	icon_state_unpowered = "pda-robot"