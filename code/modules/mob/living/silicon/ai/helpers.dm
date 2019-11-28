
/proc/get_ais_in_network(var/net_name,var/native_net)
	var/list/ais_in_net = list()
	for(var/ai_untyped in ai_list)
		var/mob/living/silicon/ai/ai = ai_untyped
		if(ai.network == net_name || ai.native_network == native_net)
			ais_in_net += ai
	return ais_in_net