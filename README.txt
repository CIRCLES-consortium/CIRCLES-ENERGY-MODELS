=================================================================================================
CIRCLES Energy Models
=================================================================================================
Vehicle-specific fitted polynomial models that approximate instantaneous fuel consumption rates 
as function of instantaneous speed, acceleration, and road grade. They are fast to evaluate, easy 
to disseminate in open-source frameworks, and compatible with optimization frameworks. Those 
models are produced by fitting some data collected from running Autonomie into physic-like models.
No Autonomie data or models are explicitly released or used to run our models, and by no means do 
our models replicate, nor should they be used as a substitute for Autonomie. Our models are the 
final product of a systematic model reduction pipeline that starts from interpolating and fitting 
data collected from running Autonomie into an approximated structurally simpler semi-principled 
models, and then subsequently approximating these semi-principled models via simplified fitted 
functions (released here as polynomials).The pipeline, based on a virtual chassis dynamometer and
subsequent approximation strategies, is reproducible and is applied to six different vehicle 
classes and validated on standard (EPA, UNECE) drivecycles.

Version 1.0
Copyright (c) 02/01/2025 Nour Khoudari, Sulaiman Almatrudi, Rabie Ramadan, 
                         Joy Carpio, Mengsha Yao, Kenneth Butts, 
		         Alexandre M. Bayen, Jonathan W. Lee, and Benjamin Seibold.


In the files below:
midSUV refers to a light-duty mid size sports utility vehicle.
Compact refers to a light-duty compact sedan.
midBase refers to a light-duty midsize sedan.
Pickup refers to a light-duty midsize pickup truck.
Class4PND refers to a medium-duty truck for pickup and delivery.
Class8Tractor refers to a medium-duty truck with manual transmission and a trailer.
Simplified models are provided explicitly (energy model file evaluates).
Semi-principled models are not released in this version.
Drive cycles are provided as speeds sampled at 10Hz.

=============================================================================================
Energy Models Files
=============================================================================================

fuel_model_midSUV_simplified.m      		      
fuel_model_Compact_simplified.m     		     
fuel_model_midBase_simplified.m     		  
fuel_model_Pickup_simplified.m 
fuel_model_Class4PND_simplified.m   
fuel_model_Class8Tractor_simplified.m  

=============================================================================================
Plotting and Drivecycles Files
=============================================================================================

plot_simplified_model_on_drivecycles.m 
   

UDDS_drivecycle_speeds_10Hz.csv                     Light-duty (FTP-72) 

HWFET_drivecycle_speeds_10Hz.csv                    Light-duty (Highway Fuel Economy Test)

US06_drivecycle_speeds_10Hz.csv                     Light-duty (US06)

WLTC_drivecycle_speeds_10Hz.csv                     Light-duty (Worldwide Harmonized 
                                                    Light-Duty Test Cycle) 

Cruise_drivecycle_speeds_10Hz.csv                   Heavy Heavy-Duty Diesel Truck Cruise
						    
Transient_drivecycle_speeds_10Hz.csv                Heavy Heavy-Duty Diesel Truck Transient
						    
High_drivecycle_speeds_10Hz.csv                     Heavy Heavy-Duty Diesel Truck High
						     
H65_drivecycle_speeds_10Hz.csv                      Heavy Heavy-Duty Diesel Truck H65
						    
=============================================================================================