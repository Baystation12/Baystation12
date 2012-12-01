/obj/effect/sign/barsign
	icon = 'barsigns.dmi'
	icon_state = "empty"
	anchored = 1
	New()
		ChangeSign(pick("pinkflamingo", "magmasea", "limbo", "rustyaxe", "armokbar", "brokendrum", "meadbay", "thedamnwall", "thecavern", "cindikate", "theorchard", "thesaucyclown", "theclownshead"))
		return
	proc/ChangeSign(var/Text)
		src.icon_state = "[Text]"
		//on = 0
		//brightness_on = 4 //uncomment these when the lighting fixes get in
		return

/obj/effect/sign/securearea/ex_act(severity)
	switch(severity)
		if(1.0)
			del(src)
			return
		if(2.0)
			del(src)
			return
		if(3.0)
			del(src)
			return
		else
	return

/obj/effect/sign/securearea/blob_act()
	del(src)
	return


/obj/effect/sign/ex_act(severity)
	switch(severity)
		if(1.0)
			del(src)
			return
		if(2.0)
			del(src)
			return
		if(3.0)
			del(src)
			return
		else
	return

/obj/effect/sign/blob_act()
	del(src)
	return