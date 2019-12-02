/** loadExpressPCBPickAndPlace
*Transmongraphied from example at: https://processing.org/reference/loadTable_.html
*Update for mouse to add row or add column or exit."
* Update to open pick and place file from ExpressPCB for Coincidence Daughter20191125_1617
* Updated to read first row of table. See: https://www.youtube.com/watch?v=woaR-CJEwqc at about 8:00 time.
*/

Table table;

void setup() {
  size(400,400);

  table = loadTable("Pick-and-place for WUKT8747EFixRef.csv", "header");
  println(table.getRowCount() + " total rows in table");
  
  println("Lets print it out in MYDATA MY100 format.\n\n"); 
  //Ref,Part Name,X,Y,Rotation,Side
  for (TableRow row : table.rows()) {
    String refDes = row.getString("Ref");
    String partName = row.getString("Part Name");
    float x = row.getFloat("X");
    float y = row.getFloat("Y");
    float rotation = row.getFloat("Rotation");
    
    //Other My100 fields
    int group = 0;                         //Not useing Groups
    String mountSkip = "N";                //Not useing Groups
    String glue = "N";                     //We do not have glue equipment
    String PartNumBOM = "foo";
   
    
//    println(partName + " (" + refDes + ") has an ID" );
//    println("F8\t"+ partName + "\t"+ refDes);

    //Output format, F8 tab x, tab y, tab angle, tab group, tab mount, tab glue, tab PartNum, CR LF, F9 tab, Ref 
    println("F8\t"+ x + "\t"+y + "\t" + rotation + "\t" + group + "\t" + mountSkip + "\t" + glue + "\t" + PartNumBOM + "\r\nF9 " + refDes);
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
      println(table.getRowCount());  // Prints 1
      TableRow newRow = table.addRow();
      newRow.setString("name", "Lion");
      newRow.setString("type", "Mammal");
      println(table.getRowCount());  // Prints 1
      
    }    
    else if (mouseButton == RIGHT ){
      println(table.getColumnCount());  //Prints starting column count
      println("Lets add a column called 'Favorite food'.");
      table.addColumn("Favorite food");
      println(table.getColumnCount());  // Prints updated column count
    }
    else {
      println("Good bye.");
      exit();

    }
}//end mousePressed
