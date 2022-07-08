/obj/machinery/bluespacedrive
	name = "bluespace drive"
	desc = "The Naophoros-pattern jump drive is a machine created by the skrell, mated with countless human devices and apparatuses to make it able to interface with the vastly different technology used in their ships."
	icon = 'icons/obj/machines/bluespacedrive.dmi'
	icon_state = "bsd_core"
	anchored = TRUE
	density = TRUE
	pixel_y = -32
	pixel_x = -32
	idle_power_usage = 150 KILOWATTS
	construct_state = /decl/machine_construction/default/panel_closed
	health_max = 1000
	health_resistances = DAMAGE_RESIST_ELECTRICAL
	damage_hitsound = 'sound/machines/BSD_damaging.ogg'
	health_min_damage = 10

	/// Indicates whether the drive should show effects.
	var/const/STATE_BROKEN = FLAG(0)

	/// Indicates whether the drive should use the unstable core effect.
	var/const/STATE_UNSTABLE = FLAG(1)

	/// A field of STATE_* flags related to the drive.
	var/state = EMPTY_BITFIELD

	/// The token for the drive's idle loop
	var/drive_sound


/obj/machinery/bluespacedrive/Destroy()
	QDEL_NULL(drive_sound)
	particles = null
	return ..()


/obj/machinery/bluespacedrive/Initialize()
	. = ..()
	drive_sound = GLOB.sound_player.PlayLoopingSound(src, "\ref[src]", 'sound/machines/BSD_idle.ogg', 50, 7)
	particles = new /particles/bluespace_torus
	set_light(1, 5, 15, 10, COLOR_CYAN)
	update_icon()


/obj/machinery/bluespacedrive/on_update_icon()
	overlays.Cut()
	if (state & STATE_BROKEN)
		icon_state = "bsd_core_broken"
	else
		icon_state = "bsd_core"
	if (state & STATE_UNSTABLE)
		overlays += "bsd_c_u"
	else
		overlays += "bsd_c_s"


/obj/machinery/bluespacedrive/emp_act(severity)
	..()
	if (!(state & STATE_BROKEN))
		visible_message(SPAN_WARNING("\The [src]'s field warps and buckles uneasily!"))
		playsound(loc, damage_hitsound, 80)


/obj/machinery/bluespacedrive/bullet_act(obj/item/projectile/projectile)
	. = ..()
	if (!(state & STATE_BROKEN))
		visible_message(SPAN_WARNING("\The [src]'s field crackles disturbingly!"))
		playsound(loc, damage_hitsound, 80)


/obj/machinery/bluespacedrive/post_health_change(health_mod, damage_type)
	. = ..()
	var/damage_percentage = get_damage_percentage()
	if (damage_percentage >= 50 && !(state & STATE_UNSTABLE))
		state |= STATE_UNSTABLE
		update_icon()
	else if (damage_percentage < 50 && (state & STATE_UNSTABLE))
		state &= ~STATE_UNSTABLE
		update_icon()


/obj/machinery/bluespacedrive/on_death()
	. = ..()
	playsound(loc, 'sound/machines/BSD_explosion.ogg', 100)
	visible_message(SPAN_DANGER(FONT_LARGE("\The [src] begins emitting an ear-splitting, horrible shrill! Get back!")))
	addtimer(CALLBACK(src, .proc/explode), 5 SECONDS)


/// Final death act handler for the drive where it explodes. You really shouldn't call this directly or you'll make weird broken things regarding health tracking. Use `kill_health()` instead, the death handler calls this.
/obj/machinery/bluespacedrive/proc/explode()
	visible_message(SPAN_DANGER(FONT_LARGE("\The [src]'s containment field is wracked by a series of horrendous distortions, buckling and twisting like a living thing before bursting in a flash of light!")))
	explosion(get_turf(src), -1, 5, 10)
	empulse(get_turf(src), 7, 14)
	state |= STATE_BROKEN
	for (var/verb in verbs)
		verbs -= verb
	update_icon()


/obj/machinery/bluespacedrive/attackby(obj/item/item, mob/user)
	if (istype(item, /obj/item/grab))
		var/obj/item/grab/grab = item
		to_chat(user, SPAN_WARNING("\The [src] pulls at \the [grab.affecting] but they're too heavy."))
		return
	if (issilicon(user) || !user.unEquip(item, src))
		to_chat(user, SPAN_WARNING("\The [src] pulls at \the [item] but it's attached to you."))
		return
	user.visible_message(
		SPAN_WARNING("\The [user] reaches out \a [item] to \the [src], warping briefly as it disappears in a flash of blue light, scintillating motes left behind."),
		SPAN_DANGER("You touch \the [src] with \the [item], the field buckling around it before retracting with a crackle as it leaves small, blue scintillas on your hand as you flinch away."),
		SPAN_WARNING("You hear an otherwordly crackle, followed by humming.")
	)
	qdel(item)
	if (prob(5))
		playsound(loc, 'sound/items/eatfood.ogg', 40)		//Yum
	else
		playsound(loc, 'sound/machines/BSD_interact.ogg', 40)


/obj/machinery/bluespacedrive/examine_damage_state(mob/user)
	if (health_dead)
		to_chat(user, SPAN_DANGER("Its field is completely destroyed, the core revealed under the arcing debris."))
		return

	var/damage_percentage = get_damage_percentage()
	switch (damage_percentage)
		if (0)
			to_chat(user, SPAN_NOTICE("At a glance, its field is peacefully humming without any alterations."))
		if (1 to 32)
			to_chat(user, SPAN_WARNING("Its field is crackling gently, with the occasional twitch."))
		if (33 to 65)
			to_chat(user, SPAN_WARNING("Its damaged field is twitching and crackling dangerously!"))
		else
			to_chat(user, SPAN_DANGER("Its unstable field is cracking and shifting dangerously, revealing the core inside briefly!"))


/particles/bluespace_torus
	width = 700
	height = 700
	count = 2700
	spawning = 260
	lifespan = 0.75 SECONDS
	fade = 0.95 SECONDS
	position = generator("circle", 16, 24, NORMAL_RAND)
	velocity = generator("circle", -6, 6, NORMAL_RAND)
	friction = 0.15
	gradient = list(0, COLOR_WHITE, 0.75, COLOR_BLUE_LIGHT)
	color_change = 0.125
	drift = generator("vector", list(-0.2, -0.2), list(0.2, 0.2))
