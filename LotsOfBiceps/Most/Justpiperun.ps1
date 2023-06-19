# Import Azure module
Import-Module Az.Accounts
Import-Module Az.DataFactory

# Login to Azure - Interactive Login
# Connect-AzAccount

# Trigger the pipeline
$pipelineRun = Start-AzDataFactoryV2Pipeline -ResourceGroupName 'YourResourceGroupName' -DataFactoryName 'YourDataFactoryName' -PipelineName 'YourPipelineName'

# Get the pipeline run id
$pipelineRunId = $pipelineRun.RunId

# Check status of the run
while ($true) {
    $pipelineStatus = Get-AzDataFactoryV2PipelineRun -ResourceGroupName 'YourResourceGroupName' -DataFactoryName 'YourDataFactoryName' -PipelineRunId $pipelineRunId

    if ($pipelineStatus.Status -eq 'InProgress') {
        Write-Host "Checking status in 10 seconds"
        Start-Sleep -Seconds 10
    }
    elseif ($pipelineStatus.Status -eq 'Succeeded') {
        Write-Host "Pipeline run succeeded"
        break
    }
    elseif ($pipelineStatus.Status -eq 'Failed') {
        Write-Host "Pipeline run failed"
        break
    }
}
