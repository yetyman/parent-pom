# Error handling function
function Test-LastExit {
    if ($LASTEXITCODE -ne 0) {
        Write-Host "Command failed with exit code $LASTEXITCODE" -ForegroundColor Red
        exit $LASTEXITCODE
    }
}

# Parent directory commands
Write-Host "Building parent project..." -ForegroundColor Cyan
mvn clean; Test-LastExit
mvn compile; Test-LastExit
mvn -Ppublication; Test-LastExit
mvn jreleaser:deploy -P release; Test-LastExit

# Array of modules
$modules = @(
    "basic-structures",
    "javafx-helpers",
    "properties",
    "javafx-nine-patch",
    "javafx-tree-view"
)

# Loop through each module
foreach ($module in $modules) {
    try {
        Push-Location $module
        Write-Host "Processing $module..." -ForegroundColor Green
        
        mvn -Ppublication; Test-LastExit
        mvn jreleaser:deploy -P release; Test-LastExit
    }
    catch {
        Write-Host "Error processing $module : $_" -ForegroundColor Red
        exit 1
    }
    finally {
        Pop-Location
    }
}

Write-Host "Deployment completed successfully!" -ForegroundColor Green
