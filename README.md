# loadExpressPCBPickAndPlace
Transform the Express PCB Pick and Place output for a file into MyData100 format

This code takes the pick and place for a particular PCB file (Coincidence Daughter20191125_1617), 
harded coded into some variable names near the top of the program.
Place the ExpressPCB pick and place file into the data folder. Modify the code for your particular pick and place file name. 
Run the code and a new file (CoincidenceDaughterMy10020191206.txt) is generated and saved in the data folder and which you
can load into a MyData100 as a layout with a panel with a PCB.  

On my sample board I did not have two (the minimu number) of fuducials so I had to use a test point (W14) as a second fuducial.

Summary:
Put your pick and place file into the data folder.
Change the code so that" final String sPROJECTNAME = "yourfilename";
Change serial number of the machine in the code: final String sSNMY100 = "my100-14n0328"; // IMPORTANT change for your maching. 
Run
With a flash drive I moved the generated output file into the MyData100.
For information about the Mydata file format, refer to Appendix D in the MyData 100 programing manual: 
MyData v2.9 Software Manual.pdf which I found by searching the internet. 
