/** loadExpressPCBPickAndPlace
*Transmongraphied from example at: https://processing.org/reference/loadTable_.html
*Update for mouse to add row or add column or exit."
* Update to open pick and place file from ExpressPCB for Coincidence Daughter20191125_1617
* Updated to read first row of table. See: https://www.youtube.com/watch?v=woaR-CJEwqc at about 8:00 time.
* Ouput for F8 and F9 lines of MY100LXE file format.
* Open the schematic BOM (parts list) which has RefDes and Part Number fields into a table.
* Remove magic strings for file names.
* Look up Part Number (Order#) from Schematic by RefDes in Pick and Place. 
* Prints to console the F8 and F9 lines as required for MyData.
*/

//The tables to create
Table pickNPlacetable;                //Open the ExpressPCB pick and place file for this PCB.
Table schematicBOMtable;              //Open the schematicBOM file with the part number in the "order#" field for this PCB.

//The files you need
final String pickNPlaceFileFixed = "Pick-and-place for WUKT8747EFixRef.csv";  //Same as above but change C0001 to C1 and so on.
//final String pickNPlaceFile = "Pick-and-place for WUKT8747E.csv";
String pickNPlaceFile = pickNPlaceFileFixed;
final String schematicBOMFile = "Coincidence Daughter20191125_1617.tsv"; // From Express PCB schematicBOM RefDes get Order# (Part Number), field 1 get field 3

//Fixed My100 fields
int group = 0;                         //Not useing Groups
String mountSkip = "N";                //Not useing mountSkip
final String glue = "N";                     //We do not have glue equipment
String PartNumBOM = "foo";

void setup() {
  size(400,400);
  
  //Load the pick and place and the BOM into tables 
  pickNPlacetable = loadTable(pickNPlaceFileFixed, "header");
  println(pickNPlacetable.getRowCount() + " total rows in Pick and Place");
  schematicBOMtable = loadTable(schematicBOMFile, "header");
  println(schematicBOMtable.getRowCount() + " total rows in BOM");
  
  println("Let's print it out F8 abd F9 lines in MYDATA MY100 format.\n\n"); 
  //Ref,Part Name,X,Y,Rotation,Side
  for (TableRow row : pickNPlacetable.rows()) {
    String refDes = row.getString("Ref");
//    String partName = row.getString("Part Name");    //Not used in MyData output.
    float x = row.getFloat("X");
    float y = row.getFloat("Y");
    float rotation = row.getFloat("Rotation");
    
    //For Ref find the schematic part number. ie, schematicBOMFile third field of (refDes)
    // Ref  Value  PartNumber
    
    for (TableRow bomRow : schematicBOMtable.rows()){
      
      String refBOM = bomRow.getString("Ref");
      String valBOM = bomRow.getString("Value");
      String pnBOM = bomRow.getString("PartNumber");      

      String[] m1 = match(refDes, bomRow.getString("Ref"));
      if (m1 != null){    
//      if (refDes == bomRow.getString("Ref")){
        PartNumBOM = pnBOM;
//        println("Got one! Ref is: " + refDes + " and PartNumBOM is: " + PartNumBOM + " and pnBOM is: " + pnBOM);
        //Output format, F8 tab x, tab y, tab angle, tab group, tab mount, tab glue, tab PartNum, CR LF, F9 tab, Ref 
        println("F8\t"+ x + "\t"+y + "\t" + rotation + "\t" + group + "\t" + mountSkip + "\t" + glue + "\t" + PartNumBOM + "\r\nF9 " + refDes);
      }else {
        PartNumBOM = "bar";
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
      println("Lets add a row.");
      println(pickNPlacetable.getRowCount());  // Prints 1
      TableRow newRow = pickNPlacetable.addRow();
      newRow.setString("name", "Lion");
      newRow.setString("type", "Mammal");
      println(pickNPlacetable.getRowCount());  // Prints 1
      
    }    
    else if (mouseButton == RIGHT ){
      println(pickNPlacetable.getColumnCount());  //Prints starting column count
      println("Lets add a column called 'Favorite food'.");
      pickNPlacetable.addColumn("Favorite food");
      println(pickNPlacetable.getColumnCount());  // Prints updated column count
    }
    else {
      println("Good bye.");
      exit();
    }
}//end mousePressed
