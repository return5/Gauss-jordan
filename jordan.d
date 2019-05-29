import std.stdio; //input and output
import std.uni; //isDigit())
import std.algorithm;  //reverse()
import std.conv; //to!double()
import std.string; //split()

/*
   program which implements a simple gauss-jordan on a matrix.
   written in D to help learn the language. 
   limited to numbers, either ints or floating point. doesnt handle trig expressions, complex numbers, nor laplace.
   input must be limited to numbers and whitespaces. no '+','-','=' nor any other symbol or letter.
   author: github.com/return5
 */


//subtracts end_row from all rows in matrix and identity
void subLinesTogetherJordan(double [][] matrix,const int end_row,double [][] identity) {
	for(int i = 0; i < end_row; i++){
		matrix[i][] -= matrix[end_row][];
		identity[i][] -= identity[end_row][];
	}
}

//subtracts row above start_row row from all rows below it.  
void subLinesTogether(double [][] matrix, const int start_row,double [][] identity) {
	for(int i = start_row; i < matrix.length; i++){
		matrix[i][] -= matrix[start_row - 1][];
		identity[i][] -= identity[start_row-1][];
	}
}

//divides through each row by the number in the location of 'index' in order to get that number to be 1.
void divideThrough(double [][] matrix, const int start_row, const int index,double [][] identity) {
	for(int i = start_row; i < matrix.length; i++) {
		if(matrix[i][index] != 0) {
			const double value = matrix[i][index];
			matrix[i][] /= value;
			identity[i][] /= value;
		}
	}
}
//forms identity matrix;
double [][] makeIdenMatrix(const int length) {
	double [][] identity = new double[][](length,length);
	for(int i = 0; i < length;i++ ) {
		for(int j = 0; j < length;j++) {
			identity[i][j] = (j == i) ? 1.0 : 0.0;
		}
	}	
	writeln("identity matrix is :",identity);
	return identity;
}
//checks to make sure matrix is correct size.
int checkMatrixSize(const double [][] matrix) {
	for(int i = 0; i < matrix.length; i++) {
		if(matrix.length != matrix[i].length) {
			writeln("your matrix must be square. try again");
			return 0;
		}
	}
	return 1;
}

//makes sure there are only numbers and spaces in a row.
int checkIfAlpha(const string row) {
	foreach(c;row) {
		if(!isNumber(c) && !isSpace(c) && c != '-') {
			return 0;
		}
	}
	return 1;
}

//gets user to input the matrix one row at a time.can only be numbers or whitespaces.
double [][] getMatrix() {
	double [][] matrix;
	string line;	
	do {
		writeln("please enter an equation of numbers.type \"done\" when finished.");
		line = strip(readln());
		if (line == "done") {
			break;
		}
		else if (line == "") {
			writeln("sorry, line cannot be empy");	
		}
		else if (checkIfAlpha(line) == 0) {
			writeln("sorry, rows must only contain numbers and spaces");
		}
		else {
			matrix ~= to!(double[])(split(line));
		}
	} while (line != "done" );
	return matrix;
}

void main() {
	double [][] matrix = getMatrix();
	double [][] identity = makeIdenMatrix(cast(int)matrix.length);
	writeln("matrix is :",matrix);
	if(checkMatrixSize(matrix) == 1 ) {	
		//puts matrix in row eschelon form using gauss elimination
		for (int i = 0; i < cast(int)matrix[0].length-1; i++) {
			 divideThrough(matrix,i,i,identity);	
			 subLinesTogether(matrix,i+1,identity);
		}
		//forms identity matrix into inverted matrix through transforming original matrix into identity matrix.
		for (int i = cast(int)matrix[0].length-1; i >= 0; i--) {
			divideThrough(matrix,0,i,identity);	
			subLinesTogetherJordan(matrix,i,identity);
		}
	writeln("inverted matrix is :",identity);
	}
}
