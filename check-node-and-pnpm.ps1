# Function to check the latest version of Node.js
function Get-LatestNodeVersion {
    $response = Invoke-RestMethod -Uri 'https://nodejs.org/dist/index.json'
    return $response[0].version
}

# Function to check the latest version of pnpm
function Get-LatestPnpmVersion {
    try {
        $response = Invoke-RestMethod -Uri 'https://registry.npmjs.org/pnpm'
        if ($response -and $response.'dist-tags' -and $response.'dist-tags'.'latest') {
            return $response.'dist-tags'.'latest'
        } else {
            Write-Error "Unexpected response structure: $($response | ConvertTo-Json)"
            return "Unknown"
        }
    } catch {
        Write-Error "Failed to get the latest pnpm version: $_"
        return "Unknown"
    }
}

# Get current versions
try {
    $currentNodeVersion = node -v
} catch {
    Write-Error "Failed to get the current Node.js version."
    $currentNodeVersion = "Unknown"
}

try {
    $currentPnpmVersion = (cmd /c "pnpm -v").Trim()
} catch {
    Write-Error "Failed to get the current pnpm version."
    $currentPnpmVersion = "Unknown"
}

# Get latest versions
$latestNodeVersion = Get-LatestNodeVersion
$latestPnpmVersion = Get-LatestPnpmVersion

# Output the version information
Write-Output "Current Node.js version: $currentNodeVersion"
Write-Output "Latest Node.js version: $latestNodeVersion"
Write-Output ""
Write-Output "Current pnpm version: $currentPnpmVersion"
Write-Output "Latest pnpm version: $latestPnpmVersion"
