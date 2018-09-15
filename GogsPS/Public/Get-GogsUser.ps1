function Get-GogsUser {
    [CmdletBinding(DefaultParameterSetName = 'Credential')]
    param (
        [Parameter(Mandatory = $true,
            HelpMessage = 'Username to retrieve')]
        [string] $UserName,

        # Parameter help description
        [Parameter(Mandatory = $true)]
        [String] $Uri,

        [Parameter(ParameterSetName = 'Credential', Mandatory = $False)]
        [pscredential] $Credential,

        # Parameter help description
        [Parameter(ParameterSetName = 'Token', Mandatory = $False)]
        [securestring] $Token,
        
        # Parameter help description
        [Parameter()]
        [switch] $AllowUnencryptedAuthentication = $false
        
    )
    
    begin {
    }
    
    process {
        $Parms = @{ Uri                    = $Uri + '/api/v1/users/' + $UserName; 
            AllowUnencryptedAuthentication = $AllowUnencryptedAuthentication
        }
        if ($PSCmdlet.ParameterSetName -eq "Credential") {
            if ($Credential -ne $null) {
                $Parms['Credential'] = $Credential
                $Parms['Authentication'] = 'Basic' 
            }
        }
        else {
            $Parms['Token'] = $Token
            $Parms['Authentication'] = 'OAuth'
        }
        $user = Invoke-RestMethod @Parms
        Write-Output $user
    }
    
    end {
    }
}