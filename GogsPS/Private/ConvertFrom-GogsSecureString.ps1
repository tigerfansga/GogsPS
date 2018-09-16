function ConvertFrom-GogsSecureString {
    [CmdletBinding()]
    param (
        # Parameter help description
        [Parameter(Mandatory = $true)]
        [securestring] $SecureString
    )
    
    begin {
    }
    
    process {
        if ($IsLinux) {
            $ret = (New-Object -TypeName pscredential ("user", $SecureString)).GetNetworkCredential().Password
        }
        else {
            $ret = ConvertFrom-SecureString -SecureString $SecureString
        }
        return $ret
    }
    
    end {
    }
}