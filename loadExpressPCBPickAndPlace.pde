/** loadExpressPCBPickAndPlace
* Lee Erickson
* This software is designed to kill you, but is not guarenteed to do so. Use at own risk.
* 20191203 Transmongraphied from example at: https://processing.org/reference/loadTable_.html
* Update for mouse to add row or add column or exit."
* Update to open pick and place file from ExpressPCB for Coincidence Daughter20191125_1617
* Updated to read first row of table. See: https://www.youtube.com/watch?v=woaR-CJEwqc at about 8:00 time.
* Ouput for F8 and F9 lines of MY100LXE file format.
* Open the schematic BOM (parts list) which has RefDes and Part Number fields into a table.
* Remove magic strings for file names.
* Look up Part Number (Order#) from Schematic by RefDes in Pick and Place. 
* Prints to console the F8 and F9 lines as required for MyData.
* Prepends the lines from an example MyData PCB file for F1 to F6.
* Add output to file.
* Remove left and right mouse actions.
* 20191203 
*/

//The tables to create
Table pickNPlacetable;                //Open the ExpressPCB pick and place file for this PCB.
Table schematicBOMtable;              //Open the schematicBOM file with the part number in the "order#" field for this PCB.

//The files you need
final String pickNPlaceFile = "Pick-and-place for WUKT8747E.csv";
//final String pickNPlaceFileFixed = "Pick-and-place for WUKT8747EFixRef.csv";  //Same as above but change C0001 to C1 and so on.
//String pickNPlaceFile = pickNPlaceFileFixed;
final String schematicBOMFile = "Coincidence Daughter20191125_1617.tsv"; // From Express PCB schematicBOM RefDes get Order# (Part Number), field 1 get field 3
final String pickAndPlacelayoutPanelHeader = "My100_LAYOUT_CD.txt"; // Layout and Panel data required by My100 for project.
final String pickAndPlacePCBHeaderF1toF6File = "My100PCBF1toF6.txt"; // Lines required by My100 for PCB file

//Fixed My100 fields
int group = 0;                         //Not useing Groups
String mountSkip = "N";                //Not useing mountSkip
final String glue = "N";                     //We do not have glue equipment
String PartNumBOM = "foo";

//Scaling factors
final int xFactor = 1000; // Convert  inches to mills
final int yFactor = 1000; // Convert  inches to mills
final int aFactor = 1000; // Convert  degrees to mills of degree

//Offset 
final int xOffset = 0; // 
final int yOffset = 2500000; // Set for board height


void setup() {
  size(400,400);
  //Load text for Layout and Panel of Mydata PCB file.
  String[] headerLayoutPanel = loadStrings(pickAndPlacelayoutPanelHeader);
  
  //Load text for lines F1 to F6 of Mydata PCB file.
  String[] headerPCB = loadStrings(pickAndPlacePCBHeaderF1toF6File);
  //Load the pick and place and the BOM into tables 
  pickNPlacetable = loadTable(pickNPlaceFile, "header");
//  println(pickNPlacetable.getRowCount() + " total rows in Pick and Place");
  schematicBOMtable = loadTable(schematicBOMFile, "header");
//  println(schematicBOMtable.getRowCount() + " total rows in BOM");

  /*Begin writing to file. Start with the Layout and Panel lines required for MY100 Layout and Panel*/ 
  for (int i = 0 ; i < headerLayoutPanel.length; i++) {
    println(headerLayoutPanel[i]);
    appendTextToFile(myLogFileName, headerLayoutPanel[i]);
  }
  
  /*Begin writing to file. Start with the lines required for MY100 PCB*/ 
  for (int i = 0 ; i < headerPCB.length; i++) {
    println(headerPCB[i]);
    appendTextToFile(myLogFileName, headerPCB[i]);
  }  
  println("#Let's print it out F8 abd F9 lines in MYDATA MY100 format."); 
  println("#F8 template  x  y  angle  group  mount  glue  Spectrum Techniques PN  \r\n#F9  Location(Refdes)"); 
  
  /*Write the F8 and F9 lines for placement to file. 
  *Get the pick and place by ref des from Pick and place file.
  *Get the Part Number for the ref (Reference designator) from the schematicBOM Order# field.
  *Compose the F8 and F9 lines*/
  
  //Ref,Part Name,X,Y,Rotation,Side
  for (TableRow row : pickNPlacetable.rows()) {
    String refDes = row.getString("Ref");
//    String partName = row.getString("Part Name");    //Not used in MyData output.
    float f_x = row.getFloat("X");
    float f_y = row.getFloat("Y");
    float f_rotation = row.getFloat("Rotation");
    //Scale and make interger
    int x = int(f_x*xFactor);
    int y = int(f_y*yFactor);
    int rotation = int(f_rotation*aFactor);
    
    //Offset origin. My100 orgin is lower left. Increase Y is up.
//    x = x - xOffset ;
//    y = -(y - yOffset);    
    
    //For Ref find the schematic part number. ie, schematicBOMFile third field of (refDes)
    // Ref  Value  PartNumber    
    for (TableRow bomRow : schematicBOMtable.rows()){      
      String refBOM = bomRow.getString("Ref");
      String valBOM = bomRow.getString("Value");
      String pnBOM = bomRow.getString("PartNumber");      //ExpressPCB Schematic BOM Order# field.
//      String[] m1 = matchAll(refBOM,refDes);
      String[] m1 = match(refDes, refBOM);
      int refDesLength = refDes.length();
      int refBOMLength = refBOM.length();
//      String[] m1 = match(refDes, bomRow.getString("Ref"));
//      String[] m1 = match(bomRow.getString("Ref"), refDes);
      if ((m1 != null) && (refDesLength == refBOMLength)){    
        PartNumBOM = pnBOM;
        //Output format, F8 tab x, tab y, tab angle, tab group, tab mount, tab glue, tab PartNum, CR LF, F9 tab, Ref
        String outText = "F8\t"+ x + "\t"+ y + "\t" + rotation + "\t" + group + "\t" + mountSkip + "\t" + glue + "\t" + PartNumBOM + "\r\nF9 " + refDes;
//        println("F8\t"+ x + "\t"+ y + "\t" + rotation + "\t" + group + "\t" + mountSkip + "\t" + glue + "\t" + PartNumBOM + "\r\nF9 " + refDes);
        println(outText);
        appendTextToFile(myLogFileName, outText);
      }else {
        PartNumBOM = "foobar";
      }//Else
    }//bomRow 
  }//Print out table
}//Setup

void draw(){
  text("Press Left Mouse to add a row",10,10);  
}//draw


// Sketch prints:
// 3 total rows in table
// Goat (Capra hircus) has an ID of 0
// Leopard (Panthera pardus) has an ID of 1
// Zebra (Equus zebra) has an ID of 2

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
