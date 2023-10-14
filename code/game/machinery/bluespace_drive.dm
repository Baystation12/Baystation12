/obj/machinery/bluespacedrive
	name = "bluespace drive"
	desc = "The Naophoros-pattern jump drive is a machine created by the skrell, mated with countless human devices and apparatuses to make it able to interface with the vastly different technology used in their ships."
	icon = 'icons/obj/machines/bluespacedrive.dmi'
	icon_state = "bsd_core"
	anchored = TRUE
	density = TRUE
	pixel_y = -32
	pixel_x = -32
	idle_power_usage = 15 KILOWATTS
	health_max = 1000
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

	///Whether or not the BSD Instability event is active
	var/instability_event_active = FALSE


/obj/machinery/bluespacedrive/Destroy()
	QDEL_NULL(drive_sound)
	particles = null
	return ..()


/obj/machinery/bluespacedrive/Initialize()
	. = ..()
	drive_sound = GLOB.sound_player.PlayLoopingSound(src, "\ref[src]", 'sound/machines/BSD_idle.ogg', 50, 7)
	AddParticles(/particles/torus/bluespace)
	set_light(15, 1, COLOR_CYAN)
	update_icon()


/obj/machinery/bluespacedrive/on_update_icon()
	ClearOverlays()
	if (state & STATE_BROKEN)
		icon_state = "bsd_core_broken"
	else
		icon_state = "bsd_core"
	if (state & STATE_UNSTABLE)
		AddOverlays("bsd_c_u")
	else
		AddOverlays("bsd_c_s")


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


/obj/machinery/bluespacedrive/post_health_change(health_mod, prior_health, damage_type)
	. = ..()
	var/damage_percentage = get_damage_percentage()
	if (damage_percentage >= 50 && !(state & STATE_UNSTABLE))
		state |= STATE_UNSTABLE
		queue_icon_update()
	else if (damage_percentage < 50 && (state & STATE_UNSTABLE))
		state &= ~STATE_UNSTABLE
		queue_icon_update()


/obj/machinery/bluespacedrive/on_death()
	playsound(loc, 'sound/machines/BSD_explosion.ogg', 100)
	visible_message(SPAN_DANGER(FONT_LARGE("\The [src] begins emitting an ear-splitting, horrible shrill! Get back!")))
	addtimer(new Callback(src, .proc/explode), 5 SECONDS)
	..()


/// Final death act handler for the drive where it explodes. You really shouldn't call this directly or you'll make weird broken things regarding health tracking. Use `kill_health()` instead, the death handler calls this.
/obj/machinery/bluespacedrive/proc/explode()
	visible_message(SPAN_DANGER(FONT_LARGE("\The [src]'s containment field is wracked by a series of horrendous distortions, buckling and twisting like a living thing before bursting in a flash of light!")))
	explosion(get_turf(src), 15, EX_ACT_HEAVY)
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
	if (health_dead())
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
	if (instability_event_active && !damage_percentage)
		to_chat(user, SPAN_WARNING("The core seems to be pulsing and lashing out at the contaiment field, as if trying to break free."))


/// Creates an expanding bluespace pulse on all z-levels connected to the drive
/obj/machinery/bluespacedrive/proc/do_pulse()
	playsound(src, 'sound/effects/EMPulse.ogg', 100, TRUE)
	var/datum/bubble_effect/bluespace_pulse/parent
	for (var/level in GetConnectedZlevels(z))
		parent = new (x, y, level, 1, 1, parent)


/// Creates a blinding flash of light that will blind and deafen those in range, and change turfs to bluespace
/obj/machinery/bluespacedrive/proc/create_flash(change_turf, range)
	playsound(src, "sound/effects/supermatter.ogg", 100, TRUE)
	var/list/victims = list()
	var/list/objs = list()
	get_mobs_and_objs_in_view_fast(loc, range, victims, objs)
	for (var/mob/living/living in victims)
		if (living.client)
			to_chat(living, SPAN_DANGER(FONT_LARGE("The Drive's field cracks open briefly, emitting a blinding flash of blue light and a deafenening screech!")))
		living.flash_eyes(FLASH_PROTECTION_MAJOR)
		living.Stun(3)
		living.mod_confused(15)
		living.ear_damage += rand(0, 5)
		living.ear_deaf = max(living.ear_deaf, 15)
	if (!change_turf)
		return
	for (var/turf/simulated/floor/floor in range(range, src))
		if (prob(25))
			continue
		floor.ChangeTurf(/turf/simulated/floor/bluespace)


/datum/bubble_effect/bluespace_pulse
	///List of mobs that can be swapped around when the pulse hits
	var/list/mob/living/mobs_to_switch = list()

/datum/bubble_effect/bluespace_pulse/New()
	..()
	START_PROCESSING(SSfastprocess, src)
	var/list/zlevels = GetConnectedZlevels(z)
	for (var/mob/living/L as anything in GLOB.alive_mobs)
		if (!(L.z in zlevels))
			continue
		if (istype(L, /mob/living/exosuit))
			continue
		mobs_to_switch += L


/datum/bubble_effect/bluespace_pulse/Destroy()
	STOP_PROCESSING(SSfastprocess, src)
	return ..()


/datum/bubble_effect/bluespace_pulse/Process()
	if (radius > 50)
		qdel(src)
		return PROCESS_KILL
	Tick()


/datum/bubble_effect/bluespace_pulse/TurfEffect(turf/turf)
	if (TICK_CHECK)
		return TRUE
	if (radius <= 20)
		new /obj/temporary (turf, 0.2 SECONDS, 'icons/effects/effects.dmi', "cyan_sparkles")
	var/obj/machinery/light/light = locate() in turf
	if (light && prob(20))
		light.broken()
	var/mob/living/being = locate() in turf
	if (being && prob(50))
		//swap places with another mob
		var/list/zlevels = GetConnectedZlevels(being.z)
		for (var/mob/living/mob as anything in mobs_to_switch)
			if (!(mob.z in zlevels))
				continue
			if (mob != being)
				var/source_position = being.loc
				var/other_position = mob.loc
				do_teleport(mob, source_position)
				do_teleport(being, other_position)
				mobs_to_switch -= mob
				mobs_to_switch -= being
				to_chat(mob, SPAN_DANGER("A wave of energy washes over you, and you find yourself somewhere else!"))
				to_chat(being, SPAN_DANGER("A wave of energy washes over you, and you find yourself somewhere else!"))
				return
	else
		to_chat(being, SPAN_WARNING("A wave of energy washes over you, giving you a strange and uneasy feeling..."))
