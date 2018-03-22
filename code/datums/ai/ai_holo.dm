/* Used for whether the AI can use a hologram. Mostly self-documenting.
* requires_malf: will display the malf hologram overlay and requires malf mode to be active.
* icon_colorize: if false, the hologram will be decolorized.
*/
/decl/ai_holo
	var/requires_malf = FALSE
	var/icon = 'icons/mob/hologram.dmi'
	var/icon_state = "icon_state"
	var/icon_colorize = FALSE
	var/name


/decl/ai_holo/proc/may_be_used_by_ai(var/mob/living/silicon/ai/AI)
	return !requires_malf || AI.is_malf_or_traitor()

/decl/ai_holo/New()
	..()
	name = icon_state

/decl/ai_holo/default
	icon_state = "Default"

/decl/ai_holo/face
	icon_state = "Face"

/decl/ai_holo/carp
	icon_state = "Carp"

/decl/ai_holo/solgov
	icon_state = "SolGov"

/decl/ai_holo/cursor
	icon_state = "Cursor"

/decl/ai_holo/caution
	icon_state = "Caution"

/decl/ai_holo/chevrons
	icon_state = "Chevrons"

/decl/ai_holo/question
	icon_state = "Question"

/decl/ai_holo/singularity
	icon_state = "Singularity"

/decl/ai_holo/clippy
	requires_malf = TRUE
	icon_state = "malf-clippy"

/decl/ai_holo/malfcursor
	requires_malf = TRUE
	icon_state = "malf-cursor"

/decl/ai_holo/missingno
	requires_malf = TRUE
	icon_colorize = TRUE
	icon_state = "malf-missingno"

/decl/ai_holo/malfsingularity
	icon_state = "malf-singularity"
	requires_malf = TRUE
	icon_colorize = TRUE

/decl/ai_holo/malftcc
	icon_state = "malf-TCC"
	requires_malf = TRUE
	icon_colorize = TRUE