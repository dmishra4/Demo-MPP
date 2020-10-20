package com.sama.mpp.cucumber.registration.utils;

import java.io.File;
import java.io.FileInputStream;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.List;
import java.util.concurrent.TimeUnit;

import org.apache.commons.io.FileUtils;
import org.junit.Assert;
import org.openqa.selenium.OutputType;
import org.openqa.selenium.TakesScreenshot;
import org.openqa.selenium.TimeoutException;
import org.openqa.selenium.WebDriver;
import org.openqa.selenium.chrome.ChromeDriver;
import org.openqa.selenium.chrome.ChromeOptions;
import org.openqa.selenium.firefox.FirefoxDriver;
import org.openqa.selenium.ie.InternetExplorerDriver;
import org.openqa.selenium.support.ui.ExpectedConditions;
import org.openqa.selenium.support.ui.WebDriverWait;

//import com.sama.mpp.cucumber.poc.stepdefs.POC_StepDefinitions;
//import com.sama.mpp.cucumber.poc.utils.CommonFunctions;
import com.sama.mpp.cucumber.registration.page.ref.RegistrationPageRef;
import com.sama.mpp.cucumber.registration.stepdefs.RegistrationStepDefinitions;

import cucumber.api.Scenario;
import net.masterthought.cucumber.Configuration;
import net.masterthought.cucumber.ReportBuilder;

public class CommonFunctions implements RegistrationPageRef{

	public static WebDriver driver;
	public static String glbpath = null;
	public static byte[] snapshot;
	/**
	 * Function for open new browser.
	 * @param browserName
	 */
	public static void openBrowser(String browserName) {
		
		//String dir = System.getProperty("user.dir")
		if (browserName.equalsIgnoreCase("Firefox")) {
			System.setProperty("webdriver.gecko.driver",
					"./src/test/resources/com/sama/mpp/cucumber/drivers/geckodriverv0.26.0-win64.exe");
			driver = new FirefoxDriver();
		} else if (browserName.equalsIgnoreCase("Chrome")) {
			// Configuring the system properties of chrome driver
			System.setProperty("webdriver.chrome.driver",
					"./src/test/resources/com/sama/mpp/cucumber/drivers/chromedriver80.0.3987.106.exe");
			System.setProperty("webdriver.chrome.silentOutput", "true"); // To avoid unwanted message on console
			ChromeOptions options = new ChromeOptions();
			options.addArguments("enable-automation");
			options.addArguments("--disable-features=NetworkService");
			options.addArguments("--dns-prefetch-disable");
			options.addArguments("--disable-extensions");
			options.setExperimentalOption("useAutomationExtension", false);  // Loading of unpacked extension 
			// Initializing the browser driver
		    driver = new ChromeDriver(options);
		} else if (browserName.equalsIgnoreCase("IE")) {
			// System.setProperty("webdriver.ie.driver",
			// "drivers\\IEDriverServer_v3.4.0_win32.exe");
			System.setProperty("webdriver.ie.driver", "Drivers\\IEDriverServer_Win32_3.11.1.exe");
			driver = new InternetExplorerDriver();
		}
		driver.manage().window().maximize(); // Maximize window
		driver.manage().timeouts().implicitlyWait(10,TimeUnit.SECONDS);
	}
	

	
	
	
	/**
	 * Function to navigate to the URL
	 * 
	 * @param Environment - environment name e.g. dev/SIT
	 */
	public static void openMPPPortalURL(Scenario scenario, String environment, String portal) {
		try {
			if (environment.equalsIgnoreCase("SIT")) {
				driver.get("http://10.158.240.218:9081/mpp-portal/home.mpp");
				scenario.write("MPP Potal URL :: http://10.158.240.218:9081/mpp-portal/home.mpp");			
			} else if (environment.equalsIgnoreCase("PPRD")) {
				driver.get("https://10.158.214.1:10042/wps/portal");
				scenario.write("MPP Potal URL:: http://10.158.240.218:9081/mpp-portal/home.mpp");
			}

			else {
				System.out.println("Mentioned enviroment is not yet defined");
			}
		} catch (Exception e) {
			System.out.println("Mentioned environment is not yet defined");
			e.getMessage();
		}
	}

	
	/**
	 * Function to login to the MPP Portal
	 * 
	 * @param username
	 * @param password
	 * @throws Exception
	 */
	public static void mppPortalLogin(Scenario scenario, String portal, String environment, String username,
			String password) throws Exception {
		WebDriverWait wait = new WebDriverWait(CommonFunctions.driver, 20);
		wait.until(ExpectedConditions.visibilityOfElementLocated(input_UserName));
		Thread.sleep(3000);
		CommonFunctions.driver.findElement(input_UserName).sendKeys(username);
		CommonFunctions.driver.findElement(input_Password).sendKeys(password);
		CommonFunctions.snapshot = CommonFunctions.getSnapshot(CommonFunctions.driver, "screenshot");
		scenario.embed(CommonFunctions.snapshot, "image/png");
		wait.until(ExpectedConditions.visibilityOfElementLocated(btn_Login));
		CommonFunctions.driver.findElement(btn_Login).click();
		WebDriverWait loginwait = new WebDriverWait(CommonFunctions.driver, 4);
		try {
			loginwait.until(ExpectedConditions.invisibilityOfElementLocated(text_LoginErrorMPPPortal));
			scenario.write("Successfully Login to " + portal + " Portal in " + environment + " Environment");
			Thread.sleep(2000);

		} catch (TimeoutException e) {
			CommonFunctions.snapshot = CommonFunctions.getSnapshot(CommonFunctions.driver, "screenshot");
			scenario.embed(CommonFunctions.snapshot, "image/png");
			scenario.write(portal + " Portal Login has been failed in " + environment
					+ " Environment. Please enter a valid user ID and password.");
			Assert.fail(portal + " Portal Login has been failed in " + environment
					+ " Environment. Please enter a valid user ID and password.");
		}
	}

	
	/**
	 * Functions to delete old screenshots.
	 */

	public static void cleanup_screenshots()
	{
		String path = System.getProperty("user.dir") + "\\Screenshots\\";
		File deleteOldScreenshots = new File(path);
		try {
			FileUtils.cleanDirectory(deleteOldScreenshots);
		} catch (Exception e) {
			System.out.println("Ensure scrrenshot path is correctly mentioned");
			e.getMessage();
		}
	}
	
	/**
	 * Function to take the snapshot
	 * @param driver
	 * @param snapshotName
	 * @return
	 */
	
	public static byte[] getSnapshot(WebDriver driver, String snapshotName) {
		String timeStamp = null;
		FileInputStream fileInputStreamReader = null;
		byte[] bytes = null;
		try {
			TakesScreenshot ts = (TakesScreenshot) driver;
			File src = ts.getScreenshotAs(OutputType.FILE);
			timeStamp = new SimpleDateFormat("yyyyMMdd_HHmmss").format(Calendar.getInstance().getTime());
			String dir = System.getProperty("user.dir");
			glbpath = dir + "\\Screenshots\\";
			File dst = new File(glbpath + snapshotName + "_" + timeStamp + ".png");
			FileUtils.copyFile(src, dst);
			fileInputStreamReader = new FileInputStream(dst);
			bytes = new byte[(int) dst.length()];
			fileInputStreamReader.read(bytes);
		} catch (Exception e) {
			e.getMessage();
		}

		return bytes;
	}
	
	/**
	 * Function to generate the custom report.
	 * @throws InterruptedException
	 */
	public static void generateCustomReport() throws InterruptedException {
		System.out.println("Start generating HTML report folder");
		File reportOutputDirectory = new File("target");
		String dir = System.getProperty("user.dir");
		List<String> jsonFiles = new ArrayList<>();
		String jsonpath = dir+ "\\target\\Cucumber-Report\\cucumber.json";
		System.out.println("Path of json file is :: "+jsonpath);
		jsonFiles.add(jsonpath);
	//	jsonFiles.add(
	//			"C:\\SAMA-ACH\\achworkspace\\sama-ach-portal-tests-automation\\ach-cucumber-portal-poc\\target\\Cucumber-Report\\cucumber.json");
		
		String buildNumber = "1";
		String projectName = "SAMA MPP API";
		// boolean runWithJenkins = true;

		Configuration configuration = new Configuration(reportOutputDirectory, projectName);
		// optional configuration - check javadoc
		// configuration.setRunWithJenkins(runWithJenkins);
		configuration.setBuildNumber(buildNumber);

		// additional metadata presented on main page
		configuration.addClassifications("Operating System", System.getProperty("os.name"));
		configuration.addClassifications("Browser", RegistrationStepDefinitions.browser);
		configuration.addClassifications("Java", System.getProperty("java.version"));
		configuration.addClassifications("Selenium", "3.141.59");
		configuration.addClassifications("Cucumber", "4.2.0");
		configuration.addClassifications("Rest Assured", "4.3.1");

		// optionally add metadata presented on main page via properties file
		// List<String> classificationFiles = new ArrayList<>();
		// classificationFiles.add("properties-1.properties");
		// classificationFiles.add("properties-2.properties");
		// configuration.addClassificationFiles(classificationFiles);

		ReportBuilder reportBuilder = new ReportBuilder(jsonFiles, configuration);
		Thread.sleep(1000);
		try {
			reportBuilder.generateReports();
		} catch (Exception e) {
			Assert.fail("Report generation failed as Json file under target folder is not created successfully");
		}

	}
	/**
	 * Function to close the browser.
	 */
	public static void teardown() {
		
		driver.manage().deleteAllCookies();
		driver.close();  //  current active browser
	//	driver.quit();
		driver=null;   
	}	
	
	// End Here
}
