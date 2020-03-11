
/obj/item/drop_pod_beacon
	name = "\improper Drop Pod Beacon"
	desc = "A single-use electronic beacon that broadcasts a signal that provides co-ordinates for drop-pods and other similar devices to use."
	icon = 'code/modules/halo/weapons/icons/Weapon Sprites.dmi'
	icon_state = "ebeacon"
	w_class = ITEM_SIZE_SMALL

	var/faction_tag = "UNSC"
	var/is_active = 0
	var/time_to_expire = 5 MINUTES
	var/time_expire_at = 0

/obj/item/drop_pod_beacon/New()
	. = ..()
	icon_state = "[initial(icon_state)]_off"

/obj/item/drop_pod_beacon/process()
	if(world.time > time_expire_at && time_expire_at != 0)
		is_active = -1
		visible_message("<span class = 'notice'>The lights on [name] darken, [name] shuts off.</span>")
		GLOB.processing_objects -= src
		icon_state = "[initial(icon_state)]_burnout"
		return

/obj/item/drop_pod_beacon/attack_self(var/mob/user)
	activate(user)

/obj/item/drop_pod_beacon/proc/activate(var/mob/user = null)
	if(is_active == 1)
		if(user)
			to_chat(user,"<span class = 'notice'>[name] is already active!</span>")
		return
	if(is_active == -1)
		if(user)
			to_chat(user,"<span class = 'notice'>[name] has ran out of charge!</span>")
		return

	if(user)
		user.visible_message("<span class = 'notice'>[user] primes [src], activating the tracking module!</span>")
	GLOB.processing_objects += src
	icon_state = "[initial(icon_state)]_on"
	is_active = 1
	time_expire_at = world.time + time_to_expire

/obj/item/drop_pod_beacon/examine(var/mob/examiner)
	. = ..()
	var/message = "inactive."
	if(is_active == 1)
		message = "active!"
	if(is_active == -1)
		message = "burnt out!"
	to_chat(examiner,"It is [message]")

/obj/item/drop_pod_beacon/invis
	time_to_expire = 1 MINUTE
	invisibility = 101
	alpha = 0