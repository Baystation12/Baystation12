//Simple pipes. Values: 100-199
#define PIPE_SIMPLE_STRAIGHT		100
#define PIPE_SIMPLE_BENT			101
#define PIPE_MANIFOLD				102
#define PIPE_MANIFOLD4W				103
#define PIPE_UP						104
#define PIPE_DOWN					105
#define PIPE_CAP					106

//Supply Pipes. Values: 200-299
#define PIPE_SUPPLY_STRAIGHT		200
#define PIPE_SUPPLY_BENT			201
#define PIPE_SUPPLY_MANIFOLD		202
#define PIPE_SUPPLY_MANIFOLD4W		203
#define PIPE_SUPPLY_UP				204
#define PIPE_SUPPLY_DOWN			205
#define PIPE_SUPPLY_CAP				206

//Scrubber Pipes. Values: 300-399
#define PIPE_SCRUBBERS_STRAIGHT		300
#define PIPE_SCRUBBERS_BENT			301
#define PIPE_SCRUBBERS_MANIFOLD		302
#define PIPE_SCRUBBERS_MANIFOLD4W	303
#define PIPE_SCRUBBERS_UP			304
#define PIPE_SCRUBBERS_DOWN			305
#define PIPE_SCRUBBERS_CAP			306

//Fuel Pipes. Values: 400-499
#define PIPE_FUEL_STRAIGHT			400
#define PIPE_FUEL_BENT				401
#define PIPE_FUEL_MANIFOLD			402
#define PIPE_FUEL_MANIFOLD4W		403
#define PIPE_FUEL_UP				404
#define PIPE_FUEL_DOWN				405
#define PIPE_FUEL_CAP				406

//Heat Exchange Pipes. Values: 500-599
#define PIPE_HE_STRAIGHT			500
#define PIPE_HE_BENT				501
//Reserved for Manifold				502
//Reserved for Manifold4W			503
//Reserved for Up					504
//Reserved for Down					505
//Reserved for Cap					506
#define PIPE_JUNCTION				507
#define PIPE_HEAT_EXCHANGE      	508

//Utility/Equipment Pipes. Values: 600-699
#define PIPE_CONNECTOR				600
#define PIPE_UVENT					601
#define PIPE_MVALVE					602
#define PIPE_DVALVE					603
#define PIPE_PUMP					604
#define PIPE_SCRUBBER				605
#define PIPE_PASSIVE_GATE       	606
#define PIPE_VOLUME_PUMP        	607
#define PIPE_MTVALVE				608
#define PIPE_OMNI_MIXER				609
#define PIPE_OMNI_FILTER			610
#define PIPE_UNIVERSAL				611
#define PIPE_MTVALVEM				612
#define PIPE_SVALVE					613

//Connection Type Definitions
#define CONNECT_TYPE_REGULAR		1
#define CONNECT_TYPE_SUPPLY			2
#define CONNECT_TYPE_SCRUBBER		4
#define CONNECT_TYPE_HE				8
#define CONNECT_TYPE_FUEL			16

//Disposal Pipe Definitions
#define DISPOSAL_STRAIGHT			0
#define DISPOSAL_BENT				1
#define DISPOSAL_JUNCTION1			2
#define DISPOSAL_JUNCTION2			3
#define DISPOSAL_JUNCTION_Y			4
#define DISPOSAL_TRUNK				5
#define DISPOSAL_BIN				6
#define DISPOSAL_OUTLET				7
#define	DISPOSAL_INLET				8
#define DISPOSAL_JUNCTION_SORT1		9
#define DISPOSAL_JUNCTION_SORT2		10
#define DISPOSAL_UP					11
#define DISPOSAL_DOWN				12
#define DISPOSAL_TAGGER				13
#define DISPOSAL_TAGGER_PARTIAL		14
#define DISPOSAL_DIVERSION			15

//Disposal Sorting Subtype Definitions
#define DISPOSAL_SUB_SORT_NORMAL	0
#define DISPOSAL_SUB_SORT_WILD		1
#define DISPOSAL_SUB_SORT_UNTAGGED	2