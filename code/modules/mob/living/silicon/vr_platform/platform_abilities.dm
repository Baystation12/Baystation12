/mob/living/silicon/platform/proc/activate(var/mob/living/M)
	active = 1
	user_body = M
	M.mind.transfer_to(src)
	add_platform_verbs()
	src << "\blue <b>Platform ready.</b>"

/mob/living/silicon/platform/verb/platform_disconnect()
	set name = "Disconnect"
	set desc = "Disconnect the VR uplink."
	set category = "Virtual Reality"

	src << "Unlocking neural clamp..."
	sleep(70)
	src << "<b>Unlocked</b>."

	remove_platform_verbs()

	src.mind.transfer_to(user_body)

	active = 0
	user_body = null

var/list/platform_verbs_default = list(
	/mob/living/silicon/platform/verb/platform_disconnect
)