/obj/item/modular_computer/tablet
	name = "tablet computer"
	desc = "A small, portable microcomputer."
	icon = 'icons/obj/modular_tablet.dmi'
	icon_state = "tablet"
	icon_state_unpowered = "tablet"

	hardware_flag = PROGRAM_TABLET
	max_hardware_size = 1
	w_class = ITEM_SIZE_SMALL
	light_strength = 5 // same as PDAs

	interact_sounds = list('sound/machines/pda_click.ogg')
	interact_sound_volume = 20

/obj/item/modular_computer/tablet/lease
	desc = "A small, portable microcomputer. This one has a gold and blue stripe, and a serial number stamped into the case."
	icon_state = "tabletsol"
	icon_state_unpowered = "tabletsol"
