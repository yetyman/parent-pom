# Error handling function
function Test-LastExit {
    if ($LASTEXITCODE -ne 0) {
        Write-Host "Command failed with exit code $LASTEXITCODE" -ForegroundColor Red
        exit $LASTEXITCODE
    }
}

## Parent directory commands
#Write-Host "Building parent project..." -ForegroundColor Cyan
#mvn clean; Test-LastExit
#mvn compile; Test-LastExit
#
## First publish the parent pom
#Write-Host "Publishing parent pom..." -ForegroundColor Cyan
#mvn -Ppublication -N; Test-LastExit  # -N flag means 'non-recursive' - parent only
#mvn jreleaser:deploy -P release -N; Test-LastExit

# Then publish individual modules
$modules = @(
#    "basic-structures",
    "javafx-helpers",
    "properties",
    "javafx-tree-view",
    "javafx-nine-patch",
    "javafx-editor-base"
)

foreach ($module in $modules) {
    Write-Host "Building individual project..." -ForegroundColor Cyan
    mvn clean; Test-LastExit
    mvn compile; Test-LastExit

    Write-Host "Publishing module $($module)..." -ForegroundColor Cyan
    mvn -Ppublication -pl $module; Test-LastExit
    mvn jreleaser:deploy -P release -pl $module; Test-LastExit
}

Write-Host "Deployment completed successfully!" -ForegroundColor Green
