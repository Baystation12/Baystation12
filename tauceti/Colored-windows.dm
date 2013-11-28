var/global/wcBrig
var/global/wcBar
var/global/wcCommon
var/global/wcDw

//for all window/New and door/window/New
/proc/color_windows(area = "common")
	var/list/common = list("#379963", "#0d8395", "#58b5c3", "#49e46e", "#8fcf44", "#ffffff")
	if(!wcCommon)
		wcCommon = pick(common)
	return wcCommon

//This func called in master-controller, replaces color in some area
/proc/color_windows_init()
	var/list/brig = list("#aa0808", "#7f0606", "#ff0000")
	var/list/bar = list("#0d8395", "#58b5c3", "#58c366", "#90d79a", "#ffffff")
	var/list/dw = list("#993300", "#ff6600", "#ffcc00", "#ff9933")

	wcBrig = pick(brig)
	wcBar = pick(bar)
	wcDw = pick(dw)

	//BRIG
	var/wsBrigList = list(
		/area/security/armoury,
		/area/security/brig,
		/area/security/detectives_office,
		/area/security/hos,
		/area/security/lobby,
		/area/security/main,
		/area/security/prison,
		/area/security/warden
		)

	for(var/A in wsBrigList)
		for(var/obj/structure/window/W in locate(A))
			W.color = wcBrig
		for(var/obj/machinery/door/window/D in locate(A))
			D.color = wcBrig

	//BAR
	for(var/obj/structure/window/W in locate(/area/crew_quarters/bar))
		W.color = wcBar
	for(var/obj/machinery/door/window/D in locate(/area/crew_quarters/bar))
		D.color = wcBar

	//DWARFS
	for(var/obj/structure/window/W in locate(/area/mine/dwarf))
		W.color = wcDw
	for(var/obj/machinery/door/window/D in locate(/area/mine/dwarf))
		D.color = wcDw