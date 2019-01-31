/obj/item/weapon/gun
	var/general_codex_key = "guns"

/obj/item/weapon/gun/projectile
	general_codex_key = "ballistic weapons"

/obj/item/weapon/gun/energy
	general_codex_key = "energy weapons"

/obj/item/weapon/gun/get_specific_codex_entry()
	if(SScodex.entries_by_path[type])
		return SScodex.entries_by_path[type]

	var/list/entries = SScodex.retrieve_entries_for_string(general_codex_key)
	var/datum/codex_entry/general_entry = LAZYACCESS(entries, 1)
	var/datum/codex_entry/entry = new()

	if(general_entry)
		entry.mechanics_text = general_entry.mechanics_text
		entry.lore_text =      general_entry.lore_text
		entry.antag_text =     general_entry.antag_text

	if(!entry.mechanics_text)  entry.mechanics_text = ""
	if(!entry.lore_text)       entry.lore_text = ""

	entry.display_name = name

	var/list/traits = list()
	
	if(one_hand_penalty)
		traits += "It's best fired with two-handed grip."

	if(has_safety)
		traits += "It has a safety switch. Control-Click it to toggle safety."

	if(is_secure_gun())
		traits += "It's fitted with secure registration chip. Swipe ID on it to register."

	if(scope_zoom)
		traits += "It has a magnifying optical scope. It can be toggled with Use Scope verb."

	if(LAZYLEN(firemodes) > 1) 
		traits += "It has multiple firemodes. Click it in hand to cycle them."

	entry.mechanics_text += jointext(traits, "<br>")

	SScodex.entries_by_path[type] = entry
	return entry

/obj/item/weapon/gun/projectile/get_specific_codex_entry()
	var/datum/codex_entry/entry = ..()
	var/list/traits = list()

	traits += "<br>Caliber: [caliber]"

	var/list/loading_ways = list()
	if(load_method & SINGLE_CASING)
		loading_ways += "loose [caliber] rounds"
	if(load_method & SPEEDLOADER)
		loading_ways += "speedloaders"
	if(load_method & MAGAZINE)
		loading_ways += "magazines"
	traits += "Can be loaded using [english_list(loading_ways)]"

	if(load_method & (SINGLE_CASING|SPEEDLOADER))
		traits += "It can hold [max_shells] rounds."
	
	if(jam_chance)
		traits += "It's prone to jamming."

	entry.mechanics_text += jointext(traits, "<br>")
	return entry

/obj/item/weapon/gun/energy/get_specific_codex_entry()
	var/datum/codex_entry/entry = ..()
	var/list/traits = list()

	traits += "<br>Its maximum capacity is [max_shots] shots worth of power."

	if(self_recharge)
		traits += "It recharges itself over time."

	entry.mechanics_text += jointext(traits, "<br>")
	return entry

/obj/item/weapon/gun/projectile/shotgun/pump/get_specific_codex_entry()
	var/datum/codex_entry/entry = ..()
	entry.mechanics_text += "<br>To pump it, click it in hand."
	return entry

/obj/item/weapon/gun/energy/crossbow/get_specific_codex_entry()
	var/datum/codex_entry/entry = ..()
	entry.antag_text = "This is a stealthy weapon which fires poisoned bolts at your target. When it hits someone, they will suffer a stun effect, in \
	addition to toxins. The energy crossbow recharges itself slowly, and can be concealed in your pocket or bag."
	return entry
	
/obj/item/weapon/gun/energy/chameleon/get_specific_codex_entry()
	var/datum/codex_entry/entry = ..()
	entry.antag_text = "This gun is actually a hologram projector that can alter its appearance to mimick other weapons. To change the appearance, use \
	the appropriate verb in the chameleon items tab. Any beams or projectiles fired from this gun are actually holograms and useless for actual combat. \
	Projecting these holograms over distance uses a little bit of charge."
	return entry

/datum/codex_entry/energy_weapons
	display_name = "energy weapons"
	mechanics_text = "This weapon is an energy weapon; they run on battery charge rather than traditional ammunition. You can recharge \
		an energy weapon by placing it in a wall-mounted or table-mounted charger, such as those found in Security or around the \
		place. Additionally, most energy weapons can go straight through windows and hit whatever is on the other side, and are \
		hitscan, making them accurate and useful against distant targets. \
		<br><br>"

/datum/codex_entry/ballistic_weapons
	display_name = "ballistic weapons"
	mechanics_text = "This weapon is a ballistic weapon; it fires solid shots using a magazine or loaded rounds of ammunition. You can \
		unload it by holding it and clicking it with an empty hand, and reload it by clicking it with a magazine, or in the case of \
		shotguns or some rifles, by opening the breech and clicking it with individual rounds. \
		<br><br>"
	lore_text = "Ballistic weapons are still used even now due to the relative expense of decent laser \
		weapons, difficulties in maintaining them, and the sheer stopping and wounding power of solid slugs or \
		composite shot. Using a ballistic weapon on a spacebound habitat is usually considered a serious undertaking, \
		as a missed shot or careless use of automatic fire could rip open the hull or injure bystanders with ease."
