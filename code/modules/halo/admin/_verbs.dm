
/hook/startup/proc/halo_admin_verbs()
	admin_verbs_fun.Add(/client/proc/covenant_announcement)
	admin_verbs_hideable.Add(/client/proc/covenant_announcement)

	admin_verbs_fun.Add(/client/proc/unsc_announcement)
	admin_verbs_hideable.Add(/client/proc/unsc_announcement)

	admin_verbs_fun.Add(/client/proc/innie_announcement)
	admin_verbs_hideable.Add(/client/proc/innie_announcement)

	admin_verbs_fun.Add(/client/proc/human_announcement)
	admin_verbs_hideable.Add(/client/proc/human_announcement)

	admin_verbs_fun.Add(/client/proc/flood_announcement)
	admin_verbs_hideable.Add(/client/proc/flood_announcement)

	admin_verbs_fun.Add(/client/proc/npc_difficulty)
	admin_verbs_hideable.Add(/client/proc/npc_difficulty)

	return 1
