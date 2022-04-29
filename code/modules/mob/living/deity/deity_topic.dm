/mob/living/deity/OnSelfTopic(list/href_list)
	if(href_list["form"])
		var/type = locate(href_list["form"]) in subtypesof(/datum/god_form)
		if(type)
			set_form(type)
		return TOPIC_HANDLED
	if(href_list["select_phenomena"])
		nano_data["phenomenaMenu"] = TRUE
		selected = phenomenas[href_list["select_phenomena"]]
		nano_data["selectedPhenomenaName"] = selected.name
		return TOPIC_HANDLED
	if(href_list["clear_selected"])
		nano_data["phenomenaMenu"] = FALSE
		selected = null
		nano_data["selectedPhenomenaName"] = null
		return TOPIC_HANDLED
	if(href_list["select_intent"])
		var/list/intent = intent_phenomenas[href_list["select_intent"]]
		if(intent[href_list["select_binding"]])
			remove_phenomena_from_intent(href_list["select_intent"], href_list["select_binding"], 0)
		if(selected)
			set_phenomena(selected, href_list["select_intent"], href_list["select_binding"])
		update_phenomena_bindings()
		return TOPIC_HANDLED
	if(href_list["jump"])
		var/atom/a = locate(href_list["jump"])
		var/follow = FALSE
		if(href_list["follow"])
			follow = TRUE
		if(a)
			if(following)
				stop_follow()
			eyeobj.setLoc(get_turf(a))
			if(follow)
				follow_follower(a)
			to_chat(src, SPAN_NOTICE("[follow ? "Following" : "Jumping to"] \the [a]"))
		return TOPIC_HANDLED
	if(href_list["buy"])
		var/datum/deity_item/di = locate(href_list["buy"])
		if(di.can_buy(src))
			di.buy(src)
		else
			to_chat(di, SPAN_WARNING("You don't meet all the requirements for [di.name]!"))
		return TOPIC_HANDLED
	if(href_list["switchCategory"])
		set_nano_category(text2num(href_list["switchCategory"]))
		return TOPIC_HANDLED
	if(href_list["switchMenu"])
		nano_data[href_list["menu"]] = text2num(href_list["switchMenu"])
		return TOPIC_HANDLED
	return ..()
