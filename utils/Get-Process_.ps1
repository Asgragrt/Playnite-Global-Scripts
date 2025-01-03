# Black magic to get 64 bit process path
# https://stackoverflow.com/questions/67217348/find-kill-64-bit-processes-by-path-in-32-bit-powershell
$pinvoke = Add-Type -PassThru -Name pinvoke -MemberDefinition @'
    [DllImport("kernel32.dll", SetLastError=true)]
    private static extern bool CloseHandle(
        IntPtr hObject);

    [DllImport("kernel32.dll", SetLastError = true)]
    private static extern IntPtr OpenProcess(
        uint processAccess,
        bool bInheritHandle,
        int processId);

    [DllImport("kernel32.dll", SetLastError=true)]
    private static extern bool QueryFullProcessImageName(
        IntPtr hProcess,
        int dwFlags,
        System.Text.StringBuilder lpExeName,
        ref int lpdwSize);
    private const int QueryLimitedInformation = 0x00001000;

    public static string GetProcessPath(int pid)
    {
        var size = 1024;
        var sb = new System.Text.StringBuilder(size);
        var handle = OpenProcess(QueryLimitedInformation, false, pid);
        if (handle == IntPtr.Zero) return null;
        var success = QueryFullProcessImageName(handle, 0, sb, ref size);
        CloseHandle(handle);
        if (!success) return null;
        return sb.ToString();
    }
'@

function Get-Process_ {
    param(
        [String]$AppPath,
        [String]$AppProcessName
    )

    $ValidPath = ![string]::IsNullOrWhiteSpace($AppPath)
    $ValidName = ![string]::IsNullOrWhiteSpace($AppProcessName)

    if (!$ValidPath -and !$ValidName) {
        throw "Get-Process_: Please specify valid values"
    }

    #Make filter
    $processFilter = if ($ValidPath -and $ValidName) {
        { $pinvoke::GetProcessPath($_.Id) -eq $AppPath -or $_.ProcessName -match $AppProcessName }
    }
    elseif ($ValidPath) {
        { $pinvoke::GetProcessPath($_.Id) -eq $AppPath }
    }
    elseif ($ValidName) {
        { $_.ProcessName -match $AppProcessName }
    }

    Get-Process | Where-Object $processFilter
}