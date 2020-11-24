Write-Host "Created By Colton Clark"

$user = "$env:USERNAME"
$groups = "directors"

foreach ($group in $groups) {
    $members = Get-ADGroupMember -Identity $group -Recursive | Select-object -ExpandProperty SamAccountName

    If ($members -contains $user) {
        #WRITE CODE HERE
        $Searchbase = Get-ADUser -identity $env:USERNAME -Properties canonicalName | Select-Object @{Name='OU';Expression={$_.DistinguishedName.Split(',')[($_.Name -split ',').count..$($_.DistinguishedName.Split(',')).count] -join ','}} | Select-Object -ExpandProperty OU 
        $usertoreset = get-aduser -Filter * -SearchBase $searchbase 
        
        $usertoreset | Select-Object SamAccountName, Name | out-string

        
        $selectedtoreset = read-host "Enter the SamAccountName of who you would like to reset."
        Set-ADAccountPassword -Identity $selectedtoreset -Reset
        Set-ADUser -Identity $selectedtoreset -ChangePasswordAtLogon $true

    } Else {
        Write-Host "$user is not a member of $group"
    }
}
