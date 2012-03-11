
//PROGRAM MASTER DEFINE STUFF//

datum/dir/file/program
	name = "program"
	var/progname = "test"
	var/datum/packet/lastpacket

datum/dir/file/program/New(namez)
	..()


datum/dir/file/program/proc/ForwardPacket(var/datum/packet/P)
	return 0

datum/dir/file/program
	var/is_script = 0
	var/script = ""
	var/running = 0
	var/datum/praser/PP

datum/dir/file/program/proc/Run(var/datum/os/client)
	running = 1
	if(is_script)
		PP = new(client,src.script,null,1,1)
		// client.process += PP // Praser take's care of this
//		if(PP)
		//	world << "PP :D"
		return
	return

datum/dir/file/program/proc/Stop(var/datum/os/client)
	if(!PP)
		world << "NO PP"
	client.process.Remove(PP)
	running = 0