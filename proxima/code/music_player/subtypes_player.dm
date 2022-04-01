//from infinity
// Radio player
/obj/item/music_player/radio
	name = "radio station"
	desc = "An old radio box. In the past people used them for listening to radio stations and communication between radio amateurs. \
	In future there's still an enthusiasts who like to repair and modify old electronics. For example this one may play music disks."
	icon_state = "radio"
	item_state = "radio"

/obj/item/music_player/radio/custom_tape
	tape = /obj/item/music_tape/custom

// Cassett player
/obj/item/music_player/csplayer
	name = "cassette player"
	desc = "An ordinary cassette player model FN-16, he looks old and worn in some places."
	icon_state = "csplayer_empty"
	item_state = "device"
	tape = /obj/item/music_tape/custom

	slot_flags = SLOT_BELT

/obj/item/music_player/csplayer/on_update_icon()
	if(tape && (mode == (1 || 2)))
		icon_state = "csplayer_on"
	else if(tape)
		icon_state = "csplayer_loaded"
	else
		icon_state = "csplayer_empty"

/obj/item/music_player/radio/csplayer
	tape = /obj/item/music_tape/custom

// Boombox
/obj/item/music_player/boombox
	name = "boombox"
	desc = "Old-fashioned portable media player, also known as boombox, or ghettobox. Looks very robust, just like most part of old-fashioned things."
	icon_state = "boombox"
	item_state = "boombox"
	tape = /obj/item/music_tape/custom

	item_icons = list(
		slot_l_hand_str = 'sprites/onmob_lefthand.dmi',
		slot_r_hand_str = 'sprites/onmob_righthand.dmi',
		slot_back_str = 'sprites/onmob_back.dmi',
		)

	//slot_flags = SLOT_BACK // Ладно, злыдни, но вы мне печеньку должны и десять пат патов. Искренних.
	w_class = ITEM_SIZE_LARGE

	throwforce = 10
	throw_speed = 2
	throw_range = 10
	force = 10

/obj/item/music_player/boombox/custom_tape
	tape = /obj/item/music_tape/custom

// This one for debug pruporses
// I'll yell on you if you will use it in game without good reason >:(
/obj/item/music_player/debug
	name = "typ3n4m3-cl4ss: CRUSH/ZER0"
	icon_state = "console"
	tape = /obj/item/music_tape/custom
