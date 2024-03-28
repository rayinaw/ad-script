New-ADOrganizationalUnit -Name _USERS -ProtectedFromAccidentalDeletion $false

$ADUsers = Import-Csv "C:\Users\rayin_awarf\Desktop\work\AD-script\NewUsersFinal.csv" -Delimiter ";"

foreach ($User in $ADUsers) {
    try {
        # Define the parameters using a hashtable
        $UserParams = @{
            SamAccountName        = $User.username
            UserPrincipalName     = "$($User.username)@$UPN"
            Name                  = "$($User.firstname) $($User.lastname)"
            GivenName             = $User.firstname
            Surname               = $User.lastname
            Initial               = $User.initials
            Enabled               = $True
            DisplayName           = "$($User.firstname) $($User.lastname)"
            Path                  = $User.ou #This field refers to the OU the user account is to be created in
            City                  = $User.city
            PostalCode            = $User.zipcode
            Country               = $User.country
            Company               = $User.company
            State                 = $User.state
            StreetAddress         = $User.streetaddress
            OfficePhone           = $User.telephone
            EmailAddress          = $User.email
            Title                 = $User.jobtitle
            Department            = $User.department
            AccountPassword       = (ConvertTo-secureString $User.password -AsPlainText -Force)
            ChangePasswordAtLogon = $True
        }
        
        if (Get-ADUser -Filter "SamAccountName -eq '$($User.username)'") {

            # Give a warning if user exists
            Write-Host "A user with username $($User.username) already exists in Active Directory." -ForegroundColor Yellow
        }
        else {
            # User does not exist then proceed to create the new user account
            # Account will be created in the OU provided by the $User.ou variable read from the CSV file
            New-ADUser @UserParams

            # If user is created, show message.
            Write-Host "The user $($User.username) is created." -ForegroundColor Green
        }

    }
    catch {
        # Handle any errors that occur during account creation
        Write-Host "Failed to create user $($User.username) - $_" -ForegroundColor Red
    }
}