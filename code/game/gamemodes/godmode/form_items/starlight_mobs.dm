/mob/living/starlight_soul
	name = "soul"
	desc = "A captured soul."

/mob/living/starlight_soul/Initialize(var/maploading, var/mob/living/old_mob)
	. = ..()
	var/mob/observer/eye/cult/C = new(src)
	C.suffix = "Soul"
	if(old_mob)
		name = old_mob.real_name
	eyeobj = C

/mob/living/starlight_soul/proc/set_deity(var/mob/living/deity/deity)
	var/mob/observer/eye/eye = eyeobj
	eyeobj.release(src)
	eyeobj.visualnet = deity.eyeobj.visualnet
	GLOB.godcult.add_antagonist_mind(src.mind,1,"lost soul of [deity]", "You have been captured by \the [deity]! You now can only see into your own reality through the same rips and tears it uses. Your only chance at another body will be one in your captor's image...",specific_god=deity)
	eye.possess(src)

/mob/living/starlight_soul/Destroy()
	QDEL_NULL(eyeobj)
	. = ..()