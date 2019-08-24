//Most interesting stuff happens in bsa_fire.dm
//This is just basic construction and deconstruction and the like

/obj/machinery/bsa
	icon = 'icons/obj/bsa.dmi'
	density = TRUE
	anchored = TRUE
	construct_state = /decl/machine_construction/default/panel_closed

/obj/machinery/bsa/examine(mob/user)
	. = ..()
	if(. && panel_open)
		to_chat(user, "The maintenance panel is open.")

/obj/machinery/bsa/attackby(obj/item/I, mob/user)
	if(isWrench(I))
		if(panel_open)
			user.visible_message("<span class='notice'>\The [user] rotates \the [src] with \the [I].</span>", "<span class='notice'>You rotate \the [src] with \the [I].</span>")
			set_dir(turn(dir, 90))
			playsound(src, 'sound/items/jaws_pry.ogg', 50, 1)
		else
			to_chat(user,"<span class='notice'>The maintenance panel must be screwed open for this!</span>")
	else
		return ..()

/obj/machinery/bsa/front
	name = "bluespace particle beam generator mark VI."
	desc = "A complex machine which shoots concentrated bluespace beams.\
		<br>A sign on it reads: <i>STAY CLEAR! DO NOT BLOCK!</i>"
	icon_state = "front"

/obj/machinery/bsa/middle
	name = "bluespace fusor mark VI."
	desc = "A complex machine which transmits immense amount of data \
		from the material deconstructor to the particle beam generator.\
		<br>A sign on it reads: <i>EXPLOSIVE! DO NOT OVERHEAT!</i>"
	icon_state = "middle"
	maximum_component_parts = list(/obj/item/weapon/stock_parts = 15)

/obj/machinery/bsa/back
	name = "bluespace material deconstructor mark VI."
	desc = "A prototype machine which can deconstruct materials atom by atom and send them through bluespace instanteniously.\
		<br>A sign on it reads: <i>KEEP AWAY FROM LIVING MATERIAL!</i>"
	icon_state = "back"
	density = FALSE
	layer = BELOW_DOOR_LAYER //So the charges go above us.