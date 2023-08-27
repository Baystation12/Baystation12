/obj/item/pen/crayon
	name = "crayon"
	desc = "A colourful crayon. Please refrain from eating it or putting it in your nose."
	icon = 'icons/obj/crayons.dmi'
	icon_state = "crayonred"
	w_class = ITEM_SIZE_TINY
	attack_verb = list("attacked", "coloured")
	colour = "#ff0000" //RGB
	color_description = "red crayon"
	iscrayon = TRUE

	var/shadeColour = "#220000" //RGB
	var/uses = 30 //0 for unlimited uses
	var/instant = 0
	var/colourName = "red" //for updateIcon purposes
	var/crayon_reagent = /datum/reagent/crayon_dust

/obj/item/pen/crayon/Initialize()
	name = "[colourName] crayon"
	. = ..()
	create_reagents(10)
	reagents.add_reagent(crayon_reagent, 10)
