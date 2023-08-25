const express = require('express');
const cors = require('cors');

const app = express();

// Use this to allow all origins
app.use(cors());

// OR be specific:
app.use(cors({
  origin: 'http://localhost:4200'
}));

// ... rest of your app code ...
