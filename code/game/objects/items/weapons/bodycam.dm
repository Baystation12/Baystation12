/obj/item/weapon/bodycam
	name = "back-mounted camera unit"
	desc = "A SPEAR-430 back-mounted bodycam unit. Often used by security forces to monitor officer behaviour, as well as positions and status."
	slot_flags = SLOT_BACK
	icon = 'icons/obj/storage.dmi'
	icon_state = "bodycam"
	item_state = "bodycam"
	w_class = ITEM_SIZE_HUGE
	var/obj/machinery/camera/network/security/camera

/obj/item/weapon/bodycam/Initialize()
	. = ..()
	if(!ispath(camera) && camera)
		verbs += /obj/item/weapon/bodycam/proc/toggle_camera
	update_icon()

/obj/item/weapon/bodycam/Destroy()
	if(!ispath(camera) && camera)
		QDEL_NULL(camera)
	. = ..()

/obj/item/weapon/bodycam/on_update_icon()
	if(!ispath(camera) && camera && camera.status)
		icon_state = "[initial(icon_state)]-on"
	else
		icon_state = "[initial(icon_state)]"
	item_state = icon_state

/obj/item/weapon/bodycam/emp_act(severity)
	if(!ispath(camera) && camera)
		camera.set_status(0)
	update_icon()
	..()

/obj/item/weapon/bodycam/proc/toggle_camera()
	set name = "Toggle Body Camera"
	set category = "Object"
	set src in usr

	if(ispath(camera))
		camera = new camera(src)
		camera.set_status(0)

	if(camera)
		for(var/obj/machinery/camera/C in cameranet.cameras)
			var/list/tempnetwork = C.network & camera.network
			if(C != camera && C.c_tag == camera.c_tag && tempnetwork.len)
				to_chat(usr, "<span class='notice'>Registration failed. User already has registered camera.</span>")
				return
		camera.set_status(!camera.status)
		if(camera.status)
			camera.c_tag = FindNameFromID(usr)
			to_chat(usr, "<span class='notice'>User scanned as [camera.c_tag]. Camera activated.</span>")
		else
			to_chat(usr, "<span class='notice'>Camera deactivated.</span>")
		playsound(usr, 'sound/effects/pop.ogg', 30, 1)
		update_icon()

/obj/item/clothing/head/helmet/space/examine(var/mob/user)
	. = ..()
	if(camera)
		to_chat(user, "The mounted camera is [!ispath(camera) && camera.status ? "" : "in"]active.")