# Ideapad Toolkit

**Ideapad Toolkit is a utility that allows you to adjust your Ideapad's power settings without installing Lenovo Vantage.**

This fork is based on [havlif/IdeapadToolkit](https://github.com/havlif/IdeapadToolkit) and is adapted specifically for **Lenovo IdeaPad S340-14API (81NB)**. Download the built application from the [GitHub Releases](https://github.com/itsmeyogs/IdeapadToolkit/releases) page.


![Screenshot 2023-04-24 174110](https://user-images.githubusercontent.com/62750643/234048210-32a98b8a-7e24-4ba3-8990-a25ecdd8a2f9.png)

**Power and charging profiles can be quickly adjusted from the tray icon**

![Screenshot 2023-04-24 174631](https://user-images.githubusercontent.com/62750643/234049214-1324dc57-b3fd-4f8f-9fb0-8a419e2e9d32.png)

**After running, the app windows can be accessed by double clicking the tray icon**
## Prerequisites
- [.NET 8 Runtime](https://dotnet.microsoft.com/en-us/download/dotnet/thank-you/runtime-8.0.10-windows-x64-installer)

- [Lenovo Intelligent Thermal Solution Driver](https://www.google.com/search?q=lenovo+<YOUR+MODEL>+intelligent+thermal+solution+driver+download)

- Visual C++ 2015 Runtime
  - This comes packed with most Windows software, so you most likely already have this.
  - If not, install from here: [X64](https://aka.ms/vs/17/release/vc_redist.x64.exe) [X86](https://aka.ms/vs/17/release/vc_redist.x86.exe)

- PowerBattery.dll
  - The installer requires you to select this DLL before installation can finish.
  - The DLL is not included in the installer and is copied only to the application directory.
  - The DLL is never copied to `System32`.

## Installation

1. Download `IdeapadToolkit-Setup.exe` from [GitHub Releases](https://github.com/itsmeyogs/IdeapadToolkit/releases).
2. Select the application installation directory.
3. Read the `PowerBattery.dll` requirement page.
4. Select your x64 `PowerBattery.dll` file.
5. Continue to the Ready to Install page and finish setup.

If you do not have the DLL, follow [How to get PowerBattery.dll](#how-to-get-powerbatterydll) first.

## Manual build

Manual builds require a local x64 DLL at:

```text
IdeapadToolkit\PowerBattery.dll
```

Build Release:

```powershell
dotnet build IdeapadToolkit.WinUI\IdeapadToolkit.WinUI3.csproj -c Release -p:Platform=x64
```

Compile the installer with Inno Setup:

```powershell
& "C:\Program Files\Inno Setup 7\ISCC.exe" installer\IdeapadToolkit.iss
```
  
### How to get PowerBattery.dll
- Method A
  1. Install Lenovo Vantage from the Microsoft Store
  2. Copy it from C:\ProgramData\Lenovo\Vantage\Addins\IdeaNotebookAddin\ to the Ideapad Toolkit directory
  3. Lenovo Vantage can now be uninstalled
- Method B (Without Microsoft Store)
  1.  Go to https://store.rg-adguard.net/
  2.  Enter the link to Lenovo Vantage (https://apps.microsoft.com/store/detail/lenovo-vantage/9WZDNCRFJ4MV)
  3.  Download the newest version in the **.msixbundle** format (The file should be called "something LevovoCompanion something **.msixbundle**)
  4.  Open the .msixbundle file using 7Zip or similar software
  5.  Inside 7Zip, navigate to LenovoVantagePackage\[Version\]x64.msix/DeployAssistant/ImController/Plugins\[Version\].cab/plugins.7z/Normal/IdeaNotebookPlugin/x64
  6.  PowerBattery.dll should be in there

## Languages
- ⚠️ Restart the app to apply the changes
- English
- Czech
- French (by [@mooms06](https://github.com/mooms06))
- Chinese (Simplified) (by [@Flicker372](https://github.com/Flicker372))

## Third party licenses
[Hardcodet.NotifyIcon.Wpf](https://github.com/hardcodet/wpf-notifyicon/blob/develop/LICENSE)

[ModernWpf](https://github.com/Kinnara/ModernWpf/blob/master/LICENSE)
 
[SimpleInjector](https://github.com/simpleinjector/SimpleInjector/blob/master/LICENSE)
 
[.NET Community Toolkit](https://github.com/CommunityToolkit/dotnet/blob/main/License.md)
 
[Serilog](https://github.com/serilog/serilog/blob/dev/LICENSE)

