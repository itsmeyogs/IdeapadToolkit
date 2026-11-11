# Ideapad Toolkit

**Ideapad Toolkit is a utility that allows you to adjust your Ideapad's power settings without installing Lenovo Vantage.**

This fork is based on [havlif/IdeapadToolkit](https://github.com/havlif/IdeapadToolkit) and is adapted specifically for **Lenovo IdeaPad S340-14API (81NB)**. Download the built application from the [GitHub Releases](https://github.com/itsmeyogs/IdeapadToolkit/releases) page.


<img height="467" alt="image" src="https://github.com/user-attachments/assets/0b139e18-d1f3-4b67-a3bf-4ca0ffef39cc" /><br>

**Power and charging profiles can be quickly adjusted from the tray icon**

<img height="180" alt="image" src="https://github.com/user-attachments/assets/27e79761-1922-4b73-901c-2668131689a2" />



**After running, the app windows can be accessed by double clicking the tray icon**
## Prerequisites
- [.NET 8 Runtime](https://dotnet.microsoft.com/en-us/download/dotnet/thank-you/runtime-8.0.10-windows-x64-installer)

- [Lenovo Intelligent Thermal Solution Driver](https://support.lenovo.com/id/id/downloads/ds543701-intelligent-thermal-solution-its-driver-for-windows-10-64-bit-s340-15api-s340-15api-touch-s340-14api)

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

