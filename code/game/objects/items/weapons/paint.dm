/*
	Paint buckets
*/

//var/global/list/cached_icons = list()

/obj/item/weapon/reagent_containers/glass/paint
	name = "paint bucket"
	desc = "It's a paint bucket."
	icon = 'icons/obj/items.dmi'
	icon_state = "paint_neutral"
	item_state = "paintcan"
	m_amt = 200
	g_amt = 0
	w_class = 2.0
	amount_per_transfer_from_this = 10
	possible_transfer_amounts = list(10,20,30,50,70)
	volume = 70
	flags = FPRINT | OPENCONTAINER
	var/paint_type
	var/paintcolor = "#75510E"

	New()
		..()
		if(paint_type && lentext(paint_type) > 0)
			name = paint_type + " " + name
			icon_state = "paint_"+paint_type
		var/colorlist = new/list("color" = paintcolor)
		reagents.add_reagent("paint", volume, colorlist)

/obj/item/weapon/reagent_containers/glass/paint/red
	paint_type = "red"
	paintcolor = "#FE191A"

/obj/item/weapon/reagent_containers/glass/paint/green
	paint_type = "green"
	paintcolor = "#18A31A"

/obj/item/weapon/reagent_containers/glass/paint/blue
	paint_type = "blue"
	paintcolor = "#247CFF"

/obj/item/weapon/reagent_containers/glass/paint/violet
	paint_type = "violet"
	paintcolor = "#CC0099"

/obj/item/weapon/reagent_containers/glass/paint/yellow
	paint_type = "yellow"
	paintcolor = "#FDFE7D"

/obj/item/weapon/reagent_containers/glass/paint/white
	paint_type = "white"
	paintcolor = "#F0F8FF"

/obj/item/weapon/reagent_containers/glass/paint/black
	paint_type = "black"
	paintcolor = "#333333"
