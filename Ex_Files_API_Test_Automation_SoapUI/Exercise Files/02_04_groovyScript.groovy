def inputFilePath = testRunner.testCase.testSuite.getPropertyValue( "inputFile" )

def tc = testRunner.testCase.testSuite.project.testSuites["Data Driven Test Suite"].testCases["TestCase 1"]

File file = new File (inputFilePath.toString()).eachLine{
	testRunner.testCase.testSuite.setPropertyValue( "inArea", it.split(",")[0] )
	testRunner.testCase.testSuite.setPropertyValue( "inLocation", it.split(",")[1] )

	def tc = testRunner.testCase.testSuite.testCases["TestCase 1"]
	def runner = tc.run(null, false)
	log.info ("${runner.status}")
	sleep 500
}