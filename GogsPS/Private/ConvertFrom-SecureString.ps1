<#
Secure Strings not fully supported in Linux and Mac. This will override
ConvertFrom-SecureSting. When full support is added this can be removed.

See https://github.com/PowerShell/PowerShell/issues/1654
#>

if ($IsLinux -or $IsMacOS) {
    function ConvertFrom-SecureString {
        [CmdletBinding()]
        param (
            # Parameter help description
            [Parameter(Mandatory = $true)]
            [securestring] $SecureString
        )

        if (($PSVersionTable.PSEdition -eq 'Desktop') -or $IsWindows) {
            Throw "ConvertFrom-SecureString should not be overridden on Windows"
        }

        $ret = (New-Object -TypeName pscredential ("user", $SecureString)).GetNetworkCredential().Password
        return $ret
    }
}