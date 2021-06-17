/mob/living/carbon/alien/chorus/OnSelfTopic(href_list, topic_status)
	if (topic_status == STATUS_INTERACTIVE)
		if(href_list["selected"])
			var/datum/chorus_building/cb = chorus_type.form.get_building_by_type(href_list["selected"])
			if(cb)
				set_selected_building(cb)
			return TOPIC_HANDLED
	return ..()
