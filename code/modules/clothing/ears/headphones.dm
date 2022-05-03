/obj/item/clothing/ears/headphones
	name = "headphones"
	desc = "It's probably not in accordance with company policy to listen to music on the job... but fuck it."
	icon_state = "headphones_off"
	item_state = "headphones_off"
	slot_flags = SLOT_EARS | SLOT_TWOEARS
	volume_multiplier = 0.5
	var/jukebox/jukebox


/obj/item/clothing/ears/headphones/Initialize()
	. = ..()
	var/ui_name = pick("Sandhouse", "Booze", "Boom & Olaf", "Jumble", "Sonnie", "Sonic-Technical")
	ui_name += " [pick("Headphones", "Monitors", "Skullshakers", "Brain Jigglers", "Sonic Dewaxers")]"
	jukebox = new(src, "boombox.tmpl", ui_name, 400, 150)
	jukebox.range = 0


/obj/item/clothing/ears/headphones/Destroy()
	QDEL_NULL(jukebox)
	. = ..()


/obj/item/clothing/ears/headphones/attack_self(mob/user)
	jukebox.ui_interact(user)


/obj/item/clothing/ears/headphones/MouseDrop(mob/user)
	jukebox.ui_interact(user)


/obj/item/clothing/ears/headphones/on_update_icon()
	if (jukebox.playing)
		icon_state = "headphones_on"
		item_state = "headphones_on"
	else
		icon_state = "headphones_off"
		item_state = "headphones_off"
	update_clothing_icon()
	