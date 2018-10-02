/*
///////////// PHORON DESUBLIMER ////////////////
	~~Created by Kwask, sprites by Founded1992~~
Desc: This is a machine which will take gaseous phoron and turns it into various materials
The process works like this:
	1.) A supermatter seed crystal is place inside of the formation chamber
	2.) A phoron tank filled with phoron is placed inside of the formation chamber
	3.) Flood the formation chamber with phoron
	4.) Expose the shard to the phoron and watch as the crystal is grown
	5.) Eject seed and phoron or repeat process until the shard is desirable size

	NEUTRON FURNACE
	5.) Place the supermatter shard inside and set the neutron flow. The neutron flow represents the desired focus point.
		Each of the different materials has a "focus peak" where you produce a maximum output of that material.
		Setting the neutron flow between two peaks creates a smaller amount of both materials.
		Some materials, such as osmium and phoron, produce so little amount that you may get nothing unless the neutron flow matches the peak.
		The amount of material recieved is also determined by the size of the shard, so a small shard may never yield osmium or phoron.
	6.) Activate the machine.
	7.) Congrats, you now have some bars!
*/

/obj/machinery/phoron_desublimer
	icon = 'icons/obj/phoron_desublimation.dmi'
	density = 1
	anchored = 1
	use_power = 1
	idle_power_usage = 10
	var/ready = 0
	var/active = 0

/obj/machinery/phoron_desublimer/Process()
	if( stat & ( BROKEN|NOPOWER ))
		ready = 0

/obj/machinery/phoron_desublimer/proc/report_ready()
	if( stat & ( BROKEN|NOPOWER ))
		ready = 0
		return

	ready = !(stat & (BROKEN|NOPOWER))
	return ready