/// A generic datum that can be used to invoke effects under certain conditions. Used by changelings, but could be used by other antagonists too.
/datum/power
	var/name = "Power"
	var/desc = "Placeholder"
	var/helptext = ""

	/// The mind of the player that owns this power
	var/datum/mind/mind
	/// If this power is "active" and has its own activation button on the screen
	var/has_button = FALSE
	/// The icon state that will appear on this ability's button. Icon is 'screen_spells.dmi'
	var/button_icon_state

/datum/power/changeling/Destroy()
	on_remove()
	. = ..()

/// Called when the ability is added.
/datum/power/proc/on_add()

/// Called when the ability is removed.
/datum/power/proc/on_remove()

/// Should return TRUE if we can use this power, and FALSE otherwise. Always TRUE by default.
/datum/power/proc/can_activate()
	return TRUE

/// Called before the power activates. This is nominally used to actually call the ability in a normal way, with things such as resource deductions.
/datum/power/proc/pre_activate()

/// The actual effects of this power, overriden on a per-type basis. Does NOT check can_activate().
/datum/power/proc/activate()

/// Whether or not this power is active. Could be used for "toggled" powers.
/datum/power/proc/is_active()
