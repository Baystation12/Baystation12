#define CODEX_INTERACTIONS_LIST list(\
	"CODEX_INTERACTION_ALT_CLICK", "CODEX_INTERACTION_ALT_SHIFT_CLICK", "CODEX_INTERACTION_CTRL_CLICK",\
	"CODEX_INTERACTION_CTRL_ALT_CLICK", "CODEX_INTERACTION_CTRL_ALT_SHIFT_CLICK", "CODEX_INTERACTION_CTRL_SHIFT_CLICK",\
	"CODEX_INTERACTION_SHIFT_CLICK", "CODEX_INTERACTION_USE_SELF", "CODEX_INTERACTION_HAND",\
	"CODEX_INTERACTION_ID_CARD", "CODEX_INTERACTION_SCREWDRIVER", "CODEX_INTERACTION_WELDER",\
	"CODEX_INTERACTION_GRAB", "CODEX_INTERACTION_GRAB_PASSIVE", "CODEX_INTERACTION_GRAB_AGGRESSIVE",\
	"CODEX_INTERACTION_GRAB_NECK", "CODEX_INTERACTION_EMAG", "CODEX_INTERACTION_EMP"\
)

//Vars that will not be copied when using /DuplicateObjectDeep
GLOBAL_LIST_INIT(duplicate_forbidden_vars, list(
	"tag", "datum_components", "area", "type", "loc", "locs", "vars", "parent", "parent_type", "verbs", "ckey", "key",
	"power_supply", "contents", "reagents", "stat", "x", "y", "z", "group", "atmos_adjacent_turfs", "comp_lookup",
	"important_recursive_contents", "bodyparts", "internal_organs", "hand_bodyparts", "overlays_standing", "hud_list",
	"actions", "AIStatus", "appearance", "managed_overlays", "managed_vis_overlays", "computer_id", "lastKnownIP", "implants",
	"tgui_shared_states", "overlays", "underlays"
)+CODEX_INTERACTIONS_LIST)

#undef CODEX_INTERACTIONS_LIST

#define IS_REF_AND_NOT_SINGLETON(A) ((istype(A, /datum) && !istype(A, /singleton)) || ismob(A) )

/proc/DuplicateObjectDeep(atom/original, perfectcopy = TRUE, sameloc, atom/newloc = null)
	RETURN_TYPE(original.type)
	if(!original)
		return
	var/atom/O
	if(sameloc)
		O = new original.type(original.loc)
	else
		O = new original.type(newloc)

	if(perfectcopy && O && original)

		for(var/V in original.vars - GLOB.duplicate_forbidden_vars)
			if(islist(original.vars[V]))
				var/skipFlag = FALSE
				for (var/key in original.vars[V])
					var/value = original.vars[V][key]
					if (IS_REF_AND_NOT_SINGLETON(key) || IS_REF_AND_NOT_SINGLETON(value))
						skipFlag = TRUE
						break
				if (skipFlag)
					continue
				var/list/L = original.vars[V]
				O.vars[V] = L.Copy()
			else if(IS_REF_AND_NOT_SINGLETON(original.vars[V]))
				continue // This would reference the original's object, that will break when it is used or deleted
			else
				O.vars[V] = original.vars[V]

	if(isobj(O))
		var/obj/N = O
		N.update_icon()
		if(istype(O, /obj/machinery))
			var/obj/machinery/M = O
			M.power_change()

	if(ismob(O)) // Overlays are carried over despite disallowing them, if a fix is found remove this
		var/mob/M = O
		M.cut_overlays()
		M.regenerate_icons()
	return O

#undef IS_REF_AND_NOT_SINGLETON
