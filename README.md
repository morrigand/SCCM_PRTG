# SCCM_PRTG
Scripts to allow for monitoring of SCCM software update activities via PRTG

Notes about SCCMSyncStatus.ps1:
- The SCCM console will need to be installed on the PRTG probe that is running the script.
- I changed this script to now use WMI instead of the SCCM-specific Powershell cmdlets, as I would get no results in the sensor unless a session of the user account that was running the script from PRTG had a pre-existing session if the PS cmdlets were used.  Switching to WMI removes this 'requirement.'

Notes about SCCM_Deployments.ps1:
- Instead of creating 3 channels per deployment, this sensor is intended to be executed attached to a sensor with the name of the device collection you wish to monitor.  This changes the limit of deployments you can monitor from 16 to the number of remaining licensed sensors you have.  This will also require that you add "%device" (with the quotes, in case your collection names have spaces) as a parameter when setting up the sensor.
- On the advice of Paessler support (https://kb.paessler.com/en/topic/86809-groups-within-a-device), I followed this guideline to 'cordon off' the SCCM sensors from the rest of the sensors which monitor the actual SCCM server itself.
- The script will detect if more than one deployment exists for the device collection and will take ONLY the most recent one.

Note about SCCM_WMI.ps1:
- This script has been deprecated in favor of SCCM_Deployments.ps1, but feel free to use it if it meets your needs.
