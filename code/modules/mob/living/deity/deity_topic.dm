/mob/living/deity/Topic(var/href, var/list/href_list)
	if(..())
		return 1
	if(href_list["form"])
		var/type = text2path(href_list["form"])
		set_form(type)
		return
	if(href_list["join_cult"])
		var/mob/living/user = usr
		if(!user)
			return
		take_charge(user, 300)
		godcult.add_antagonist_mind(user.mind,1,"a follower of [src]. May it bless you with powers unknown in return for your loyalty.", "Servant of [src]", specific_god=src)
	if(href_list["pylon"])
		var/atom/a = locate(href_list["pylon"])
		if(a)
			eyeobj.forceMove(get_turf(a))
			to_chat(src, "<span class='notice'>Jumping to \the [a]</span>")