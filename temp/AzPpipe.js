import React, { Component } from 'react';
import axios from 'axios';

class PipelineStatus extends Component {
  state = {
    status: '',
    lastRun: '',
    lastRunId: '',
    pipelineRuns: [],
  };

  componentDidMount() {
    const pipelineId = '<your-pipeline-id>';
    const apiUrl = `https://management.azure.com/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DataFactory/factories/{factoryName}/pipelines/${pipelineId}/activityruns?api-version=2018-06-01`;

    axios.get(apiUrl, {
      headers: {
        Authorization: `Bearer ${process.env.AZURE_ACCESS_TOKEN}`,
      },
      params: {
        $top: 10,
      },
    }).then((response) => {
      const pipelineRuns = response.data.value;
      const lastRun = pipelineRuns[0].runEnd;
      const lastRunId = pipelineRuns[0].activityRunId;
      const status = pipelineRuns[0].status;
      this.setState({ pipelineRuns, lastRun, lastRunId, status });
    }).catch((error) => {
      console.log(error);
    });
  }

  render() {
    const { status, lastRun, lastRunId, pipelineRuns } = this.state;

    return (
      <div>
        <p>Pipeline Status: {status === 'Succeeded' ? 'Success' : 'Failed'}</p>
        {lastRun && <p>Last Run: {new Date(lastRun).toLocaleString()}</p>}
        {lastRunId && <p>Last Run ID: {lastRunId}</p>}
        {pipelineRuns.length > 0 && (
          <div>
            <h3>Last 10 Pipeline Runs:</h3>
            <ul>
              {pipelineRuns.map((run) => (
                <li key={run.activityRunId}>
                  <span>{run.status === 'Succeeded' ? 'Success' : 'Failed'}</span>
                  <span>{new Date(run.runEnd).toLocaleString()}</span>
                </li>
              ))}
            </ul>
          </div>
        )}
      </div>
    );
  }
}

export default PipelineStatus;
