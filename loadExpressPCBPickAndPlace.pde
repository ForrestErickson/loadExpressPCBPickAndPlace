/** loadExpressPCBPickAndPlace
* Lee Erickson
* This software is designed to kill you, but is not guarenteed to do so. Use at own risk.
*
* 20191203 Transmongraphied from example at: https://processing.org/reference/loadTable_.html
* Update for mouse to add row or add column or exit."
* Update to open pick and place file from ExpressPCB for Coincidence Daughter20191125_1617
* Updated to read first row of table. See: https://www.youtube.com/watch?v=woaR-CJEwqc at about 8:00 time.
* Ouput for F8 and F9 lines of MY100LXE file format.
* Reference the MyData v2.9 Software Manual especially appendix D for the My100 file data format.
* Open the schematic BOM (parts list) which has RefDes and Part Number fields into a table.
* Remove magic strings for file names.
* Look up Part Number (Order#) from Schematic by RefDes in Pick and Place. 
* Prints to console the F8 and F9 lines as required for MyData.
* Prepends the lines from an example MyData PCB file for F1 to F6.
* Add output to file.
* Remove left and right mouse actions.
* 20191203
* Eliminate duplicate C10 by test for equal lenght ref des before doing the look up. Make offset origin and flip Y direction. Not yet correct.
* Set board height in mm. Mirror Y direction.
* 20191204
* This is working well. My100 preview looks good. The Cs and Rs are all 90 degress off.
* Add prompt and end of file generation. Change text in draw(). Make comments more accurate.
* Rename the file name variable. Rename the output file to include 'My100'.
* Remove 'DNI' and 'Board Feature' items from output. Make sure your Fuducials are not called Board Feature.
* Add file descriptions. Remove magic number on BOARDHEIGHT. Change for Schematic BOM first field '*Ref'.
* 20191206 Programaticaly create the lines previously in files: My100PCBF1toF6.txt and My100_LAYOUT_PANEL.txt
* 
*/

/*Project setup. The user must edit this code for each project.*/
final String sPROJECTNAME = "Coincidence Daughter20191125_1617";
final String sLAYOUTNOTE = "A daughter board for ST475 to add coincidence and other functions.";
final String sPROJECTNOTE = "As Ordered R1";
//Fuducials. Need two. rnd-1.2mm assumed.  Units in metric. From ExpressPCB PCB pick and place for FD1 and W4.
final int FD1X = 2540;  // for Coincidence Daughter20191125_1617
final int FD1Y = 60960;  // for Coincidence Daughter20191125_1617
final int FD2X = 92710;  // for Coincidence Daughter20191125_1617
final int FD2Y = 11430;  // for Coincidence Daughter20191125_1617
final int MOUNTX = 4000;  // for Coincidence Daughter20191125_1617
final int MOUNTY = 4000;  // for Coincidence Daughter20191125_1617
final String sSNMY100 = "my100-14n0328"; // IMPORTANT change for your maching.

final float BOARDHEIGHT = 2.5;         // Magic number in INCHES for board. Example the ExpressPCB MiniboardPro.

//The files you need in the data folder
// Pick and place file emailed from ExpressPCB.
final String pickNPlaceFile = "Pick-and-place for WUKT8747E.csv";
// From Edit>Copy bill of material to clip board (of Express PCB schematic RefDes get Order# (Part Number), field 1 get field 3
final String schematicBOMFile = "Coincidence Daughter20191125_1617.tsv"; 

/*End of code user must edit. */

// Some text files with My100 programing strings. Edit these files for the assembly name and for board width and fuducial locations.
final String pickAndPlacelayoutPanelHeader = "My100_LAYOUT_PANEL.txt"; // Layout and Panel data required by My100 for project.

//The tables to create
Table pickNPlacetable;                //Open the ExpressPCB pick and place file for this PCB.
Table schematicBOMtable;              //Open the schematicBOM file with the part number in the "order#" field for this PCB.

//Fixed My100 fields
int group = 0;                         //Not useing Groups
String mountSkip = "N";                //Not useing mountSkip
final String glue = "N";               //We do not have glue equipment
String PartNumBOM = "foo";

//Scaling factors
final int xFactor = 1000; // Convert  inches to mills or mm to um
final int yFactor = 1000; // Convert  inches to mills
final int aFactor = 1000; // Convert  degrees to mills of degree

//Offset 
//The ExpressPCB orgin is upper left of board. My100 origin is lower left
//The xOffset is therefor zero but the My100 origin must be offset by the board height.
final int xOffset = 0; // 
final int yOffset = int(BOARDHEIGHT*25.4*1000); // 63500; // Set magic number for board height  2.5 inch * 25.4 * 1000


void setup() {
  size(400,400);
  //Load the pick and place and the schematic BOM into tables. 
  pickNPlacetable = loadTable(pickNPlaceFile, "header");
//  println(pickNPlacetable.getRowCount() + " total rows in Pick and Place");
  //CAUTION: The Schematic BOM must manualy be prepended with '*Ref  Value  PartNumber' header, or add a schematic part to do so.
  schematicBOMtable = loadTable(schematicBOMFile, "header");
//  println(schematicBOMtable.getRowCount() + " total rows in BOM");
 
  /* The "S" lines required for MY100 LAYOUT*/
  //S1, S, S3, S4, S4M, S4, S5 and S6 lines in the LAYOUT
  appendTextToFile(my100PickNPlaceFileName, "# *** LAYOUTS ***"); //A decorative comment
  appendTextToFile(my100PickNPlaceFileName, "S1\t" + sPROJECTNAME); //S1
  appendTextToFile(my100PickNPlaceFileName, "S2\t" + sLAYOUTNOTE); //S2
  appendTextToFile(my100PickNPlaceFileName, "S3P\t" + sPROJECTNAME); //S3
  appendTextToFile(my100PickNPlaceFileName, "S4\t" + FD1X +"\t" +FD1Y + "\t" +FD2X +"\t" +FD2Y); //S4B Layout Fuducial marks, optional.
  appendTextToFile(my100PickNPlaceFileName, "S4M\t" + sSNMY100); //S4M serial number for MY100.
  appendTextToFile(my100PickNPlaceFileName, "S4\t" + FD1X +"\t" +FD1Y + "\t" +FD2X +"\t" +FD2Y); //S4B Layout Fuducial marks, optional.
  appendTextToFile(my100PickNPlaceFileName, "S5\t" + int(BOARDHEIGHT*2.5*1000));//the board height for rail width
  appendTextToFile(my100PickNPlaceFileName, "S6\t NORMAL");                   //S6 conveor board type 
  appendTextToFile(my100PickNPlaceFileName, "S7\t N NEW Y");     //S7 GlobalGroupingNO, measureboardlevelwhenNEW, overlapboardwarningYES 

  
   /* The "P" lines required for MY100 PANEL*/ 
  //P1, P21, P3 and P3, P5, P6, P7 and P8 lines in the PANEL 
  appendTextToFile(my100PickNPlaceFileName, "\r\n# *** PANELS ***"); //A decorative comment
  appendTextToFile(my100PickNPlaceFileName, "P1\t" + sPROJECTNAME); //P1
  appendTextToFile(my100PickNPlaceFileName, "F21\t All_Tools"); //P21
  //Fuducials for panel Make the same as PCB.
  appendTextToFile(my100PickNPlaceFileName, "P3\t" +FD1X+ "\t" +FD1Y +"\trnd-1.2mm");  //P3 first fuducial in PCB
  appendTextToFile(my100PickNPlaceFileName, "P3\t" +FD2X+ "\t" +FD2Y +"\trnd-1.2mm");  //P3 second fuducial in PCB
  appendTextToFile(my100PickNPlaceFileName, "P5 \t0  \t0  ");                   //P5 Glue test position
  appendTextToFile(my100PickNPlaceFileName, "P51 \t0  \t0  ");                   //P51 Barcode test postion
  appendTextToFile(my100PickNPlaceFileName, "P6\t" + MOUNTX +"\t"+ MOUNTY);     //P6 Mount tool test position.
  appendTextToFile(my100PickNPlaceFileName, "P6B \t0  \t0  ");                   //P6B BAD Barcode poistion
  appendTextToFile(my100PickNPlaceFileName, "P7\t" + sPROJECTNAME);
  appendTextToFile(my100PickNPlaceFileName, "P8\t" + FD1X +"\t" +FD1Y + "\t" +FD2X +"\t" +FD2Y); //P6B PCB Fuducial marks, optional.
    
  /* The "F" lines required for MY100 PCB*/ 
  //F1, F2, F3 and F3, F5 and F6 lines in the PCB 
  appendTextToFile(my100PickNPlaceFileName, "\r\n# *** PCB ***"); //A decorative comment
  appendTextToFile(my100PickNPlaceFileName, "F1\t" + sPROJECTNAME); //F1
  appendTextToFile(my100PickNPlaceFileName, "F2\t" + sPROJECTNOTE); //F2
  appendTextToFile(my100PickNPlaceFileName, "F3\t" +FD1X+ "\t" +FD1Y +"\trnd-1.2mm");  //F3 first fuducial in PCB
  appendTextToFile(my100PickNPlaceFileName, "F3\t" +FD2X+ "\t" +FD2Y +"\trnd-1.2mm");  //F3 second fuducial in PCB
  appendTextToFile(my100PickNPlaceFileName, "F5 \t0  \t0  ");                   //F5 Glue test position
  appendTextToFile(my100PickNPlaceFileName, "F6 \t" + MOUNTX +"\t"+ MOUNTY);    //F6 Mount tool test position.
  
  /*Write the F8 and F9 lines for placement to file. 
  *Get the pick and place by ref des from Pick and place file.
  *Get the Part Number for the ref (Reference designator) from the schematicBOM Order# field.
  *Compose the F8 and F9 lines.
  *println("#F8 template  x  y  angle  group  mount  glue  Spectrum Techniques PN  \r\n#F9  Location(Refdes)");   
  */
  
  //Ref,Part Name,X,Y,Rotation,Side
  for (TableRow row : pickNPlacetable.rows()) {
    String refDes = row.getString("Ref");
    //String partName = row.getString("Part Name");    //Not used in MyData output.
    float f_x = row.getFloat("X");
    float f_y = row.getFloat("Y");
    float f_rotation = row.getFloat("Rotation");
    //Scale and make interger
    int x = int(f_x*xFactor);
    int y = int(f_y*yFactor);
    int rotation = int(f_rotation)+90;        //Lets rotate all components +90 degrees to get the C and Rs correct.
    rotation = (rotation % 360) * aFactor ;    
  
    //Offset origin. My100 orgin is lower left. Increase Y is up.
    x = x - xOffset ;
    y = -(y - yOffset);    
    
    //For Ref find the schematic part number. ie, schematicBOMFile third field of (refDes)
    // Ref  Value  PartNumber    
    for (TableRow bomRow : schematicBOMtable.rows()){  
      Boolean isDNI = false;
      String refBOM = bomRow.getString("*Ref");
      String valBOM = bomRow.getString("Value");
      String pnBOM = bomRow.getString("PartNumber");      //ExpressPCB Schematic BOM Order# field.

      String[] isValDNI = match(valBOM, "DNI");
      String[] isPNDNI = match(pnBOM, "DNI");
      if( (isValDNI != null) || (isPNDNI != null)){      //Remove DNI from pick and place.
        isDNI = true;
      }  
      Boolean isBoardFeatureDNI = false;
      String[] isBoardFeature = match(pnBOM, "Board Feature");
      if( (isBoardFeature != null)){      //Remove 'Board Feature' from pick and place.
        isBoardFeatureDNI = true;
      }
            
      String[] m1 = match(refDes, refBOM);
      int refDesLength = refDes.length();
      int refBOMLength = refBOM.length();
      if ((m1 != null) && (refDesLength == refBOMLength) && !isDNI && !isBoardFeatureDNI){    
        PartNumBOM = pnBOM;
        //Output format: F8 tab x, tab y, tab angle, tab group, tab mount, tab glue, tab PartNum, CR LF, F9 tab, Ref
        String outText = "F8\t"+ x + "\t"+ y + "\t" + rotation + "\t" + group + "\t" + mountSkip + "\t" + glue + "\t" + PartNumBOM + "\r\nF9 " + refDes;
        println(outText);
        appendTextToFile(my100PickNPlaceFileName, outText);
      }else {
        PartNumBOM = "foobar";
      }//Else
    }//bomRow 
  }//Print out table
  println("Done generating My100PickandPlace file as: " + my100PickNPlaceFileName);
}//Setup

void draw(){
  text("Press Mouse wheel to exit when done.",10,10);  
}//draw

/*event driven functions*/
//Mouse press to modify table
void mousePressed() {
    if (mouseButton == LEFT){
    }    
    else if (mouseButton == RIGHT ){
    }
    else {
      println("Good bye.");
      exit();
    }
}//end mousePressed
