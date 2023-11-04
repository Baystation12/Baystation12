//Most interesting stuff happens in disperser_fire.dm
//This is just basic construction and deconstruction and the like

/obj/machinery/disperser
	icon = 'icons/obj/machines/disperser.dmi'
	density = TRUE
	anchored = TRUE
	construct_state = /singleton/machine_construction/default/panel_closed

/obj/machinery/disperser/examine(mob/user)
	. = ..()
	if(panel_open)
		to_chat(user, "The maintenance panel is open.")

/obj/machinery/disperser/use_tool(obj/item/I, mob/living/user, list/click_params)
	if(isWrench(I))
		if(panel_open)
			user.visible_message(
				SPAN_NOTICE("\The [user] rotates \the [src] with \the [I]."),
				SPAN_NOTICE("You rotate \the [src] with \the [I].")
			)
			set_dir(turn(dir, 90))
			playsound(src, 'sound/items/jaws_pry.ogg', 50, 1)
			return TRUE
		else
			to_chat(user,SPAN_NOTICE("The maintenance panel must be screwed open for this!"))
			return TRUE

	return ..()

/obj/machinery/disperser/front
	name = "obstruction field disperser beam generator"
	desc = "A complex machine which shoots concentrated material beams.\
		<br>A sign on it reads: <i>STAY CLEAR! DO NOT BLOCK!</i>"
	icon_state = "front"

/obj/machinery/disperser/middle
	name = "obstruction field disperser fusor"
	desc = "A complex machine which transmits immense amount of data \
		from the material deconstructor to the particle beam generator.\
		<br>A sign on it reads: <i>EXPLOSIVE! DO NOT OVERHEAT!</i>"
	icon_state = "middle"
	maximum_component_parts = list(/obj/item/stock_parts = 15)

/obj/machinery/disperser/back
	name = "obstruction field disperser material deconstructor"
	desc = "A prototype machine which can deconstruct materials atom by atom.\
		<br>A sign on it reads: <i>KEEP AWAY FROM LIVING MATERIAL!</i>"
	icon_state = "back"
	density = FALSE
	layer = ABOVE_HUMAN_LAYER //So the charges go inside us.
