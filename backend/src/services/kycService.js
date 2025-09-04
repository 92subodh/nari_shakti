// Simple Aadhaar checker: 12 digits. This is NOT real verification.
// In production, integrate with an official KYC provider.
exports.verifyAadhaar = async (aadharNumber) => {
  const num = String(aadharNumber || '').replace(/\D/g, '');
  const isFormatValid = /^\d{12}$/.test(num);
  if (!isFormatValid) {
    return { verified: false, provider: 'mock', reason: 'invalid_format' };
  }
  // Toy rule: treat even last digit as verified
  const lastDigit = Number(num[num.length - 1]);
  const verified = lastDigit % 2 === 0;
  return { verified, provider: 'mock', reason: verified ? 'format_ok' : 'heuristic_rejected' };
};

