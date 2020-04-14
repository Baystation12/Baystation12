
///////Vampire132978123\\\\\\\

//Skirmisher

/obj/item/clothing/head/helmet/kigyar/skirmisher/donator/vampire
	name = "Pirate's Hat"
	desc = "A worn, probably stolen, pirate hat. Looks like it belongs in a theater."
	icon = 'code/modules/halo/covenant/species/tvoan/skirm_clothing.dmi'
	icon_state = "piratehat_obj"
	item_state = "piratehat"
	species_restricted = list("Tvaoan Kig-Yar")

/obj/item/clothing/suit/armor/special/skirmisher/donator/vampire
	name = "Worn Coat"
	desc = "A coat that is rumored to be owned by a legendary pirate, though some say it was stolen from a cargo vessel by a humanoid bird."
	icon = 'code/modules/halo/covenant/species/tvoan/skirm_clothing.dmi'
	icon_state = "piratecoat_obj"
	item_state = "piratecoat"
	sprite_sheets = list("Tvaoan Kig-Yar" = 'code/modules/halo/covenant/species/tvoan/skirm_clothing.dmi')
	species_restricted = list("Tvaoan Kig-Yar")
	body_parts_covered = ARMS|UPPER_TORSO|LOWER_TORSO
	flags_inv = HIDEGLOVES|HIDESHOES|HIDEJUMPSUIT|HIDETAIL

/obj/item/toy/plushie/donator/vampire
	name = "Rafaj"
	desc = "A pirate's best friend, and most prized possession. It looks like it's been through many adventures. Squeeze to activate an internal speaker."
	icon = 'code/modules/halo/covenant/species/tvoan/Skirmisher_inhand.dmi'
	icon_state = "parrot_obj"
	item_state = "parrot"
	slot_flags = SLOT_POCKET | SLOT_BELT | SLOT_BACK | SLOT_EARS
	var/next_sound = 0
	var/play_music = 0
	var/list/sound_music = list(\
	'code/modules/halo/sounds/rafaj_donor/music_1.ogg' = 162 SECONDS,
	'code/modules/halo/sounds/rafaj_donor/music_2.ogg' = 127 SECONDS
	)
	var/list/sound_voice = list(\
	'code/modules/halo/sounds/rafaj_donor/voiceline_1.ogg',
	'code/modules/halo/sounds/rafaj_donor/voiceline_2.ogg',
	'code/modules/halo/sounds/rafaj_donor/voiceline_3.ogg',
	'code/modules/halo/sounds/rafaj_donor/voiceline_4.ogg',
	'code/modules/halo/sounds/rafaj_donor/voiceline_5.ogg',
	'code/modules/halo/sounds/rafaj_donor/voiceline_6.ogg',
	'code/modules/halo/sounds/rafaj_donor/voiceline_7.ogg'
	)

/obj/item/toy/plushie/donator/vampire/verb/toggle_soundtype()
	set name = "Toggle Speaker Type"
	set category = "Object"

	if(!istype(usr,/mob/living))
		return
	play_music = !play_music
	to_chat(usr,"<span class = 'notice'>You toggle [src] to [play_music ? "play music" : "play voice lines"].</span>")

/obj/item/toy/plushie/donator/vampire/attack_self(var/mob/user)
	if(sound_voice.len > 0)
		var/list/l_use = sound_voice
		if(play_music)
			if(sound_music.len == 0 || world.time < next_sound)
				return
			l_use = sound_music
		var/sfx_play = pick(l_use)
		if(play_music)
			next_sound = world.time + l_use[sfx_play]
		playsound(user, sfx_play , 100)

/obj/item/weapon/storage/box/large/donator/vampire
	startswith = list(/obj/item/clothing/head/helmet/kigyar/skirmisher/donator/vampire,
					/obj/item/clothing/suit/armor/special/skirmisher/donator/vampire,
					/obj/item/toy/plushie/donator/vampire
					)
	can_hold = list(/obj/item/clothing/head/helmet/kigyar/skirmisher/donator/vampire,
					/obj/item/clothing/suit/armor/special/skirmisher/donator/vampire,
					/obj/item/toy/plushie/donator/vampire
					)

/decl/hierarchy/outfit/vampire_kigyar
	name = "vampire - kig-yar"
	suit = /obj/item/clothing/suit/armor/special/skirmisher/donator/vampire
	suit_store = /obj/item/toy/plushie/donator/vampire
	head = /obj/item/clothing/head/helmet/kigyar/skirmisher/donator/vampire
