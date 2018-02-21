SUBSYSTEM_DEF(ghosttraps)
	name = "Ghost Traps"
	priority = SS_PRIORITY_GHOST_TRAPS

	flags = SS_BACKGROUND|SS_POST_FIRE_TIMING|SS_NO_INIT
	wait = 1 SECOND

	var/list/pending_requests = list()
	var/list/pending_requests_by_target = list()

	var/list/current_run = list()

	var/static/priv_default_ghost_trap_settings

/datum/controller/subsystem/ghosttraps/fire(resumed = 0)
	if (!resumed)
		src.current_run = pending_requests.Copy()

	//cache for sanic speed (lists are references anyways)
	var/list/current_run = src.current_run
	var/wait = src.wait

	while(current_run.len)
		var/datum/ghost_trap_setup/GTS = current_run[current_run.len]
		current_run.len--
		if(GTS.Process(wait) == PROCESS_KILL)
			RemoveRequest(GTS.target, FALSE)
		if (MC_TICK_CHECK)
			return

/datum/controller/subsystem/ghosttraps/stat_entry()
	..("Pending Requests: [pending_requests.len]")

/datum/controller/subsystem/ghosttraps/proc/RequestCandidates(var/ghost_trap_type, var/notification_message)
	// Validation
	if(!ispath(ghost_trap_type, /decl/ghost_trap))
		return
	if(args.len < 3)
		return FALSE

	var/list/request_args = args.Copy(3)
	var/datum/target = request_args[1]

	var/decl/ghost_trap/GT = decls_repository.get_decl(ghost_trap_type)
	if(!GT.ValidateRequest(arglist(request_args)))
		return FALSE

	// Remove any prior requests
	var/had_pending_request = RemoveRequest(target)

	// Acquire candidates
	var/list/eager_candidates = list()
	var/list/all_candidates = list()
	for(var/mob/observer/ghost/candidate in SSmobs.mob_list)
		if(!candidate.client)
			continue
		var/preference = candidate.client.wishes_to_be_role(GT.name)
		if(preference == ROLE_DESIRE_NEVER)
			continue
		if(!GT.AssessCandidate(candidate))
			continue

		if(preference == ROLE_DESIRE_ALWAYS)
			eager_candidates += candidate
		all_candidates += candidate

	// Ghost trap setup needs to be prepared ahead of candidate selection
	var/datum/ghost_trap_setup/request = GT.GenerateRequest(arglist(request_args))
	pending_requests_by_target[target] = request
	ADD_SORTED(pending_requests, request, /proc/cmp_ghost_trap_setup)

	if(eager_candidates.len) // If we have any eager candidates randomly pick one
		GT.TransferCandidate(target, pick(eager_candidates))
	else if(!had_pending_request) // We only notify candidates if there were no prior pending requests
		request.NotifyCandidates(notification_message, all_candidates)
	return TRUE

/datum/controller/subsystem/ghosttraps/proc/AssessTargetAndCandidate(var/ghost_trap_type, var/datum/target, var/mob/observer/ghost/candidate)
	if(!ispath(ghost_trap_type, /decl/ghost_trap))
		return FALSE
	var/decl/ghost_trap/GT = decls_repository.get_decl(ghost_trap_type)
	var/datum/ghost_trap_setup/GTS = pending_requests_by_target[target] || PrivDefaultSettings()
	if(!GT.AssessTargetAndCandidate(target, candidate, GTS))
		return FALSE
	return TRUE

/datum/controller/subsystem/ghosttraps/proc/TransferCandidate(var/ghost_trap_type, var/datum/target, var/mob/observer/ghost/candidate)
	if(!ispath(ghost_trap_type, /decl/ghost_trap))
		return

	if(!AssessTargetAndCandidate(ghost_trap_type, target, candidate))
		return

	var/datum/ghost_trap_setup/GTS = pending_requests_by_target[target] || PrivDefaultSettings()
	var/decl/ghost_trap/GT = decls_repository.get_decl(ghost_trap_type)
	if(GT.TransferCandidate(target, candidate, GTS))
		RemoveRequest(target)

/datum/controller/subsystem/ghosttraps/proc/RemoveRequest(var/datum/target, var/validate = TRUE)
	var/datum/ghost_trap_setup/GTS = pending_requests_by_target[target]
	if(GTS)
		. = validate && GTS.Validate()
		pending_requests_by_target -= target
		pending_requests -= GTS
		GTS.OnRequestWithdrawn()
		qdel(GTS)
		return TRUE
	return FALSE

/datum/controller/subsystem/ghosttraps/proc/AskTransfer(var/ghost_trap_type, var/datum/target, var/mob/observer/ghost/candidate)
	if(!AssessTargetAndCandidate(ghost_trap_type, target, candidate))
		return
	var/decl/ghost_trap/GT = decls_repository.get_decl(ghost_trap_type)
	if(alert(candidate, "Are you sure you wish to possess \the [target]?", GT.name, "Yes", "No") == "Yes")
		TransferCandidate(ghost_trap_type, target, candidate)

/datum/controller/subsystem/ghosttraps/Recover()
	if(istype(SSghosttraps.pending_requests))
		pending_requests = SSghosttraps.pending_requests

/datum/controller/subsystem/ghosttraps/proc/PrivDefaultSettings()
	. = priv_default_ghost_trap_settings
	if(!.)
		var/decl/ghost_trap/GT = decls_repository.get_decl(/decl/ghost_trap)
		priv_default_ghost_trap_settings = new/datum/ghost_trap_setup(src, GT, INFINITY)
		. = priv_default_ghost_trap_settings

/datum/controller/subsystem/ghosttraps/Topic(href, href_list)
	if((. = ..()))
		return
	if(href_list["ghost_trap_type"] && href_list["target"] && href_list["candidate"])
		AskTransfer(locate(href_list["ghost_trap_type"]), locate(href_list["target"]), locate(href_list["candidate"]))
		return TRUE

var/const/GHOST_TRAP_FLAG_HAS_CANDIDACY = 0x0001
var/const/GHOST_TRAP_FLAG_SET_OWN_NAME  = 0x0002
var/const/GHOST_TRAP_FLAG_STRICT_SETUP  = 0x0004

/*************
* Ghost Trap *
*************/

/decl/ghost_trap
	var/name
	var/timeout = INFINITY

	var/transfer_message

	var/list/ban_checks = list()
	var/trap_flags = GHOST_TRAP_FLAG_HAS_CANDIDACY

	var/target_type = /datum
	var/setup_type = /datum/ghost_trap_setup

/decl/ghost_trap/proc/IsBanned(var/mob/M)
	for(var/ban_type in ban_checks)
		if(jobban_isbanned(M, ban_type))
			return TRUE
	return FALSE

/decl/ghost_trap/proc/ValidateRequest(var/datum/target)
	return AssessTarget(target)

/decl/ghost_trap/proc/GenerateRequest()
	var/target = args[1]
	var/arguments = list(target, src, timeout)
	if(args.len > 1)
		arguments |= args.Copy(2)
	return new setup_type(arglist(arguments))

/decl/ghost_trap/proc/AssessTarget(var/datum/target, var/datum/ghost_trap_setup/ghost_trap_setup)
	return istype(target, target_type) && target.AssessSelf()

/decl/ghost_trap/proc/AssessCandidate(var/mob/observer/ghost/candidate, var/datum/ghost_trap_setup/ghost_trap_setup, var/feedback = FALSE)
	return istype(candidate) && !IsBanned(candidate) && candidate.MayRespawn(feedback)

/decl/ghost_trap/proc/AssessTargetAndCandidate(var/datum/target, var/mob/observer/ghost/candidate, var/datum/ghost_trap_setup/ghost_trap_setup)
	if((trap_flags & GHOST_TRAP_FLAG_STRICT_SETUP) && ghost_trap_setup.type != setup_type)
		return FALSE
	if(!AssessTarget(target, ghost_trap_setup))
		return FALSE
	if(!AssessCandidate(candidate, ghost_trap_setup, TRUE))
		return FALSE
	return ghost_trap_setup.Validate()

/decl/ghost_trap/proc/TransferCandidate(var/datum/target, var/mob/observer/ghost/candidate, var/datum/ghost_trap_setup/ghost_trap_setup)
	announce_ghost_joinleave(candidate, 0, transfer_message)
	var/mob/M = target.ReceiveCandidate(candidate, src, ghost_trap_setup)

	if(istype(M) && (trap_flags & GHOST_TRAP_FLAG_SET_OWN_NAME))
		var/timeout = world.time + 60 SECONDS
		var/newname = sanitizeSafe(input(candidate,"You have 60 seconds to select a name.", "Name change", M.real_name) as null|text, MAX_NAME_LEN)
		if (world.time <= timeout && newname && newname != M.real_name)
			M.fully_replace_character_name(newname)
	return M

/*******************
* Ghost Trap Setup *
*******************/
/datum/ghost_trap_setup
	var/name
	var/decl/ghost_trap/ghost_trap

	var/datum/target
	var/times_out_at = INFINITY

	var/obj/effect/stat_button

	var/abort_request_callback        // If there are situations other than possession or timeout that will invalidate the request. Args: var/datum/target, abort_request_callback_args (as individual arguments)
	var/abort_request_callback_args

	var/timeout_callback              // On request timeout this is called. Args: var/datum/target,timeout_callback_args (as individual arguments)
	var/list/timeout_callback_args

/datum/ghost_trap_setup/New(var/target, var/decl/ghost_trap/ghost_trap, var/timeout)
	name = ghost_trap.name
	src.target = target
	src.ghost_trap = ghost_trap
	times_out_at = world.time + timeout

/datum/ghost_trap_setup/Destroy()
	QDEL_NULL(stat_button)
	ghost_trap = null
	target = null

	abort_request_callback_args = null
	timeout_callback_args = null

	. = ..()


/datum/ghost_trap_setup/Process()
	if(!Validate())
		return PROCESS_KILL

/datum/ghost_trap_setup/proc/Validate()
	if(world.time > times_out_at)
		OnTimeout()
		return FALSE

	if(!AccessTarget())
		return FALSE

	if(abort_request_callback)
		var/arguments = list(target) | (abort_request_callback_args || list())
		if(call(abort_request_callback)(arguments))
			return FALSE

	return TRUE

/datum/ghost_trap_setup/proc/AccessTarget()
	return ghost_trap.AssessTarget(target)

/datum/ghost_trap_setup/proc/OnTimeout()
	if(timeout_callback)
		var/arguments = list(target) | (timeout_callback_args || list())
		call(timeout_callback)(arglist(arguments))


/datum/ghost_trap_setup/proc/OnRequestWithdrawn()
	return

/datum/ghost_trap_setup/proc/NotifyCandidates(var/notification_message, var/list/candidates)
	for(var/candidate in candidates)
		var/mob/observer/ghost/G = candidate
		var/ghost_link = ghost_follow_link(src, G, "", "\[", "\]")
		to_chat(candidate, "<span class='notice'>[ghost_link] [notification_message]</span>")

/datum/ghost_trap_setup/proc/AskTransfer(var/user)
	SSghosttraps.AskTransfer(ghost_trap.type, target, user)

/datum/ghost_trap_setup/extra_ghost_link(var/atom/ghost, var/prefix, var/sufix, var/short_links)
	. = target.extra_ghost_link(ghost, prefix, sufix, short_links)
	var/text = short_links ? "P" : "Possess"
	. += "<a href='byond://?src=\ref[SSghosttraps];ghost_trap_type=\ref[ghost_trap.type];target=\ref[target];candidate=\ref[ghost]'>[prefix][text][sufix]</a>"

/datum/ghost_trap_setup/proc/StatButton()
	if(!target)
		return
	if(!stat_button)
		stat_button = new /obj/effect/ghost_trap_button(src)
	stat_button.name = "[target] ([times_out_at == INFINITY ? "INF" : "[round(max(0, (times_out_at - world.time) / 10))] second\s"])"
	return stat_button

/obj/effect/ghost_trap_button
	var/datum/ghost_trap_setup/ghost_trap_setup

/obj/effect/ghost_trap_button/New(var/ghost_trap_setup)
	..(null)
	src.ghost_trap_setup = ghost_trap_setup

/obj/effect/ghost_trap_button/Destroy()
	ghost_trap_setup = null
	. = ..()

/obj/effect/ghost_trap_button/Click()
	var/atom/A = ghost_trap_setup.target
	if(istype(A))
		A.DblClick()

/obj/effect/ghost_trap_button/DblClick()
	ghost_trap_setup.AskTransfer(usr)

/*
	Assist procs
*/

/mob/observer/ghost/Stat()
	. = ..()
	if(. && statpanel("Ghost Traps"))
		if(SSghosttraps.pending_requests.len)
			for(var/entry in SSghosttraps.pending_requests)
				var/datum/ghost_trap_setup/GTS = entry
				stat(GTS.name, GTS.StatButton())
		else
			stat("No ghost traps available.")

/datum/proc/AssessSelf()
	return !QDELETED(src)

/mob/AssessSelf()
	return stat != DEAD && !ckey && !client && ..()

/datum/proc/ReceiveCandidate(var/mob/observer/ghost/candidate, var/decl/ghost_trap/ghost_trap, var/datum/ghost_trap_setup/ghost_trap_setup)
	return

/mob/ReceiveCandidate(var/mob/observer/ghost/candidate, var/decl/ghost_trap/ghost_trap, var/datum/ghost_trap_setup/ghost_trap_setup)
	..()
	ckey = candidate.ckey
	if(mind)
		mind.assigned_role = "[ghost_trap.name]"
	return src


/*****************************
* Ghost Trap Implementations *
*****************************/
/* Maintenance Drone */
/decl/ghost_trap/maintenance_drone
	name = "Maintenance Drone"
	timeout = 30 SECONDS
	target_type = /mob/living/silicon/robot/drone

/decl/ghost_trap/maintenance_drone/AssessTarget()
	return !too_many_active_drones() && ..()

/* Cortical Borer */
/decl/ghost_trap/cortical_borer
	name = "Cortical Borer"
	target_type = /mob/living/simple_animal/borer

/* Diona Nymph */
/decl/ghost_trap/diona_nymph
	name = "Diona Nymph"
	timeout = 1 MINUTE
	target_type = /mob/living/carbon/alien/diona

/decl/ghost_trap/diona_nymph/GenerateRequest()
	var/datum/ghost_trap_setup/GTS = ..()
	GTS.timeout_callback = /proc/kill_unpossessed_mob
	return GTS

/* Plant */
/decl/ghost_trap/plant
	name = "Plant"
	timeout = 15 SECONDS
	target_type = /mob/living

/decl/ghost_trap/plant/GenerateRequest(var/target,var/seed_type)
	var/datum/ghost_trap_setup/GTS = ..()
	GTS.timeout_callback = /proc/kill_unpossessed_plant
	GTS.timeout_callback_args = list(seed_type)
	return GTS

/proc/kill_unpossessed_plant(var/mob/living/target, var/seed_type)
	if(!kill_unpossessed_mob(target))
		return
	target.visible_message("<span class='danger'>\The [host] is malformed and unable to survive. It expires pitifully, leaving behind some seeds.</span>")
	var/total_yield = rand(1,3)
	for(var/j = 0;j<=total_yield;j++)
		var/obj/item/seeds/S = new(get_turf(target))
		S.seed_type = seed_type
		S.update_seed()

/* Shade  */
/decl/ghost_trap/shade
	name = "Soul Stone Shade"

/* Positronic Brain */
/decl/ghost_trap/positronic
	name = "Positronic Brain"
	timeout = 1 MINUTE
	target_type = /obj/item/organ/internal/posibrain
	setup_type = /datum/ghost_trap_setup/positronic
	trap_flags = (GHOST_TRAP_FLAG_HAS_CANDIDACY|GHOST_TRAP_FLAG_SET_OWN_NAME)

/decl/ghost_trap/positronic/TransferCandidate(var/obj/item/organ/internal/posibrain/target, var/mob/observer/ghost/candidate)
	. = ..()
	target.brainmob.fully_replace_character_name("positronic brain ([target.brainmob.name])")
	target.searching = FALSE
	target.update_icon()

/datum/ghost_trap_setup/positronic/New(var/obj/item/organ/internal/posibrain/target)
	..()
	target.searching = TRUE
	target.update_icon()

/datum/ghost_trap_setup/positronic/OnTimeout()
	OnRequestWithdrawn()
	var/atom/A = target
	A.visible_message("<span class='notice'>The positronic brain buzzes quietly, and the golden lights fade away. Perhaps you could try again?</span>", "<span class='notice'>You hear a quiet buzz.</span>")

/datum/ghost_trap_setup/positronic/OnRequestWithdrawn()
	var/obj/item/organ/internal/posibrain/PB = target
	if(PB.searching)
		PB.searching = FALSE
		PB.update_icon()

/obj/item/organ/internal/posibrain/AssessSelf()
	return brainmob && brainmob.AssessSelf()

/obj/item/organ/internal/posibrain/ReceiveCandidate(var/mob/observer/ghost/candidate, var/decl/ghost_trap/ghost_trap)
	return brainmob.ReceiveCandidate(candidate, ghost_trap)

/* Wizard Familiar */
/decl/ghost_trap/wizard_familiar
	name = "Wizard Familiar"
	timeout = 1 MINUTE
	target_type = /atom
	setup_type = /datum/ghost_trap_setup/wizard
	trap_flags = (GHOST_TRAP_FLAG_HAS_CANDIDACY|GHOST_TRAP_FLAG_SET_OWN_NAME|GHOST_TRAP_FLAG_STRICT_SETUP)

/decl/ghost_trap/wizard_familiar/ValidateRequest(var/turf/target, var/mob/wizard, var/obj/item/weapon/monster_manual/monster_manual, var/familiar_path)
	return !(locate(/obj/effect/wizard_summon_circle) in target) && ispath(familiar_path, /mob/living/simple_animal/familiar) && asses_wizard_familiar_setup(target, wizard, monster_manual) && ..()

/datum/ghost_trap_setup/wizard
	var/obj/effect/wizard_summon_circle/wizard_summon_circle
	var/mob/wizard
	var/obj/item/weapon/monster_manual/monster_manual
	var/familiar_path

/datum/ghost_trap_setup/wizard/New(var/turf/target, var/decl/ghost_trap/ghost_trap, var/timeout, var/mob/wizard, var/obj/item/weapon/monster_manual/monster_manual, var/familiar_path)
	src.wizard = wizard
	src.monster_manual = monster_manual
	wizard_summon_circle = new(target)
	src.familiar_path = familiar_path

	var/arguments = args.Copy()
	arguments[1] = wizard_summon_circle
	..(arglist(arguments))

/datum/ghost_trap_setup/wizard/Destroy()
	wizard = null
	monster_manual = null
	QDEL_NULL(wizard_summon_circle)
	. = ..()

/datum/ghost_trap_setup/wizard/Validate()
	return asses_wizard_familiar_setup(get_turf(wizard_summon_circle), wizard, monster_manual) && ..()

/obj/effect/wizard_summon_circle
	name = "Summoning Circle"
	anchored = TRUE
	simulated = FALSE
	icon = 'icons/obj/rune.dmi'
	icon_state = "wizard_mark"

/obj/effect/wizard_summon_circle/Initialize()
	. = ..()
	set_light(4, 2, COLOR_SUN)

/obj/effect/wizard_summon_circle/ReceiveCandidate(var/mob/observer/ghost/candidate, var/decl/ghost_trap/ghost_trap, var/datum/ghost_trap_setup/wizard/GTS)
	GTS.monster_manual.uses--
	var/mob/familiar = new GTS.familiar_path(get_turf(src))
	return familiar.ReceiveCandidate(candidate, ghost_trap, GTS)

/proc/asses_wizard_familiar_setup(var/turf/target, var/mob/wizard, var/obj/item/weapon/monster_manual/monster_manual)
	if(QDELETED(wizard) || QDELETED(monster_manual))
		return FALSE
	if(wizard.stat == DEAD)
		return FALSE
	if(monster_manual.uses < 1)
		return FALSE
	return TRUE
