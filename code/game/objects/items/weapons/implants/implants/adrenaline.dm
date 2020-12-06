/obj/item/weapon/implant/adrenalin
	name = "adrenalin"
	desc = "Removes all stuns and knockdowns."
	origin_tech = list(TECH_MATERIAL = 1, TECH_BIO = 2, TECH_ILLEGAL = 2)
	var/uses

/obj/item/weapon/implant/adrenalin/get_data()
	return {"
	<b>Implant Specifications:</b><BR>
	<b>Name:</b> Cybersun Industries Adrenalin Implant<BR>
	<b>Life:</b> Five days.<BR>
	<b>Important Notes:</b> <font color='red'>Illegal</font><BR>
	<HR>
	<b>Implant Details:</b> Subjects injected with implant can activate a massive injection of adrenalin.<BR>
	<b>Function:</b> Contains nanobots to stimulate body to mass-produce Adrenalin.<BR>
	<b>Special Features:</b> Will prevent and cure most forms of brainwashing.<BR>
	<b>Integrity:</b> Implant can only be used three times before the nanobots are depleted."}

/obj/item/weapon/implant/adrenalin/trigger(emote, mob/source)
	if (src.uses < 1)	return 0
	if (emote == "pale")
		src.uses--
		to_chat(source, "<span class='notice'>You feel a sudden surge of energy!</span>")
		source.SetStunned(0)
		source.SetWeakened(0)
		source.SetParalysis(0)

/obj/item/weapon/implant/adrenalin/implanted(mob/source)
	source.mind.store_memory("A implant can be activated by using the pale emote, <B>say *pale</B> to attempt to activate.", 0, 0)
	to_chat(source, "The implanted freedom implant can be activated by using the pale emote, <B>say *pale</B> to attempt to activate.")
	return TRUE

/obj/item/weapon/implanter/adrenalin
	name = "implanter-adrenalin"
	imp = /obj/item/weapon/implant/adrenalin

/obj/item/weapon/implantcase/adrenalin
	name = "glass case - 'adrenalin'"
	imp = /obj/item/weapon/implant/adrenalin