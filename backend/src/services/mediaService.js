const path = require('path');
const fs = require('fs');

// Stores file locally under /uploads with timestamped name.
// Replace with S3/GCS/Azure in production.
exports.uploadToCloud = async (buffer, opts = {}) => {
  const uploadsDir = path.join(process.cwd(), 'uploads');
  if (!fs.existsSync(uploadsDir)) fs.mkdirSync(uploadsDir, { recursive: true });
  const ext = (opts.type === 'image' && '.jpg') || (opts.type === 'audio' && '.mp3') || (opts.type === 'video' && '.mp4') || '.bin';
  const filename = `evidence_${Date.now()}${ext}`;
  const fullPath = path.join(uploadsDir, filename);
  await fs.promises.writeFile(fullPath, buffer);
  return { url: `/uploads/${filename}` };
};

