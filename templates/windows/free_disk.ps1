$disk=Get-WmiObject Win32_LogicalDisk -Filter "DeviceID='<%= @drive_letter.upcase %>:'"
$per=100 - $disk.FreeSpace / $disk.Size * 100
echo $per
