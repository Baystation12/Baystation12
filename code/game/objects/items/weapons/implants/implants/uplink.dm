/obj/item/weapon/implant/uplink
	name = "uplink implant"
	desc = "Summon things."
	origin_tech = list(TECH_MATERIAL = 1, TECH_BIO = 2, TECH_ESOTERIC = 3)
	hidden = 1
	var/activation_emote

/obj/item/weapon/implant/uplink/New(var/loc, var/amount)
	amount = amount || IMPLANT_TELECRYSTAL_AMOUNT(DEFAULT_TELECRYSTAL_AMOUNT)
	hidden_uplink = new(src, telecrystals = amount)
	..()

/obj/item/weapon/implant/uplink/implanted(mob/source)
	var/emote_options = list("blink", "blink_r", "eyebrow", "chuckle", "twitch_v", "frown", "nod", "blush", "giggle", "grin", "groan", "shrug", "smile", "pale", "sniff", "whimper", "wink")
	activation_emote = source.client ? (input(source, "Choose activation emote:", "Uplink Implant Setup") in emote_options) : emote_options[1]
	source.StoreMemory("Uplink implant can be activated by using the [src.activation_emote] emote, <B>say *[src.activation_emote]</B> to attempt to activate.", /decl/memory_options/system)
	to_chat(source, "The implanted uplink implant can be activated by using the [src.activation_emote] emote, <B>say *[src.activation_emote]</B> to attempt to activate.")
	hidden_uplink.uplink_owner = source.mind
	return TRUE

/obj/item/weapon/implant/uplink/trigger(emote, mob/source as mob)
	if(hidden_uplink && usr == source && !malfunction) // Let's not have another people activate our uplink
		hidden_uplink.check_trigger(source, emote, activation_emote)

/obj/item/weapon/implant/uplink/emp_act(severity)
	var/power = 4 - severity
	if(prob(power))
		meltdown()
	else if(prob(power * 40))
		disable(rand(power*100,power*1000))

/obj/item/weapon/implanter/uplink
	name = "implanter (U)"
	imp = /obj/item/weapon/implant/uplink
