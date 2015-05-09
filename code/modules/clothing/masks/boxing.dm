/obj/item/clothing/mask/balaclava
	name = "balaclava"
	desc = "LOADSAMONEY"
	icon_state = "balaclava"
	item_state = "balaclava"
	flags = BLOCKHAIR
	flags_inv = HIDEFACE
	body_parts_covered = FACE
	w_class = 2
	sprite_sheets = list(
		"Tajara" = 'icons/mob/species/tajaran/mask.dmi',
		"Unathi" = 'icons/mob/species/unathi/mask.dmi',
		)

/obj/item/clothing/mask/balaclava/tactical
	name = "green balaclava"
	desc = "Designed to both hide identities and keep your face comfy and warm."
	icon_state = "swatclava"
	item_state = "balaclava"
	flags = BLOCKHAIR
	flags_inv = HIDEFACE
	w_class = 2
	sprite_sheets = list(
		"Tajara" = 'icons/mob/species/tajaran/mask.dmi',
		"Unathi" = 'icons/mob/species/unathi/mask.dmi',
		)

/obj/item/clothing/mask/luchador
	name = "Luchador Mask"
	desc = "Worn by robust fighters, flying high to defeat their foes!"
	icon_state = "luchag"
	item_state = "luchag"
	flags = BLOCKHAIR
	flags_inv = HIDEFACE
	body_parts_covered = HEAD|FACE
	w_class = 2
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