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
        [switch] $AllowUnencryptedAuthentication = $false,

        # Parameter help description
        [Parameter()]
        [Microsoft.PowerShell.Commands.WebRequestMethod]
        $Method = "Get",

        # Parameter help description
        [Parameter()]
        [System.Collections.IDictionary]
        $Data

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
            AllowUnencryptedAuthentication = $AllowUnencryptedAuthentication;
            Method                         = $Method
        }

        if ($Credential -ne $null) {
            $Parms['Credential'] = $Credential
            $Parms['Authentication'] = 'Basic'
        }

        if ($Token -ne $null) {
            $plainToken = ConvertFrom-SecureString -SecureString $Token
            $headers.Add("Authorization", "token $plainToken")
        }

        if ($Data -ne $null) {
            $Body = ConvertTo-Json $Data
            $headers.Add('Content-Type', 'application/json')
            $Parms.Add('Body', $Body)
        }

        $res = Invoke-RestMethod -Headers $headers @Parms
        return $res
    }

    end {
    }
}