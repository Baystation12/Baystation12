/obj/item/towel
	name = "towel"
	icon = 'icons/obj/weapons/other.dmi'
	icon_state = "towel"
	item_flags = ITEM_FLAG_IS_BELT | ITEM_FLAG_WASHER_ALLOWED
	slot_flags = SLOT_HEAD | SLOT_BELT | SLOT_OCLOTHING
	force = 0.5
	w_class = ITEM_SIZE_NORMAL
	attack_verb = list("whipped")
	hitsound = 'sound/weapons/towelwhip.ogg'
	desc = "A soft cotton towel."

/obj/item/towel/equipped(mob/user, slot)
	switch(slot)
		if(slot_head)
			sprite_sheets = list(
				SPECIES_VOX = 'icons/mob/species/vox/onmob_head_vox.dmi',
				SPECIES_UNATHI = 'icons/mob/species/unathi/onmob_head_unathi.dmi',
				SPECIES_NABBER = 'icons/mob/species/nabber/onmob_head_gas.dmi'
				)
		if(slot_belt)
			sprite_sheets = list()
		if(slot_wear_suit)
			sprite_sheets = list(
				SPECIES_VOX = 'icons/mob/species/vox/onmob_suit_vox.dmi',
				SPECIES_UNATHI = 'icons/mob/species/unathi/onmob_suit_unathi.dmi',
				SPECIES_NABBER = 'icons/mob/species/nabber/onmob_suit_gas.dmi'
				)
	return ..()

/obj/item/towel/attack_self(mob/living/user as mob)
	user.visible_message(SPAN_NOTICE("[user] uses [src] to towel themselves off."))
	playsound(user, 'sound/weapons/towelwipe.ogg', 25, 1)

/obj/item/towel/random/New()
	..()
	color = get_random_colour()

/obj/item/towel/fleece // loot from the king of goats. it's a golden towel
	name = "golden fleece"
	desc = "The legendary Golden Fleece of Jason made real."
	color = "#ffd700"
	force = 1
	attack_verb = list("smote")
