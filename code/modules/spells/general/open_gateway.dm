/spell/open_gateway
	name = "Open Gateway"
	desc = "Open a gateway for your master. Don't do it for too long, or you will die."

	charge_max = 600
	spell_flags = Z2NOCAST
	invocation = "none"
	invocation_type = SpI_NONE

	number_of_channels = 0
	time_between_channels = 200
	hud_state = "const_wall"
	cast_sound = 'sound/effects/meteorimpact.ogg'

/spell/open_gateway/choose_targets()
	var/turf/T = get_turf(holder)
	holder.visible_message("<span class='notice'>A gateway opens up underneath \the [holder]!</span>")
	return list(new /obj/structure/deity/gateway(T,connected_god))

/spell/open_gateway/cast(var/list/targets, var/mob/holder, var/channel_count)
	if(prob((channel_count / 5) * 100))
		to_chat(holder, "<span class='warning'>If you hold the portal open for much longer you'll be ripped apart!</span>")
	if(channel_count == 6)
		to_chat(holder, "<span class='danger'>The gateway consumes you... leaving nothing but dust.</span>")
		holder.dust()


/spell/open_gateway/after_spell(var/list/targets)
	QDEL_NULL_LIST(targets)