# SCCM_PRTG
Scripts to allow for monitoring of SCCM software update activities via PRTG

Notes about SCCMSyncStatus.ps1:
- The SCCM console will need to be installed on the PRTG probe that is running the script.
- Once installed, run the console under the security context of the account that PRTG will be using.  Then, click on the blue button in the top-left and select "Connect via Windows PowerShell."  On the security prompt that then appears, be sure to select "Always Allow."  This will allow the PRTG user account to execute the SCCM-specific Powershell cmdlets.

Note about SCCM_WMI.ps1:
- This script will create 3 channels per deployment.  PRTG's current channels-per-sensor limit is 50, which means after the 16th deployment data will be lost.  If you could be potentially monitoring more than that, consider removing a set of channels from the script, reducing the cutoff time (default to 30 days), or improving the efficiency of my script!  :)
