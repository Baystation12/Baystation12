/obj/item/weapon/buzzer
	name = "buzzer"
	desc = "A very annoying buzzer."
	icon = 'icons/obj/items.dmi'
	icon_state = "buzzton"
	item_state = "buzzton"
	throwforce = 3
	w_class = ITEM_SIZE_SMALL
	throw_speed = 3
	throw_range = 15
	var/spam_flag = 0
	var/audio_files = list("sound/machines/buzz-two.ogg")

/obj/item/weapon/buzzer/attack_self(mob/user as mob)
	if (spam_flag == 0)
		spam_flag = 1
		playsound(src.loc, pick(src.audio_files), 50, 1)
		src.add_fingerprint(user)
		spawn(15)
			spam_flag = 0
	return