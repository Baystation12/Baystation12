
/obj/vehicles/track_bound
	name = "track bound vehicle"
	desc = "A vehicle that relies on prebuilt emplacements to move."
	icon = 'code/modules/halo/vehicles/track_vehicle.dmi'
	icon_state = "train"

	var/track_obj_type = /obj/structure/track

/obj/vehicles/track_bound/Move(var/turf/newloc,var/dir)
	var/obj/structure/track/t = locate(track_obj_type) in newloc.contents
	if(t && !t.damaged)
		. = ..()

/obj/structure/track
	name = "track"
	desc = "a track for a vehicle to run across."
	icon = 'code/modules/halo/vehicles/track.dmi'
	icon_state = "track"
	anchored = 1
	density = 0

	var/damaged = 0

/obj/structure/track/update_icon()
	if(damaged)
		icon_state = "[initial(icon_state)]_damaged"
	else
		icon_state = initial(icon_state)

/obj/structure/track/attackby(var/obj/item/tool,var/mob/user)
	if(!damaged)
		to_chat(user,"<span class='notice'>[src] is not damaged!</span>")
		return
	if(istype(tool,/obj/item/weapon/wrench))
		visible_message("<span class='notice'>[user] repairs [src]</span>")

/obj/structure/track/ex_act(severity)
	damaged = 1