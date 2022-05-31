# grab necessary permissions and connect to powershell graph API
Select-MgProfile -Name "v1.0"
(Find-MgGraphCommand -Command Get-MgApplicationOwner).Permissions
Connect-MgGraph -Scopes "Application.ReadWrite.All" -UseDeviceAuthentication



# application stuff
$OwnerIdParams = @{
    "@odata.id" = "https://graph.microsoft.com/v1.0/directoryObjects/$ownerId"
}
$AppSecretParams = @{
    PasswordCredential = @{
        DisplayName = "secret to service connection, Subscription owner has responsibility to keep this secret"
	}
}


$applicationDisplayName = "graphRules03"
$ownerId = "a78f2077-056c-42e8-9155-d0c93c86bd4f"
$ApplicationExistance = get-mgapplication -Property DisplayName | Where-Object { $_.DisplayName -eq $applicationDisplayName }
if (!$ApplicationExistance) {
   Write-Output "Application does not exist, creating..."
   $newApp = New-MgApplication -DisplayName $applicationDisplayName -SignInAudience AzureADMyOrg
   $appOwner = New-MgApplicationOwnerByRef -ApplicationId $newApp.id -BodyParameter $OwnerIdParams
   $newSecret = Add-MgApplicationPassword -ApplicationId $newApp.id -BodyParameter $AppSecretParams
   $newSecret
   $appOwner
   $spParams=@{
       "AppId" = $newApp.AppId
    }
    $newSP = New-MgServicePrincipal -BodyParameter $spParams
    $spOwner = New-MgServicePrincipalOwnerByRef -ServicePrincipalId $newSP.id -BodyParameter $OwnerIdParams
    $spOwner

} else {
    Write-Output "done"
}


get-mgapplication | Where-Object { $_.displayName -like "graphRules*" } | ForEach-Object {
    Remove-MgApplication -ApplicationId $_.id -Verbose
}