# NuGet packages for WebDriver - Chrome, Firefox, Internet Explorer

## This is a repurposed repo of [nupkg-selenium-webdriver-chromedriver](https://github.com/jsakamoto/nupkg-selenium-webdriver-chromedriver) by [jsakamoto](https://github.com/jsakamoto) that handles downloading Chrome, Firefox, and Internet Explorer WebDrivers instead

[![NuGet Package](https://img.shields.io/nuget/v/Selenium.Chrome.WebDriver.svg)](https://www.nuget.org/packages/Selenium.Chrome.WebDriver/)
[![NuGet Package](https://img.shields.io/nuget/v/Selenium.Firefox.WebDriver.svg)](https://www.nuget.org/packages/Selenium.Firefox.WebDriver/)
[![NuGet Package](https://img.shields.io/nuget/v/Selenium.InternetExplorer.WebDriver.svg)](https://www.nuget.org/packages/Selenium.InternetExplorer.WebDriver/)

These NuGet packages will download Selenium WebDrivers (Chrome, Firefox, Internet Explorer) into your Unit Test Project.
Each WebDriver binary file does not appear in Solution Explorer, but it is copied to bin folder from package folder when the build process.
NuGet package restoring ready, and no need to commit any WebDriver binary files into source code control repository.

## How to install?

For example, at the package manager console on Visual Studio, enter following command to install ChromeDriver  
    PM> Install-Package Selenium.Chrome.WebDriver

For Firefox WebDriver (Marionette)
	PM> Install-Package Selenium.Firefox.WebDriver

For Internet Explorer Driver 32bit
	PM> Install-Package Selenium.InternetExplorer.WebDriver
	
## Detail

### Where is each WebDriver binary file saved to?

Each WebDriver will be downloaded to their respective nuget package location
" _{solution folder}_ /packages/Selenium.[Browser].WebDriver. _{ver}_ /**driver**"  
folder.

     {Solution folder}/
      +-- packages/
      |   +-- Selenium.Chrome.WebDriver.{version}/
      |       +-- driver/
      |       |   +-- chromedriver.exe
      |       +-- build/
	  |   +-- Selenium.Firefox.WebDriver.{version}/
      |       +-- driver/
      |       |   +-- geckodriver.exe
      |       +-- build/
	  |   +-- Selenium.InternetExplorer.WebDriver.{version}/
      |       +-- driver/
      |       |   +-- IEDriverServer.exe
      |       +-- build/
      +-- {project folder}/
          +-- bin/
              +-- Debug/
			  |   +-- chromedriver.exe (copy from above by build process)
			  |   +-- geckodriver.exe (copy from above by build process)
              |   +-- IEDriverServer.exe (copy from above by build process)
              +-- Release/
				  +-- chromedriver.exe (copy from above by build process)
				  +-- geckodriver.exe (copy from above by build process)
                  +-- IEDriverServer.exe (copy from above by build process)

And package installer configure msbuild task such as .csproj to copy each WebDriver binary file into output folder during build process.

## How to build each nuget package?

You will need to execute the BuildPackage.bat file with the following input parameters:
- Browser {Chrome, Firefox, IE}
- Version

Usage Examples:
For creating nuget package for ChromeDriver version 2.25
	BuildPackage.bat Chrome 2.25

For creating nuget package for Firefox (Marionette) Driver version 0.11.1
	BuildPackage.bat Firefox 0.11.1
	
For creating nuget package for Internet Explorer Driver version 2.48
	BuildPackage.bat IE 2.48