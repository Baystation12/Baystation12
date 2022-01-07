/// The base
/obj/item/spider_eggs
	name = "egg cluster"
	desc = "They seem to pulse slightly with an inner life."
	icon = 'icons/spider.dmi'
	icon_state = "eggs"
	health_max = 15
	w_class = ITEM_SIZE_SMALL

/// [number|list] Number: Exact count of spiderlings to create. List: set to number from rand([1], [2]) at creation time.
	var/spiderling_limit = list(6, 12)

/// [number|list] Number: Process( left before creating spiderlings. List: set to number from rand([1], [2]) at Initialize(
	var/growth_remaining = list(100, 150)

/// [path|list] Path: The guaranteed spiderling type. List: weighted pick of type per-spiderling.
	var/obj/item/spider/spider_type = /obj/item/spider


/obj/item/spider_eggs/giant
	spider_type = /obj/item/spider/giant


/obj/item/spider_eggs/Destroy()
	STOP_PROCESSING(SSobj, src)
	if (istype(loc, /obj/item/organ/external))
		var/obj/item/organ/external/external = loc
		external.implants -= src
	return ..()


/obj/item/spider_eggs/Initialize(mapload, atom/parent)
	. = ..()
	if (islist(growth_remaining))
		growth_remaining = rand(growth_remaining[1], growth_remaining[2])
	get_light_and_color(parent)
	pixel_x = rand(3, -3)
	pixel_y = rand(3, -3)
	START_PROCESSING(SSobj, src)


/obj/item/spider_eggs/handle_death_change(new_state)
	if (!new_state)
		return
	qdel(src)


/obj/item/spider_eggs/fire_act(datum/gas_mixture/air, exposed_temperature, exposed_volume)
	if (exposed_temperature > T50C)
		if (exposed_temperature > T100C)
			damage_health(health_max, DAMAGE_FIRE)
		else
			damage_health(3, DAMAGE_FIRE)


/obj/item/spider_eggs/attackby(obj/item/item, mob/living/user)
	user.setClickCooldown(item.attack_cooldown || DEFAULT_ATTACK_COOLDOWN)
	var/visible = "uselessly prod"
	var/audible = "soft squishing"
	if (!(item.item_flags & ITEM_FLAG_NO_BLUDGEON))
		var/force = is_hot(item)
		if (force >= 1000)
			damage_health(health_max, DAMAGE_FIRE)
			visible = "incinerate"
			audible = "the swoosh of a quick flame"
		else if (force >= 100)
			damage_health(health_max / 3, DAMAGE_FIRE)
			visible = "singe"
			audible = "sizzling"
		else if (item.damtype == DAMAGE_BRUTE)
			force = item.force
			if (!item.edge && !item.sharp)
				force = force * 0.5
			if (force > health_current)
				damage_health(health_max, DAMAGE_BRUTE)
				visible = "splatter"
				audible = "wet splattering"
			else if (force >= 2)
				damage_health(force, DAMAGE_BRUTE)
				visible = "pop"
				audible = "wet popping"
	user.do_attack_animation(src)
	user.visible_message(
		SPAN_WARNING("\The [user] [visible]s \a [src] with \a [item]."),
		SPAN_WARNING("You [visible] \the [src] with \the [item]."),
		SPAN_WARNING("You hear [audible].")
	)


/obj/item/spider_eggs/Process()
	if (--growth_remaining > 0)
		return
	var/obj/item/organ/external/external
	if (istype(loc, /obj/item/organ/external))
		external = loc
	var/create_type = spiderling_type
	var/create_count = spiderling_limit
	if (islist(create_count))
		create_count = rand(create_count[1], create_count[2])
	for (var/i = create_count to 1 step -1)
		if (islist(spiderling_type))
			create_type = pickweight(spiderling_type)
		var/spiderling = new create_type (loc, src)
		if (external)
			external.implants += spiderling
	qdel(src)
	return PROCESS_KILL
