/obj/item/weapon/delabeler
	name = "Delabeler"
	icon = 'icons/obj/bureaucracy.dmi'
	icon_state = "delabeler"
	item_state = "Delabeler"

/obj/item/weapon/delabeler/afterattack(obj/item/item, mob/user as mob, proximity)
	if(!proximity) return
	if(item == loc)
		return
	if(istype(item, /obj/item/weapon/reagent_containers/glass))
		user << "<span class='notice'>[item.name] couldn't possibly have a label.</span>"
		return
	if(istype(item, /obj/item))
		if (item.name == item.defaultName)
			user << "<span class='notice'>[item.name] is not labeled.</span>"
			return
		else
			user.visible_message("<span class='notice'>[user] scrapes all labels off [item].</span>", \
				"<span class='notice'>You scrape all labels off [item].</span>")
			item.name = "[item.defaultName]"