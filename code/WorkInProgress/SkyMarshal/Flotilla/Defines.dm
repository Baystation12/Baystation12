//Distances are in 10^9th meters
//Acceleration is in 10^9th meters/s^2
//Velocity is in 10^9th meters/s
//Mass is in Yottagrams, 10^24th grams
//Force in Yottanewtons.  10^21 kgm/s^2
//Bearings are in degrees.
//Angular velocity is in degrees/second
//Density is in grams/cm^3

#define PHYSICS_DEBUG //Enables debugging fucntionality.


//Important shit.  Increase this number to increase the force of graivty universally.
#define GRAVITATIONAL_CONSTANT (6.67384e-11) //(m^3)/kg(s^2)


//Function to add two velocities in accordance with relativity.  Sanity is goood.  .6c +.5c = ~.85c
#define VelocityAdd(x,y) ((x + y)/(1 + ((x*y)/0.08988)))

  ////////////////////////////
 //VARIOUS USEFUL FUNCTIONS//
////////////////////////////
#define Gravity(mass, distance)  ((GRAVITATIONAL_CONSTANT*mass)/(((distance)**2)*1e6)) //Source is a frame, distance is... self-explanatory
#define Dist(x,y) sqrt((x)**2 + (y)**2)
#define OrbitalVelocity(orbited_mass, distance) sqrt((orbited_mass * GRAVITATIONAL_CONSTANT)/(distance*1e6))
#define LorentzFactor(dx, dy) (1/sqrt(1 - (dist(dx,dy)**2)/SPEED_OF_LIGHT_SQ))
#define Momentum(mass,dx,dy) ((1e9)*mass*dist(dx,dy)*lorentz_factor(dx, dy))
#define Radius(mass, density) (((3*(mass/density)/(PI*4e27))**(1/3))/1e6) //Takes Yottagrams, 1e6g/m^3.   Returns 1e9*meters

//Defines related to optimizing gravity computerations.  Used to skip gravity computation if the force applied is too low.
#define MINUMUM_ATTRACTION_TO_CONSIDER 1e-20  //10 newtons.
#define InverseGravity(mass) sqrt((GRAVITATIONAL_CONSTANT*mass)/(MINUMUM_ATTRACTION_TO_CONSIDER*1e6))	//Takes: Mass in Yottagrams.  Outputs: Distance from said mass where the applied force is equal to MINUMUM_ATTRACTION_TO_CONSIDER


  //////////////////////////////////////////////////////////
 //VARIOUS DEFINES FOR SIZE AND VOLUME AND MASS AND STUFF//
//////////////////////////////////////////////////////////

//Minimum mass to attract other frames, in yottagrams.
#define MINIMUM_MASS_TO_CONSIDER_ATTRACTION (4.2e-5) //Mass of this fucker: http://en.wikipedia.org/wiki/243_Ida

#define STARTING_STAR_MASS (1.631062e9)
#define MINIMUM_SOLAR_MASS (1.39237e9)
#define MAXIMUM_SOLAR_MASS (1.59128e10)
#define SOL_MASS (1.9891e9)

#define NUMBER_OF_PLANETS_MIN 0
#define NUMBER_OF_PLANETS_MAX 10
#define PLANET_MASS_MIN 330
#define PLANET_MASS_MAX (1.898e6)
#define PLANET_CLOSEST_ORBIT(mass) 69*mass/SOL_MASS
#define PLANET_FARTHEST_ORBIT(mass) 4553*mass/SOL_MASS

#define GAS_GIANT_MASS_CUTOFF (2.986095e4) //Yottagrams.  5x Earth.
#define GAS_GIANT_DENSITY 1.33 //1e6g/m^3  (Jupiter)
#define SOLID_PLANET_DENSITY 5.52 //1e6g/m^3 (Earth)
#define STAR_DENSITY 1.4 //1e6g/m^3 (The sun)
#define DENSITY_DEVIATION 0.02 //2%

#define CLOSEST_GAS_GIANT_ORBIT(mass) 400*mass/SOL_MASS

#define MOON_CHANCE 50 //percent
#define MOON_MAX_SIZE 73.477
#define MOON_MIN_SIZE (1.072e-5)
#define MOON_CLOSEST_ORBIT (9.518e-3)
#define MOON_FARTHEST_ORBIT (4.0541e-1)
#define MOON_DENSITY 2.5

#define ORBITAL_VECTOR_DEVATION 0.5 //fraction from "circular"

//For rotations of planets/moons
#define CLOCKWISE 1
#define ANTICLOCKWISE -1

//#define PROJECTILE_DELETE_DISTANCE 3

  ///////////////////////////////////
 //DEFINES RELATED TO THE UNIVERSE//
///////////////////////////////////

#define STARTING_SYSTEM_NAME "Epsilon Erandi"

#define GIGAMETERS_PER_SIDE (2.83815852e13) //3 million Lightyears.  More than enough.  Simulation is toroidal, by the way. (due to simplicity.)



  /////////////////////////////////////////////////////
 //DEFINES RELATED TO VARIOUS INTERNAL DATA HANDLING//
/////////////////////////////////////////////////////
#define QUADTREE_MAX_CHILDREN 4			//Maximum number of frames before a node splits into components.
#define QUADTREE_MAX_LIMIT 12			//Maximum times a node can be subdivided before it cannot subdivide further.
#define SQRT_OF_TWO 1.4142