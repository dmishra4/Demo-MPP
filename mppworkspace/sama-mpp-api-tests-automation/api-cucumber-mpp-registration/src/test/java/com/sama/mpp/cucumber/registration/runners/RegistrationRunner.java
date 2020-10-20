package com.sama.mpp.cucumber.registration.runners;

import org.junit.AfterClass;
import org.junit.BeforeClass;
import org.junit.runner.RunWith;

import com.sama.mpp.cucumber.registration.utils.CommonFunctions;

import cucumber.api.CucumberOptions;
import cucumber.api.junit.Cucumber;

@RunWith(Cucumber.class)
@CucumberOptions(features = "./src/test/resources/com/sama/mpp/cucumber/features", glue =
"com.sama.mpp.cucumber.registration.stepdefs", dryRun =false,plugin = {"pretty", "html:Reports/Cucumber-StandardReport",
	"json:target/Cucumber-Report/cucumber.json"},
tags = {
	
	//     #########################Feature tags #####################
	//	"@01_CreateRegistration"
    //  "@02_AmendRegistration"
	//	"@03_LookUpProxy"
    //	 ######################### Scenario tags #####################
	//	"@01_01_Create_IndividualRegistration"  //pass
	//	"@01_02_Create_BusinessRegistration"     // Pass
	//	"@01_03_Create_InvalidStructure"   // Passed
	//	"@01_04_Create_BusinessAndIndividual"     // Passed
	//	"@01_05_CreateReg_WrongAccType"        // Pass
	//	"@01_06_CreateReg_NotSupportedAccType"   // Pass
	//	"@01_07_CreateReg_99Proxies"   // Pass
	//	"@01_08_CreateReg_NotSupportedProxyType" // Pass		
	//	"@02_01_Amendment_PersonName"  // Pass
	//	"@02_02_Amendment_AccNumber"// pass
	//	"@02_03_Amendment_NonExistRegID" // pass
	//	"@02_04_Amendment_DeactivatedRegID"  //Pass
	//	"@02_05_Amendment_NoUpdateFields"  //pass
	//	"@02_06_Amendment_NonAmendableProxyType"  // Pass
	//	"@02_07_Amendment_DifferentAccType"   //pass
	//	"@02_08_Amendment_99Proxies"
	//	"@03_01_LOOKUPS_AccInfo"  // Pass
	//	"@03_02_LOOKUPS_RetiredParticipant"  // Pass
	//	"@03_03_LOOKUPS_InvalidProxy"   // Pass
	//	"@03_04_LOOKUPS_RetiredParticipant"    // Pass
	//	"@03_05_LOOKUPS_NotRegisteredToken"   // Pass
			   

			
         })
public class RegistrationRunner {
	@BeforeClass
	public static void deleteOldScreenshots() {
		CommonFunctions.cleanup_screenshots();
	}

	@AfterClass
	public static void report() throws InterruptedException {
		CommonFunctions.generateCustomReport();
	}
}
