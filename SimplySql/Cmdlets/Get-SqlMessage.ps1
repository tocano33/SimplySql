<#
.Synopsis
    Returns any available informational messages.

.Description
    Get-SqlMessage returns any informational messages generated by
    Invoke-SqlScalar, Invoke-SqlQuery, or Invoke-SqlUpdate.  Not all providers
    support informational messages.

    If you use Print or Raiserror without the "NoWait", then messages will be
    batched to 8kb and then sent.  To get messages immediately sent, your 
    query needs to use
        
        RAISERROR('your message', 10,1) WITH NOWAIT

.Parameter ConnectionName
    User defined name for connection.

#>
Function Get-SqlMessage {
    [cmdletBinding()]
    Param([Alias("cn")][string]$ConnectionName = "default")

    If(TestConnectionName -ConnectionName $ConnectionName) {
        Try {
            While ($Script:Connections.$ConnectionName.HasMessages()) {
                Write-Output $Script:Connections.$ConnectionName.GetMessage()
            }
        }
        Catch [System.NotSupportedException] {
            Write-Warning ("[{0}] {1}" -f $Script:Connections.$ConnectionName.ProviderType(), $_.exception.message)
        }
    }
}

Export-ModuleMember -Function Get-SqlMessage