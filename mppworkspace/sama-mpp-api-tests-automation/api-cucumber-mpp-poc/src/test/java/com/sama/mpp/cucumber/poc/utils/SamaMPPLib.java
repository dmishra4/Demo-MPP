package com.sama.mpp.cucumber.poc.utils;

import static io.restassured.RestAssured.given;


import java.io.File;
import java.io.FileWriter;
import java.io.IOException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

import org.json.simple.JSONObject;
import org.junit.Assert;
import org.openqa.selenium.By;
import org.openqa.selenium.TimeoutException;
import org.openqa.selenium.support.ui.ExpectedConditions;
import org.openqa.selenium.support.ui.WebDriverWait;

import com.fasterxml.jackson.core.JsonProcessingException;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.sama.mpp.cucumber.poc.page.ref.POC_PageRef;
import com.sama.mpp.cucumber.poc.stepdefs.POC_StepDefinitions;

import cucumber.api.Scenario;
import io.restassured.response.Response;

public class SamaMPPLib implements POC_PageRef {
	
	public static String encypted_output;
	public static Response Respond;
	
	public static String access_token;
	public static String signature_output;
	public static String signature;
	public static String registrationID;
	public static String cipheredData;
	

	public static String encypted_accesstoken;
	public static String decrypted_accesstoken;

	public static Map<String, String> headers = new HashMap<String, String>();
	public static File file;
	public static String dir;
	
	/**
	 * Functions to add required key value pairs in headers
	 * @param listoflist
	 */
	public static void addheaders(List<List<String>> listoflist,String baseURL, String endpoint) {
		for (List<String> str : listoflist) {
			String headerName, headerValue, runtime;
			headerName = str.get(0);
			// System.out.println("headerName :: " + headerName);
			if (headerName.equals("authorization")) {
				runtime = str.get(1);
				headerValue = runtime.replace(runtime, "Bearer " + access_token);
				// System.out.println("headerValue :: " + headerValue);
			} else if (headerName.equals("signature")) {
				runtime = str.get(1);
				headerValue = runtime.replace(runtime, signature);
				// System.out.println("headerValue :: " + headerValue);
			} else {
				headerValue = str.get(1);
				// System.out.println("headerValue :: " + headerValue);
			}
			headers.put(headerName, headerValue);
		}
		try {
			System.out.println("Required Headers values for URL :: "+baseURL+endpoint+"  :: "
					+ new ObjectMapper().writerWithDefaultPrettyPrinter().writeValueAsString(headers));
			POC_StepDefinitions.scenario.write("Required Headers values for URL :: "+baseURL+endpoint+"  :: "
					+ new ObjectMapper().writerWithDefaultPrettyPrinter().writeValueAsString(headers));
		} catch (JsonProcessingException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
	}
	
	/**
	 * Function to generate encrypted and decrypted token.
	 * @param action
	 * @param activity
	 */
	
	public static void generatetoken(String action, String activity, String baseURL, String endpoint) {
		if(activity.equalsIgnoreCase("encypted"))
		{
			 File file = new File(dir+"\\src\\test\\resources\\com\\sama\\mpp\\cucumber\\input\\responseEncryption.json");
				// Respond = given().headers(headers).when().body(file).post(baseURL+resourcepath);
			
			 JSONObject jsonObject = new JSONObject();
             jsonObject.put("cipheredData",encypted_output);			
			 try {
				FileWriter fw = new FileWriter(file);
				fw.write(jsonObject.toJSONString());
			//	System.out.println("JSON file "+jsonObject+" :: "+jsonObject);
				fw.close();
			} catch (IOException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
			
		//	 System.out.println("headers value is :: "+headers);
			
		//	Respond = given().headers(headers).relaxedHTTPSValidation().when().body(file).post("https://10.158.244.98/sp/dev/v1/token/generation");
			Respond = given().headers(headers).when().body(file).post(baseURL+endpoint);			
			encypted_accesstoken= Respond.prettyPrint();
			    System.out.println( "encypted_accesstoken is :: "+encypted_accesstoken);
			//	System.out.println("Status Code is :: "+Respond.getStatusCode());
				POC_StepDefinitions.scenario.write("encypted_accesstoken  :: "+encypted_accesstoken);
				
		}
		else if(activity.equalsIgnoreCase("decypted"))
		{
			 File file = new File(dir+"\\src\\test\\resources\\com\\sama\\mpp\\cucumber\\input\\requestDecryption.json");			
			 try {
				FileWriter fw = new FileWriter(file);
				fw.write(encypted_accesstoken);
		//		System.out.println("JSON file "+jsonObject+" :: "+jsonObject);
				fw.close();
			} catch (IOException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
			
		//	Respond = given().headers(headers).when().body(file).post("https://10.158.244.98/sp/dev/dummy/decrypt");			
				Respond = given().headers(headers).when().body(file).post(baseURL+endpoint);	
			 decrypted_accesstoken= Respond.prettyPrint();
			    System.out.println( "decrypted_accesstoken is :: "+decrypted_accesstoken);
//				System.out.println("Status Code is :: "+Respond.getStatusCode());
//				System.out.println("Content Type is :: "+Respond.getContentType());
				System.out.println("Status Line is :: "+Respond.getStatusLine());
//				System.out.println("Get Time in milli seconds is :: "+Respond.getTime());
//				System.out.println("Get Time  is :: "+Respond.getTimeIn(TimeUnit.MILLISECONDS));
				
				String token_type=Respond.jsonPath().get("token_type");
				System.out.println(" token_type is :: "+token_type);
				access_token=Respond.jsonPath().get("access_token");
				System.out.println(" access_token is  :: "+access_token);
				POC_StepDefinitions.scenario.write("decrypted_accesstoken  :: "+decrypted_accesstoken);
		}
		else
		{
			System.out.println(" Required data form is not present");
		}
	    
	}

	/**
	 * Function to generate Signature for Proxy Registration and Proxy Amendment
	 * @param action
	 * @param activity
	 * @param baseURL
	 * @param endPoint
	 */
	public static void generateSignature(String action,String activity,String baseURL,String endPoint,String requestFile) {
		
		if(activity.equalsIgnoreCase("Proxy Registration")) {
			File file = new File(dir+"\\src\\test\\resources\\com\\sama\\mpp\\cucumber\\input\\"+requestFile+".json");
			// Respond = given().headers(headers).when().body(file).post(baseURL+resourcepath);
		    Respond = given().headers(headers).relaxedHTTPSValidation().when().body(file).post(baseURL+endPoint);
		    System.out.println( "signature_output is :: "+Respond.prettyPrint());
			//System.out.println("Status Code is :: "+Respond.getStatusCode());
			signature=Respond.jsonPath().get("signature");
			System.out.println(" Value of Signature Key is :: "+signature);
			POC_StepDefinitions.scenario.write("Signature Output :: "+Respond.prettyPrint());
		}
			else if(activity.equalsIgnoreCase("Proxy Amendment")) {	
				
				System.out.println(" Request File name under Proxy Amendment is :: "+requestFile);
				File file = new File(dir+"\\src\\test\\resources\\com\\sama\\mpp\\cucumber\\input\\"+requestFile+".json");
				// Respond = given().headers(headers).when().body(file).post(baseURL+resourcepath);
			    Respond = given().headers(headers).relaxedHTTPSValidation().when().body(file).post(baseURL+endPoint);
//			    Respond = given().headers(headers).relaxedHTTPSValidation().when().body(file).post("https://10.158.239.131/sp/pre-prd/dummy/encrypt");
			    signature_output= Respond.prettyPrint();
			    System.out.println( "signature_output for proxy Amendment is :: "+signature_output);
				System.out.println("Status Code is :: "+Respond.getStatusCode());
				signature=Respond.jsonPath().get("signature");
				System.out.println(" Value of Signature Key for Proxy Amendment is :: "+signature);
				POC_StepDefinitions.scenario.write("Signature Output for Proxy Amendment :: "+decrypted_accesstoken);
				
				
				
				
			}
		else {
			
		}
		
		
	}
	
	public static void generateSignatureProxyAmendment(String node,String value,JSONObject jsonobject)
	{
		Pattern p = Pattern.compile("[^A-Za-z0-9]");
		Matcher m = p.matcher(node);
		boolean flag = m.find();
		System.out.println(" The value of flag is ::: "+flag);
		if (flag) {
			//System.out.println(" The value of node under if block is ::: "+node);
			String[] str = node.split("\\.");				
             if (str.length == 2) {
				JSONObject js = (JSONObject) jsonobject.get(str[0]);
				//System.out.println("The value of str[1] is :: " + str[1]);
				//System.out.println("The value of value is :: " + value);
				js.put(str[1], value);
			} else if (str.length == 3) {
				JSONObject js = (JSONObject) jsonobject.get(str[0]);
				JSONObject js1 = (JSONObject) js.get(str[1]);
				js1.put(str[2], value);
			} else {
				System.out.println(" Did not find node ");
			}
		}
		else {
			
			//System.out.println("The value of node in else block is :: " + node);
			//System.out.println("The value of value in else block is :: " + value);
			jsonobject.put(node, value);
		}
	}
	
	/**
	 * 
	 * @param action
	 * @param activity
	 * @param baseURL
	 * @param endpoint
	 * @param requestFile
	 */
	public static void proxyRegistration(String action, String activity,String baseURL,String endpoint, String requestFile) {
		
		   
		 if(activity.equalsIgnoreCase("Proxy Registration")) {
					File file = new File(dir+"\\src\\test\\resources\\com\\sama\\mpp\\cucumber\\input\\"+requestFile+".json");
					// Respond = given().headers(headers).when().body(file).post(baseURL+resourcepath);
				//    Respond = given().headers(headers).relaxedHTTPSValidation().when().body(file).post("https://10.158.244.98/sp/sit/v1/customer-proxy-registrations/registrations");
       			    Respond = given().headers(headers).relaxedHTTPSValidation().when().body(file).post(baseURL+endpoint);
				    //String registrationKeyPair= Respond.prettyPrint();
				    System.out.println( "Registration Key pair value  is :: "+Respond.prettyPrint());
					System.out.println("Status Code is :: "+Respond.getStatusCode());
					registrationID = Respond.jsonPath().get("registrationId");
					System.out.println(" Registration ID is  :: "+registrationID);
					//String reasonCode = Respond.jsonPath().get("Errors.Error[0].ReasonCode");
					//System.out.println("reason code value is :: "+reasonCode);
					POC_StepDefinitions.scenario.write("Registration Key pair value  is :: "+Respond.prettyPrint());
					}
				else {
					
				}
	}
	
	
	/**
	 * Function to perform action e.g. POST
	 * @param action
	 * @param activity
	 * @param baseURL
	 * @param endpoint
	 */
	
	public static void requestActivity(String action, String activity, String baseURL,String endpoint)
	{
		if(action.equalsIgnoreCase("POST") && activity.equalsIgnoreCase("Encryption")) {
		    dir = System.getProperty("user.dir");
			file = new File(dir+"\\src\\test\\resources\\com\\sama\\mpp\\cucumber\\input\\"+POC_StepDefinitions.requestFile+".json");
			// Respond = given().headers(headers).when().body(file).post(baseURL+resourcepath);
		    Respond = given().headers(headers).relaxedHTTPSValidation().when().body(file).post(baseURL+endpoint);
	//	    Respond = given().headers(headers).relaxedHTTPSValidation().when().body(file).post("https://10.158.239.131/sp/pre-prd/dummy/encrypt");
		    encypted_output= Respond.prettyPrint();
		    System.out.println( "encypted_output is :: "+encypted_output);
			System.out.println("Status Code is :: "+Respond.getStatusCode());
			POC_StepDefinitions.scenario.write("Encypted_Output :: "+Respond.prettyPrint());
			
		}
	}
      
	/**
	 * Function to validate status code 
	 * @param expStatusCode
	 */
	public static void statusCodevalidation(String expStatusCode)
      {
    		int actStatusCode= Respond.statusCode();
    		System.out.println(" The value of actual status code is :: "+actStatusCode);
    		POC_StepDefinitions.scenario.write("The value of actual status code is :: "+actStatusCode);
    		Assert.assertEquals("Status code does not match", Integer.parseInt(expStatusCode), actStatusCode);
    		headers.clear();
      }
	/**
	 * 
	 * @param node
	 * @param value
	 */
	public static void jsonResponseValidation(String node , String value) {
		
		if(node.equalsIgnoreCase("encryptdata"))
		{
			value=encypted_output;
			System.out.println("The value of cipherdata is ::: "+value );
			Assert.assertNotNull(" cipherdata value is not displaying as intended", value);
			
		}
	
		else if(node.equalsIgnoreCase("cipheredData"))
		{
			value=Respond.jsonPath().get(node);
			System.out.println("The value of "+node+" is ::: "+value );
			POC_StepDefinitions.scenario.write("The value of "+node+" is ::: "+value );
			Assert.assertNotNull(" cipheredData value is not displaying as intended", value);
			
		}
		else if(node.equalsIgnoreCase("access_token"))
		{
			value=Respond.jsonPath().get(node);
			System.out.println("The value of "+node+" is ::: "+value );
			POC_StepDefinitions.scenario.write("The value of "+node+" is ::: "+value );
			Assert.assertNotNull(" access_token value is not displaying as intended", value);
			
		}
		else if(node.equalsIgnoreCase("consented_on"))
		{
			int actvalue=Respond.jsonPath().get(node);
			System.out.println("The value of consented_on is :: "+actvalue );
			POC_StepDefinitions.scenario.write("The value of "+node+" is ::: "+actvalue );
			Assert.assertNotNull(" consented_on value is not displaying as intended", actvalue);
			
		}
		else if(node.equalsIgnoreCase("signature"))
		{
			value=Respond.jsonPath().get(node);
			System.out.println("The value of signature is :: "+value );
			POC_StepDefinitions.scenario.write("The value of "+node+" is ::: "+value );
			Assert.assertNotNull(" Signature value is not displaying as intended", value);
			
		}
		else if(node.equalsIgnoreCase("registrationId"))
		{
			value=Respond.jsonPath().get(node);
			System.out.println("The value of "+node+" is :: "+value );
			POC_StepDefinitions.scenario.write("The value of "+node+" is ::: "+value );
			Assert.assertNotNull(" registrationId value is not displaying as intended", value);
			
			
		}
		else if(node.equalsIgnoreCase("ReasonCode") || node.equalsIgnoreCase("Description"))
		{
			
			////String reasonCode = Respond.jsonPath().get("Errors.Error[0].ReasonCode");
			String actvalue=Respond.jsonPath().get("Errors.Error[0]."+node);
			System.out.println("The value of "+node+" is :: "+actvalue );
			POC_StepDefinitions.scenario.write("The value of "+node+" is ::: "+actvalue );
			//Assert.assertNotNull(" consented_on value is not displaying as intended", value);
			Assert.assertEquals("Value did not match for node "+node+" ", value, actvalue);
		
	
		}
	
		else {
			
			if(node.equalsIgnoreCase("expires_in"))
			{
				int actvalue=Respond.jsonPath().get(node);
				System.out.println("The value of "+node+" is :: "+actvalue );	
				POC_StepDefinitions.scenario.write("The value of "+node+" is ::: "+actvalue );
				Assert.assertEquals("Value did not match for node "+node+" ", Integer.parseInt(value), actvalue);
			}
			else {
			String actvalue=Respond.jsonPath().get(node);
			System.out.println("The value of "+node+" is :: "+actvalue );
			POC_StepDefinitions.scenario.write("The value of "+node+" is ::: "+actvalue );
			//Assert.assertNotNull(" consented_on value is not displaying as intended", value);
			Assert.assertEquals("Value did not match for node "+node+" ", value, actvalue);
			}
		}
		
	}
	/**
	 * 
	 * @param action
	 * @param registrationId
	 * @param baseURL
	 * @param endPoint
	 * @param requestFile
	 */
	
	public static void proxyAmendment(String action,String registrationId,String baseURL,String endPoint,String newrequestFile)
	{
		
		registrationId=registrationID;
		System.out.println("URL is :: "+baseURL+endPoint+"/"+registrationID);
		File file1 = new File(dir+"\\src\\test\\resources\\com\\sama\\mpp\\cucumber\\input\\generateSignatureAmendment.json");
		System.out.println("headers value in debug ::"+headers);
		Respond = given().headers(headers).relaxedHTTPSValidation().when().body(file1).put(baseURL+endPoint+"/"+registrationID);
//	    Respond = given().headers(headers).relaxedHTTPSValidation().when().body(file).post("https://10.158.239.131/sp/pre-prd/dummy/encrypt");
	    signature_output= Respond.prettyPrint();
	    System.out.println("Amended Proxy value is "+Respond.prettyPrint());
	}
/////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////// MPP Portal Code //////////////////////////
	
	/**
	 * This function has been written to navigate pages inside Portal application
	 * @param pageName
	 * @param navigation
	 * @param row
	 * @throws InterruptedException
	 */
	
	public static void menuNavigation(String pageName, String navigation, int row) throws InterruptedException {

		WebDriverWait wait = new WebDriverWait(CommonFunctions.driver, 30);
		switch (row) {
		case 0:
			try {
				wait.until(ExpectedConditions
						.visibilityOfElementLocated(By.xpath(String.format(strNavigate, navigation))));
			} catch (TimeoutException e) {
				System.out.println(e.getMessage());
				Assert.fail("Link  " + navigation + " is eihter not available or network speed is slow");
			}
			CommonFunctions.driver.findElement(By.xpath(String.format(strNavigate, navigation))).click();
			Thread.sleep(1000);
			break;
		case 1:
			// CommonFunctions.driver.findElement(By.xpath("//*[text()='" + navigation +
			// "']")).click();
			// wait.until(ExpectedConditions.visibilityOfElementLocated(By.linkText(String.format(strNavigate,navigation))));
			try {
				wait.until(ExpectedConditions
						.visibilityOfElementLocated(By.xpath(String.format(strNavigate, navigation))));
			} catch (TimeoutException e) {
				System.out.println(e.getMessage());
				Assert.fail("Link  " + navigation + " is eihter not available or network speed is slow");
			}
			CommonFunctions.driver.findElement(By.xpath(String.format(strNavigate, navigation))).click();
			Thread.sleep(1000);
			break;
		case 2:
			// CommonFunctions.driver.findElement(By.xpath("//*[text()='" + navigation +
			// "']")).click();
			// wait.until(ExpectedConditions.visibilityOfElementLocated(By.linkText(String.format(strNavigate,navigation))));
			try {
				wait.until(ExpectedConditions
						.visibilityOfElementLocated(By.xpath(String.format(strNavigate, navigation))));
			} catch (TimeoutException e) {
				System.out.println(e.getMessage());
				Assert.fail("Link  " + navigation + " is eihter not available or network speed is slow");
			}
			CommonFunctions.driver.findElement(By.xpath(String.format(strNavigate, navigation))).click();
			Thread.sleep(1000);
			break;
		default:
			System.out.println("Check feature file. Might be navigation path is not correctly mentioned");
			Assert.fail("Check feature file. " + navigation + " is not available in the application. ");

		}
	}
	/**
	 * Function to enter single value in any text field.
	 * @param label_name
	 * @param label_value
	 * @param buttonName
	 * @throws InterruptedException 
	 */
	
	public static void enterSingleValue(Scenario scenario,String label_name, String label_value, String buttonName) throws InterruptedException {
		WebDriverWait wait = new WebDriverWait(CommonFunctions.driver, 10);
		if (label_name.equalsIgnoreCase("Registration Id")) {
			wait.until(ExpectedConditions.visibilityOfElementLocated(input_registrationId));
			if (label_value.equalsIgnoreCase("%RUNTIME%")) {
				label_value = registrationID;
				CommonFunctions.driver.findElement(input_registrationId).sendKeys(label_value);
			} else {

				CommonFunctions.driver.findElement(input_registrationId).sendKeys(label_value);
			}
			Thread.sleep(2000);
			// CommonFunctions.driver.findElement(By.xpath("//input[@value='"+buttonName+"']")).click();
			CommonFunctions.driver.findElement(btn_Search).click();
			WebDriverWait regisrationwait = new WebDriverWait(CommonFunctions.driver, 3);
			try {
				regisrationwait.until(ExpectedConditions.invisibilityOfElementLocated(text_RegistationError));
				scenario.write("Registration ID "+label_value+" is exist in MPP portal");
				//Thread.sleep(1000);

			} catch (TimeoutException e) {
				CommonFunctions.snapshot = CommonFunctions.getSnapshot(CommonFunctions.driver, "screenshot");
				scenario.embed(CommonFunctions.snapshot, "image/png");
				scenario.write("Registration ID "+label_value+" does not exist in MPP Portal");
				Assert.fail("Registration ID "+label_name+" does not exist in MPP Portal");
			}
			
		}
	}
	
	
	
	
	
	// End Here.
}
