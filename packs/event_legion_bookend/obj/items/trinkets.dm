/obj/item/material/coin/northstar
	default_material = MATERIAL_SILVER
	icon = 'packs/event_legion_bookend/icons/northstar_trinket.dmi'
	icon_state = "c_coin"

	name = "maxim's token"
	desc = "A silver coin denoting your visit, call, or service aboard the Maxim Interplanar Layover station - coloquially dubbed as 'Northstar' by the Solar Assembly, and 'Krasnyy-Balise' by the Gilgameshi."

/obj/item/northstar_photo
	icon = 'packs/event_legion_bookend/icons/northstar_trinket.dmi'
	icon_state = "photo"

	name = "maxim photograph"
	desc = "A well-laminated photograph depicting the station, with Maxim's World in the background. Often given to those visiting, calling-to or serving aboard the Maxim Interplanar Layover station at E-14b. On the back, is etched; 'A beacon. Always, forever.'."

/obj/item/northstar_medal
	name = "expeditionary conflict medal"
	desc = "A medal wrought from iron and silver. A unit award generally given to groups, ships and departments, denoting service for the Solar Assembly under duress, outside of her borders."
	icon = 'packs/event_legion_bookend/icons/northstar_trinket.dmi'
	icon_state = "medal"

	w_class = ITEM_SIZE_SMALL

/obj/item/storage/medalbox/northstar
	desc = "A small aluminum box for holding decorations, adorned with gold-on-blue ribbons."
	icon_state = "medalbox_sol"

	w_class = ITEM_SIZE_SMALL

	startswith = list(
		/obj/item/northstar_medal
	)
