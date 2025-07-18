import React, { useState, useEffect, useCallback } from 'react';
import axios from 'axios';

function LogsPage() {
  const [logs, setLogs] = useState('');
  const [loading, setLoading] = useState(false);
  const [error, setError] = useState(null);

  const fetchLogs = useCallback(() => {
    setLoading(true);
    setError(null);
    axios.get('/api/logs')
      .then(response => {
        setLogs(response.data);
        setLoading(false);
      })
      .catch(error => {
        console.error('Error fetching logs:', error);
        setError('Could not fetch logs.');
        setLoading(false);
      });
  }, []);

  useEffect(() => {
    fetchLogs();
  }, [fetchLogs]);

  return (
    <div>
      <div className="d-flex justify-content-between align-items-center">
        <h1>Sync Logs</h1>
        <button className="btn btn-secondary" onClick={fetchLogs} disabled={loading}>
          {loading && <span className="spinner-border spinner-border-sm" role="status" aria-hidden="true"></span>}
          {loading ? ' Refreshing...' : 'Refresh'}
        </button>
      </div>

      {error && (
        <div className="alert alert-danger mt-3" role="alert">
          {error}
        </div>
      )}

      <pre className="mt-3" style={{ whiteSpace: 'pre-wrap', wordBreak: 'break-all', border: '1px solid #ccc', padding: '10px', minHeight: '200px' }}>
        {loading ? 'Loading logs...' : logs}
      </pre>
    </div>
  );
}

export default LogsPage;
