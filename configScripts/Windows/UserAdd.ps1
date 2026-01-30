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
        $OUPath = "OU=Guests,OU=evils,DC=EvilCaffee.hu,DC=local"
        $RoleGroup = "EvilGuests"
        $UserType = "Guest"
    }
    "2" {
        $OUPath = "OU=workers,OU=evils,DC=EvilCaffee.hu,DC=local"
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
Add-ADGroupMember -Identity "WIFI Users" -Members $Username
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