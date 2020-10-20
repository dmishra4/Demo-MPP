package com.sama.mpp.cucumber.poc.page.ref;

import org.openqa.selenium.By;

public interface POC_PageRef {


	
/***************** MPP Page_Dashboard******************************/

public static final String strTextNavigate                 = "%s";
public static final String strNavigate      = "//*[text()='%s']";

public static final By input_registrationId = By.xpath("//input[@name='registrationId']");
public static final By btn_Search = By.xpath("//*[text()='Search']");
public static final By text_RegistationError= By.xpath("//*[contains(text(),'Registration ID does not exist')]");
/***************** Page_Login ******************************/
	

	public static final By input_UserName = By.xpath("//input[@name='username']");
	public static final By input_Password = By.xpath("//input[@name='password']");
	public static final By btn_Login = By.xpath("//button[@id='loginButton-btnEl']//*[text()='Login']");
	
	public static final By text_LoginErrorMPPPortal= By.xpath("//p[text()='Please enter your correct User Name and/or Password.']");
}
