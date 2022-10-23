/* Used for whether the AI can use a hologram. Mostly self-documenting.
* requires_malf: will display the malf hologram overlay and requires malf mode to be active.
* bypass_colorize: if false, the hologram will be decolorized.
*/
/singleton/ai_holo
	var/requires_malf = FALSE
	var/icon = 'icons/mob/hologram.dmi'
	var/icon_state = "icon_state"
	var/bypass_colorize = FALSE
	var/name


/singleton/ai_holo/proc/may_be_used_by_ai(mob/living/silicon/ai/AI)
	return !requires_malf || AI.is_malf_or_traitor()

/singleton/ai_holo/New()
	..()
	name = icon_state

/singleton/ai_holo/default
	icon_state = "Default"

/singleton/ai_holo/face
	icon_state = "Face"

/singleton/ai_holo/carp
	icon_state = "Carp"

/singleton/ai_holo/solgov
	icon_state = "SolGov"

/singleton/ai_holo/info
	icon_state = "Info"

/singleton/ai_holo/cursor
	icon_state = "Cursor"

/singleton/ai_holo/caution
	icon_state = "Caution"

/singleton/ai_holo/chevrons
	icon_state = "Chevrons"

/singleton/ai_holo/question
	icon_state = "Question"

/singleton/ai_holo/singularity
	icon_state = "Singularity"

/singleton/ai_holo/nullicon
	icon_state = "null"

/singleton/ai_holo/cat
	icon_state = "Cat"

/singleton/ai_holo/clippy
	name = "Clippy"
	icon_state = "clippy"

/singleton/ai_holo/malfcursor
	name = "Middle Finger"
	requires_malf = TRUE
	icon_state = "malf-cursor"

/singleton/ai_holo/missingno
	name = "MissingNo"
	requires_malf = TRUE
	bypass_colorize = TRUE
	icon_state = "malf-missingno"

/singleton/ai_holo/malfsingularity
	name = "Singularity"
	icon_state = "malf-singularity"
	requires_malf = TRUE
	bypass_colorize = TRUE

/singleton/ai_holo/malftcc
	name = "TCC"
	icon_state = "malf-TCC"
	requires_malf = TRUE
	bypass_colorize = TRUE
