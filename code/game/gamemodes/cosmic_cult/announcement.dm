var/global/datum/announcement/priority/malign/cosmic_tier_2_announcement = new(do_log = 0, new_sound = 'sound/coscult/tier2.ogg')
var/global/datum/announcement/priority/malign/cosmic_tier_3_announcement = new(do_log = 0, new_sound = 'sound/coscult/tier3.ogg')
var/global/datum/announcement/priority/malign/cosmic_tier_4_announcement = new(do_log = 0, new_sound = 'sound/coscult/tier-finale.ogg')

/datum/announcement/priority/malign
	title = "Lambda-CDM Scanner Update"
	announcement_type = "Lambda-CDM Scanner Update"

/datum/announcement/priority/malign/FormMessage(message as text, message_title as text)
	. = FONT_HUGE(SPAN_CLASS("malign", message_title))
	. += "<br>[SPAN_CLASS("malign", message)]"
