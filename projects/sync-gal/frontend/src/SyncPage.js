import React, { useState } from 'react';
import axios from 'axios';

function SyncPage() {
  const [status, setStatus] = useState({ message: 'Idle', type: 'info' });
  const [loading, setLoading] = useState(false);

  const handleSync = () => {
    setLoading(true);
    setStatus({ message: 'Syncing...', type: 'info' });
    axios.post('/api/sync')
      .then(response => {
        setStatus({ message: 'Sync process started successfully.', type: 'success' });
        setLoading(false);
      })
      .catch(error => {
        setStatus({ message: 'Error starting sync process.', type: 'danger' });
        setLoading(false);
        console.error(error);
      });
  };

  return (
    <div>
      <h1>GAL Sync</h1>
      <p>Click the button to start the synchronization process.</p>
      <button className="btn btn-primary" onClick={handleSync} disabled={loading}>
        {loading && <span className="spinner-border spinner-border-sm" role="status" aria-hidden="true"></span>}
        {loading ? ' Syncing...' : 'Sync Now'}
      </button>
      <div className="mt-3">
        {status.message && (
          <div className={`alert alert-${status.type}`} role="alert">
            {status.message}
          </div>
        )}
      </div>
    </div>
  );
}

export default SyncPage;
