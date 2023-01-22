/obj/item/mech_equipment/sleeper
	name = "\improper exosuit sleeper"
	desc = "An exosuit-mounted sleeper designed to mantain patients stabilized on their way to medical facilities."
	icon_state = "mech_sleeper"
	restricted_hardpoints = list(HARDPOINT_BACK)
	restricted_software = list(MECH_SOFTWARE_MEDICAL)
	equipment_delay = 30 //don't spam it on people pls
	active_power_use = 0 //Usage doesn't really require power. We don't want people stuck inside
	origin_tech = list(TECH_DATA = 2, TECH_BIO = 3)
	passive_power_use = 1.5 KILOWATTS
	var/obj/machinery/sleeper/mounted/sleeper = null

/obj/item/mech_equipment/sleeper/Initialize()
	. = ..()
	sleeper = new /obj/machinery/sleeper/mounted(src)
	sleeper.forceMove(src)

/obj/item/mech_equipment/sleeper/Destroy()
	sleeper.go_out() //If for any reason you weren't outside already.
	QDEL_NULL(sleeper)
	. = ..()

/obj/item/mech_equipment/sleeper/uninstalled()
	. = ..()
	sleeper.go_out()

/obj/item/mech_equipment/sleeper/attack_self(var/mob/user)
	. = ..()
	if(.)
		sleeper.ui_interact(user)

/obj/item/mech_equipment/sleeper/attackby(var/obj/item/I, var/mob/user)
	if(istype(I, /obj/item/reagent_containers/glass))
		sleeper.attackby(I, user)
	else return ..()

/obj/item/mech_equipment/sleeper/afterattack(var/atom/target, var/mob/living/user, var/inrange, var/params)
	. = ..()
	if(.)
		if(ishuman(target) && !sleeper.occupant)
			owner.visible_message(SPAN_NOTICE("\The [src] is lowered down to load [target]"))
			sleeper.go_in(target, user)
		else to_chat(user, SPAN_WARNING("You cannot load that in!"))

/obj/item/mech_equipment/sleeper/get_hardpoint_maptext()
	if(sleeper && sleeper.occupant)
		return "[sleeper.occupant]"

/obj/machinery/sleeper/mounted
	name = "\improper mounted sleeper"
	density = FALSE
	anchored = FALSE
	idle_power_usage = 0
	active_power_usage = 0 //It'd be hard to handle, so for now all power is consumed by mech sleeper object
	synth_modifier = 0
	stasis_power = 0
	interact_offline = TRUE
	stat_immune = NOPOWER

/obj/machinery/sleeper/mounted/ui_interact(var/mob/user, var/ui_key = "main", var/datum/nanoui/ui = null, var/force_open = 1, var/datum/topic_state/state = GLOB.mech_state)
	. = ..()

/obj/machinery/sleeper/mounted/nano_host()
	var/obj/item/mech_equipment/sleeper/S = loc
	if(istype(S))
		return S.owner
	return null

//You cannot modify these, it'd probably end with something in nullspace. In any case basic meds are plenty for an ambulance
/obj/machinery/sleeper/mounted/attackby(var/obj/item/I, var/mob/user)
	if(istype(I, /obj/item/reagent_containers/glass))
		if(!user.unEquip(I, src))
			return

		if(beaker)
			beaker.forceMove(get_turf(src))
			user.visible_message("<span class='notice'>\The [user] removes \the [beaker] from \the [src].</span>", "<span class='notice'>You remove \the [beaker] from \the [src].</span>")
		beaker = I
		user.visible_message("<span class='notice'>\The [user] adds \a [I] to \the [src].</span>", "<span class='notice'>You add \a [I] to \the [src].</span>")

/obj/item/mech_equipment/mender
	name = "exosuit medigel spray"
	desc = "An exosuit-mounted matrix of medical gel nozzles and radiation emitters designed to treat wounds before transporting patient."
	icon_state = "mech_mender"
	restricted_hardpoints = list(HARDPOINT_LEFT_HAND, HARDPOINT_RIGHT_HAND)
	restricted_software = list(MECH_SOFTWARE_MEDICAL)
	active_power_use = 0 //Usage doesn't really require power. It's per wound
	origin_tech = list(TECH_DATA = 2, TECH_BIO = 3)
	var/list/apply_sounds = list('sound/effects/spray.ogg', 'sound/effects/spray2.ogg', 'sound/effects/spray3.ogg')

/obj/item/mech_equipment/mender/afterattack(atom/target, mob/living/user, inrange, params)
	. = ..()
	if(.)
		if (istype(target, /mob/living/carbon/human))
			var/mob/living/carbon/human/H = target
			var/obj/item/organ/external/affecting = H.get_organ(user.zone_sel.selecting)

			if(affecting.is_bandaged() && affecting.is_disinfected() && affecting.is_salved())
				to_chat(user, SPAN_WARNING("The wounds on \the [H]'s [affecting.name] have already been treated."))
				return
			else
				if(!LAZYLEN(affecting.wounds))
					return
				owner.visible_message(SPAN_NOTICE("\The [owner] extends \the [src] towards \the [H]'s [affecting.name]."))
				var/large_wound = FALSE
				for (var/datum/wound/W as anything in affecting.wounds)
					if (W.bandaged && W.disinfected && W.salved)
						continue
					var/delay = (W.damage / 4) * user.skill_delay_mult(SKILL_MEDICAL, 0.8)
					owner.setClickCooldown(delay)
					if(!do_after(user, delay, target))
						break

					var/obj/item/cell/C = owner.get_cell()
					if(istype(C))
						C.use(0.01 KILOWATTS) //Does cost power, so not a freebie, specially with large amount of wounds
					else
						return //Early out, cell is gone

					if (W.current_stage <= W.max_bleeding_stage)
						owner.visible_message(SPAN_NOTICE("\The [owner] covers \a [W.desc] on \the [H]'s [affecting.name] with large globs of medigel."))
						large_wound = TRUE
					else if (W.damage_type == INJURY_TYPE_BRUISE)
						owner.visible_message(SPAN_NOTICE("\The [owner] sprays \a [W.desc] on \the [H]'s [affecting.name] with a fine layer of medigel."))
					else
						owner.visible_message(SPAN_NOTICE("\The [owner] drizzles some medigel over \a [W.desc] on \the [H]'s [affecting.name]."))
					playsound(owner, pick(apply_sounds), 20)
					W.bandage()
					W.disinfect()
					W.salve()
					if (H.stat == UNCONSCIOUS && prob(25))
						to_chat(H, SPAN_NOTICE(SPAN_BOLD("... [pick("feels better", "hurts less")] ...")))
				if(large_wound)
					owner.visible_message(SPAN_NOTICE("\The [src]'s UV matrix glows faintly as it cures the medigel."))
					playsound(owner, 'sound/items/Welder2.ogg', 10)
				affecting.update_damages()
				H.update_bandages(TRUE)
