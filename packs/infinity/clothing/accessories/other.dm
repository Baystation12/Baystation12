/obj/item/clothing/accessory/storage/bandolier/armory/Initialize()
	. = ..()

	for(var/i = 0, i < slots, i++)
		new /obj/item/ammo_casing/shotgun/pellet(src)

//Sprites from tgstation, specially for Parasoul's custom-item
/obj/item/clothing/accessory/necklace/talisman
	name = "bone talisman"
	desc = "A hunter's talisman, some say the old gods smile on those who wear it."
	icon = CUSTOM_ITEM_OBJ
	accessory_icons = list(slot_w_uniform_str = CUSTOM_ITEM_MOB, slot_wear_suit_str = CUSTOM_ITEM_MOB)
	item_icons = list(slot_wear_mask_str = 'infinity/icons/mob/onmob/onmob_accessories.dmi')
	icon_state = "talisman-4"

/obj/item/clothing/accessory/scarf/inf
	name = "red striped scarf"
	icon = 'packs/infinity/icons/obj/clothing/obj_accessories.dmi'
	icon_state = "stripedredscarf"
	accessory_icons = list(slot_w_uniform_str = 'infinity/icons/mob/onmob/onmob_accessories.dmi', slot_wear_suit_str = 'infinity/icons/mob/onmob/onmob_accessories.dmi')
	item_icons = list(slot_wear_mask_str = 'infinity/icons/mob/onmob/onmob_accessories.dmi')

/obj/item/clothing/accessory/scarf/inf/green
	name = "green striped scarf"
	icon_state = "stripedgreenscarf"

/obj/item/clothing/accessory/scarf/inf/blue
	name = "blue striped scarf"
	icon_state = "stripedbluescarf"

/obj/item/clothing/accessory/scarf/inf/zebra
	name = "zebra scarf"
	icon_state = "zebrascarf"

/obj/item/clothing/accessory/scarf/inf/christmas
	name = "christmas scarf"
	icon_state = "christmasscarf"

/obj/item/clothing/accessory/scarf/tajaran
	name = "tua-tari scarf"
	desc = "A light and soft scarf, very long and wide. You also may rise it to hide your person..."
	icon = 'packs/infinity/icons/obj/clothing/obj_accessories.dmi'
	icon_state = "tajneck"
	accessory_icons = list(slot_w_uniform_str = 'infinity/icons/mob/onmob/onmob_accessories.dmi', slot_wear_suit_str = 'infinity/icons/mob/onmob/onmob_accessories.dmi')
	item_icons = list(slot_wear_mask_str = 'infinity/icons/mob/onmob/onmob_accessories.dmi')
	body_parts_covered = 0
	item_flags = ITEM_FLAG_FLEXIBLEMATERIAL
	species_restricted = list(SPECIES_TAJARA)
	slot_flags = SLOT_MASK | SLOT_TIE
	var/lowered_icon_state = "tajneck"
	var/rised_icon_state = "tajmask"

/obj/item/clothing/accessory/scarf/tajaran/attack_self(mob/user)
	if(body_parts_covered >= FACE)
		body_parts_covered &= ~FACE
		icon_state = lowered_icon_state
		to_chat(user, SPAN_NOTICE("You lowered your scarf."))
	else
		body_parts_covered |= FACE
		icon_state = rised_icon_state
		to_chat(user, SPAN_NOTICE("You rised your scarf. Let's rrrobe someone!"))

/obj/item/clothing/accessory/amulet
	name = "talisman"
	desc = "A simple metal amulet with runes, according to the primitive beliefs of Tajara, able to protect them from evil spirits."
	icon_state = "taj_amulet"
	icon = 'packs/infinity/icons/obj/clothing/obj_accessories.dmi'
	w_class = ITEM_SIZE_SMALL
	slot_flags = SLOT_MASK | SLOT_TIE

/* todo
Сделать, чтобы блокировало мелкое воздействие - чтение мыслей, слабое лечение. Сейчас оно высасывае псионику \
со своего тайла - можно контрить псиоников, удерживая.
/obj/item/clothing/accessory/amulet/disrupts_psionics()
	visible_message("<span class='rose'>The [src] protect his owner but explodes.</span>")
	playsound(src.loc, 'sound/effects/glass_step.ogg', 100, 1, -4)
	QDEL_IN(src, 0)
	return src
*/

/obj/item/clothing/accessory/amulet/medium
	name = "amulet"
	desc = "An expensive-looking amulet, interspersed with unknown crystals and runes, according to the primitive beliefs of Tajara, able to protect them from evil spirits."
	icon_state = "taj_amulet_2"

/* todo
/obj/item/clothing/accessory/amulet/medium/disrupts_psionics()
	if(prob(20))
		visible_message("<span class='rose'>The [src] protect his owner but explodes.</span>")
		playsound(src.loc, 'sound/effects/glass_step.ogg', 100, 1, -4)
		QDEL_IN(src, 0)
	return src
*/

/obj/item/clothing/accessory/amulet/strong
	name = "averter"
	desc = "Amulet of Tajara, created from the primordial stone according to their belief, able to protect according to their primitive religion from evil spirits and their servants. The runes on the amulet are etched with acid."
	icon_state = "taj_amulet_3"

/* todo
/obj/item/clothing/accessory/amulet/strong/disrupts_psionics()
	visible_message("<span class='rose'>The [src] radiated faint waves of heat and light, protecting the wearer from psionic influence...</span>")
	if(prob(0.01))
		visible_message("<span class='rose'>The [src] protect his owner but explodes.</span>")
		playsound(src.loc, 'sound/effects/glass_step.ogg', 100, 1, -4)
		QDEL_IN(src, 0)
	return src
*/
