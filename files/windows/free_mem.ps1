Get-WmiObject Win32_PerfFormattedData_PerfOS_Memory | ForEach-Object {
    $_.AvailableBytes - ($_.StandbyCacheNormalPriorityBytes + $_.StandbyCacheReserveBytes)
}
