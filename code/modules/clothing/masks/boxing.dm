/obj/item/clothing/mask/balaclava
	name = "balaclava"
	desc = "Designed to both hide identities and keep your face comfy and warm."
	icon_state = "balaclava"
	item_state = "balaclava"
	flags_inv = HIDEFACE|BLOCKHAIR|HIDEEARS
	body_parts_covered = FACE|HEAD
	down_body_parts_covered = HEAD
	down_flags_inv = BLOCKHEADHAIR
	down_icon_state = "balaclava_r"
	pull_mask = 1
	w_class = ITEM_SIZE_SMALL
	sprite_sheets = list(
		SPECIES_UNATHI = 'icons/mob/species/unathi/onmob_mask_unathi.dmi',
		)

/obj/item/clothing/mask/balaclava/tactical
	name = "green balaclava"
	icon_state = "swatclava"
	down_icon_state = "swatclava_r"

/obj/item/clothing/mask/luchador
	name = "Luchador Mask"
	desc = "Worn by robust fighters, flying high to defeat their foes!"
	icon_state = "luchag"
	item_state = "luchag"
	flags_inv = HIDEFACE|BLOCKHAIR|HIDEEARS
	body_parts_covered = HEAD|FACE
	w_class = ITEM_SIZE_SMALL
	siemens_coefficient = 3.0

/obj/item/clothing/mask/luchador/tecnicos
	name = "Tecnicos Mask"
	desc = "Worn by robust fighters who uphold justice and fight honorably."
	icon_state = "luchador"
	item_state = "luchador"

/obj/item/clothing/mask/luchador/rudos
	name = "Rudos Mask"
	desc = "Worn by robust fighters who are willing to do anything to win."
	icon_state = "luchar"
	item_state = "luchar"

/obj/item/clothing/mask/luchador/pendragon
	name = "Pendragon Mask"
	desc = "This mask looks very harmless and typical for any carnival, but a glance at it can give you other not-so-harmless ideas for its usage."
	icon_state = "vibeway1"
	item_state = "vibeway1"
	flags_inv = HIDEFACE|HIDEEARS
	body_parts_covered = HEAD|FACE
	w_class = ITEM_SIZE_SMALL

/obj/item/clothing/mask/luchador/pendragon/rope
	name = "Rope Mask"
	icon_state = "vibeway2"
	item_state = "vibeway2"

/obj/item/clothing/mask/luchador/pendragon/cat
	name = "Cat Mask"
	icon_state = "vibeway3"
	item_state = "vibeway3"

/obj/item/clothing/mask/luchador/pendragon/houston
	name = "Houston Mask"
	icon_state = "vibeway4"
	item_state = "vibeway4"
