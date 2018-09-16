function Get-GogsUser {
    [CmdletBinding(DefaultParameterSetName = 'Credential')]
    param (
        [Parameter(Mandatory = $true,
            HelpMessage = 'Username to retrieve')]
        [string] $UserName,

        # Parameter help description
        [Parameter(Mandatory = $true, HelpMessage = 'Base Uri of Gogs Server')]
        [String] $BaseUri,

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
        $Parms = $PSBoundParameters
        $Parms.Remove('UserName') | Out-Null
        $Parms['ApiEndpoint'] = '/users/' + $UserName
        $Parms['Method'] = 'Get'

        $user = Invoke-GogsApi @Parms
        return $user
    }
    
    end {
    }
}