// Cheap, shitty, hacky means of draining water without a proper pipe system.
// TODO: water pipes.
/obj/structure/drain
	name = "gutter"
	desc = "You probably can't get sucked down the plughole."
	icon = 'icons/obj/drain.dmi'
	icon_state = "drain"
	anchored = 1
	density = 0
	layer = TURF_LAYER+0.1
	var/drainage = 0.5
	var/last_gurgle = 0
	var/welded

/obj/structure/drain/New()
	..()
	START_PROCESSING(SSobj, src)

/obj/structure/drain/Destroy()
	STOP_PROCESSING(SSobj, src)
	. = ..()

/obj/structure/drain/attackby(var/obj/item/thing, var/mob/user)
	if(isWelder(thing))
		var/obj/item/weapon/weldingtool/WT = thing
		if(WT.isOn())
			welded = !welded
			to_chat(user, "<span class='notice'>You weld \the [src] [welded ? "closed" : "open"].</span>")
		else
			to_chat(user, "<span class='warning'>Turn \the [thing] on, first.</span>")
		update_icon()
		return
	return ..()

/obj/structure/drain/on_update_icon()
	icon_state = "[initial(icon_state)][welded ? "-welded" : ""]"

/obj/structure/drain/Process()
	if(welded)
		return
	var/turf/T = get_turf(src)
	if(!istype(T)) return
	var/fluid_here = T.get_fluid_depth()
	if(fluid_here <= 0)
		return

	T.remove_fluid(ceil(fluid_here*drainage))
	T.show_bubbles()
	if(world.time > last_gurgle + 80)
		last_gurgle = world.time
		playsound(T, pick(SSfluids.gurgles), 50, 1)
