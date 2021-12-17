I am using the framework called Karate (https://github.com/karatelabs/karate)
These tests can be run from Intellij and VSCode (https://github.com/karatelabs/karate/wiki/IDE-Support). 

Here are the instructions to run the tests using karate standalone
* Ensure Java installed (best to have any version between 8 - 11, I have used 11)
* Download karate jar file from the following link, and rename to `karate.jar` (use latest stable, I have used v1.1.0)
  * https://github.com/karatelabs/karate/releases
* Download following file into the same directory:
  * gistapitest.feature
* Open console in directory, and use the following command to run the tests
  * java -jar karate.jar gistapitest.feature
* Open target/karate-reports folder and open karate-summary.html in browser to check the test report
