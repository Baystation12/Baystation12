/obj/prefab/test
	name = "test prefab spawn"

/decl/prefab/ic_assembly/test
	assembly_name = "test-assembly"
	data = ""
	power_cell_type = /obj/item/weapon/cell/hyper

/decl/prefab/ic_assembly/test/heatercooler
	assembly_name = "heating-cooling-test"
	data = {"{'assembly':{'type':'type-e electronic machine'},'components':\[{'type':'big reagent storage'},{'type':'reagent heater','inputs':\[\[1,0,65]]},{'type':'reagent cooler','inputs':\[\[1,0,-50]]},{'type':'reagent pump','name':'Heater Pump','inputs':\[\[3,0,5]]},{'type':'reagent pump','name':'Cooler Pump','inputs':\[\[3,0,5]]},{'type':'reagent funnel'},{'type':'starter','name':'Starter'},{'type':'button','name':'Pumps'},{'type':'button','name':'Activate'},{'type':'text-to-speech circuit','inputs':\[\[1,0,'Heating performed']]},{'type':'text-to-speech circuit','inputs':\[\[1,0,'Cooling performed']]},{'type':'button','name':'Update Temp'},{'type':'text-to-speech circuit','inputs':\[\[1,0,'20']]},{'type':'number to string','inputs':\[\[1,0,20]]}],'wires':\[\[\[1,'O',2],\[6,'I',1]],\[\[1,'O',2],\[4,'I',1]],\[\[1,'O',2],\[5,'I',1]],\[\[1,'A',1],\[7,'A',1]],\[\[2,'O',2],\[14,'I',1]],\[\[2,'O',3],\[4,'I',2]],\[\[2,'A',1],\[9,'A',1]],\[\[2,'A',2],\[10,'A',1]],\[\[2,'A',3],\[12,'A',1]],\[\[2,'A',4],\[7,'A',1]],\[\[3,'O',3],\[5,'I',2]],\[\[3,'A',1],\[9,'A',1]],\[\[3,'A',2],\[11,'A',1]],\[\[3,'A',3],\[12,'A',1]],\[\[3,'A',4],\[7,'A',1]],\[\[4,'A',1],\[8,'A',1]],\[\[5,'A',1],\[8,'A',1]],\[\[12,'A',1],\[14,'A',1]],\[\[13,'I',1],\[14,'O',1]],\[\[13,'A',1],\[14,'A',2]]]}"}

/obj/prefab/test/heatcool
	name = "heating-cooling test"
	prefab_type = /decl/prefab/ic_assembly/test/heatercooler

/decl/prefab/ic_assembly/test/interactor
	assembly_name = "interactor-test"
	data = {"{'assembly':{'type':'type-b electronic drone'},'components':\[{'type':'interactor'},{'type':'constant chip'},{'type':'button','name':'Toggle Hatch'},{'type':'starter'},{'type':'text-to-speech circuit','inputs':\[\[1,0,'Interaction happened']]}],'wires':\[\[\[1,'I',1],\[2,'O',1]],\[\[1,'A',1],\[3,'A',1]],\[\[1,'A',2],\[5,'A',1]],\[\[2,'A',1],\[4,'A',1]]]}"}

/obj/prefab/test/interactor
	name = "interactor test"
	prefab_type = /decl/prefab/ic_assembly/test/heatercooler