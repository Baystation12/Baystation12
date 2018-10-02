/obj/structure/metaphoron
	name = "supermatter crystal"
	desc = "A jutting spike of glowing supermatter. Forged from a radioactive baptism, this crystal seems a lot more stable than its parent counterpart."
	icon = 'icons/obj/supermatter.dmi'
	icon_state = "floor_crystal"
	density = 1
	w_class = ITEM_SIZE_LARGE
	anchored = 1.0
	var/smlevel = 1
	var/next_event = 0
	var/health = 30

	light_color = COLOR_SM_DEFAULT
	light_outer_range = 6

/obj/structure/metaphoron/Initialize(var/maploading, var/level = 1)
	. = ..()
	level = Clamp(level, MIN_SUPERMATTER_LEVEL, MAX_SUPERMATTER_LEVEL)

	smlevel = level
	icon_state = pick("floor_crystal1", "floor_crystal2", "floor_crystal3")

	START_PROCESSING(SSprocessing, src)
	update_icon()

/obj/structure/metaphoron/Destroy()
	STOP_PROCESSING(SSprocessing, src)
	. = ..()

/obj/structure/metaphoron/examine(mob/user)
	..()
	if(user.skill_check(SKILL_SCIENCE, SKILL_ADEPT))
		to_chat(user, "<span class='notice'>It looks like a level [smlevel] shard.</span>")

/obj/structure/metaphoron/on_update_icon()
	var/datum/sm_control/sm_tier = GLOB.supermatter_tiers[smlevel]
	color = sm_tier.color
	light_color = color
	set_light(0.5, 0.1, light_outer_range, 2, light_color)

/obj/structure/metaphoron/Process()
	if(world.time > next_event)
		if(prob(50))
			SSradiation.radiate(src, 2 * smlevel)
		next_event = world.time + 20
	..()

/obj/structure/metaphoron/attackby(obj/item/weapon/W as obj, mob/user as mob)
	..()
	user.setClickCooldown(DEFAULT_ATTACK_COOLDOWN)
	if(W.damtype == BRUTE || W.damtype == BURN)
		user.do_attack_animation(src)
	else
		playsound(loc, 'sound/effects/Glasshit.ogg', 75, 1)
	health -= W.force
	if(health <= 0)
		smash()

/obj/structure/metaphoron/proc/smash()
	if(smlevel >= 4 && prob(min(100, smlevel*10)))
		visible_message("<span class='alert'><B>\The [src] explodes!</B></span>")
		playsound(loc, 'sound/effects/Glassbr2.ogg', 100, 1)
		supermatter_delamination(get_turf(src), round(smlevel/2), round(smlevel/2), 0, 0)
	else
		playsound(loc, 'sound/effects/Glassbr2.ogg', 100, 1)

		for(var/mob/living/l in range(src, 2))
			SSradiation.radiate(src, 15 * smlevel)


		if(prob(min(100, 10 * smlevel)))
			visible_message("<span class='alert'><B>\The [src] shatters!</B></span>")
			if(prob(min(100, 10 * smlevel)))
				new /obj/item/weapon/metaphoron/high(get_turf(src), smlevel)
			else
				new /obj/item/weapon/metaphoron/low(get_turf(src), smlevel)
		else
			visible_message("<span class='alert'><B>\The [src] shatters to dust!</B></span>")
	qdel_self()

/obj/structure/metaphoron/wall
	name = "supermatter crystals"
	icon_state = "wall_crystal"
	density = 0

/obj/structure/metaphoron/wall/Initialize(var/maploading, var/level = 1)
	. = ..()
	icon_state = "wall_crystal"

/obj/structure/metaphoron/ex_act(severity)
	switch(severity)
		if(1)
			qdel(src)
			return
		if(2)
			if(prob(50))
				qdel(src)
				return


/obj/structure/metaphoron/random/Initialize(var/maploading, var/level = 1)
	. = ..()
	smlevel = rand(MIN_SUPERMATTER_LEVEL, MAX_SUPERMATTER_LEVEL)
	icon_state = pick("floor_crystal1", "floor_crystal2", "floor_crystal3")

	START_PROCESSING(SSprocessing, src)
	update_icon()

/obj/structure/metaphoron/random/highlevel/Initialize()
	. = ..()
	smlevel = rand(4, MAX_SUPERMATTER_LEVEL)
	update_icon()

/obj/item/weapon/metaphoron
	name = "solid metaphoron"
	icon = 'icons/obj/supermatter.dmi'
	icon_state = "sheet-metaphoron1"
	item_state = "shard-mp1"
	var/smlevel = 1
	var/next_event = 0

/obj/item/weapon/metaphoron/Initialize(var/maploading, var/level = 1)
	. = ..()
	level = Clamp(level, MIN_SUPERMATTER_LEVEL, MAX_SUPERMATTER_LEVEL)
	smlevel = level
	var/datum/sm_control/sm_tier = GLOB.supermatter_tiers[smlevel]
	color = sm_tier.color
	light_color = color
	set_light(0.5, 0.1, light_outer_range, 2, light_color)
	START_PROCESSING(SSprocessing, src)

/obj/item/weapon/metaphoron/Destroy()
	STOP_PROCESSING(SSprocessing, src)
	. = ..()

/obj/item/weapon/metaphoron/Process()
	if(world.time > next_event)
		if(prob(50))
			SSradiation.radiate(src, 15 * smlevel)
		next_event = world.time + 20
	..()

/obj/item/weapon/metaphoron/low
	name = "low grade metaphoron"
	desc = "A crystalline flower of glowing metaphoron, one of the rarest materials in the universe. Far more stable than its' parent supermatter, but still dangerous. This one has some imperfections visible."

/obj/item/weapon/metaphoron/high
	name = "high grade metaphoron"
	icon_state = "sheet-metaphoron2"
	item_state = "shard-mp2"
	desc = "A crystalline flower of glowing metaphoron, one of the rarest materials in the universe. Far more stable than its' parent supermatter, but still dangerous. This one is beautifully formed."
