/obj/item/modular_computer/pda
	name = "\improper PDA"
	desc = "A very compact computer, designed to keep its user always connected."
	icon = 'icons/obj/modular_pda.dmi'
	icon_state = "pda"
	icon_state_unpowered = "pda"
	hardware_flag = PROGRAM_PDA
	max_hardware_size = 1
	w_class = ITEM_SIZE_SMALL
	light_strength = 2
	slot_flags = SLOT_ID | SLOT_BELT
	stores_pen = TRUE
	stored_pen = /obj/item/pen/retractable
	interact_sounds = list('sound/machines/pda_click.ogg')
	interact_sound_volume = 20

/obj/item/modular_computer/pda/Initialize()
	. = ..()
	enable_computer()

/obj/item/modular_computer/pda/CtrlClick(mob/user)
	if(!isturf(loc)) ///If we are dragging the PDA across the ground we don't want to remove the pen
		remove_pen(user)
	else
		. = ..()

/obj/item/modular_computer/pda/AltClick(var/mob/user)
	if(!CanPhysicallyInteract(user))
		return
	if(card_slot && istype(card_slot.stored_card))
		card_slot.eject_id(user)
	else
		..()

// PDA box
/obj/item/storage/box/PDAs
	name = "box of spare PDAs"
	desc = "A box of spare PDA microcomputers."
	icon = 'icons/obj/pda.dmi'
	icon_state = "pdabox"

/obj/item/storage/box/PDAs/Initialize()
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

/obj/item/modular_computer/pda/chemistry
	icon_state = "pda-m"
	icon_state_unpowered = "pda-m"

/obj/item/modular_computer/pda/engineering
	icon_state = "pda-e"
	icon_state_unpowered = "pda-e"

/obj/item/modular_computer/pda/security
	icon_state = "pda-s"
	icon_state_unpowered = "pda-s"

/obj/item/modular_computer/pda/forensics
	icon_state = "pda-s"
	icon_state_unpowered = "pda-s"

/obj/item/modular_computer/pda/science
	icon_state = "pda-nt"
	icon_state_unpowered = "pda-nt"

/obj/item/modular_computer/pda/heads
	name = "command PDA"
	icon_state = "pda-h"
	icon_state_unpowered = "pda-h"

/obj/item/modular_computer/pda/heads/paperpusher
	stored_pen = /obj/item/pen/fancy

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

/obj/item/modular_computer/pda/mining
	icon_state = "pda-nt"
	icon_state_unpowered = "pda-nt"

/obj/item/modular_computer/pda/syndicate
	icon_state = "pda-syn"
	icon_state_unpowered = "pda-syn"

/obj/item/modular_computer/pda/roboticist
	icon_state = "pda-robot"
	icon_state_unpowered = "pda-robot"