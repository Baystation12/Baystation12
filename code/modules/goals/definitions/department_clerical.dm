/datum/goal/department/paperwork
	var/generated_paperwork = FALSE
	var/waiting_for_signatories_description = "Wait for %STAFF% to arrive and have them sign %PAPERWORK%."
	var/obj/item/paperwork/paperwork_instance
	var/paperwork_type
	var/list/paperwork_types = list(/obj/item/paperwork)
	var/list/signatory_job_list = list(/datum/job)
	var/min_signatories = 1
	var/max_signatories = 1

/datum/goal/department/paperwork/New()
	SSgoals.pending_goals |= src
	var/list/signatory_job_titles = list()
	for(var/job_type in signatory_job_list)
		var/datum/job/job = job_type
		signatory_job_titles |= "[initial(job.total_positions) == 1 ? "the" : "a"] [initial(job.title)]"
	waiting_for_signatories_description = replacetext_char(waiting_for_signatories_description, "%STAFF%", english_list(signatory_job_titles, and_text = " or "))
	if(!length(paperwork_types))
		crash_with("Paperwork goal [type] initialized with no available paperwork types!")
		SSgoals.pending_goals -= src
		return
	paperwork_type = pick(paperwork_types)
	var/obj/item/paperwork/paperwork_type_obj = paperwork_type
	waiting_for_signatories_description = replacetext_char(waiting_for_signatories_description, "%PAPERWORK%", "\the [initial(paperwork_type_obj.name)]")

	..()

/datum/goal/department/paperwork/proc/get_spawn_turfs()
	return

/datum/goal/department/paperwork/proc/get_end_areas()
	return

/datum/goal/department/paperwork/try_initialize()

	var/list/start_candidates = get_spawn_turfs()
	if(!length(start_candidates))
		crash_with("Paperwork goal [type] initialized with no spawn landmarks mapped!")
		SSgoals.pending_goals -= src
		return FALSE

	var/list/end_candidates = get_end_areas()
	if(!length(end_candidates))
		crash_with("Paperwork goal [type] initialized with no end landmarks mapped!")
		SSgoals.pending_goals -= src
		return FALSE

	var/list/signatories = generate_signatory_list()
	if(length(signatories) < min_signatories)
		return FALSE
	shuffle(signatories)
	signatories.Cut(1, max_signatories)

	paperwork_instance = new paperwork_type(pick(start_candidates))
	paperwork_instance.associated_goal = src
	paperwork_instance.must_end_round_in_area = pick(end_candidates)
	paperwork_instance.all_signatories = signatories
	paperwork_instance.needs_signed = paperwork_instance.all_signatories.Copy()
	generated_paperwork = TRUE
	update_strings()
	return TRUE

/datum/goal/department/paperwork/proc/generate_signatory_list()
	. = list()
	for(var/mob/M in GLOB.living_mob_list_)
		if(!M.mind?.assigned_job)
			continue
		for(var/job_type in signatory_job_list)
			if(istype(M.mind.assigned_job, job_type))
				. |= M.real_name
				break

/datum/goal/department/paperwork/update_strings()
	if(!generated_paperwork)
		description = waiting_for_signatories_description
	else if(QDELETED(paperwork_instance))
		var/obj/item/paperwork/paperwork_type_obj = paperwork_type
		description = "\The [initial(paperwork_type_obj.name)] has been destroyed."
	else if(length(paperwork_instance.needs_signed))
		description = "Have \the [paperwork_instance] signed by [english_list(paperwork_instance.all_signatories)]."
	else
		description = "File the completed [paperwork_instance.name] in \the [paperwork_instance.must_end_round_in_area] by the end of the shift."

/datum/goal/department/paperwork/check_success()
	if(!generated_paperwork)
		return TRUE
	. = !QDELETED(paperwork_instance)
	if(.)
		var/turf/T = get_turf(paperwork_instance)
		if(!istype(T))
			return FALSE
		var/area/A = get_area(T)
		if(!istype(A))
			return FALSE
		return !length(paperwork_instance.needs_signed) && (A == paperwork_instance.must_end_round_in_area)

/obj/item/paperwork
	name = "paperwork"
	gender = PLURAL
	desc = "This densely typed sheaf of documents is filled with legalese and jargon. You can't make heads or tails of them."
	icon = 'icons/obj/goal_paperwork.dmi'
	icon_state = "generic"

	var/datum/goal/department/paperwork/associated_goal
	var/list/all_signatories
	var/list/needs_signed
	var/list/has_signed
	var/area/must_end_round_in_area

/obj/item/paperwork/Destroy()
	if(associated_goal)
		if(associated_goal.paperwork_instance == src)
			associated_goal.paperwork_instance = null
			associated_goal.update_strings()
		associated_goal = null
	. = ..()

/obj/item/paperwork/on_update_icon()
	icon_state = "[icon_state][length(has_signed) || ""]"
	
/obj/item/paperwork/examine(mob/user, distance)
	. = ..()
	if(distance <= 1)
		if(length(needs_signed))
			to_chat(user, SPAN_WARNING("It needs [length(needs_signed)] more signature\s before it can be filed: [english_list(needs_signed)]."))
		if(length(has_signed))
			to_chat(user, SPAN_NOTICE("It has been signed by: [english_list(has_signed)]."))

/obj/item/paperwork/attackby(obj/item/W, mob/user)
	if(istype(W, /obj/item/pen))
		if(user.real_name in has_signed)
			to_chat(user, SPAN_WARNING("You have already signed \the [src]."))
			return
		if(!(user.real_name in needs_signed))
			to_chat(user, SPAN_WARNING("You can't see anywhere on \the [src] for you to sign; it doesn't need your signature."))
			return
		LAZYADD(has_signed, user.real_name)
		LAZYREMOVE(needs_signed, user.real_name)
		user.visible_message(SPAN_NOTICE("\The [user] signs \the [src] with \the [W]."))
		associated_goal?.update_strings()
		update_icon()
		return TRUE
	. = ..()
