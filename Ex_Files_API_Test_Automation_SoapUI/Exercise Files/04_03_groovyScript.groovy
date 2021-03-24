def inputFilePath = testRunner.testCase.testSuite.getPropertyValue( "inputFile" )

def tc = testRunner.testCase.testSuite.project.testSuites["Data Driven Test Suite"].testCases["TestCase 1"]
void setProperties(string currentLine){
    testRunner.testCase.testSuite.setPropertyValue( "inArea", currentLine.split(",")[0] )
    testRunner.testCase.testSuite.setPropertyValue( "inLocation", currentLine.split(",")[1] )
}
File file = new File (inputFilePath.toString()).eachLine{
	try{
        setProperties(it)
        def tc = testRunner.testCase.testSuite.testCases["TestCase 1"]
        def runner = tc.run(null, false)
        log.info ("${runner.status}")
        sleep 500
        1/0
    }
    catch(Exception){
        log.info("Exception Thrown")
    }
}