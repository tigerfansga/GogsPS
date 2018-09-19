function Remove-GogsUser {
    [CmdletBinding(DefaultParameterSetName = 'Credential',
        SupportsShouldProcess, ConfirmImpact = 'High')]
    param (
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
        [switch] $AllowUnencryptedAuthentication = $false,

        [Parameter(Mandatory = $true,
            HelpMessage = 'Username to delete')]
        [string] $UserName
    )

    begin {
    }

    process {
        $Parms = @{ BaseUri = $BaseUri; ApiEndpoint = "/admin/users/$UserName"; Method = 'Delete'; ApiVersion = '1' }
        Foreach ($var in "Credential", "Token", "AllowUnencryptedAuthentication") {
            $val = Get-Variable -Name $var -ValueOnly -ErrorAction SilentlyContinue
            if ($val) {
                $Parms[$var] = $val
            }
        }
        if ($PSCmdlet.ShouldProcess("$username")) {
            $user = Invoke-GogsApi @Parms
        }
        return $user
    }

    end {
    }
}