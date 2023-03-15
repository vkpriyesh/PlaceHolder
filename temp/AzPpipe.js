import React, { Component } from 'react';
import axios from 'axios';

class PipelineStatus extends Component {
  state = {
    status: '',
    lastRun: '',
  };

  componentDidMount() {
    const pipelineId = '<your-pipeline-id>';
    const apiUrl = `https://management.azure.com/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DataFactory/factories/{factoryName}/pipelines/${pipelineId}/getLastActivity?api-version=2018-06-01`;

    axios.get(apiUrl, {
      headers: {
        Authorization: `Bearer ${process.env.AZURE_ACCESS_TOKEN}`,
      },
    }).then((response) => {
      const status = response.data.status;
      const lastRun = response.data.runEnd;
      this.setState({ status, lastRun });
    }).catch((error) => {
      console.log(error);
    });
  }

  render() {
    const { status, lastRun } = this.state;

    return (
      <div>
        <p>Pipeline Status: {status === 'Succeeded' ? 'Success' : 'Failed'}</p>
        {lastRun && <p>Last Run: {new Date(lastRun).toLocaleString()}</p>}
      </div>
    );
  }
}

export default PipelineStatus;
