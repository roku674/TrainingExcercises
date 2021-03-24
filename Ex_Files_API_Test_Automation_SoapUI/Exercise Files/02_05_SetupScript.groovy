def inputFilePath = testRunner.testCase.testSuite.getPropertyValue( "inputFile" )

def myFile = new File (inputFilePath)

def lines = myFile.readLines()

context.mylines = lines

assert lines.size() == 4