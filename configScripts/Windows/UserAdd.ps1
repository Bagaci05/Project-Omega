Import-Module ActiveDirectory
 
Write-Host "=== New AD User Creation ===" -ForegroundColor Cyan
 
# Ask basic info
$FirstName = Read-Host "First name"
$LastName  = Read-Host "Last name"
$Username  = Read-Host "Username (samAccountName)"
$Password  = Read-Host "Password" -AsSecureString
 
# Ask user type
Write-Host ""
Write-Host "Select user type:" -ForegroundColor Yellow
Write-Host "1 - Guest"
Write-Host "2 - Worker"
 
$TypeChoice = Read-Host "Enter 1 or 2"
 
switch ($TypeChoice) {
    "1" {
        $OUPath = "OU=EvilGuests,OU=evils,DC=EvilInc,DC=hu"
        $RoleGroup = "EvilGuests"
        $UserType = "Guest"
    }
    "2" {
        $OUPath = "OU=EvilWorkers,OU=evils,DC=EvilInc,DC=hu"
        $RoleGroup = "EvilWorkers"
        $UserType = "Worker"
    }
    default {
        Write-Host "Invalid selection. Exiting." -ForegroundColor Red
        exit 1
    }
}
 
# Home folder
$HomeDrive = "H:"
$HomePath  = "\\CaffeeServer\home\$Username"
 
# Create user
New-ADUser `
    -Name "$FirstName $LastName" `
    -GivenName $FirstName `
    -Surname $LastName `
    -SamAccountName $Username `
    -UserPrincipalName "$Username@$(Get-ADDomain).DNSRoot" `
    -AccountPassword $Password `
    -Enabled $true `
    -Path $OUPath `
    -HomeDrive $HomeDrive `
    -HomeDirectory $HomePath
 
# Add to security groups
Add-ADGroupMember -Identity "WIFIUsers" -Members $Username
Add-ADGroupMember -Identity $RoleGroup -Members $Username
 
Write-Host ""
Write-Host "User created successfully!" -ForegroundColor Green
Write-Host "Name: $FirstName $LastName"
Write-Host "Username: $Username"
Write-Host "Type: $UserType"
Write-Host "OU: $OUPath"
Write-Host "Groups:"
Write-Host " - WIFI Users"
Write-Host " - $RoleGroup"
Write-Host "Home folder: $HomePath"

Start-Sleep -Seconds 2

if (!(Test-Path $HomePath)) {
    New-Item -ItemType Directory -Path $HomePath | Out-Null
}

$Acl = Get-Acl $HomePath
$Acl.SetAccessRuleProtection($true, $false)

$UserRule = New-Object System.Security.AccessControl.FileSystemAccessRule(
    "$Username",
    "FullControl",
    "ContainerInherit,ObjectInherit",
    "None",
    "Allow"
)

$AdminRule = New-Object System.Security.AccessControl.FileSystemAccessRule(
    "Administrators",
    "FullControl",
    "ContainerInherit,ObjectInherit",
    "None",
    "Allow"
)

$Acl.SetAccessRule($UserRule)
$Acl.AddAccessRule($AdminRule)

Set-Acl -Path $HomePath -AclObject $Acl
