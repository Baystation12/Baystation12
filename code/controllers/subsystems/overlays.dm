SUBSYSTEM_DEF(overlays)
	name = "Overlay"
	wait = 1
	priority = SS_PRIORITY_OVERLAYS
	init_order = SS_INIT_ORDER_OVERLAY
	runlevels = RUNLEVEL_LOBBY | RUNLEVELS_DEFAULT

	var/list/processing = list()

	var/idex = 1
	var/list/overlay_icon_state_caches = list()
	var/list/overlay_icon_cache = list()

/datum/controller/subsystem/overlays/UpdateStat(text)
	..("Ov:[processing.len - (idex - 1)]")

/datum/controller/subsystem/overlays/Initialize()
	Flush()
	. = ..()

/datum/controller/subsystem/overlays/Recover()
	overlay_icon_state_caches = SSoverlays.overlay_icon_state_caches
	overlay_icon_cache = SSoverlays.overlay_icon_cache
	processing = SSoverlays.processing

/datum/controller/subsystem/overlays/fire(resumed = FALSE, mc_check = TRUE)
	var/list/processing = src.processing
	while(idex <= processing.len)
		var/atom/thing = processing[idex++]

		if(!QDELETED(thing) && thing.overlay_queued)	// Don't double-process if something already forced a compile.
			thing.compile_overlays()

		if(mc_check)
			if(MC_TICK_CHECK)
				break
		else
			CHECK_TICK

	if (idex > 1)
		processing.Cut(1, idex)
		idex = 1

/datum/controller/subsystem/overlays/proc/Flush()
	if(processing.len)
		log_ss("overlays", "Flushing [processing.len] overlays.")
		fire(mc_check = FALSE)

/atom/proc/compile_overlays()
	var/list/oo = our_overlays
	var/list/po = priority_overlays
	if(LAZYLEN(po) && LAZYLEN(oo))
		overlays = oo + po
	else if(LAZYLEN(oo))
		overlays = oo
	else if(LAZYLEN(po))
		overlays = po
	else
		overlays.Cut()

	overlay_queued = FALSE

/proc/iconstate2appearance(icon, iconstate)
	var/static/image/stringbro = new()
	var/list/icon_states_cache = SSoverlays.overlay_icon_state_caches
	var/list/cached_icon = icon_states_cache[icon]
	if (cached_icon)
		var/cached_appearance = cached_icon["[iconstate]"]
		if (cached_appearance)
			return cached_appearance
	stringbro.icon = icon
	stringbro.icon_state = iconstate
	if (!cached_icon) //not using the macro to save an associated lookup
		cached_icon = list()
		icon_states_cache[icon] = cached_icon
	var/cached_appearance = stringbro.appearance
	cached_icon["[iconstate]"] = cached_appearance
	return cached_appearance

/proc/icon2appearance(icon)
	var/static/image/iconbro = new()
	var/list/icon_cache = SSoverlays.overlay_icon_cache
	. = icon_cache[icon]
	if (!.)
		iconbro.icon = icon
		. = iconbro.appearance
		icon_cache[icon] = .

#define APPEARANCEIFY(origin, target) \
	if (istext(origin)) { \
		target = iconstate2appearance(icon, origin); \
	} \
	else if (isicon(origin)) { \
		target = icon2appearance(origin); \
	} \
	else { \
		appearance_bro.appearance = origin; \
		if (!ispath(origin)) { \
			appearance_bro.dir = origin.dir; \
		} \
		target = appearance_bro.appearance; \
	}

/atom/proc/build_appearance_list(atom/new_overlays)
	var/static/image/appearance_bro = new
	if (islist(new_overlays))
		listclearnulls(new_overlays)
		for (var/i in 1 to length(new_overlays))
			var/image/cached_overlay = new_overlays[i]
			APPEARANCEIFY(cached_overlay, new_overlays[i])
		return new_overlays
	else
		APPEARANCEIFY(new_overlays, .)

#undef APPEARANCEIFY
#define NOT_QUEUED_ALREADY (!(overlay_queued))
#define QUEUE_FOR_COMPILE overlay_queued = TRUE; SSoverlays.processing += src;

/atom/proc/cut_overlays(priority = FALSE)
	var/list/cached_overlays = our_overlays
	var/list/cached_priority = priority_overlays

	var/need_compile = FALSE

	if(LAZYLEN(cached_overlays)) //don't queue empty lists, don't cut priority overlays
		cached_overlays.Cut()  //clear regular overlays
		need_compile = TRUE

	if(priority && LAZYLEN(cached_priority))
		cached_priority.Cut()
		need_compile = TRUE

	if(NOT_QUEUED_ALREADY && need_compile)
		QUEUE_FOR_COMPILE

/atom/proc/cut_overlay(list/overlays_list, priority)
	if(!overlays_list)
		return

	overlays_list = build_appearance_list(overlays_list)

	var/list/cached_overlays = our_overlays	//sanic
	var/list/cached_priority = priority_overlays
	var/init_o_len = LAZYLEN(cached_overlays)
	var/init_p_len = LAZYLEN(cached_priority)  //starter pokemon

	LAZYREMOVE(cached_overlays, overlays_list)
	if(priority)
		LAZYREMOVE(cached_priority, overlays_list)

	if(NOT_QUEUED_ALREADY && ((init_o_len != LAZYLEN(cached_priority)) || (init_p_len != LAZYLEN(cached_overlays))))
		QUEUE_FOR_COMPILE

/atom/proc/add_overlay(list/overlays_list, priority = FALSE)
	if(!overlays_list)
		return

	overlays_list = build_appearance_list(overlays_list)

	if (!overlays_list || (islist(overlays_list) && !overlays_list.len))
		// No point trying to compile if we don't have any overlays.
		return

	if(priority)
		LAZYADD(priority_overlays, overlays_list)
	else
		LAZYADD(our_overlays, overlays_list)

	if(NOT_QUEUED_ALREADY)
		QUEUE_FOR_COMPILE

/atom/proc/set_overlays(list/overlays_list, priority = FALSE)	// Sets overlays to a list, equivalent to cut_overlays() + add_overlays().
	if (!overlays_list)
		return

	overlays_list = build_appearance_list(overlays_list)

	if (priority)
		LAZYCLEARLIST(priority_overlays)
		if (overlays_list)
			LAZYADD(priority_overlays, overlays_list)
	else
		LAZYCLEARLIST(our_overlays)
		if (overlays_list)
			LAZYADD(our_overlays, overlays_list)

	if (NOT_QUEUED_ALREADY)
		QUEUE_FOR_COMPILE

/atom/proc/copy_overlays(atom/other, cut_old = FALSE)	//copys our_overlays from another atom
	if(!other)
		if(cut_old)
			cut_overlays()
		return

	var/list/cached_other = other.our_overlays
	if(cached_other)
		if(cut_old)
			our_overlays = cached_other.Copy()
		else
			our_overlays |= cached_other
		if(NOT_QUEUED_ALREADY)
			QUEUE_FOR_COMPILE
	else if(cut_old)
		cut_overlays()

#undef NOT_QUEUED_ALREADY
#undef QUEUE_FOR_COMPILE

//TODO: Better solution for these?
/image/proc/add_overlay(x)
	overlays += x

/image/proc/cut_overlay(x)
	overlays -= x

/image/proc/cut_overlays(x)
	overlays.Cut()

/atom
	var/tmp/list/our_overlays	//our local copy of (non-priority) overlays without byond magic. Use procs in SSoverlays to manipulate
	var/tmp/list/priority_overlays	//overlays that should remain on top and not normally removed when using cut_overlay functions, like c4.
	var/tmp/overlay_queued
