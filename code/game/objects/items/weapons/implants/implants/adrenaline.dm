/obj/item/implant/adrenalin
	name = "adrenalin implant"
	desc = "Removes all stuns and knockdowns."
	origin_tech = list(TECH_MATERIAL = 1, TECH_BIO = 2, TECH_ESOTERIC = 2)
	hidden = 1
	var/uses

/obj/item/implant/adrenalin/get_data()
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

/obj/item/implant/adrenalin/trigger(emote, mob/source)
	if (emote == "pale")
		activate()
		
/obj/item/implant/adrenalin/activate()//this implant is unused but I'm changing it for the sake of consistency
	if (uses < 1 || malfunction || !imp_in)	return 0
	uses--
	to_chat(imp_in, "<span class='notice'>You feel a sudden surge of energy!</span>")
	imp_in.SetStunned(0)
	imp_in.SetWeakened(0)
	imp_in.SetParalysis(0)

/obj/item/implant/adrenalin/implanted(mob/source)
	source.StoreMemory("A implant can be activated by using the pale emote, <B>say *pale</B> to attempt to activate.", /decl/memory_options/system)
	to_chat(source, "The implanted freedom implant can be activated by using the pale emote, <B>say *pale</B> to attempt to activate.")
	return TRUE

/obj/item/implanter/adrenalin
	name = "implanter-adrenalin"
	imp = /obj/item/implant/adrenalin

/obj/item/implantcase/adrenalin
	name = "glass case - 'adrenalin'"
	imp = /obj/item/implant/adrenalin