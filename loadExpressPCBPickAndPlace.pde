/** loadTable
*From: https://processing.org/reference/loadTable_.html
*Update for mouse to add row or add column or exit."
*/


// The following short CSV file called "mammals.csv" is parsed
// in the code below. It must be in the project's "data" folder.
//
// id,species,name
// 0,Capra hircus,Goat
// 1,Panthera pardus,Leopard
// 2,Equus zebra,Zebra

Table table;

void setup() {
  size(400,400);
  table = loadTable("mammals.csv", "header");
  println(table.getRowCount() + " total rows in table");
  for (TableRow row : table.rows()) {
    int id = row.getInt("id");
    String species = row.getString("species");
    String name = row.getString("name");
    println(name + " (" + species + ") has an ID of " + id);
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
