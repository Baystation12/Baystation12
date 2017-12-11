/obj/item/weapon/implant/uplink
	name = "uplink"
	desc = "Summon things."
	origin_tech = list(TECH_MATERIAL = 1, TECH_BIO = 2, TECH_ILLEGAL = 3)
	var/activation_emote

/obj/item/weapon/implant/uplink/New()
	hidden_uplink = new(src, telecrystals = round((DEFAULT_TELECRYSTAL_AMOUNT / 2) * 0.8))
	..()

/obj/item/weapon/implant/uplink/implanted(mob/source)
	activation_emote = input("Choose activation emote:") in list("blink", "blink_r", "eyebrow", "chuckle", "twitch_v", "frown", "nod", "blush", "giggle", "grin", "groan", "shrug", "smile", "pale", "sniff", "whimper", "wink")
	source.mind.store_memory("Uplink implant can be activated by using the [src.activation_emote] emote, <B>say *[src.activation_emote]</B> to attempt to activate.", 0, 0)
	to_chat(source, "The implanted uplink implant can be activated by using the [src.activation_emote] emote, <B>say *[src.activation_emote]</B> to attempt to activate.")
	hidden_uplink.uplink_owner = source.mind
	return TRUE

/obj/item/weapon/implant/uplink/trigger(emote, mob/source as mob)
	if(hidden_uplink && usr == source) // Let's not have another people activate our uplink
		hidden_uplink.check_trigger(source, emote, activation_emote)

/obj/item/weapon/implanter/uplink
	name = "implanter (U)"
	imp = /obj/item/weapon/implant/uplink