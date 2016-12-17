#define ALL_SPELLS "All"
#define OFFENSIVE_SPELLS "Offensive"
#define DEFENSIVE_SPELLS "Defensive"
#define UTILITY_SPELLS "Utility"
#define SUPPORT_SPELLS "Support"

var/list/all_technomancer_spells = typesof(/datum/technomancer/spell) - /datum/technomancer/spell
var/list/all_technomancer_equipment = typesof(/datum/technomancer/equipment) - /datum/technomancer/equipment
var/list/all_technomancer_consumables = typesof(/datum/technomancer/consumable) - /datum/technomancer/consumable
var/list/all_technomancer_assistance = typesof(/datum/technomancer/assistance) - /datum/technomancer/assistance

/datum/technomancer
	var/name = "technomancer thing"
	var/desc = "If you can see this, something broke."
	var/enhancement_desc = "No effect."
	var/cost = 100
	var/hidden = 0
	var/obj_path = null
	var/ability_icon_state = null

/datum/technomancer/spell
	var/category = ALL_SPELLS

/obj/item/weapon/technomancer_catalog
	name = "catalog"
	desc = "A \"book\" featuring a holographic display, metal cover, and miniaturized teleportation device, allowing the user to \
	requisition various things from.. where ever they came from."
	icon = 'icons/obj/storage.dmi'
	icon_state ="scientology" //placeholder
	w_class = ITEM_SIZE_SMALL
	var/budget = 1000
	var/max_budget = 1000
	var/mob/living/carbon/human/owner = null
	var/list/spell_instances = list()
	var/list/equipment_instances = list()
	var/list/consumable_instances = list()
	var/list/assistance_instances = list()
	var/tab = 0
	var/spell_tab = ALL_SPELLS
	var/show_scepter_text = 0

/obj/item/weapon/technomancer_catalog/apprentice
	name = "apprentice's catelog"
	budget = 700
	max_budget = 700

/obj/item/weapon/technomancer_catalog/master //for badmins, I suppose
	name = "master's catelog"
	budget = 2000
	max_budget = 2000


// Proc: bind_to_owner()
// Parameters: 1 (new_owner - mob that the book is trying to bind to)
// Description: Links the catelog to hopefully the technomancer, so that only they can access it.
/obj/item/weapon/technomancer_catalog/proc/bind_to_owner(var/mob/living/carbon/human/new_owner)
	if(!owner && technomancers.is_antagonist(new_owner.mind))
		owner = new_owner

// Proc: New()
// Parameters: 0
// Description: Sets up the catelog, as shown below.
/obj/item/weapon/technomancer_catalog/New()
	..()
	set_up()

// Proc: set_up()
// Parameters: 0
// Description: Instantiates all the catelog datums for everything that can be bought.
/obj/item/weapon/technomancer_catalog/proc/set_up()
	if(!spell_instances.len)
		for(var/S in all_technomancer_spells)
			spell_instances += new S()
	if(!equipment_instances.len)
		for(var/E in all_technomancer_equipment)
			equipment_instances += new E()
	if(!consumable_instances.len)
		for(var/C in all_technomancer_consumables)
			consumable_instances += new C()
	if(!assistance_instances.len)
		for(var/A in all_technomancer_assistance)
			assistance_instances += new A()

/obj/item/weapon/technomancer_catalog/apprentice/set_up()
	..()
	for(var/datum/technomancer/assistance/apprentice/A in assistance_instances)
		assistance_instances.Remove(A)

// Proc: show_categories()
// Parameters: 1 (category - the category link to display)
// Description: Shows an href link to go to a spell subcategory if the category is not already selected, otherwise is bold, to reduce
// code duplicating.
/obj/item/weapon/technomancer_catalog/proc/show_categories(var/category)
	if(category)
		if(spell_tab != category)
			return "<a href='byond://?src=\ref[src];spell_category=[category]'>[category]</a>"
		else
			return "<b>[category]</b>"

// Proc: attack_self()
// Parameters: 1 (user - the mob clicking on the catelog)
// Description: Shows an HTML window, to buy equipment and spells, if the user is the legitimate owner.  Otherwise it cannot be used.
/obj/item/weapon/technomancer_catalog/attack_self(mob/user)
	if(!user)
		return 0

	if(user.incapacitated())
		return

	if(owner && user != owner)
		to_chat(user,"<span class='danger'>\The [src] knows that you're not the original owner, and has locked you out of it!</span>")
		return 0
	else if(!owner)
		bind_to_owner(user)

	switch(tab)
		if(0) //Functions
			var/dat = ""
			user.set_machine(src)
			dat += "<align='center'><b>Functions</b> | "
			dat += "<a href='byond://?src=\ref[src];tab_choice=1'>Equipment</a> | "
			dat += "<a href='byond://?src=\ref[src];tab_choice=2'>Consumables</a> | "
			dat += "<a href='byond://?src=\ref[src];tab_choice=3'>Assistance</a></align><br>"
			dat += "You currently have a budget of <b>[budget]/[max_budget]</b>.<br><br>"
			dat += "<a href='byond://?src=\ref[src];refund_functions=1'>Refund Functions</a><br><br>"

			dat += "[show_categories(ALL_SPELLS)] | [show_categories(OFFENSIVE_SPELLS)] | [show_categories(DEFENSIVE_SPELLS)] | \
			[show_categories(UTILITY_SPELLS)] | [show_categories(SUPPORT_SPELLS)]<br>"
			for(var/datum/technomancer/spell/spell in spell_instances)
				if(spell.hidden)
					continue
				if(spell_tab != ALL_SPELLS && spell.category != spell_tab)
					continue
				dat += "<b>[spell.name]</b><br>"
				dat += "<i>[spell.desc]</i><br>"
				if(show_scepter_text)
					dat += "<span class='info'><i>[spell.enhancement_desc]</i></span>"
				if(spell.cost <= budget)
					dat += "<a href='byond://?src=\ref[src];spell_choice=[spell.name]'>Purchase</a> ([spell.cost])<br><br>"
				else
					dat += "<font color='red'><b>Cannot afford!</b></font><br><br>"
			show_browser(user,dat, "window=radio")
			onclose(user, "radio")
		if(1) //Equipment
			var/dat = ""
			user.set_machine(src)
			dat += "<align='center'><a href='byond://?src=\ref[src];tab_choice=0'>Functions</a> | "
			dat += "<b>Equipment</b> | "
			dat += "<a href='byond://?src=\ref[src];tab_choice=2'>Consumables</a> | "
			dat += "<a href='byond://?src=\ref[src];tab_choice=3'>Assistance</a></align><br>"
			dat += "You currently have a budget of <b>[budget]/[max_budget]</b>.<br><br>"
			for(var/datum/technomancer/equipment/E in equipment_instances)
				dat += "<b>[E.name]</b><br>"
				dat += "<i>[E.desc]</i><br>"
				if(E.cost <= budget)
					dat += "<a href='byond://?src=\ref[src];item_choice=[E.name]'>Purchase</a> ([E.cost])<br><br>"
				else
					dat += "<font color='red'><b>Cannot afford!</b></font><br><br>"
			show_browser(user,dat, "window=radio")
			onclose(user, "radio")
		if(2) //Consumables
			var/dat = ""
			user.set_machine(src)
			dat += "<align='center'><a href='byond://?src=\ref[src];tab_choice=0'>Functions</a> | "
			dat += "<a href='byond://?src=\ref[src];tab_choice=1'>Equipment</a> | "
			dat += "<b>Consumables</b> | "
			dat += "<a href='byond://?src=\ref[src];tab_choice=3'>Assistance</a></align><br>"
			dat += "You currently have a budget of <b>[budget]/[max_budget]</b>.<br><br>"
			for(var/datum/technomancer/consumable/C in consumable_instances)
				dat += "<b>[C.name]</b><br>"
				dat += "<i>[C.desc]</i><br>"
				if(C.cost <= budget)
					dat += "<a href='byond://?src=\ref[src];item_choice=[C.name]'>Purchase</a> ([C.cost])<br><br>"
				else
					dat += "<font color='red'><b>Cannot afford!</b></font><br><br>"
			show_browser(user,dat, "window=radio")
			onclose(user, "radio")
		if(3) //Assistance
			var/dat = ""
			user.set_machine(src)
			dat += "<align='center'><a href='byond://?src=\ref[src];tab_choice=0'>Functions</a> | "
			dat += "<a href='byond://?src=\ref[src];tab_choice=1'>Equipment</a> | "
			dat += "<a href='byond://?src=\ref[src];tab_choice=2'>Consumables</a> | "
			dat += "<b>Assistance</b></align><br>"
			dat += "You currently have a budget of <b>[budget]/[max_budget]</b>.<br><br>"
			for(var/datum/technomancer/assistance/A in assistance_instances)
				dat += "<b>[A.name]</b><br>"
				dat += "<i>[A.desc]</i><br>"
				if(A.cost <= budget)
					dat += "<a href='byond://?src=\ref[src];item_choice=[A.name]'>Purchase</a> ([A.cost])<br><br>"
				else
					dat += "<font color='red'><b>Cannot afford!</b></font><br><br>"
			show_browser(user,dat, "window=radio")
			onclose(user, "radio")

// Proc: Topic()
// Parameters: 2 (href - don't know, href_list - the choice that the person using the interface above clicked on.)
// Description: Acts upon clicks on links for the catelog, if they are the rightful owner.
/obj/item/weapon/technomancer_catalog/Topic(href, href_list)
	if(..())
		return 1

	var/mob/living/carbon/human/H = usr
	if(!istype(H, /mob/living/carbon/human))
		return 1 //why does this return 1?

	if(loc == H || (in_range(src, H) && istype(loc, /turf)))
		H.set_machine(src)
		if(href_list["tab_choice"])
			tab = text2num(href_list["tab_choice"])
		if(href_list["spell_category"])
			spell_tab = href_list["spell_category"]
		if(href_list["spell_choice"])
			var/datum/technomancer/new_spell = null
			//Locate the spell.
			for(var/datum/technomancer/spell/spell in spell_instances)
				if(spell.name == href_list["spell_choice"])
					new_spell = spell
					break

			var/obj/item/weapon/technomancer_core/core = null
			if(istype(H.back, /obj/item/weapon/technomancer_core))
				core = H.back

			if(new_spell && core)
				if(new_spell.cost <= budget)
					if(!core.has_spell(new_spell))
						budget -= new_spell.cost
						to_chat(H,"<span class='notice'>You have just bought [new_spell.name].</span>")
						core.add_spell(new_spell.obj_path, new_spell.name, new_spell.ability_icon_state)
					else //We already own it.
						to_chat(H,"<span class='danger'>You already have [new_spell.name]!</span>")
						return
				else //Can't afford.
					to_chat(H,"<span class='danger'>You can't afford that!</span>")
					return

		// This needs less copypasta.
		if(href_list["item_choice"])
			var/datum/technomancer/desired_object = null
			for(var/datum/technomancer/O in equipment_instances + consumable_instances + assistance_instances)
				if(O.name == href_list["item_choice"])
					desired_object = O
					break

			if(desired_object)
				if(desired_object.cost <= budget)
					budget -= desired_object.cost
					to_chat(H,"<span class='notice'>You have just bought \a [desired_object.name].</span>")
					var/obj/O = new desired_object.obj_path(get_turf(H))
					technomancer_belongings.Add(O) // Used for the Track spell.

				else //Can't afford.
					to_chat(H,"<span class='danger'>You can't afford that!</span>")
					return


		if(href_list["refund_functions"])
			if(!isAdminLevel(H.z))
				to_chat(H,"<span class='danger'>You can only refund at your base, it's too late now!</span>")
				return
			var/obj/item/weapon/technomancer_core/core = null
			if(istype(H.back, /obj/item/weapon/technomancer_core))
				core = H.back
			if(core)
				for(var/obj/spellbutton/spell in core.spells)
					for(var/datum/technomancer/spell/spell_datum in spell_instances)
						if(spell_datum.obj_path == spell.spellpath && !spell.was_bought_by_preset)
							budget += spell_datum.cost
							core.remove_spell(spell)
							break
		attack_self(H)
