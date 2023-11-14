/obj/item/mech_equipment/sleeper
	name = "exosuit sleeper"
	desc = "An exosuit-mounted sleeper designed to mantain patients stabilized on their way to medical facilities."
	icon_state = "mech_sleeper"
	restricted_hardpoints = list(HARDPOINT_BACK)
	restricted_software = list(MECH_SOFTWARE_MEDICAL)
	equipment_delay = 30 //don't spam it on people pls
	active_power_use = 0 //Usage doesn't really require power. We don't want people stuck inside
	origin_tech = list(TECH_DATA = 2, TECH_BIO = 3)
	passive_power_use = 0 //Raised to 1.5 KW when patient is present.
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

/obj/item/mech_equipment/sleeper/attack_self(mob/user)
	. = ..()
	if(.)
		sleeper.ui_interact(user)

/obj/item/mech_equipment/sleeper/attackby(obj/item/I, mob/user)
	if(istype(I, /obj/item/reagent_containers/glass))
		sleeper.attackby(I, user)
	else return ..()

/obj/item/mech_equipment/sleeper/afterattack(atom/target, mob/living/user, inrange, params)
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
	name = "mounted sleeper"
	density = FALSE
	anchored = FALSE
	idle_power_usage = 0
	active_power_usage = 0 //It'd be hard to handle, so for now all power is consumed by mech sleeper object
	synth_modifier = 0
	stasis_power = 0
	interact_offline = TRUE
	stat_immune = MACHINE_STAT_NOPOWER
	base_chemicals = list("Inaprovaline" = /datum/reagent/inaprovaline, "Paracetamol" = /datum/reagent/paracetamol, "Dylovene" = /datum/reagent/dylovene, "Dexalin" = /datum/reagent/dexalin, "Kelotane" = /datum/reagent/kelotane, "Hyronalin" = /datum/reagent/hyronalin)

/obj/machinery/sleeper/mounted/ui_interact(mob/user, ui_key = "main", datum/nanoui/ui = null, force_open = 1, datum/topic_state/state = GLOB.mech_state)
	. = ..()

/obj/machinery/sleeper/mounted/nano_host()
	var/obj/item/mech_equipment/sleeper/S = loc
	if(istype(S))
		return S.owner
	return null

/obj/machinery/sleeper/mounted/go_in()
	..()
	var/obj/item/mech_equipment/sleeper/S = loc
	if(istype(S) && occupant)
		S.passive_power_use = 1.5 KILOWATTS

/obj/machinery/sleeper/mounted/go_out()
	..()
	var/obj/item/mech_equipment/sleeper/S = loc
	if(istype(S))
		S.passive_power_use = 0 //No passive power drain when the sleeper is empty. Set to 1.5 KW when patient is inside.

//You cannot modify these, it'd probably end with something in nullspace. In any case basic meds are plenty for an ambulance
/obj/machinery/sleeper/mounted/attackby(obj/item/I, mob/user)
	if(istype(I, /obj/item/reagent_containers/glass))
		if(!user.unEquip(I, src))
			return

		if(beaker)
			beaker.forceMove(get_turf(src))
			user.visible_message(SPAN_NOTICE("\The [user] removes \the [beaker] from \the [src]."), SPAN_NOTICE("You remove \the [beaker] from \the [src]."))
		beaker = I
		user.visible_message(SPAN_NOTICE("\The [user] adds \a [I] to \the [src]."), SPAN_NOTICE("You add \a [I] to \the [src]."))

#define MEDIGEL_SALVE 1
#define MEDIGEL_SCAN  2

/obj/item/mech_equipment/mender
	name = "exosuit medigel-scanner matrix"
	desc = "An exosuit-mounted matrix of medical gel nozzles and radiation emitters designed to treat wounds before transporting patient, with an integrated health scanning suite for field analysis of injuries."
	icon_state = "mech_mender"
	restricted_hardpoints = list(HARDPOINT_LEFT_HAND, HARDPOINT_RIGHT_HAND)
	restricted_software = list(MECH_SOFTWARE_MEDICAL)
	active_power_use = 0 //Usage doesn't really require power. It's per wound
	origin_tech = list(TECH_DATA = 2, TECH_BIO = 3)
	var/list/apply_sounds = list('sound/effects/spray.ogg', 'sound/effects/spray2.ogg', 'sound/effects/spray3.ogg')
	var/mode = MEDIGEL_SALVE
	var/obj/item/device/scanner/health/scanner = null

/obj/item/mech_equipment/mender/attack_self(mob/user)
	if(!.)
		return
	mode = mode == MEDIGEL_SALVE ? MEDIGEL_SCAN : MEDIGEL_SALVE
	to_chat(user, SPAN_NOTICE("You set \the [src] to [mode == MEDIGEL_SALVE ? "dispense medigel" : "scan for injuries"]."))
	update_icon()

/obj/item/mech_equipment/mender/afterattack(atom/target, mob/living/user, inrange, params)
	. = ..()
	if (!.)
		return
	if (mode == MEDIGEL_SALVE)
		if (istype(target, /mob/living/carbon/human))
			var/mob/living/carbon/human/H = target
			var/treated = 0
			var/large_wound = FALSE
			for (var/obj/item/organ/external/organ in H.organs)
				if (BP_IS_ROBOTIC(organ))
					continue
				for (var/datum/wound/W as anything in organ.wounds)
					if (W.bandaged && W.disinfected && W.salved)
						continue
					if (!do_after(user, W.damage / 5, H, DO_MEDICAL))
						break
					var/obj/item/cell/C = owner.get_cell()
					if (istype(C))
						C.use(0.01 KILOWATTS)
						treated = 1
						if (W.current_stage <= W.max_bleeding_stage)
							owner.visible_message(SPAN_NOTICE("\The [owner] covers \a [W.desc] on \the [H]'s [organ.name] with large globs of medigel."))
							large_wound = TRUE
						else if (W.damage_type == INJURY_TYPE_BRUISE)
							owner.visible_message(SPAN_NOTICE("\The [owner] sprays \a [W.desc] on \the [H]'s [organ.name] with a fine layer of medigel."))
						else
							owner.visible_message(SPAN_NOTICE("\The [owner] drizzles some medigel over \a [W.desc] on \the [H]'s [organ.name]."))
						playsound(user, pick(apply_sounds), 20)
						if (large_wound)
							owner.visible_message(SPAN_NOTICE("\The [src]'s UV matrix glows faintly as it cures the medigel."))
							playsound(owner, 'sound/items/Welder2.ogg', 10)
						visible_message(SPAN_NOTICE("\The [user] sprays \a [W.desc] on \the [H]'s [organ.name] with a fine layer of medigel."))
						if (H.stat == UNCONSCIOUS && prob(25))
							to_chat(H, SPAN_NOTICE(SPAN_BOLD("... [pick("feels better", "hurts less")] ...")))
						W.bandage()
						W.disinfect()
						W.salve()
						organ.update_damages()
						H.update_bandages(TRUE)
						update_icon()
					else
						return
			if (treated == 0)
				to_chat(user, SPAN_NOTICE("\The [H] has no injuries in need of medigel."))
	else if(mode == MEDIGEL_SCAN)
		if (istype(target, /mob/living/carbon/human))
			var/mob/living/carbon/human/H = target
			medical_scan_action(H, user, scanner)

/obj/item/device/scanner/health/mech
	name = "exosuit health analyzer"

#undef MEDIGEL_SALVE
#undef MEDIGEL_SCAN