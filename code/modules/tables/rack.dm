/obj/structure/table/rack
	name = "rack"
	desc = "Different from the Middle Ages version."
	icon = 'icons/obj/objects.dmi'
	icon_state = "rack"
	can_plate = 0
	can_reinforce = 0
	flipped = -1

/obj/structure/table/rack/New()
	..()
	verbs -= /obj/structure/table/verb/do_flip
	verbs -= /obj/structure/table/proc/do_put

/obj/structure/table/rack/initialize()
	..()
	//arrange everything on our turf, similar to how closets store everything on theirs
	for(var/obj/item/I in src.loc)
		place_item(I, null) //inefficient, but saves us some copypasta

/obj/structure/table/rack/update_connections()
	return

/obj/structure/table/rack/update_desc()
	return

/obj/structure/table/rack/update_icon()
	return

/obj/structure/table/rack/holorack/dismantle(obj/item/weapon/wrench/W, mob/user)
	user << "<span class='warning'>You cannot dismantle \the [src].</span>"
	return

/obj/structure/table/rack/place_item(obj/item/I, var/click_params)
	var/index = 1
	for(var/obj/item/J in src.loc)
		if(J.anchored)
			continue
		if(I == J)
			arrange_item(I, index)
			break
		index++


//spent waaay too much time tweaking these
#define START_X -4
#define START_Y 8
#define NUM_ROWS 3
#define NUM_COLS 2
#define ROW_SPACING 4
#define COL_SPACING 5
#define COL_OFFSET 3

//Sets the pixel_x/y values of an item to place it neatly on the rack
/obj/structure/table/rack/proc/arrange_item(obj/item/I, var/index)
	//respect center_of_mass
	var/center_x = 0
	var/center_y = 0
	if(istype(I, /obj/item/weapon/reagent_containers/food))
		var/obj/item/weapon/reagent_containers/food/F = I
		if(F.center_of_mass.len)
			center_x = F.center_of_mass["x"] - 16
			center_y = F.center_of_mass["y"] - 16


	var/col = (index-1) % NUM_COLS //0-indexed
	var/row = round((index-1)/NUM_COLS) % NUM_ROWS //I just love how round() actually floors the value. Makes things so clear. Also 0-indexed

	I.pixel_x = START_X + ROW_SPACING*row + COL_OFFSET - COL_SPACING*col - center_x
	I.pixel_y = START_Y - ROW_SPACING*row - round(ROW_SPACING/NUM_COLS)*col - center_y

#undef START_X
#undef START_Y
#undef NUM_ROWS
#undef NUM_COLS
#undef ROW_SPACING
#undef COL_SPACING
#undef COL_OFFSET