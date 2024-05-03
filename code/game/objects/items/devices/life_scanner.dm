/obj/item/device/life_scanner
	name = "biotracker"
	desc = "A portable scanner that uses a more powerful but less precise version of the medical HUD to track the movements of living creatures through solid materials. Unfortunately, the strength of the emitters will short out any thermal sensors you're using."
	icon = 'icons/obj/tools/life_scanner.dmi'
	icon_state = "motion-0"
	slot_flags = SLOT_BELT
	w_class = ITEM_SIZE_SMALL
	item_state = "electronic"
	matter = list(
		MATERIAL_ALUMINIUM = 150,
		MATERIAL_GLASS = 50
	)
	var/scan_range = 6 //you don't want this higher than one less than the view range

	var/on = 0
	var/list/active_scanned = list() //assoc list of objects being scanned, mapped to their overlay
	var/client/user_client //since making sure overlays are properly added and removed is pretty important, so we track the current user explicitly
	var/list/last_overlays = list() //cache recent overlays
	var/scan_delay = 2 //amount of time between pings, in seconds
	var/last_scan //the world.time of the last ping
	var/list/scanned
	var/ping_noise = 'sound/items/sensor_ping_quiet.ogg'
	var/activation_sound = 'sound/items/tracker_ready_quiet.ogg'
	var/deactivation_sound = 'sound/items/plastic_handle_quiet.ogg'

#define OVERLAY_CACHE_LEN 50

/obj/item/device/life_scanner/Initialize()
	. = ..()
	icon_state = "motion-[on]"
	last_scan = world.time

/obj/item/device/life_scanner/proc/cleanup_overlays()
	for (var/obj/screen/image in last_overlays)
		if (user_client)
			user_client.screen -= image
			last_overlays -= image
			del(image)

/obj/item/device/life_scanner/proc/add_mob_ping(mob/pinged)


/obj/item/device/life_scanner/Destroy()
	if (on)
		set_active(FALSE)
	return ..()

/obj/item/device/life_scanner/on_update_icon()
	icon_state = "motion-[on]"

/obj/item/device/life_scanner/emp_act()
	audible_message(SPAN_NOTICE(" \The [src] buzzes oddly."))
	set_active(FALSE)
	..()

/obj/item/device/life_scanner/attack_self(mob/user)
	set_active(!on)
	user.update_action_buttons()

/obj/item/device/life_scanner/proc/set_active(active)
	on = active
	var/mob/mob = null
	cleanup_overlays()
	if(ismob(src.loc))
		mob = src.loc
	if(istype(src.loc, /obj/item/rig_module/device))
		if(ismob(src.loc.loc.loc))
			mob = src.loc.loc.loc //yeah, the location of the location of the location of us will be either the person wearing the suit or a turf
	if(on)
		START_PROCESSING(SSfastprocess, src)
		GLOB.moved_event.register(mob, src, .proc/update_drawings)
		sound_to(mob, activation_sound)
	else
		STOP_PROCESSING(SSfastprocess, src)
		set_user_client(null)
		GLOB.moved_event.unregister(mob, src, .proc/update_drawings)
		sound_to(mob, deactivation_sound)
	update_icon()

/obj/item/device/life_scanner/equipped(mob/user, slot)
	. = ..()
	GLOB.moved_event.register(user, src, .proc/update_drawings)


//If reset is set, then assume the client has none of our overlays, otherwise we only send new overlays.
/obj/item/device/life_scanner/Process()
	update_drawings()

/obj/item/device/life_scanner/proc/update_drawings()
	if(!on) return

	//handle clients changing
	var/client/loc_client = null
	var/mob/mob = null
	if(ismob(src.loc))
		mob = src.loc
		loc_client = mob.client
	if(istype(src.loc, /obj/item/rig_module/device))
		if(ismob(src.loc.loc.loc))
			mob = src.loc.loc.loc //yeah, the location of the location of the location of us will be either the person wearing the suit or a turf
			loc_client = mob.client
		else
			return
	set_user_client(loc_client)

	//no sense processing if no-one is going to see it.
	if(!user_client) return

	cleanup_overlays()

	//get all objects in scan range
	if (world.time > last_scan + scan_delay SECONDS)
		scanned = get_scanned_turfs(scan_range)
		last_scan = world.time
		sound_to(mob, ping_noise)



	if(ishuman(src.loc))
		var/mob/living/carbon/human/holder = src.loc
		if (!((src == holder.r_hand) || (src == holder.l_hand))) //are we in someone's hands or not?
			return // if we're not, don't give them any overlays

	for (var/turf/turf in scanned)
		if (!(turf in range(scan_range, get_turf(mob))))
			scanned -= turf //this means moving out of range of the object causes it to "forget" about it. this is required to keep screen stretching.
		if (get_overlay(turf))
			user_client.screen += get_overlay(turf)

//creates a new overlay for a scanned object
/obj/item/device/life_scanner/proc/get_overlay(turf/scanned)
	var/turf/mob_turf = scanned
	var/turf/our_turf = get_turf(src)
	var/difference_x
	var/difference_y
	var/obj/screen/Image = new /obj/screen
	Image.icon = 'icons/effects/effects.dmi'
	Image.icon_state = "lifesigns"
	Image.plane = FULLSCREEN_PLANE
	Image.layer = FULLSCREEN_LAYER
	Image.appearance_flags = DEFAULT_APPEARANCE_FLAGS
	difference_x = num2text(mob_turf.x - our_turf.x)
	difference_y = num2text(mob_turf.y - our_turf.y)
	if (text2num(difference_x) >= 0)
		difference_x = "+[difference_x]"
	if (text2num(difference_y) >= 0)
		difference_y = "+[difference_y]"
	Image.screen_loc = "CENTER[difference_x],CENTER[difference_y]"
	Image.mouse_opacity = 0
	last_overlays += Image
	return Image

/obj/item/device/life_scanner/proc/scan(mob/observer/virtual/pinged)
	if(pinged.host)
		scanned = pinged.host
		if (!ismob(scanned))
			return
		var/mob/mob = scanned
		if (mob.isSynthetic())
			return
		if (isliving(mob))
			var/mob/living/living = mob
			if (living.health <= 0)
				return
			if (isbrain(mob)) //we probably shouldn't show disembodied brains as life signs
				return
			if (ishuman(mob))
				var/mob/living/carbon/human/human = mob
				if (human.get_pulse_as_number() <= 0)
					return
		return get_turf(pinged)

/obj/item/device/life_scanner/proc/get_scanned_turfs(scan_dist)
	. = list()

	var/turf/center = get_turf(src.loc)
	if(!center) return

	for (var/mob/observer/virtual/mob in range(scan_range, center))
		. += (scan(mob))

/obj/item/device/life_scanner/proc/set_user_client(client/new_client)
	if(new_client == user_client)
		return
	if(user_client)
		for(var/scanned in active_scanned)
			user_client.images -= active_scanned[scanned]
	if(new_client)
		for(var/scanned in active_scanned)
			new_client.images += active_scanned[scanned]
	else
		active_scanned.Cut()

	user_client = new_client

/obj/item/device/life_scanner/dropped(mob/user)
	GLOB.moved_event.unregister(user, src, .proc/update_drawings)
	cleanup_overlays()
	Process()
	set_user_client(null)
	..()

#undef OVERLAY_CACHE_LEN
