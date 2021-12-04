/datum/codex_entry/suitcooler
	associated_paths = list(/obj/item/device/suit_cooling_unit)
	mechanics_text = "You may wear this instead of your backpack to cool yourself down. It is commonly used by full-body prosthetic users, \
	as it allows them to go into low pressure environments for more than few seconds without overheating. It runs off energy provided by internal power cell. \
	Remember to turn it on by clicking it when it's your in your hand before you put it on."

/datum/codex_entry/barsign
	associated_paths = list(/obj/structure/sign/double/barsign)
	mechanics_text = "If your ID has bar access, you may swipe it on this sign to alter its display."

/datum/codex_entry/sneakies
	associated_paths = list(/obj/item/clothing/shoes/laceup/sneakies)
	lore_text =  "Originally designed to confuse Terran troops on the swamp moon of Nabier XI, where they were proven somewhat effective. Not bad on a space vessel, either."

/datum/codex_entry/moneygun
	associated_paths = list(/obj/item/gun/launcher/money)
	mechanics_text = "Load money into the cannon by picking it up with the gun, or feeding it directly by hand. Use in your hand to configure how much money you want to fire per shot."
	lore_text = "These devices were invented several centuries ago and are a distinctly human cultural infection. They have produced knockoffs as timeless and as insipid as the potato gun and the paddle ball, showing up in all corners of the galaxy. The Money Cannon variation is noteworthy for its sturdiness and build quality, but is, at the end of the day, just another knockoff of the ancient originals."

/datum/codex_entry/moneygun/New(_display_name, list/_associated_paths, list/_associated_strings, _lore_text, _mechanics_text, _antag_text)
	. = ..()
	antag_text = "Sliding a cryptographic sequencer into the receptacle will short the motors and override their speed. If you set the cannon to dispense 100 [GLOB.using_map.local_currency_name] or more, this might make a handy weapon."

/datum/codex_entry/ssd
	display_name = "SSD/S.S.D."
	mechanics_text = "When a player has disconnected or ghosted, they display a special message when they're examined, colored in purple. If the message indicates something like them staring blankly, being fast asleep, or displaying a SYSTEM OFFLINE message, it's likely that the player's closed their BYOND client or lost their connection. In such a case, it's possible they'll resume play soon or at a later time. These players are referred as \"going SSD\" or otherwise being SSD.<br><br>\
	\
	If the message displays something more severe, like being completely comatose or having a full system failure, the player has voluntarily ghosted while still alive - this means that the character won't return back to the round as a player, short of invervention from an admin. For clarity, these cases will also always mention that the player won't be recovering or waking up any time soon.<br><br>\
	\
	The server's rules likely have special clauses regarding SSD players. Check the rule list before you touch a player who's disconnected or take any actions on them."

/datum/codex_entry/wrist_computer
	associated_paths = list(/obj/item/modular_computer/pda/wrist)
	lore_text = "Morally obsolete and replaced by a more compact and perfect personal computer, \
	the wrist computer has been used to this day as a cheap replacement for more expensive equipment \
	in some small corporations, \
	and sometimes for the sake of aesthetic pleasure of it's owner."
