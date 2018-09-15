function Invoke-GogsApi {
    [CmdletBinding(DefaultParameterSetName = 'Credential')]
    param (
        # Parameter help description
        [Parameter(Mandatory = $true, HelpMessage = 'Base Uri for Api Call')]
        [String] $BaseUri,

        [Parameter(ParameterSetName = 'Credential', Mandatory = $False)]
        [pscredential] $Credential,

        # Parameter help description
        [Parameter(ParameterSetName = 'Token', Mandatory = $False)]
        [securestring] $Token,

        # Parameter help description
        [Parameter(Mandatory = $True)]
        [string]
        $ApiEndPoint,

        # Parameter help description
        [Parameter()]
        [ValidateSet('1')]
        [string]
        $ApiVersion = '1',
        
        # Parameter help description
        [Parameter()]
        [switch] $AllowUnencryptedAuthentication = $false
        
    )
    
    begin {
    }
    
    process {
        $apiPrefixs = @{ '1' = 'api/v1' }
        $headers = @{}

        if (-not $BaseUri.EndsWith('/')) {
            $BaseUri += '/'
        }

        $Parms = @{ Uri                    = $BaseUri + $apiPrefixs[$ApiVersion] + $ApiEndPoint; 
            AllowUnencryptedAuthentication = $AllowUnencryptedAuthentication
        }

        if ($Credential -ne $null) {
            $Parms['Credential'] = $Credential
            $Parms['Authentication'] = 'Basic' 
        }
        
        if ($Token -ne $null) {
            if ($IsLinux) {
                $plainToken = (New-Object -TypeName pscredential ("user", $Token)).GetNetworkCredential().Password
            }
            else {
                $plainToken = ConvertFrom-SecureString -SecureString $Token
            }
            $headers.Add("Authorization", "Token $plainToken")
        }

        $res = Invoke-RestMethod -Headers $headers @Parms
        return $res
    }
    
    end {
    }
}