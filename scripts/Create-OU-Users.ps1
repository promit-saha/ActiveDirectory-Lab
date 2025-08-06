# Import Active Directory module
Import-Module ActiveDirectory

# Define base domain
$domain = "DC=promit,DC=local"

# Define OUs and corresponding users
$ouUsers = @{
    "OU=IT_Department,$domain" = @(
        @{FirstName="IT"; LastName="USER3"; Username="ituser3"},
        @{FirstName="IT"; LastName="USER4"; Username="ituser4"}
    );
    "OU=HR,$domain" = @(
        @{FirstName="HR"; LastName="USER1"; Username="hruser1"},
        @{FirstName="HR"; LastName="USER2"; Username="hruser2"}
    );
    "OU=AdminUsers,$domain" = @(
        @{FirstName="Admin"; LastName="One"; Username="admin1"},
        @{FirstName="Admin"; LastName="Two"; Username="admin2"}
    )
}

# Loop through OUs and create users
foreach ($ou in $ouUsers.Keys) {
    foreach ($user in $ouUsers[$ou]) {
        $fullName = "$($user.FirstName) $($user.LastName)"
        $samAccountName = $user.Username
        $password = ConvertTo-SecureString "Test@1234" -AsPlainText -Force

        Write-Host "Creating user $samAccountName in $ou..."

        New-ADUser `
            -Name $fullName `
            -GivenName $user.FirstName `
            -Surname $user.LastName `
            -SamAccountName $samAccountName `
            -UserPrincipalName "$samAccountName@promit.local" `
            -AccountPassword $password `
            -Enabled $true `
            -Path $ou
    }
}
