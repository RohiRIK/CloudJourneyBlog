#Requires -PSEdition Desktop
#Requires -Modules Entra

<#
.SYNOPSIS
    Assigns Microsoft Graph or other API permissions to a Managed Identity.

.DESCRIPTION
    This function assigns specified application permissions to a Managed Identity in Azure AD.

.PARAMETER TenantID
    The Azure AD tenant ID. Defaults to "YOUR_TENANT_ID".

.PARAMETER ManagedIdentityId
    The Object ID of the Managed Identity service principal.

.PARAMETER PermissionsName
    An array of permission names to assign (e.g. "User.Read.All", "Group.ReadWrite.All").

.PARAMETER ApplicationName
    The name of the API to grant permissions for. Defaults to "Microsoft Graph".

.EXAMPLE
    Assign-ManagedIdentityPermissions -ManagedIdentityId "12345678-1234-1234-1234-123456789012" -PermissionsName "User.Read.All","Group.Read.All"

.NOTES
    Requires the Entra PowerShell module.
#>

function New-ManagedIdentityAppRoleAssignment {
    param(
        [Parameter(Mandatory)]
        [string]$ResourceId,
        [Parameter(Mandatory)] 
        [string]$AppRoleId,
        [Parameter(Mandatory)]
        [string]$PrincipalId
    )

    New-EntraBetaServicePrincipalAppRoleAssignment `
        -ObjectId $PrincipalId `
        -ResourceId $ResourceId `
        -PrincipalId $PrincipalId `
        -Id $AppRoleId `
        -ErrorAction Stop #-Verbose
}



function Assign-ManagedIdentityPermissions {
    [CmdletBinding()]
    param (
        [string]$TenantID = "YOUR_TENANT_ID",
        
        [Parameter(Mandatory)]
        [string]$ManagedIdentityId,
        
        [Parameter(Mandatory)]
        [string[]]$PermissionsName,
        
        [string]$ApplicationName = "Microsoft Graph"
    )

    try {
        # Connect to Entra ID
        Write-Verbose "Connecting to Microsoft Entra tenant: $TenantID"
        Connect-Entra -TenantId $TenantID -ErrorAction Stop -Scopes \'AppRoleAssignment.ReadWrite.All\' , \'Application.ReadWrite.All\'
        
        # Get the service principal for the API (outside the loop for efficiency)
        Write-Verbose "Getting service principal for: $ApplicationName"
        $GraphServicePrincipal = Get-EntrabetaServicePrincipal -Filter "DisplayName eq \'$ApplicationName\'" | Select-Object -First 1
        
        if (-not $GraphServicePrincipal) {
            Write-Error "Application \'$ApplicationName\' was not found in Microsoft Entra ID"
            return
        }

        $SuccessCount = 0
        $FailedPermissions = @()
        
        foreach($PermissionName in $PermissionsName) {
            Write-Verbose "Processing permission: $PermissionName"
            
            # Find the appropriate app role
            $AppRole = $GraphServicePrincipal.AppRoles |\
                Where-Object {$_.Value -eq $PermissionName -and $_.AllowedMemberTypes -contains "Application"}
            
            if ($AppRole) {
                try {
                    Write-Verbose "Assigning permission: $PermissionName"
                    Write-Verbose "Managed Identity ID: $ManagedIdentityId"
                    Write-Verbose "Graph Service Principal ID: $($GraphServicePrincipal.Id)"
                    Write-Verbose "App Role ID: $($AppRole.Id)"
                    
                    New-ManagedIdentityAppRoleAssignment -ResourceId $($GraphServicePrincipal.Id) -AppRoleId $($AppRole.Id) -PrincipalId $($ManagedIdentityId)
  
                    Write-Verbose "Successfully assigned permission: $PermissionName"
                    $SuccessCount++
                }
                catch {
                    Write-Error "Failed to assign permission \'$PermissionName\': $_"
                    $FailedPermissions += $PermissionName
                }
            }
            else {
                Write-Error "Permission \'$PermissionName\' was not found in $($GraphServicePrincipal.DisplayName)"
                $FailedPermissions += $PermissionName
            }
        }
        
        # Summary
        Write-Output "Assignment complete. Successfully assigned $SuccessCount of $($PermissionsName.Count) permissions."
        if ($FailedPermissions.Count -gt 0) {
            Write-Warning "Failed to assign the following permissions: $($FailedPermissions -join \', \')"
        }
    }
    catch {
        Write-Error "An error occurred: $_"
    }
}

# Example Usage (replace with your actual values)
# Assign-ManagedIdentityPermissions -ManagedIdentityId "YOUR_MANAGED_IDENTITY_OBJECT_ID" -TenantID "YOUR_TENANT_ID" -PermissionsName "Application.Read.All","AuditLog.Read.All","Policy.Read.All","Policy.ReadWrite.ConditionalAccess" -ApplicationName "Microsoft Graph"

