const http = require('http');
const { PORT } = require('./config/env');
const app = require('./app');

const server = http.createServer(app);

server.listen(PORT, () => {
  console.log(`Server listening on port ${PORT}`);
});

