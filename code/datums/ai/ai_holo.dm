/* Used for whether the AI can use a hologram. Mostly self-documenting.
* requires_malf: will display the malf hologram overlay and requires malf mode to be active.
* icon_colorize: if false, the hologram will be decolorized.
*/
/decl/ai_holo
	var/icon = 'icons/mob/hologram.dmi'
	var/icon_state = "icon_state"
	var/icon_colorize = FALSE
	var/name = null
	var/required_ckey = null
	var/faction_lock = null


/decl/ai_holo/proc/may_be_used_by_ai(var/ai_ckey,var/ai_faction)
	return !isnull(name) && (isnull(required_ckey) || required_ckey == ai_ckey) && (isnull(faction_lock) || ai_faction == faction_lock)

/decl/ai_holo/default
	icon_state = "Default"
	name = "Default"

/decl/ai_holo/face
	icon_state = "Face"
	name = "Face"

/decl/ai_holo/carp
	icon_state = "Carp"
	name = "Carp"

/decl/ai_holo/solgov
	icon_state = "SolGov"
	name = "SolGov"

/decl/ai_holo/cursor
	icon_state = "Cursor"
	name = "Cursor"

/decl/ai_holo/caution
	icon_state = "Caution"
	name = "Caution"

/decl/ai_holo/chevrons
	icon_state = "Chevrons"
	name = "Chevrons"

/decl/ai_holo/question
	icon_state = "Question"
	name = "Question"

/decl/ai_holo/singularity
	icon_state = "Singularity"
	name = "Singularity"

/decl/ai_holo/clippy
	icon_state = "malf-clippy"
	name = "Clippy"

/decl/ai_holo/malfcursor
	icon_state = "malf-cursor"
	name = "Malf Cursor"

/decl/ai_holo/missingno
	icon_colorize = TRUE
	icon_state = "malf-missingno"
	name = "Missingno"

/decl/ai_holo/malfsingularity
	icon_state = "malf-singularity"
	icon_colorize = TRUE
	name = "Malf Singularity"