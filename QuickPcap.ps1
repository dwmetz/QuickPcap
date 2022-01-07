<#
QuickPcap.ps1
https://github.com/dwmetz
Author: @dwmetz
Function: This script will use the native functions on a Windows host to collect a packet capture as an .etl file.
Note the secondary phase where etl2pcapng is required to convert to pcap.
#>
Write-Host -Fore Gray "------------------------------------------------------"
Write-Host -Fore Cyan "       QuickPcap.ps1" 
Write-Host -Fore DarkCyan "       https://github.com/dwmetz/QuickPcap"
Write-Host -Fore Cyan "       @dwmetz | bakerstreetforensics.com"
Write-Host -Fore Gray "------------------------------------------------------"
Start-Sleep -Seconds 3
#Get the local IPv4 address
$env:HostIP = (
    Get-NetIPConfiguration |
    Where-Object {
        $_.IPv4DefaultGateway -ne $null -and
        $_.NetAdapter.Status -ne "Disconnected"
    }
).IPv4Address.IPAddress
#Run the capture until the specified Sleep duration. Adjust as needed (in seconds.)
netsh trace start capture=yes IPv4.Address=$env:HostIP tracefile=c:\temp\capture.etl
Start-Sleep 90
netsh trace stop
<# Convert .etl to .pcap

Download the latest etl2pcapng from
https://github.com/microsoft/etl2pcapng/releases

#>
Set-Location C:\Tools\etl2pcapng\x64 
./etl2pcapng.exe c:\temp\capture.etl c:\temp\capture.pcap
Set-Location C:\Temp
Get-ChildItem