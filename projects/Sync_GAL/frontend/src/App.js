import React from 'react';
import { BrowserRouter as Router, Routes, Route, Link } from 'react-router-dom';
import SyncPage from './SyncPage';
import LogsPage from './LogsPage';

function App() {
  return (
    <Router>
      <div className="container mt-3">
        <nav className="nav nav-pills">
          <Link className="nav-link" to="/">Sync</Link>
          <Link className="nav-link" to="/logs">Logs</Link>
        </nav>
        <hr />
        <Routes>
          <Route path="/" element={<SyncPage />} />
          <Route path="/logs" element={<LogsPage />} />
        </Routes>
      </div>
    </Router>
  );
}

export default App;
