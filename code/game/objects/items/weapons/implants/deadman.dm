/obj/item/weapon/implant/deadman
	name = "deadman switch implant"
	desc = "Activates a signal on death."
	var/obj/item/device/assembly/signaler/signaler
	icon_state = "implant_evil"

	get_data()
		var/dat = {"
<b>Implant Specifications:</b><BR>
<b>Name:</b> Robust Corp RX-79 Deadman Switch Implant<BR>
<b>Life:</b> Activates upon death.<BR>
<b>Important Notes:</b> Sends triggering signal<BR>
<HR>
<b>Implant Details:</b><BR>
<b>Function:</b> Contains a compact, electric signaller that activates upon host death.<BR>
<b>Integrity:</b> Implant will occasionally be degraded by the body's immune system and thus will occasionally malfunction."}
		return dat

	implanted(mob/source as mob)
		signaler = new /obj/item/device/assembly/signaler(src)
		signaler.interact(source)
		usr.mind.store_memory("Deadman switch will broadcast signal on <B>[signaler.frequency]</B> using encryption <B>[signaler.code]</B>.", 0, 0)
		usr << "Deadman switch will broadcast signal on <B>[signaler.frequency]</B> using encryption <B>[signaler.code]</B>."


	trigger(emote, source as mob)
		if(emote == "deathgasp")
			src.activate("death")
		return

	activate(var/cause)
		if((!cause) || (!src.imp_in))	return 0
		signaler.signal()

	islegal()
		return 0