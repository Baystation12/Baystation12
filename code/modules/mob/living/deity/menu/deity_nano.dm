/mob/living/deity
	var/menu_category
	var/list/nano_data = list()
	var/datum/phenomena/selected

/mob/living/deity/ui_interact(mob/user, ui_key = "main", var/datum/nanoui/ui = null, var/force_open = 1, var/uistate = GLOB.self_state)
	if(!nano_data["categories"]) //If we don't have the categories set yet, we should populate our data.
		var/list/categories = list()
		for(var/cat in items_by_category)
			categories += cat
		nano_data["name"] = name
		nano_data["form_name"] = form.name
		nano_data["categories"] = categories
		nano_data["menu"] = 0 //0 followers, 1 shop, 2 phenomena
		nano_data["phenomenaMenu"] = 0 //0 Phenoms 1 Bindings
		set_nano_category(0)
		update_followers()
		update_phenomenas()
		update_phenomena_bindings()
	else
		update_category()
	nano_data["power"] = power
	nano_data["power_min"] = power_min
	nano_data["regen"] = power_per_regen
	ui = SSnano.try_update_ui(user, src, ui_key, ui, nano_data, force_open)
	if(!ui)
		ui = new(user, src, ui_key, "deity.tmpl", "Deity Menu", 650, 600, state = uistate)
		ui.set_initial_data(nano_data)
		ui.open()
		ui.set_auto_update(TRUE)

/mob/living/deity/proc/set_nano_category(var/num)
	nano_data["category"] = num
	update_category()

/mob/living/deity/proc/update_category()
	var/actual_cat = nano_data["categories"][nano_data["category"] + 1]
	var/list/cat_items = items_by_category[actual_cat]
	var/list/item_data = list()
	for(var/item in cat_items)
		var/datum/deity_item/di = item
		item_data[++item_data.len] = list("name" = di.name, "desc" = di.desc, "requirements" = di.print_requirements(), "level" = di.print_level(), "cost" = di.get_cost(), "ref" = "\ref[di]")
	nano_data["item_data"] = item_data

/mob/living/deity/proc/update_followers()
	var/list/follower_data = list()
	for(var/m in minions)
		var/list/minion_data = list()
		var/datum/mind/mind = m
		if(mind.current)
			if(mind.current.stat != DEAD && mind.current.loc)
				minion_data["ref"] = "\ref[mind.current]"
			minion_data["name"] = "[mind.current.name]"
		else
			minion_data["name"] = mind.name
		follower_data[++follower_data.len] = minion_data
	nano_data["followers"] = follower_data

/mob/living/deity/proc/update_phenomenas()
	var/list/phenomena_data = list()
	for(var/p in phenomenas)
		var/datum/phenomena/P = phenomenas[p]
		phenomena_data[++phenomena_data.len] = list("name" = p, "description" = P.desc, "cost" = P.cost, "cooldown" = P.cooldown)
	nano_data["phenomenas"] = phenomena_data

/mob/living/deity/proc/update_phenomena_bindings()
	var/list/phenomena_bindings = list()
	for(var/intent in intent_phenomenas)
		var/list/intent_data = list()
		for(var/binding in intent_phenomenas[intent])
			var/datum/phenomena/P = intent_phenomenas[intent][binding]
			var/list/data = list()
			if(P)
				data["phenomena_name"] = P.name
			data["binding"] = binding
			intent_data[++intent_data.len] = data
		phenomena_bindings[++phenomena_bindings.len] = list("intent" = intent, "intent_data" = intent_data)
	nano_data["bindings"] = phenomena_bindings
	//Update the hud as well.
	var/obj/screen/intent/deity/SD = hud_used.action_intent
	SD.update_text()