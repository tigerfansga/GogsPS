function New-GogsUser {
    [CmdletBinding(DefaultParameterSetName = 'Credential',
        SupportsShouldProcess, ConfirmImpact = 'Medium')]
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
            HelpMessage = 'User to create')]
        [string] $UserName,

        # Parameter help description
        [Parameter(Mandatory = $true)]
        [string] $email,

        # Parameter help description
        [Parameter()]
        [int] $source_id,

        # Parameter help description
        [Parameter()]
        [string] $login_name,

        # Parameter help description
        [Parameter()]
        [securestring] $Password,

        # Parameter help description
        [Parameter()]
        [System.Boolean] $send_notify

    )

    begin {
    }

    process {
        $Parms = @{ BaseUri = $BaseUri; ApiEndpoint = '/admin/users'; Method = 'post'; ApiVersion = '1' }
        Foreach ($var in "Credential", "Token", "AllowUnencryptedAuthentication") {
            $val = Get-Variable -Name $var -ValueOnly -ErrorAction SilentlyContinue
            if ($val) {
                $Parms[$var] = $val
            }
        }

        $dataParms = @('UserName', 'email', 'source_id', 'login_name', 'send_notify')
        $data = @{}
        foreach ($var in $dataParms) {
            $val = Get-Variable -Name $var -ValueOnly -ErrorAction SilentlyContinue
            if ($val) {
                $Data[$var] = $val
            }
        }
        if ($Password) {
            $Data["Password"] = ConvertFrom-SecureString -SecureString $Password
        }

        $Parms["Data"] = $data
        if ($PSCmdlet.ShouldProcess("$Username")) {
            $user = Invoke-GogsApi @Parms
        }
        return $user
    }

    end {
    }
}