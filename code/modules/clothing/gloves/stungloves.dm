/obj/item/clothing/gloves/attackby(obj/item/weapon/W, mob/user)
	if(istype(src, /obj/item/clothing/gloves/boxing))			//quick fix for stunglove overlay not working nicely with boxing gloves.
		user << "<span class='notice'>That won't work.</span>"	//i'm not putting my lips on that!
		..()
		return
	
	//add wires
	if(istype(W, /obj/item/stack/cable_coil))
		var/obj/item/stack/cable_coil/C = W
		if (clipped)
			user << "<span class='notice'>The [src] are too badly mangled for wiring.</span>"
			return
		
		if(wired)
			user << "<span class='notice'>The [src] are already wired.</span>"
			return
			
		if(C.amount < 2)
			user << "<span class='notice'>There is not enough wire to cover the [src].</span>"
			return
			
		C.use(2)
		wired = 1
		siemens_coefficient = 3.0
		user << "<span class='notice'>You wrap some wires around the [src].</span>"
		update_icon()
		return
	
	//add cell
	else if(istype(W, /obj/item/weapon/cell))
		if(!wired)
			user << "<span class='notice'>The [src] need to be wired first.</span>"
		else if(!cell)
			user.drop_item()
			W.loc = src
			cell = W
			user << "<span class='notice'>You attach the [cell] to the [src].</span>"
			update_icon()
		else
			user << "<span class='notice'>A [cell] is already attached to the [src].</span>"
		return

	else if(istype(W, /obj/item/weapon/wirecutters) || istype(W, /obj/item/weapon/scalpel))

		//stunglove stuff
		if(cell)
			cell.updateicon()
			user << "<span class='notice'>You cut the [cell] away from the [src].</span>"
			cell.loc = get_turf(src.loc)
			cell = null
			update_icon()
			return
		if(wired) //wires disappear into the void because fuck that shit
			wired = 0
			siemens_coefficient = initial(siemens_coefficient)
			user << "<span class='notice'>You cut the wires away from the [src].</span>"
			update_icon()
			return
		
		//clipping fingertips
		if(!clipped)
			playsound(src.loc, 'sound/items/Wirecutter.ogg', 100, 1)
			user.visible_message("\red [user] cuts the fingertips off of the [src].","\red You cut the fingertips off of the [src].")
			
			clipped = 1
			name = "mangled [name]"
			desc = "[desc]<br>They have had the fingertips cut off of them."
			if("exclude" in species_restricted)
				species_restricted -= "Unathi"
				species_restricted -= "Tajaran"
			return
		else
			user << "<span class='notice'>The [src] have already been clipped!</span>"
			update_icon()
			return
		
		return
		
	..()

/obj/item/clothing/gloves/update_icon()
	..()
	overlays.Cut()
	if(wired)
		overlays += "gloves_wire"
	if(cell)
		overlays += "gloves_cell"
