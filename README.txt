=============================================================================================
CIRCLES Energy Models
=============================================================================================
Vehicle-specific fitted polynomial models that approximate instantaneous fuel consumption 
rates as function of instantaneous speed, acceleration, and road grade. They are fast to 
evaluate, easy to disseminate in open-source frameworks, and compatible with optimization 
frameworks. Those models are the final product of systematic model reduction pipeline that 
starts from complex vehicle models based on the Autonomie software that is first approximated 
by structurally simpler semi-principled models (not explicitly released here), and then 
subsequently approximated via simplified fitted functions. The pipeline, based on a virtual 
chassis dynamometer and subsequent approximation strategies, is reproducible and is applied 
to six different vehicle classes and validated on standard (EPA, UNECE) drivecycles.

Version 1.0
Copyright (c) 09/30/2023 Nour Khoudari, Sulaiman Almatrudi, Rabie Ramadan, 
                         Joy Carpio, Mengsha Yao, Kenneth Butts, 
		         Alexandre M. Bayen, Jonathan W. Lee, and Benjamin Seibold.


In the files below:
midSUV refers to a light-duty mid size sports utility vehicle.
Compact refers to a light-duty compact sedan.
midBase refers to a light-duty midsize sedan.
Pickup refers to a light-duty midsize pickup truck.
Class4PND refers to a medium-duty truck for pickup and delivery.
Class8Tractor refers to a heavy-duty truck with manual transmission and a trailer.
Simplified models are provided explicitly (energy model file evaluates).
Semi-principled models are provided as evaluations on a 3D grid (energy model interpolates).
Drive cycles are provided as speeds sampled at 10Hz.

=============================================================================================
Energy Models Files
=============================================================================================

fuel_model_midSUV_simplified.m      		      
fuel_model_midSUV_semiprincipled.m  

fuel_model_Compact_simplified.m  
fuel_model_Compact_semiprincipled.m    		     

fuel_model_midBase_simplified.m   
fuel_model_midBase_semiprincipled.m   		   

fuel_model_Pickup_simplified.m 
fuel_model_Pickup_semiprincipled.m      		    

fuel_model_Class4PND_simplified.m   
fuel_model_Class4PND_semiprincipled.m 		    

fuel_model_Class8Tractor_simplified.m  
fuel_model_Class8Tractor_semiprincipled.m               

=============================================================================================
Plotting and Validation Files
=============================================================================================

plot_semiprincipled_vs_simplified_model_on_drivecycles.m 
  
midSUV_semiprincipled_model_evaluations.csv         
Compact_semiprincipled_model_evaluations.csv        
midBase_semiprincipled_model_evaluations.csv        
Pickup_semiprincipled_model_evaluations.csv        
Class4PND_semiprincipled_model_evaluations.csv                                          
Class8Tractor_semiprincipled_model_evaluations.csv    

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
