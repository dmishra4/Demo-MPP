package com.sama.mpp.cucumber.registration.page.ref;

import org.openqa.selenium.By;

public interface RegistrationPageRef {

	/***************** MPP Page_Dashboard******************************/

	public static final String strTextNavigate                 = "%s";
	public static final String strNavigate       = "//*[text()='%s']";
	public static final String strProxyType      = "//li[text()='%s']";

	public static final By input_registrationId  = By.xpath("//input[@name='registrationId']");
	public static final By btn_Search            = By.xpath("//*[text()='Search']");
	public static final By text_RegistationError = By.xpath("//*[contains(text(),'Registration ID does not exist')]");

	public static final By label_ProxyType       = By.xpath("//label[text()='Proxy Type']");
	public static final By input_ProxyValue      = By.xpath("//input[@name='proxy']");
	public static final By text_ProxyError = By.xpath("//*[contains(text(),'Proxy is not registered on MPP')]");

	/***************** Page_Login ******************************/
		

		public static final By input_UserName = By.xpath("//input[@name='username']");
		public static final By input_Password = By.xpath("//input[@name='password']");
		public static final By btn_Login = By.xpath("//button[@id='loginButton-btnEl']//*[text()='Login']");
		public static final By text_LoginErrorMPPPortal= By.xpath("//p[text()='Please enter your correct User Name and/or Password.']");
		
		// End here
	
}
