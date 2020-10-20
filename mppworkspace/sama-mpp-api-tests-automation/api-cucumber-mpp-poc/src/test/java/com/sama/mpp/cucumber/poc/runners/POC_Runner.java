package com.sama.mpp.cucumber.poc.runners;

import org.junit.AfterClass;
import org.junit.BeforeClass;
import org.junit.runner.RunWith;

import com.sama.mpp.cucumber.poc.utils.CommonFunctions;

import cucumber.api.junit.Cucumber;

import cucumber.api.CucumberOptions;

@RunWith(Cucumber.class)
@CucumberOptions(features = "./src/test/resources/com/sama/mpp/cucumber/features", glue =
"com.sama.mpp.cucumber.poc.stepdefs", dryRun =false,plugin = {"pretty", "html:Reports/Cucumber-StandardReport",
	"json:target/Cucumber-Report/cucumber.json"},
tags = {
	
	//"@Create_Registration"
	//	"@01_01_MPP_EnquiryByRegistrationId"
	//	"@Proxy_Amendment"
	//	"@Create_BusinessRegistration"
	//	"@01_03_Create_TechErrorRegistration"   // Passed
	//	"@01_04_Create_BusinessErrorRegistration"     // Passed
	//	"@01_05_CreateReg_WrongAccType"        // Pass
	//	"@01_06_CreateReg_SameAccName"   // Not Passed yet Need clarification.
		"@01_08_CreateReg_WrongProxyType"  // Passed.
			

			
         })
 public class POC_Runner {
   
	@BeforeClass
	public static void deleteOldScreenshots() {
		CommonFunctions.cleanup_screenshots();
	}

	@AfterClass
	public static void report() throws InterruptedException {
		CommonFunctions.generateCustomReport();
	}
	
}
