@{
    # Both scripts in this folder are user-facing CLI tools that intentionally
    # print colored status to the console. Write-Host is the right call; the
    # output is meant for a human looking at the terminal, not for redirection
    # or capture. Suppress the rule rather than blanket-disable warnings.
    ExcludeRules = @(
        'PSAvoidUsingWriteHost',
        'PSUseBOMForUnicodeEncodedFile'   # PowerShell 7+ reads UTF-8 without BOM correctly
    )
    Severity = @('Error', 'Warning')
}
