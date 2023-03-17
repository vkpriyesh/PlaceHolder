import React, { useEffect, useState } from 'react';

const AzureDataFactoryRuns = () => {
  const [runs, setRuns] = useState([]);

  useEffect(() => {
    const fetchData = async () => {
      const dataFactoryName = 'PNL-Factory';
      const pipelineName = 'DailyRunForPnL';
      const top = 10;

      const response = await fetch(`https://management.azure.com/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DataFactory/factories/${dataFactoryName}/pipelineruns?api-version=2018-06-01&$filter=PipelineName eq '${pipelineName}'&$orderby=RunEnd%20desc&$top=${top}`, {
        headers: {
          Authorization: `Bearer ${process.env.REACT_APP_AZURE_AUTH_TOKEN}`,
          'Content-Type': 'application/json'
        }
      });

      const data = await response.json();

      if (data && data.value) {
        setRuns(data.value);
      }
    };

    fetchData();
  }, []);

  return (
    <table>
      <thead>
        <tr>
          <th>Pipeline Name</th>
          <th>Status</th>
          <th>Date/Time</th>
          <th>Log</th>
        </tr>
      </thead>
      <tbody>
        {runs.map(run => (
          <tr key={run.runId}>
            <td>{run.pipelineName}</td>
            <td>{run.status}</td>
            <td>{new Date(run.runEnd).toLocaleString()}</td>
            <td>{run.message}</td>
          </tr>
        ))}
      </tbody>
    </table>
  );
};

export default AzureDataFactoryRuns;
