REACT_APP_AZURE_CLIENT_ID=<YOUR_AZURE_CLIENT_ID>
REACT_APP_AZURE_TENANT_ID=<YOUR_AZURE_TENANT_ID>
REACT_APP_AZURE_SUBSCRIPTION_ID=<YOUR_AZURE_SUBSCRIPTION_ID>
REACT_APP_AZURE_RESOURCE_GROUP=<YOUR_AZURE_RESOURCE_GROUP>
REACT_APP_AZURE_DATA_FACTORY_NAME=<YOUR_AZURE_DATA_FACTORY_NAME>
REACT_APP_AZURE_PIPELINE_NAME=<YOUR_AZURE_PIPELINE_NAME>



Index
import React from 'react';
import ReactDOM from 'react-dom';
import { PublicClientApplication } from '@azure/msal-browser';
import { MsalProvider } from '@azure/msal-react';

import App from './App';
import './index.css';

const msalConfig = {
  auth: {
    clientId: process.env.REACT_APP_AZURE_CLIENT_ID,
    authority: `https://login.microsoftonline.com/${process.env.REACT_APP_AZURE_TENANT_ID}`,
    redirectUri: window.location.origin,
  },
  cache: {
    cacheLocation: 'localStorage',
    storeAuthStateInCookie: false,
  },
};

const pca = new PublicClientApplication(msalConfig);

ReactDOM.render(
  <React.StrictMode>
    <MsalProvider instance={pca}>
      <App />
    </MsalProvider>
  </React.StrictMode>,
  document.getElementById('root')
);

Signin
import React from "react";
import { useMsal } from "@azure/msal-react";

function SignIn() {
  const { instance } = useMsal();

  const handleSignIn = () => {
    instance.loginPopup({
      scopes: ["openid", "profile", "https://management.azure.com//.default"],
    });
  };

  return (
    <button onClick={handleSignIn}>
      Sign In
    </button>
  );
}

export default SignIn;

Pipelinejs
import React, { useEffect, useState } from "react";
import { useMsal, useAccount } from "@azure/msal-react";
import { DataFactoryManagementClient } from "@azure/arm-datafactory";

async function fetchPipelineRuns(accessToken) {
  const client = new DataFactoryManagementClient(accessToken, process.env.REACT_APP_AZURE_SUBSCRIPTION_ID);
  const response = await client.pipelineRuns.queryByFactory(process.env.REACT_APP_AZURE_RESOURCE_GROUP, process.env.REACT_APP_AZURE_DATA_FACTORY_NAME, {
    filter: `PipelineName eq '${process.env.REACT_APP_AZ
    .APP_AZURE_PIPELINE_NAME}'`,
    orderBy: "RunStart desc",
  });

  return response.value;
}

function PipelineRuns() {
  const { instance, accounts } = useMsal();
  const account = useAccount(accounts[0]);
  const [pipelineRuns, setPipelineRuns] = useState([]);

  useEffect(() => {
    if (account) {
      instance
        .acquireTokenSilent({
          account: account,
          scopes: ["https://management.azure.com//.default"],
        })
        .then((response) => {
          fetchPipelineRuns(response.accessToken).then((runs) => setPipelineRuns(runs));
        });
    }
  }, [account, instance]);

  return (
    <table>
      <thead>
        <tr>
          <th>Pipeline Run ID</th>
          <th>Status</th>
          <th>Start Time</th>
          <th>End Time</th>
        </tr>
      </thead>
      <tbody>
        {pipelineRuns.map((run) => (
          <tr key={run.runId}>
            <td>{run.runId}</td>
            <td>{run.status}</td>
            <td>{run.runStart ? new Date(run.runStart).toLocaleString() : ""}</td>
            <td>{run.runEnd ? new Date(run.runEnd).toLocaleString() : ""}</td>
          </tr>
        ))}
      </tbody>
    </table>
  );
}

export default PipelineRuns;

Appjs
import { useMsal, useIsAuthenticated } from "@azure/msal-react";
import SignIn from "./SignIn";
import PipelineRuns from "./PipelineRuns";

function App() {
  const isAuthenticated = useIsAuthenticated();

  return (
    <div className="App">
      {isAuthenticated ? <PipelineRuns /> : <SignIn />}
    </div>
  );
}

export default App;

