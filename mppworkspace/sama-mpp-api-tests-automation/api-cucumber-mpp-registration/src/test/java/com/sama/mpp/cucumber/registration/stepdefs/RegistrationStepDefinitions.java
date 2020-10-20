package com.sama.mpp.cucumber.registration.stepdefs;

import java.io.File;
import java.io.FileReader;
import java.io.FileWriter;
import java.io.IOException;
import java.util.List;

import org.json.simple.JSONObject;
import org.json.simple.parser.JSONParser;
import org.json.simple.parser.ParseException;

import com.sama.mpp.cucumber.registration.utils.CommonFunctions;
import com.sama.mpp.cucumber.registration.utils.RegistrationLib;

import cucumber.api.Scenario;
import cucumber.api.java.Before;
import cucumber.api.java.en.Given;
import cucumber.api.java.en.Then;
import cucumber.api.java.en.When;
import io.restassured.RestAssured;

public class RegistrationStepDefinitions {

	public static Scenario scenario;
	private static  String baseURL;
	public static String requestFile;
	public static String newRequestFile;
	private static String resourcepath;
	public static String encypted_output;
	public static String encypted_accesstoken;
	public static String decrypted_accesstoken;
	public static String access_token;
	public static String signature_output;
	public static String signature;
	public static String browser;
	
	@Before
	public void beforeScenario(Scenario scenario) {
		//this.scenario = scenario;
		
		RegistrationStepDefinitions.scenario = scenario;
		RestAssured.useRelaxedHTTPSValidation();
		
	}
	
	@Given("a REST API request {string} and url {string} along with below headers under {string} environment")
	public void a_REST_API_request_and_url_along_with_below_headers_under_environment(String requestEncryption, String endpoint,String environment, List<List<String>> listoflist) {
	    // Write code here that turns the phrase above into concrete actions

		environment = "SIT";
		// environment="UAT";
		resourcepath = endpoint;
		if (environment.equalsIgnoreCase("SIT")) {
			baseURL = "https://10.158.244.98";
		} else if (environment.equalsIgnoreCase("UAT")) {
			baseURL = "https://10.158.239.131";
		} else {
			System.out.println(" Environment must be either SIT or UAT");
		}
		RegistrationLib.addheaders(listoflist,baseURL,endpoint);		
		requestFile = requestEncryption; // Assigning requestEncryption value to the requestFile String variable.		
	}

	

	@When("{string} action is performed")
	public void action_is_performed(String action) {
	    // Write code here that turns the phrase above into concrete actions
		RegistrationLib.requestActivity(action, "encryption", baseURL,resourcepath);
	    
	}

	@Then("the status code is {string}")
	public void the_status_code_is(String expStatusCode) {
	    // Write code here that turns the phrase above into concrete actions
		
		RegistrationLib.statusCodevalidation(expStatusCode);    
	}

	@Then("{string} response includes the following values as")
	public void response_includes_the_following_values_as(String string, List<List<String>> listoflist) {
	    // Write code here that turns the phrase above into concrete actions

		for(List<String> liststring :listoflist) {
		String nodename =	liststring.get(0);
		String nodevalue = liststring.get(1);
		RegistrationLib.jsonResponseValidation(nodename,nodevalue);
		}
	}

	@Given("a encrypted output  {string} and url {string} along with below headers under {string} environment")
	public void a_encrypted_output_and_url_along_with_below_headers_under_environment(String requestfile, String endpoint, String string3, List<List<String>> listoflist) {
	    // Write code here that turns the phrase above into concrete actions

		resourcepath=endpoint;
        RegistrationLib.addheaders(listoflist,baseURL,endpoint);		
	}
	
	@When("{string} action is performed to genarate signature for {string}")
	public void action_is_performed_to_genarate_signature_for(String action, String activity) throws IOException, ParseException {
	    // Write code here that turns the phrase above into concrete actions
		 
		if(activity.equalsIgnoreCase("Proxy Registration"))
		{
		RegistrationLib.generateSignature(action,activity,baseURL,resourcepath,requestFile);
		}
		else 
		{
			RegistrationLib.generateSignature(action,activity,baseURL,resourcepath,newRequestFile);
		}

			
	}
	@When("{string} action is performed to genarate {string}")
	public void action_is_performed_to_genarate(String action, String activity) {

	 
	    // Write code here that turns the phrase above into concrete actions		
		RegistrationLib.proxyRegistration(action, activity,baseURL,resourcepath,requestFile);		

	}
	@When("{string} action is performed to retrieve {string}")
	public void action_is_performed_to_retrieve(String action, String activity) {
	    // Write code here that turns the phrase above into concrete actions
		RegistrationLib.proxyLOOKUPS(action, activity,baseURL,resourcepath,requestFile);
	}
	@When("{string} action is performed for Proxy Amendment having registration ID {string}")
	public void action_is_performed_for_Proxy_Amendment_having_registration_ID(String action, String registrationId) {
	    // Write code here that turns the phrase above into concrete actions
		RegistrationLib.proxyAmendment(action,registrationId,baseURL,resourcepath,newRequestFile);
	}
	
	@When("{string} action is performed to genarate {string} access token")
	public void action_is_performed_to_genarate_access_token(String action, String activity) {
	    // Write code here that turns the phrase above into concrete actions
		
		RegistrationLib.generatetoken(action, activity, baseURL, resourcepath);	    
	}

	
	@Given("Perform the below Proxy Amendment for registration {string} and generate a new REST API request {string}")
	public void perform_the_below_Proxy_Amendment_for_registration_and_generate_a_new_REST_API_request(String registrationId, String filename,List<List<String>> listoflist) throws IOException, ParseException {
	    // Write code here that turns the phrase above into concrete actions
       
		registrationId=RegistrationLib.registrationID;
		newRequestFile=filename;
		System.out.println("filename is :: "+filename);		
		String dir = System.getProperty("user.dir");
		System.out.println("The value of requestFile is :: "+requestFile);
		File file = new File(dir+"\\src\\test\\resources\\com\\sama\\mpp\\cucumber\\input\\"+requestFile+".json");
		FileReader fr = new FileReader(file);		
		JSONParser jsonparser = new JSONParser();
		JSONObject jsonobject =(JSONObject)jsonparser.parse(fr);
		System.out.println("Registration ID under proxy amendment debug is :: "+registrationId);
		jsonobject.put("registrationId", registrationId);
		for(List<String> liststring : listoflist)
		{
			String node =liststring.get(0);
			String value = liststring.get(1);
			System.out.println("The value of node is :: "+node);
			System.out.println("The value of value is :: "+value);
			RegistrationLib.generateSignatureProxyAmendment(node,value,jsonobject);
		}
		File file1 = new File(dir+"\\src\\test\\resources\\com\\sama\\mpp\\cucumber\\input\\"+newRequestFile+".json");
		FileWriter fw = new FileWriter(file1);
		fw.write(jsonobject.toJSONString());
	    fw.flush();
		fw.close();
		
	}
	
/////////////////////////////////////////////////////////////////////////////////////////////
	/////////////////////////  MPP Portal ///////////////////////////////////////////////////
	
	@Given("Open browser {string}")
	public void open_browser(String browserName) {
		// Write code here that turns the phrase above into concrete actions
		// Below function will open the browser which will be mentioned in Feature File
		browser = browserName;
		CommonFunctions.openBrowser(browserName);
	}

	@When("Login to {string} Portal under {string} environment with username as {string} and password as {string}")
	public void login_to_Portal_under_environment_with_username_as_and_password_as(String portal, String environment,
			String username, String password) throws Exception {
		// Write code here that turns the phrase above into concrete actions		
		environment = "SIT";
		// environment="PPRD";
		CommonFunctions.openMPPPortalURL(scenario,environment,portal);
		CommonFunctions.snapshot = CommonFunctions.getSnapshot(CommonFunctions.driver, "screenshot");
		scenario.embed(CommonFunctions.snapshot, "image/png");
		CommonFunctions.mppPortalLogin(scenario,portal,environment, username, password);
		CommonFunctions.snapshot = CommonFunctions.getSnapshot(CommonFunctions.driver, "screenshot");
		scenario.embed(CommonFunctions.snapshot, "image/png");

	}

	@Then("Navigate to below mentioned menu in order to reach {string} page")
	public void navigate_to_below_mentioned_menu_in_order_to_reach_page(String pageName, List<String> navlist)
			throws InterruptedException {
		// Write code here that turns the phrase above into concrete actions
		Thread.sleep(2000);
		for (int i = 0; i < navlist.size(); i++) {
			RegistrationLib.menuNavigation(pageName, navlist.get(i), i);
		}
		Thread.sleep(2000);
		CommonFunctions.snapshot = CommonFunctions.getSnapshot(CommonFunctions.driver, "screenshot");
		scenario.embed(CommonFunctions.snapshot, "image/png");
	}
	
	@Then("Enter {string} as {string} then click on {string} button")
	public void enter_as_then_click_on_button(String label_name, String label_value, String buttonName) throws InterruptedException {
		// Write code here that turns the phrase above into concrete actions
		RegistrationLib.enterSingleValue(scenario,label_name, label_value, buttonName);
		CommonFunctions.snapshot = CommonFunctions.getSnapshot(CommonFunctions.driver, "screenshot");
		scenario.embed(CommonFunctions.snapshot, "image/png");

	}
	
	@Then("Select {string} as {string} under {string} page")
	public void select_as_under_page(String type, String value, String page) {
	    // Write code here that turns the phrase above into concrete actions
	    RegistrationLib.selectDropdown(type, value,page);
	    CommonFunctions.snapshot = CommonFunctions.getSnapshot(CommonFunctions.driver, "screenshot");
		scenario.embed(CommonFunctions.snapshot, "image/png");
	}
   /**
    * Function to close the browser.
    */
	@Then("Close the browser")
	public void close_the_browser() {
		// Write code here that turns the phrase above into concrete actions
		CommonFunctions.teardown();

	}
// End here 
	
	
}
