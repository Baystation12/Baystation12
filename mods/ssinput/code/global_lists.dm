var/global/list/hotkey_keybinding_list_by_key = list()
var/global/list/keybindings_by_name = list()

/hook/global_init/makeDatumRefLists()
	. = ..()
	for(var/datum/keybinding/keybinding as anything in subtypesof(/datum/keybinding))
		if(!initial(keybinding.name))
			continue
		var/datum/keybinding/instance = new keybinding
		global.keybindings_by_name[instance.name] = instance
		if(length(instance.hotkey_keys))
			for(var/bound_key in instance.hotkey_keys)
				global.hotkey_keybinding_list_by_key[bound_key] += list(instance.name)
