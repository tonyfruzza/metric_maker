100 - ((Get-WmiObject Win32_PerfFormattedData_PerfOS_Memory).AvailableKBytes / (gwmi Win32_OperatingSystem | %{ $_.TotalVisibleMemorySize}))*100
