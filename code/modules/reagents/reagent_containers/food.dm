////////////////////////////////////////////////////////////////////////////////
/// Food.
////////////////////////////////////////////////////////////////////////////////
/obj/item/weapon/reagent_containers/food
	possible_transfer_amounts = null
	volume = 50 //Sets the default container amount for all food items.
	var/filling_color = "#FFFFFF" //Used by sandwiches.

	var/list/center_of_mass = newlist() //Center of mass

/obj/item/weapon/reagent_containers/food/New()
	..()
	if (!pixel_x && !pixel_y)
		src.pixel_x = rand(-6.0, 6) //Randomizes postion
		src.pixel_y = rand(-6.0, 6)

/obj/item/weapon/reagent_containers/food/afterattack(atom/A, mob/user, proximity, params)
	if(proximity && params && istype(A, /obj/structure/table) && center_of_mass.len)
		//Places the item on a grid
		var/list/mouse_control = params2list(params)
		var/cellnumber = 4

		var/mouse_x = text2num(mouse_control["icon-x"])
		var/mouse_y = text2num(mouse_control["icon-y"])

		var/grid_x = round(mouse_x, 32/cellnumber)
		var/grid_y = round(mouse_y, 32/cellnumber)

		if(mouse_control["icon-x"])
			var/sign = mouse_x - grid_x != 0 ? sign(mouse_x - grid_x) : -1 //positive if rounded down, else negative
			pixel_x = grid_x - center_of_mass["x"] + sign*16/cellnumber //center of the cell
			if(pixel_x > 32)
				pixel_x=0
		if(mouse_control["icon-y"])
			var/sign = mouse_y - grid_y != 0 ? sign(mouse_y - grid_y) : -1
			pixel_y = grid_y - center_of_mass["y"] + sign*16/cellnumber
			if(pixel_y > 32)
				pixel_y=0