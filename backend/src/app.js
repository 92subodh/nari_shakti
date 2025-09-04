const express = require('express');
const cors = require('cors');
const morgan = require('morgan');
const connectDB = require('./config/db');
const { NODE_ENV } = require('./config/env');

// Routes
const authRoutes = require('./routes/authRoutes');
const userRoutes = require('./routes/userRoutes');
const sosRoutes = require('./routes/sosRoutes');
const locationRoutes = require('./routes/locationRoutes');
const communityRoutes = require('./routes/communityRoutes');
const reportRoutes = require('./routes/reportRoutes');

// Middlewares
const { errorHandler, notFound } = require('./middlewares/errorHandler');

const app = express();

// DB
connectDB();

// Core middleware
app.use(cors());
app.use(express.json({ limit: '2mb' }));
app.use(morgan(NODE_ENV === 'development' ? 'dev' : 'tiny'));

// Health
app.get('/health', (req, res) => res.json({ ok: true }));

// Static files for uploaded media
app.use('/uploads', express.static(require('path').join(process.cwd(), 'uploads')));

app.get('/', (req, res) => res.json({ server: "working......" }));

// API routes
app.use('/api/auth', authRoutes);
app.use('/api/user', userRoutes);
app.use('/api/sos', sosRoutes);
app.use('/api/location', locationRoutes);
app.use('/api/community', communityRoutes);
app.use('/api/report', reportRoutes);

// 404 and error handlers
app.use(notFound);
app.use(errorHandler);

module.exports = app;

