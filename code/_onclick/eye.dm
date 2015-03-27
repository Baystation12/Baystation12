/mob/living/simple_animal/shade/narsie/DblClickOn(var/atom/A, params)
	if(client.buildmode) // comes after object.Click to allow buildmode gui objects to be clicked
		build_click(src, client.buildmode, params, A)
		return

	sanity_check_eye()
	eyeobj.setLoc(A)
