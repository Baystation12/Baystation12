/proc/cosmic_cult_siphon_vfx(atom/target, client/viewer, duration = 1 SECOND)
	if (!viewer)
		return

	var/image/vfx = image('icons/coscult/ability-siphon.dmi', target, "vfx")
	vfx.pixel_y = 26
	vfx.transform = matrix().Scale(0.65, 0.65)
	vfx.plane = EFFECTS_ABOVE_LIGHTING_PLANE
	vfx.layer = ABOVE_LIGHTING_LAYER
	vfx.appearance_flags = DEFAULT_APPEARANCE_FLAGS | RESET_TRANSFORM
	viewer.images += vfx
	addtimer(new Callback(GLOBAL_PROC, GLOBAL_PROC_REF(cosmic_cult_remove_client_image), viewer, vfx), duration)
	usr.playsound_local(null, 'sound/coscult/ability-siphon.ogg', 75, FALSE)

/proc/cosmic_cult_remove_client_image(client/viewer, image/I)
	if (viewer)
		viewer.images -= I
